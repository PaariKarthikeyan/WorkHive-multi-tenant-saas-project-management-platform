const express  = require('express');
const router   = express.Router();
const db       = require('../db');
const bcrypt   = require('bcryptjs');
const nodemailer = require('nodemailer');
const authMiddleware = require('../middleware/auth');

const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 587,
  secure: false,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

// All routes require authentication
router.use(authMiddleware);

// ── GET /api/profile ──────────────────────────────────────────
router.get('/', async (req, res) => {
  try {
    const [[user]] = await db.query(
      `SELECT
         u.user_id, u.first_name, u.last_name, u.email,
         u.secondary_email, u.phone, u.avatar_url, u.bio,
         u.department, u.job_title, u.location, u.timezone,
         u.date_of_birth, u.gender, u.linkedin_url,
         u.two_factor_enabled, u.notification_email,
         u.notification_sms, u.theme_preference,
         u.is_active, u.created_at,
         r.name AS role,
         t.name AS org_name, t.plan
       FROM users u
       JOIN roles r  ON u.role_id  = r.role_id
       JOIN tenants t ON u.tenant_id = t.tenant_id
       WHERE u.user_id = ?`,
      [req.user.user_id]
    );
    if (!user) return res.status(404).json({ success: false, error: 'User not found.' });
    res.json({ success: true, data: user });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch profile.' });
  }
});

// ── PUT /api/profile ─── Update basic info ───────────────────
router.put('/', async (req, res) => {
  const {
    first_name, last_name, bio, department, job_title,
    location, timezone, date_of_birth, gender,
    linkedin_url, notification_email, notification_sms, theme_preference
  } = req.body;

  if (!first_name?.trim() || !last_name?.trim()) {
    return res.status(400).json({ success: false, error: 'First and last name are required.' });
  }

  try {
    await db.query(
      `UPDATE users SET
         first_name=?, last_name=?, bio=?, department=?,
         job_title=?, location=?, timezone=?, date_of_birth=?,
         gender=?, linkedin_url=?, notification_email=?,
         notification_sms=?, theme_preference=?
       WHERE user_id=?`,
      [
        first_name.trim(), last_name.trim(), bio || null,
        department || null, job_title || null, location || null,
        timezone || 'Asia/Kolkata', date_of_birth || null,
        gender || null, linkedin_url || null,
        notification_email ? 1 : 0, notification_sms ? 1 : 0,
        theme_preference || 'system', req.user.user_id
      ]
    );
    res.json({ success: true, message: 'Profile updated successfully.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to update profile.' });
  }
});

// ── PUT /api/profile/security ─── Update secondary email, phone, 2FA ──
router.put('/security', async (req, res) => {
  const { secondary_email, phone, two_factor_enabled, otp } = req.body;
  const { email: work_email } = req.user;

  if (secondary_email && secondary_email.toLowerCase() === work_email.toLowerCase()) {
    return res.status(400).json({ success: false, error: 'Secondary email must be different from your work email.' });
  }
  if (secondary_email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(secondary_email)) {
    return res.status(400).json({ success: false, error: 'Invalid secondary email format.' });
  }
  if (phone && !/^[+]?[\d\s\-()]{7,15}$/.test(phone)) {
    return res.status(400).json({ success: false, error: 'Invalid phone number format.' });
  }

  try {
    if (secondary_email) {
      const [secInUse] = await db.query(
        'SELECT user_id FROM users WHERE (email=? OR secondary_email=?) AND user_id != ?',
        [secondary_email, secondary_email, req.user.user_id]
      );
      if (secInUse.length > 0) {
        return res.status(400).json({ success: false, error: 'Secondary email is already in use by another account.' });
      }
    }

    const [[user]] = await db.query('SELECT secondary_email, first_name FROM users WHERE user_id=?', [req.user.user_id]);
    
    // Check if changing an existing secondary email
    const changingSecondary = user.secondary_email && secondary_email && secondary_email.toLowerCase() !== user.secondary_email.toLowerCase();
    
    if (changingSecondary) {
      if (!otp) {
        // Generate and send OTP
        const newOtp = Math.floor(100000 + Math.random() * 900000).toString();
        const expiry = new Date(Date.now() + 10 * 60 * 1000);
        await db.query('UPDATE users SET reset_token=?, reset_token_expiry=? WHERE user_id=?', [newOtp, expiry, req.user.user_id]);
        
        try {
          await transporter.sendMail({
            from: `"ProjexPM Security" <${process.env.EMAIL_USER}>`,
            to: user.secondary_email,
            subject: 'Security Update — Verify it\'s you',
            html: `
              <div style="font-family:sans-serif;max-width:480px;margin:auto">
                <h2 style="color:#01696f">Security Update Request</h2>
                <p>Hi ${user.first_name},</p>
                <p>Someone is trying to change your secondary email. If this is you, enter this code:</p>
                <div style="font-size:48px;font-weight:800;letter-spacing:12px;color:#01696f;padding:24px;text-align:center;background:#f3f0ec;border-radius:12px;">${newOtp}</div>
              </div>
            `
          });
        } catch (e) {
          console.error('OTP email send failed:', e.message);
        }
        
        return res.json({ success: true, requires_otp: true, message: 'OTP sent to your old secondary email.' });
      } else {
        // Verify OTP
        const [[verify]] = await db.query('SELECT reset_token FROM users WHERE user_id=? AND reset_token=? AND reset_token_expiry > NOW()', [req.user.user_id, otp]);
        if (!verify) {
          return res.status(400).json({ success: false, error: 'Invalid or expired OTP.' });
        }
        await db.query('UPDATE users SET reset_token=NULL, reset_token_expiry=NULL WHERE user_id=?', [req.user.user_id]);
      }
    }

    await db.query(
      'UPDATE users SET secondary_email=?, phone=?, two_factor_enabled=? WHERE user_id=?',
      [secondary_email || null, phone || null, two_factor_enabled ? 1 : 0, req.user.user_id]
    );
    res.json({ success: true, message: 'Security settings updated.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to update security settings.' });
  }
});

// ── PUT /api/profile/password ─── Change password ────────────
router.put('/password', async (req, res) => {
  const { current_password, new_password, confirm_password } = req.body;

  if (!current_password || !new_password || !confirm_password) {
    return res.status(400).json({ success: false, error: 'All password fields are required.' });
  }
  if (new_password.length < 8) {
    return res.status(400).json({ success: false, error: 'New password must be at least 8 characters.' });
  }
  if (new_password !== confirm_password) {
    return res.status(400).json({ success: false, error: 'New passwords do not match.' });
  }

  try {
    const [[user]] = await db.query('SELECT password_hash FROM users WHERE user_id=?', [req.user.user_id]);
    const valid = await bcrypt.compare(current_password, user.password_hash);
    if (!valid) return res.status(400).json({ success: false, error: 'Current password is incorrect.' });

    const hash = await bcrypt.hash(new_password, 12);
    await db.query('UPDATE users SET password_hash=? WHERE user_id=?', [hash, req.user.user_id]);
    res.json({ success: true, message: 'Password changed successfully.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to change password.' });
  }
});

module.exports = router;
