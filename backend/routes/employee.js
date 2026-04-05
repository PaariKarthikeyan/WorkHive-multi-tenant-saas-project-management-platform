// backend/routes/employee.js
// All routes require: auth + rbac('employee')
// Schema fixes: CONCAT names, employee_id in team_members, employee_id/manager_id in queries

const express = require('express');
const db      = require('../db');
const router  = express.Router();

// ── GET /api/employee/tasks ───────────────────────────────────────────────────
router.get('/tasks', async (req, res) => {
  const { status, priority } = req.query;
  let sql = `SELECT t.*, p.name AS project_name,
               CONCAT(u.first_name,' ',u.last_name) AS assigned_by_name
             FROM tasks t
             JOIN projects p ON t.project_id = p.project_id
             JOIN users u ON t.assigned_by = u.user_id
             WHERE t.assigned_to=?`;
  const params = [req.user.user_id];

  if (status)   { sql += ' AND t.status=?';   params.push(status); }
  if (priority) { sql += ' AND t.priority=?'; params.push(priority); }
  sql += ' ORDER BY t.created_at DESC';

  try {
    const [tasks] = await db.query(sql, params);
    res.json({ success: true, data: tasks });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch tasks.' });
  }
});

// ── GET /api/employee/tasks/:id ───────────────────────────────────────────────
router.get('/tasks/:id', async (req, res) => {
  try {
    const [[task]] = await db.query(
      `SELECT t.*, p.name AS project_name,
              CONCAT(u.first_name,' ',u.last_name) AS assigned_by_name
       FROM tasks t
       JOIN projects p ON t.project_id = p.project_id
       JOIN users u ON t.assigned_by = u.user_id
       WHERE t.task_id=? AND t.assigned_to=?`,
      [req.params.id, req.user.user_id]
    );
    if (!task) return res.status(404).json({ success: false, error: 'Task not found.' });
    res.json({ success: true, data: task });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch task.' });
  }
});

// ── PUT /api/employee/tasks/:id/status ───────────────────────────────────────
router.put('/tasks/:id/status', async (req, res) => {
  const { status } = req.body;
  if (!['in_progress', 'completed'].includes(status)) {
    return res.status(400).json({ success: false, error: 'Status must be in_progress or completed.' });
  }
  try {
    const [result] = await db.query(
      `UPDATE tasks SET status=?,
       completion_pct = IF(? = 'completed', 100, 30)
       WHERE task_id=? AND assigned_to=?`,
      [status, status, req.params.id, req.user.user_id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, error: 'Task not found or not assigned to you.' });
    }
    res.json({ success: true, message: `Task marked as ${status}.` });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to update task status.' });
  }
});

