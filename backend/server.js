// backend/server.js
// ─────────────────────────────────────────────────
//  SaaS PM — Express Backend Entry Point
//  Start with: node server.js
//  Runs on:    http://localhost:3000
// ─────────────────────────────────────────────────

require('dotenv').config(); // Load .env variables FIRST before anything else

const express = require('express');
const cors = require('cors');
const path = require('path');

// ── Import Middleware ─────────────────────────────
const auth = require('./middleware/auth');
const rbac = require('./middleware/rbac');

// ── Import Route Handlers ─────────────────────────
const authRoutes = require('./routes/auth');
const adminRoutes = require('./routes/admin');
const managerRoutes = require('./routes/manager');
const employeeRoutes = require('./routes/employee');
const profileRoutes = require('./routes/profile');
const subscriptionRoutes = require('./routes/subscription');
const cron = require('node-cron');
const db = require('./db');

// ── Create Express App ────────────────────────────
const app = express();
const PORT = process.env.PORT || 3000;

// ════════════════════════════════════════════════
//  GLOBAL MIDDLEWARE
// ════════════════════════════════════════════════

// CORS — Allow requests from your frontend (adjust origin in production)
app.use(cors({
  origin: [
    'http://localhost:5500',   // VS Code Live Server default
    'http://127.0.0.1:5500',
    'http://localhost:5501',
    'http://127.0.0.1:5501',
    'http://localhost:3001',   // Alternative frontend port
  ],
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
}));

// Parse incoming JSON request bodies
app.use(express.json());

// Parse URL-encoded form data (for HTML forms if needed)
app.use(express.urlencoded({ extended: true }));

// Request Logger (shows every incoming request in terminal)
app.use((req, res, next) => {
  const time = new Date().toLocaleTimeString('en-IN', { timeZone: 'Asia/Kolkata' });
  console.log(`[${time}] ${req.method} ${req.url}`);
  next();
});

app.use('/api/profile', profileRoutes);

app.use('/api/subscription', subscriptionRoutes);

// ════════════════════════════════════════════════
//  ROUTES
// ════════════════════════════════════════════════

// ── Public Routes (no auth required) ─────────────
// POST /api/auth/register  → Create tenant + admin
// POST /api/auth/login     → Login, returns JWT
app.use('/api/auth', authRoutes);

// ── Protected: Admin only ─────────────────────────
// auth    → Verifies JWT token
// rbac    → Checks role is 'admin'
app.use('/api/admin', auth, rbac('admin'), adminRoutes);

// admin routes already mounted with auth + rbac above

// ── Protected: Manager only ──────────────────────
app.use('/api/manager', auth, rbac('manager'), managerRoutes);

// ── Protected: Employee only ─────────────────────
app.use('/api/employee', auth, rbac('employee'), employeeRoutes);

// ── Health Check ──────────────────────────────────
// GET /api/health → Quick check that server is alive
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'SaaS PM API is running',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
  });
});

const ownerRoutes = require('./routes/owner');
// Add after existing routes (no auth for simplicity — add a secret key in production)
app.use('/api/owner', ownerRoutes);

// ════════════════════════════════════════════════
//  ERROR HANDLING
// ════════════════════════════════════════════════

