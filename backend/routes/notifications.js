const express = require('express');
const router = express.Router();
const db = require('../db');
const authMiddleware = require('../middleware/auth');

router.use(authMiddleware);

// GET /api/notifications - Get all notifications for user
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 50',
      [req.user.user_id]
    );
    res.json({ success: true, data: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch notifications.' });
  }
});

// PUT /api/notifications/:id/read - Mark a notification as read
router.put('/:id/read', async (req, res) => {
  try {
    await db.query(
      'UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?',
      [req.params.id, req.user.user_id]
    );
    res.json({ success: true, message: 'Notification marked as read.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to update notification.' });
  }
});

// PUT /api/notifications/read-all - Mark all as read
router.put('/read-all', async (req, res) => {
  try {
    await db.query(
      'UPDATE notifications SET is_read = 1 WHERE user_id = ?',
      [req.user.user_id]
    );
    res.json({ success: true, message: 'All notifications marked as read.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to update notifications.' });
  }
});

module.exports = router;