// ── GET /api/employee/team ────────────────────────────────────────────────────
router.get('/team', async (req, res) => {
  try {
    const [[membership]] = await db.query(
      'SELECT team_id FROM team_members WHERE employee_id=?',
      [req.user.user_id]
    );
    if (!membership) {
      return res.json({ success: true, data: null, message: 'Not assigned to a team yet.' });
    }

    const [[team]] = await db.query(
      `SELECT t.team_id, t.team_name, t.team_name AS name,
              CONCAT(u.first_name,' ',u.last_name) AS manager_name,
              u.email AS manager_email
       FROM teams t
       JOIN users u ON t.manager_id = u.user_id
       WHERE t.team_id=?`,
      [membership.team_id]
    );

    const [members] = await db.query(
      `SELECT u.user_id,
              CONCAT(u.first_name,' ',u.last_name) AS name,
              u.email,
              COUNT(t.task_id) AS total_tasks,
              SUM(t.status='completed') AS completed_tasks
       FROM team_members tm
       JOIN users u ON tm.employee_id = u.user_id
       JOIN roles r ON u.role_id = r.role_id
       LEFT JOIN tasks t ON t.assigned_to = u.user_id
       WHERE tm.team_id=? AND r.name = 'employee'
       GROUP BY u.user_id`,
      [membership.team_id]
    );

    res.json({ success: true, data: { ...team, members } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch team.' });
  }
});

// ── GET /api/employee/team/colleague/:id/tasks ────────────────────────────────
router.get('/team/colleague/:id/tasks', async (req, res) => {
  try {
    const [[myTeam]]    = await db.query('SELECT team_id FROM team_members WHERE employee_id=?', [req.user.user_id]);
    const [[theirTeam]] = await db.query('SELECT team_id FROM team_members WHERE employee_id=?', [req.params.id]);

    if (!myTeam || !theirTeam || myTeam.team_id !== theirTeam.team_id) {
      return res.status(403).json({ success: false, error: 'Can only view teammates in your own team.' });
    }

    const [tasks] = await db.query(
      `SELECT t.name, t.status, t.priority, t.deadline, p.name AS project_name
       FROM tasks t
       JOIN projects p ON t.project_id = p.project_id
       WHERE t.assigned_to=? AND t.status != 'completed'
       ORDER BY t.created_at DESC`,
      [req.params.id]
    );
    res.json({ success: true, data: tasks });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch colleague tasks.' });
  }
});

// ── GET /api/employee/queries ─────────────────────────────────────────────────
router.get('/queries', async (req, res) => {
  try {
    const [queries] = await db.query(
      `SELECT q.*,
              CONCAT(u.first_name,' ',u.last_name) AS manager_name
       FROM queries q
       JOIN users u ON q.manager_id = u.user_id
       WHERE q.employee_id=?
       ORDER BY q.created_at DESC`,
      [req.user.user_id]
    );
    res.json({ success: true, data: queries });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch queries.' });
  }
});

// ── POST /api/employee/queries ────────────────────────────────────────────────
router.post('/queries', async (req, res) => {
  const { subject, message } = req.body;
  if (!subject || !message) {
    return res.status(400).json({ success: false, error: 'Subject and message are required.' });
  }
  try {
    const [[membership]] = await db.query(
      'SELECT team_id FROM team_members WHERE employee_id=?', [req.user.user_id]
    );
    if (!membership) {
      return res.status(400).json({ success: false, error: 'You must be in a team to raise a query.' });
    }
    const [[team]] = await db.query(
      'SELECT manager_id FROM teams WHERE team_id=?', [membership.team_id]
    );
    const [result] = await db.query(
      `INSERT INTO queries (tenant_id, employee_id, manager_id, subject, message)
       VALUES (?, ?, ?, ?, ?)`,
      [req.user.tenant_id, req.user.user_id, team.manager_id, subject, message]
    );
    res.status(201).json({
      success: true,
      message: 'Query submitted to your manager.',
      data: { query_id: result.insertId },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to submit query.' });
  }
});

// GET /api/employee/chat — load last 50 messages for team
router.get('/chat', async (req, res) => {
  try {
    const [[membership]] = await db.query(
      'SELECT team_id FROM team_members WHERE employee_id=?', [req.user.user_id]
    );
    if (!membership) return res.status(403).json({ success: false, error: 'Not in a team.' });

    const [messages] = await db.query(
      `SELECT m.message_id, m.message, m.created_at, m.is_deleted,
              CONCAT(u.first_name,' ',u.last_name) AS sender_name,
              m.sender_id, m.reply_to_id,
              r.message AS reply_to_message,
              CONCAT(ru.first_name,' ',ru.last_name) AS reply_to_name
       FROM team_messages m
       JOIN users u ON m.sender_id = u.user_id
       LEFT JOIN team_messages r ON m.reply_to_id = r.message_id
       LEFT JOIN users ru ON r.sender_id = ru.user_id
       WHERE m.team_id = ? 
         AND m.message_id NOT IN (
           SELECT message_id FROM team_message_deletions WHERE user_id = ?
         )
       ORDER BY m.created_at ASC
       LIMIT 50`,
      [membership.team_id, req.user.user_id]
    );

    // Filter out content of deleted messages, instead returning tombstone
    const finalMessages = messages.map(msg => {
      if (msg.is_deleted) {
        msg.message = null; // hide message
      }
      return msg;
    });

    // Mark these as read by the user
    const otherMsgIds = finalMessages.filter(m => m.sender_id !== req.user.user_id).map(m => [m.message_id, req.user.user_id]);
    if (otherMsgIds.length > 0) {
      await db.query(`INSERT IGNORE INTO team_message_reads (message_id, user_id) VALUES ?`, [otherMsgIds]);
    }

    res.json({ success: true, data: finalMessages, team_id: membership.team_id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to load chat.' });
  }
});

// POST /api/employee/chat — send a message
router.post('/chat', async (req, res) => {
  const { message, reply_to_id } = req.body;
  if (!message || !message.trim()) {
    return res.status(400).json({ success: false, error: 'Message cannot be empty.' });
  }
  try {
    const [[membership]] = await db.query(
      'SELECT team_id FROM team_members WHERE employee_id=?', [req.user.user_id]
    );
    if (!membership) return res.status(403).json({ success: false, error: 'Not in a team.' });

    const [result] = await db.query(
      'INSERT INTO team_messages (team_id, sender_id, reply_to_id, message) VALUES (?, ?, ?, ?)',
      [membership.team_id, req.user.user_id, reply_to_id || null, message.trim()]
    );

    const [[newMsg]] = await db.query(
      `SELECT m.message_id, m.message, m.created_at, m.is_deleted,
              CONCAT(u.first_name,' ',u.last_name) AS sender_name,
              m.sender_id, m.reply_to_id,
              r.message AS reply_to_message,
              CONCAT(ru.first_name,' ',ru.last_name) AS reply_to_name
       FROM team_messages m
       JOIN users u ON m.sender_id = u.user_id
       LEFT JOIN team_messages r ON m.reply_to_id = r.message_id
       LEFT JOIN users ru ON r.sender_id = ru.user_id
       WHERE m.message_id = ?`,
      [result.insertId]
    );

    res.status(201).json({ success: true, data: newMsg });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to send message.' });
  }
});

// DELETE /api/employee/chat/:id — Delete for Me or Delete for Everyone
router.delete('/chat/:id', async (req, res) => {
  const type = req.query.type; // 'me' or 'everyone'
  try {
    // Get message verify it belongs to user's team
    const [[membership]] = await db.query(
      'SELECT team_id FROM team_members WHERE employee_id=?', [req.user.user_id]
    );
    if (!membership) return res.status(403).json({ success: false, error: 'Not in a team.' });

    const [[msg]] = await db.query(
      'SELECT team_id, sender_id, created_at FROM team_messages WHERE message_id = ?', 
      [req.params.id]
    );
    if (!msg || msg.team_id !== membership.team_id) {
      return res.status(404).json({ success: false, error: 'Message not found.' });
    }

    if (type === 'everyone') {
      if (msg.sender_id !== req.user.user_id) {
        return res.status(403).json({ success: false, error: 'You can only delete your own messages.' });
      }
      
      const timeDiff = (Date.now() - new Date(msg.created_at)) / 1000 / 60; // in minutes
      if (timeDiff > 15) {
        return res.status(400).json({ success: false, error: 'Cannot delete message after 15 minutes.' });
      }

      await db.query('UPDATE team_messages SET is_deleted = 1 WHERE message_id = ?', [req.params.id]);
      return res.json({ success: true, message: 'Message deleted for everyone.' });
    } 
    
    // Delete for 'me'
    await db.query(
      'INSERT IGNORE INTO team_message_deletions (message_id, user_id) VALUES (?, ?)',
      [req.params.id, req.user.user_id]
    );
    res.json({ success: true, message: 'Message deleted for you.' });

  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to delete message.' });
  }
});

// GET /api/employee/chat/:id/info — Get read receipts
router.get('/chat/:id/info', async (req, res) => {
  try {
    const [[msg]] = await db.query('SELECT sender_id FROM team_messages WHERE message_id=?', [req.params.id]);
    if (!msg || msg.sender_id !== req.user.user_id) {
      return res.status(403).json({ success: false, error: 'Can only view info for your own messages.' });
    }

    const [readers] = await db.query(
      `SELECT CONCAT(u.first_name, ' ', u.last_name) AS name, r.read_at
       FROM team_message_reads r
       JOIN users u ON r.user_id = u.user_id
       WHERE r.message_id = ?
       ORDER BY r.read_at DESC`,
      [req.params.id]
    );

    res.json({ success: true, readers });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch read receipts.' });
  }
});

// ── GET /api/employee/attendance/today ────────────────────────────────────────
router.get('/attendance/today', async (req, res) => {
  try {
    const [[attendance]] = await db.query(
      `SELECT * FROM attendance WHERE user_id=? AND date=CURDATE()`,
      [req.user.user_id]
    );
    res.json({ success: true, data: attendance || null });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch attendance.' });
  }
});

// ── POST /api/employee/attendance/check-in ────────────────────────────────────
router.post('/attendance/check-in', async (req, res) => {
  try {
    const [[existing]] = await db.query(
      `SELECT clock_in FROM attendance WHERE user_id=? AND date=CURDATE()`,
      [req.user.user_id]
    );
    if (existing) return res.status(400).json({ success: false, error: 'Already checked in today.' });

    await db.query(
      `INSERT INTO attendance (user_id, tenant_id, date, clock_in, status)
       VALUES (?, ?, CURDATE(), NOW(), 'present')`,
      [req.user.user_id, req.user.tenant_id]
    );
    
    res.json({ success: true, message: 'Checked in successfully.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to check in.' });
  }
});

// ── PUT /api/employee/attendance/check-out ────────────────────────────────────
router.put('/attendance/check-out', async (req, res) => {
  try {
    const [[attendance]] = await db.query(
      `SELECT clock_in, clock_out FROM attendance WHERE user_id=? AND date=CURDATE()`,
      [req.user.user_id]
    );
    if (!attendance) return res.status(400).json({ success: false, error: 'No check-in record found for today.' });
    if (attendance.clock_out) return res.status(400).json({ success: false, error: 'Already checked out today.' });

    await db.query(
      `UPDATE attendance
       SET clock_out=NOW()
       WHERE user_id=? AND date=CURDATE()`,
      [req.user.user_id]
    );
    
    res.json({ success: true, message: 'Checked out successfully.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to check out.' });
  }
});

// ── DELETE /api/employee/attendance/today (Undo Check-In) ─────────────────
router.delete('/attendance/today', async (req, res) => {
  try {
    const [result] = await db.query(
      `DELETE FROM attendance WHERE user_id=? AND date=CURDATE() AND clock_out IS NULL`,
      [req.user.user_id]
    );
    if (result.affectedRows === 0) {
      return res.status(400).json({ success: false, error: 'Cannot undo. You are not checked in, or already checked out.' });
    }
    res.json({ success: true, message: 'Check-in undone.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to undo check-in.' });
  }
});

// ── PUT /api/employee/attendance/undo-check-out ────────────────────────────────
router.put('/attendance/undo-check-out', async (req, res) => {
  try {
    const [result] = await db.query(
      `UPDATE attendance SET clock_out=NULL WHERE user_id=? AND date=CURDATE()`,
      [req.user.user_id]
    );
    if (result.affectedRows === 0) {
       return res.status(400).json({ success: false, error: 'No daily record found' });
    }
    res.json({ success: true, message: 'Checkout undone.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to undo check-out.' });
  }
});

// ── GET /api/employee/attendance/history ──────────────────────────────────────
router.get('/attendance/history', async (req, res) => {
  try {
    const [history] = await db.query(
      `SELECT date, clock_in, clock_out, status
       FROM attendance
       WHERE user_id=?
       ORDER BY date DESC
       LIMIT 7`,
      [req.user.user_id]
    );
    res.json({ success: true, data: history });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch attendance history.' });
  }
});

module.exports = router;