// ── Temp: Manual billing trigger ─────────────────
app.get('/api/owner/run-billing', async (req, res) => {
  console.log('⏰ Running monthly billing job...');
  try {
    const period = new Date().toISOString().slice(0, 7); // "2026-04"
    const [tenants] = await db.query(`SELECT tenant_id, plan FROM tenants`);

    const PLAN_CHARGES = { free: 0, pro: 999, ultra: 2499, enterprise: 4999 };
    const TASK_RATE = 0.5;   // ₹0.50 per task
    const USER_RATE = 10;    // ₹10 per active user

    for (const tenant of tenants) {
      // Skip if already billed for this period
      const [[existing]] = await db.query(
        `SELECT id FROM billing_summary WHERE tenant_id = ? AND billing_period = ?`,
        [tenant.tenant_id, period]
      );
      if (existing) continue;

      const base_charge = PLAN_CHARGES[tenant.plan] ?? 0;

      // Get latest metrics for this tenant
      const [[metrics]] = await db.query(
        `SELECT 
          COALESCE(total_tasks, 0)  AS total_tasks,
          COALESCE(active_users, 0) AS active_users
         FROM tenant_metrics
         WHERE tenant_id = ?
         ORDER BY created_at DESC LIMIT 1`,
        [tenant.tenant_id]
      );

      const total_tasks = parseInt(metrics?.total_tasks) || 0;
      const active_users = parseInt(metrics?.active_users) || 0;
      const usage_charge = (total_tasks * TASK_RATE) + (active_users * USER_RATE);
      const total_due = base_charge + usage_charge;

      await db.query(
        `INSERT INTO billing_summary
          (tenant_id, billing_period, base_charge, usage_charge, storage_gb, api_calls_used, total_due, status)
         VALUES (?, ?, ?, ?, ?, ?, ?, 'pending')`,
        [
          tenant.tenant_id,
          period,
          base_charge.toFixed(2),
          usage_charge.toFixed(2),
          0,
          total_tasks,
          total_due.toFixed(2),
          'pending'
        ]
      );

      console.log(`  ✅ Tenant ${tenant.tenant_id} — ₹${total_due.toFixed(2)}`);
    }

    res.json({ success: true, message: `✅ Monthly billing complete for ${tenants.length} tenants — ${period}` });
  } catch (err) {
    console.error('❌ Billing endpoint error:', err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// 404 — Route not found
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: `Route not found: ${req.method} ${req.url}`,
  });
});

// 500 — Global error handler (catches unhandled errors from routes)
app.use((err, req, res, next) => {
  console.error('🔥 Unhandled Error:', err.stack);
  res.status(err.status || 500).json({
    success: false,
    error: process.env.NODE_ENV === 'production'
      ? 'An unexpected error occurred.'
      : err.message,
  });
});

// ════════════════════════════════════════════════
//  START SERVER
// ════════════════════════════════════════════════

app.listen(PORT, () => {
  console.log('');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`🚀  SaaS PM Server running`);
  console.log(`📡  http://localhost:${PORT}`);
  console.log(`🌍  Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('');
  console.log('  Available API endpoints:');
  console.log('  POST  /api/auth/register');
  console.log('  POST  /api/auth/login');
  console.log('  GET   /api/admin/...');
  console.log('  GET   /api/manager/...');
  console.log('  GET   /api/employee/...');
  console.log('  GET   /api/health');
  console.log('');
});

cron.schedule('0 0 1 * *', async () => {
  console.log('⏰ Running monthly billing job...');
  try {
    const period = new Date().toISOString().slice(0, 7);
    const [tenants] = await db.query(`SELECT tenant_id, plan FROM tenants`);
    const PLAN_CHARGES = { free: 0, pro: 999, ultra: 2499, enterprise: 4999 };

    for (const tenant of tenants) {
      const [[existing]] = await db.query(
        `SELECT id FROM billing_summary WHERE tenant_id = ? AND billing_period = ?`,
        [tenant.tenant_id, period]
      );
      if (existing) continue;

      const base_charge = PLAN_CHARGES[tenant.plan] ?? 0;

      const [countRows] = await db.query(
        `SELECT
        (SELECT COUNT(*) FROM tasks t
        JOIN projects p ON t.project_id = p.project_id
        WHERE p.tenant_id = ?) AS total_tasks,
        (SELECT COUNT(*) FROM users
        WHERE tenant_id = ? AND is_active = 1) AS active_users`,
        [tenant.tenant_id, tenant.tenant_id]
      );
      const counts = countRows[0] || { total_tasks: 0, active_users: 0 };

      const usage_charge = (counts.total_tasks * 0.5) + (counts.active_users * 10);
      const total_due = base_charge + usage_charge;

      await db.query(
        `INSERT INTO billing_summary
          (tenant_id, billing_period, base_charge, usage_charge, storage_gb, api_calls_used, total_due, status)
         VALUES (?, ?, ?, ?, 0, ?, ?, 'pending')`,
        [tenant.tenant_id, period, base_charge.toFixed(2),
        usage_charge.toFixed(2), counts.total_tasks, total_due.toFixed(2)]
      );
    }
    console.log(`✅ Billing complete for ${tenants.length} tenants — ${period}`);
  } catch (err) {
    console.error('❌ Billing cron error:', err);
  }
});

module.exports = app; // Export for testing purposes