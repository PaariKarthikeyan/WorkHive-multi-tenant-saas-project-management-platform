// backend/routes/admin.js
// All routes require: auth + rbac('admin')
// Schema fixes: CONCAT(first_name,' ',last_name), role_id→roles, employee_id in team_members

const express = require('express');
const bcrypt = require('bcryptjs');
const db = require('../db');
const router = express.Router();
const authMiddleware = require('../middleware/auth');

// ── GET /api/admin/projects ──────────────────────────────────────────────────
router.get('/projects', async (req, res) => {
  try {
    const [projects] = await db.query(
      `SELECT p.*,
              t.team_name, t.team_id AS assigned_team_id,
              COUNT(tk.task_id) AS total_tasks,
              SUM(tk.status = 'completed') AS completed_tasks
       FROM projects p
       LEFT JOIN teams t ON p.team_id = t.team_id
       LEFT JOIN tasks tk ON p.project_id = tk.project_id
       WHERE p.tenant_id = ?
       GROUP BY p.project_id
       ORDER BY p.created_at DESC`,
      [req.user.tenant_id]
    );
    res.json({ success: true, data: projects });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch projects.' });
  }
});

// ── POST /api/admin/projects ─────────────────────────────────────────────────
router.post('/projects', async (req, res) => {
  const { name, description, type, priority, estimated_end_date, team_id } = req.body;
  if (!name) return res.status(400).json({ success: false, error: 'Project name is required.' });

  try {
    // Check plan limits...
    const [[tenant]] = await db.query('SELECT plan FROM tenants WHERE tenant_id=?', [req.user.tenant_id]);
    const PLAN_LIMITS = require('../middleware/planLimits');
    const limits = PLAN_LIMITS[tenant.plan] || PLAN_LIMITS['free'];
    if (limits.projects !== -1) {
      const [[{ projectCount }]] = await db.query('SELECT COUNT(*) AS projectCount FROM projects WHERE tenant_id=?', [req.user.tenant_id]);
      if (projectCount >= limits.projects) {
        return res.status(403).json({ success: false, error: `Your ${tenant.plan} plan allows a maximum of ${limits.projects} projects.` });
      }
    }

    // Check team is not already assigned to another active project
    if (team_id) {
      const [[existing]] = await db.query(
        `SELECT project_id, name FROM projects
         WHERE team_id = ? AND tenant_id = ? AND status != 'completed' AND status != 'cancelled'`,
        [team_id, req.user.tenant_id]
      );
      if (existing) {
        return res.status(409).json({
          success: false,
          error: `This team is already assigned to active project: "${existing.name}". Complete or cancel it first.`
        });
      }
    }

    const [result] = await db.query(
      `INSERT INTO projects (tenant_id, name, description, type, priority, est_end_date, team_id)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [req.user.tenant_id, name, description || null, type || null,
      priority || 'medium', estimated_end_date || null, team_id || null]
    );
    res.status(201).json({ success: true, message: 'Project created.', data: { project_id: result.insertId } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to create project.' });
  }
});

// ── PUT /api/admin/projects/:id ──────────────────────────────────────────────
router.put('/projects/:id', async (req, res) => {
  const { name, description, type, priority, status, estimated_end_date, team_id } = req.body;
  try {
    // Check team conflict if changing team
    if (team_id) {
      const [[existing]] = await db.query(
        `SELECT project_id FROM projects
         WHERE team_id=? AND tenant_id=? AND project_id != ?
         AND status NOT IN ('completed','cancelled')`,
        [team_id, req.user.tenant_id, req.params.id]
      );
      if (existing) {
        return res.status(409).json({ success: false, error: 'This team is already assigned to another active project.' });
      }
    }

    await db.query(
      `UPDATE projects SET name=?, description=?, type=?, priority=?, status=?,
       estimated_end_date=?, team_id=?
       WHERE project_id=? AND tenant_id=?`,
      [name, description, type, priority, status, estimated_end_date,
        team_id || null, req.params.id, req.user.tenant_id]
    );
    res.json({ success: true, message: 'Project updated.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to update project.' });
  }
});

// ── DELETE /api/admin/projects/:id ──────────────────────────────────────────
router.delete('/projects/:id', async (req, res) => {
  try {
    await db.query(
      'DELETE FROM projects WHERE project_id=? AND tenant_id=?',
      [req.params.id, req.user.tenant_id]
    );
    res.json({ success: true, message: 'Project deleted.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to delete project.' });
  }
});

// ── GET /api/admin/employees ─────────────────────────────────────────────────
router.get('/employees', async (req, res) => {
  try {
    const [users] = await db.query(
      `SELECT u.user_id,
          CONCAT(u.first_name, ' ', u.last_name) AS name,
          u.email,
          r.name  AS role,
          u.created_at,
          u.is_active,
          tm.team_id,
          t.team_name
      FROM users u
      JOIN roles r ON u.role_id = r.role_id
      LEFT JOIN team_members tm ON u.user_id = tm.employee_id
      LEFT JOIN teams t ON tm.team_id = t.team_id
      WHERE u.tenant_id = ?
      ORDER BY r.role_id, u.first_name`,
      [req.user.tenant_id]
    );
    res.json({ success: true, data: users });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch employees.' });
  }
});

// ── POST /api/admin/employees ────────────────────────────────────────────────
router.post('/employees', async (req, res) => {
  const { name, email, password, role } = req.body;
  if (!name || !email || !password || !role) {
    return res.status(400).json({ success: false, error: 'All fields required.' });
  }

  try {
    // ── GET tenant plan ──────────────────────────────────
    const [[tenant]] = await db.query(
      'SELECT plan FROM tenants WHERE tenant_id=?',
      [req.user.tenant_id]
    );
    const PLAN_LIMITS = require('../middleware/planLimits');
    const limits = PLAN_LIMITS[tenant.plan] || PLAN_LIMITS['free'];

    // ── CHECK user limit ─────────────────────────────────
    if (limits.users !== -1) {
      const [[{ userCount }]] = await db.query(
        'SELECT COUNT(*) AS userCount FROM users WHERE tenant_id=?',
        [req.user.tenant_id]
      );
      if (userCount >= limits.users) {
        return res.status(403).json({
          success: false,
          error: `Your ${tenant.plan} plan allows a maximum of ${limits.users} users. Please upgrade to add more.`
        });
      }
    }

    // ── Proceed with creation ─────────────────────────────
    const [exists] = await db.query('SELECT user_id FROM users WHERE email=?', [email]);
    if (exists.length > 0) return res.status(409).json({ success: false, error: 'Email already exists.' });

    const nameParts = name.trim().split(' ');
    const first_name = nameParts[0] || name;
    const last_name = nameParts.slice(1).join(' ') || '';
    const roleMap = { admin: 1, manager: 2, employee: 3 };
    const role_id = roleMap[role] || 3;
    const password_hash = await bcrypt.hash(password, 12);

    const [result] = await db.query(
      'INSERT INTO users (tenant_id, role_id, first_name, last_name, email, password_hash) VALUES (?, ?, ?, ?, ?, ?)',
      [req.user.tenant_id, role_id, first_name, last_name, email, password_hash]
    );
    res.status(201).json({ success: true, message: `${role} created.`, data: { user_id: result.insertId } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to create user.' });
  }
});

// ── DELETE /api/admin/employees/:id ─────────────────────────────────────────
router.delete('/employees/:id', async (req, res) => {
  const userId = parseInt(req.params.id);
  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    // Step 1: Verify user belongs to this tenant and is not admin
    const [[user]] = await conn.query(
      'SELECT user_id, role_id FROM users WHERE user_id=? AND tenant_id=?',
      [userId, req.user.tenant_id]
    );

    if (!user) {
      await conn.rollback();
      return res.status(404).json({ success: false, error: 'Employee not found.' });
    }
    if (user.role_id === 1) {
      await conn.rollback();
      return res.status(403).json({ success: false, error: 'Cannot delete admin users.' });
    }

    // Step 2: Remove from team_members
    await conn.query('DELETE FROM team_members WHERE employee_id=?', [userId]);

    // Step 3: Unassign from tasks (set assigned_to NULL)
    await conn.query('UPDATE tasks SET assigned_to=NULL WHERE assigned_to=?', [userId]);

    // Step 4: Delete queries raised by this user
    await conn.query('DELETE FROM queries WHERE employee_id=?', [userId]);

    // Step 5: Delete notifications for this user
    await conn.query('DELETE FROM notifications WHERE user_id=?', [userId]);

    // Step 6: Delete performance metrics
    await conn.query('DELETE FROM user_performance_metrics WHERE user_id=?', [userId]);

    // Step 7: Delete activity logs created by this user
    await conn.query('DELETE FROM activity_logs WHERE actor_id=?', [userId]);

    // Step 8: Now delete the user
    await conn.query('DELETE FROM users WHERE user_id=?', [userId]);

    await conn.commit();
    res.json({ success: true, message: 'Employee permanently deleted.' });

  } catch (err) {
    await conn.rollback();
    console.error('Delete employee error:', err);
    res.status(500).json({ success: false, error: 'Failed to delete employee: ' + err.message });
  } finally {
    conn.release();
  }
});

// ── GET /api/admin/teams ─────────────────────────────────────────────────────
router.get('/teams', async (req, res) => {
  try {
    const [teams] = await db.query(
      `SELECT t.team_id,
          t.team_name,
          t.team_name AS name,
          t.manager_id,
          CONCAT(u.first_name, ' ', u.last_name) AS manager_name,
          COUNT(tm.employee_id) AS member_count
      FROM teams t
      LEFT JOIN users u ON t.manager_id = u.user_id
      LEFT JOIN team_members tm ON t.team_id = tm.team_id
      WHERE t.tenant_id = ?
      GROUP BY t.team_id`,
      [req.user.tenant_id]
    );
    res.json({ success: true, data: teams });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch teams.' });
  }
});

/// POST /api/admin/teams — Create a team
router.post('/teams', async (req, res) => {
  const { team_name, manager_id } = req.body;

  if (!team_name || !manager_id) {
    return res.status(400).json({ success: false, error: 'team_name and manager_id are required.' });
  }

  try {
    // Check if manager already has a team
    const [existing] = await db.query(
      'SELECT team_id FROM teams WHERE tenant_id = ? AND manager_id = ?',
      [req.user.tenant_id, parseInt(manager_id)]
    );
    if (existing.length > 0) {
      return res.status(400).json({ success: false, error: 'This manager is already assigned to a team.' });
    }

    const [result] = await db.query(
      'INSERT INTO teams (tenant_id, team_name, manager_id) VALUES (?, ?, ?)',
      [req.user.tenant_id, team_name, parseInt(manager_id)]
    );
    res.status(201).json({
      success: true,
      message: 'Team created.',
      data: { team_id: result.insertId }
    });
  } catch (err) {
    console.error('Create team error:', err);
    res.status(500).json({ success: false, error: 'Failed to create team.' });
  }
});

// ── DELETE /api/admin/teams/:id ───────────────────────────────────────────────
router.delete('/teams/:id', async (req, res) => {
  try {
    const [result] = await db.query(
      'DELETE FROM teams WHERE team_id = ? AND tenant_id = ?',
      [req.params.id, req.user.tenant_id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, error: 'Team not found.' });
    }
    res.json({ success: true, message: 'Team deleted.' });
  } catch (err) {
    console.error('Delete team error:', err);
    res.status(500).json({ success: false, error: 'Failed to delete team.' });
  }
});

// ── POST /api/admin/teams/:id/members ────────────────────────────────────────
router.post('/teams/:id/members', async (req, res) => {
  const { user_id } = req.body;
  if (!user_id) return res.status(400).json({ success: false, error: 'user_id is required.' });
  try {
    await db.query(
      'INSERT IGNORE INTO team_members (team_id, employee_id) VALUES (?, ?)',
      [req.params.id, user_id]
    );
    res.json({ success: true, message: 'Member added to team.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to add member.' });
  }
});

// ── DELETE /api/admin/teams/:id/members/:userId ───────────────────────────────
router.delete('/teams/:id/members/:userId', async (req, res) => {
  try {
    await db.query(
      'DELETE FROM team_members WHERE team_id=? AND employee_id=?',
      [req.params.id, req.params.userId]
    );
    res.json({ success: true, message: 'Member removed.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to remove member.' });
  }
});

// ── GET /api/admin/insights ───────────────────────────────────────────────────
router.get('/insights', async (req, res) => {
  try {
    const tid = req.user.tenant_id;
    const [[summary]] = await db.query('SELECT * FROM analytics_summary WHERE tenant_id=?', [tid]);
    const [projectStats] = await db.query(
      `SELECT status, COUNT(*) AS count FROM projects WHERE tenant_id=? GROUP BY status`, [tid]
    );
    const [taskStats] = await db.query(
      `SELECT t.status, COUNT(*) AS count FROM tasks t
       JOIN projects p ON t.project_id = p.project_id
       WHERE p.tenant_id=? GROUP BY t.status`, [tid]
    );
    const [topEmployees] = await db.query(
      `SELECT CONCAT(u.first_name, ' ', u.last_name) AS name, COUNT(t.task_id) AS completed
       FROM tasks t
       JOIN users u ON t.assigned_to = u.user_id
       JOIN projects p ON t.project_id = p.project_id
       WHERE p.tenant_id=? AND t.status='completed'
       GROUP BY u.user_id ORDER BY completed DESC LIMIT 5`, [tid]
    );
    res.json({ success: true, data: { summary, projectStats, taskStats, topEmployees } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch insights.' });
  }
});

// GET /api/admin/subscription

// Plan limits map — adjust values to match your actual plans
const PLAN_LIMITS = {
  'free': { users: 3, projects: 5 },
  'pro': { users: 20, projects: 50 },
  'ultra': { users: 100, projects: 200 },
  'enterprise': { users: -1, projects: -1 },
};

router.get('/subscription', authMiddleware, async (req, res) => {
  try {
    const tenant_id = req.user.tenant_id;
    console.log('Billing fetch for tenant_id:', tenant_id);

    const [[tenantData]] = await db.query(
      `SELECT t.plan, t.name AS org_name,
              s.plan_type, s.subscription_plan, s.subscription_status,
              s.current_period_start, s.current_period_end, s.is_active
       FROM tenants t
       LEFT JOIN subscriptions s ON t.tenant_id = s.tenant_id
       WHERE t.tenant_id = ?`,
      [tenant_id]
    );

    const [billing] = await db.query(
      `SELECT id, billing_period, period_start, period_end, base_charge, usage_charge,
              storage_gb, api_calls_used, total_due, status
       FROM billing_summary
       WHERE tenant_id = ?
       ORDER BY period_start DESC, id DESC
       LIMIT 12`,
      [tenant_id]
    );

    // ✅ Lookup limits by plan name (case-insensitive)
    const planKey = (tenantData?.subscription_plan ?? tenantData?.plan_type ?? tenantData?.plan ?? '').toLowerCase();
    const limits = PLAN_LIMITS[planKey] ?? { users: -1, projects: -1 };

    return res.json({
      success: true,
      data: {
        plan: tenantData?.subscription_plan ?? tenantData?.plan_type ?? tenantData?.plan,
        subscriptionend: tenantData?.current_period_end,
        is_active: tenantData?.is_active,
        status: tenantData?.subscription_status,
        limits,
        billingHistory: billing,
      }
    });

  } catch (err) {
    console.error('Subscription route error:', err);
    return res.status(500).json({ success: false, error: 'Failed to load subscription data.' });
  }
});

// ── PUT /api/admin/subscription ──────────────────────────────────────────────
router.put('/subscription', async (req, res) => {
  const { plan, billing_cycle } = req.body;
  const cycle = billing_cycle || 'monthly';

  if (!['free', 'pro', 'ultra', 'enterprise'].includes(plan)) {
    return res.status(400).json({ success: false, error: 'Invalid plan.' });
  }
  try {
    await db.query('UPDATE tenants SET plan=? WHERE tenant_id=?', [plan, req.user.tenant_id]);

    // Updated pricing matrix to match tiered requirements
    const PLAN_CHARGES = {
      monthly:   { free: 0, pro: 299,  ultra: 499,   enterprise: 999 },
      annual:    { free: 0, pro: 2999, ultra: 5099,  enterprise: 10099 },
      lifetime:  { free: 0, pro: 4999, ultra: 14999, enterprise: 23999 }
    };

    const period = new Date().toISOString().slice(0, 7);
    const [[existing]] = await db.query(
      `SELECT id FROM billing_summary WHERE tenant_id = ? AND billing_period = ?`,
      [req.user.tenant_id, period]
    );

    if (!existing) {
      const base_charge = PLAN_CHARGES[cycle]?.[plan] ?? 0;
      
      // Calculate period end based on cycle
      let interval = '1 MONTH';
      if (cycle === 'annual') interval = '1 YEAR';
      if (cycle === 'lifetime') interval = '99 YEAR';

      await db.query(`
        INSERT INTO billing_summary
          (tenant_id, billing_period, period_start, period_end, base_charge, usage_charge, storage_gb, api_calls_used, total_due, status)
        VALUES (?, ?, CURRENT_TIMESTAMP, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL ${interval}), ?, 0, 0, 0, ?, 'pending')`,
        [req.user.tenant_id, period, base_charge.toFixed(2), base_charge.toFixed(2)]
      );
    }

    res.json({ success: true, message: `Plan updated to ${plan} (${cycle}).` });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to update plan.' });
  }
});

// ✅ No authMiddleware needed here — already applied in server.js
router.patch('/billing/:id/pay', async (req, res) => {
  try {
    const tenant_id = req.user.tenant_id;
    const billing_id = req.params.id;

    const [[bill]] = await db.query(
      `SELECT id, status FROM billing_summary WHERE id = ? AND tenant_id = ?`,
      [billing_id, tenant_id]
    );

    if (!bill) return res.status(404).json({ success: false, error: 'Bill not found.' });
    if (bill.status === 'paid') return res.status(400).json({ success: false, error: 'Already paid.' });

    await db.query(
      `UPDATE billing_summary SET status = 'paid' WHERE id = ? AND tenant_id = ?`,
      [billing_id, tenant_id]
    );

    res.json({ success: true, message: 'Payment recorded.' });
  } catch (err) {
    console.error('Pay bill error:', err);
    res.status(500).json({ success: false, error: 'Failed to process payment.' });
  }
});

// ── GET /api/admin/employees/attendance ──────────────────────────────────────
router.get('/employees/attendance', async (req, res) => {
  try {
    const period = req.query.period || 'today';
    let dateFilter = 'a.date = CURDATE()';
    if (period === '7days') dateFilter = 'a.date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND a.date <= CURDATE()';
    if (period === '30days') dateFilter = 'a.date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND a.date <= CURDATE()';

    const [roster] = await db.query(
      `SELECT u.user_id, CONCAT(u.first_name, ' ', u.last_name) AS name, u.email, 
              r.name AS role,
              t.team_name AS team,
              a.date, a.clock_in, a.clock_out, a.status
       FROM users u
       JOIN roles r ON u.role_id = r.role_id
       LEFT JOIN team_members tm ON u.user_id = tm.employee_id
       LEFT JOIN teams t ON tm.team_id = t.team_id
       LEFT JOIN attendance a ON u.user_id = a.user_id AND ${dateFilter}
       WHERE u.tenant_id = ?
       ORDER BY a.date DESC, u.role_id ASC, u.first_name ASC`,
      [req.user.tenant_id]
    );
    res.json({ success: true, data: roster });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch organization attendance.' });
  }
});

module.exports = router;