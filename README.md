<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SaaS PM — README</title>
  <link href="https://api.fontshare.com/v2/css?f[]=satoshi@400,500,700,900&f[]=cabinet-grotesk@400,500,700,800&display=swap" rel="stylesheet">
  <style>
    /* ── TOKENS ── */
    :root,[data-theme="light"]{
      --bg:#f7f6f2;--surf:#f9f8f5;--surf2:#fbfbf9;--surfoff:#f0ede8;--surfdyn:#e6e4df;
      --bdr:rgba(40,37,29,0.12);--txt:#28251d;--txtm:#7a7974;--txtf:#bab9b4;
      --pr:#01696f;--prh:#0c4e54;--prhl:#cedcd8;
      --suc:#437a22;--suchl:#d4dfcc;
      --err:#a12c7b;--warn:#964219;--warnhl:#ddcfc6;
      --sh-sm:0 1px 3px rgba(40,37,29,.06);--sh-md:0 4px 16px rgba(40,37,29,.09);--sh-lg:0 12px 40px rgba(40,37,29,.13);
      --r-sm:.375rem;--r-md:.5rem;--r-lg:.75rem;--r-xl:1rem;--r-2xl:1.5rem;--r-full:9999px;
      --font-display:'Cabinet Grotesk',system-ui,sans-serif;
      --font-body:'Satoshi',system-ui,sans-serif;
    }
    [data-theme="dark"]{
      --bg:#141312;--surf:#1a1917;--surf2:#1f1e1c;--surfoff:#1d1c1a;--surfdyn:#2a2927;
      --bdr:rgba(205,204,202,0.1);--txt:#cdccca;--txtm:#797876;--txtf:#4a4947;
      --pr:#4f98a3;--prh:#3a8590;--prhl:#1e3538;
      --suc:#6daa45;--suchl:#1e3318;
      --err:#d163a7;--warn:#bb653b;--warnhl:#3a2c20;
      --sh-sm:0 1px 3px rgba(0,0,0,.25);--sh-md:0 4px 16px rgba(0,0,0,.35);--sh-lg:0 12px 40px rgba(0,0,0,.45);
    }

    /* ── BASE ── */
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    html{scroll-behavior:smooth;-webkit-font-smoothing:antialiased}
    body{font-family:var(--font-body);background:var(--bg);color:var(--txt);line-height:1.65;font-size:1rem;min-height:100vh;transition:background .25s,color .25s}
    h1,h2,h3,h4{font-family:var(--font-display);line-height:1.1;text-wrap:balance}
    p{text-wrap:pretty;max-width:72ch}
    code,pre{font-family:'SF Mono','Cascadia Code','Fira Code',monospace}
    ::selection{background:rgba(79,152,163,.22);color:var(--txt)}
    :focus-visible{outline:2px solid var(--pr);outline-offset:3px;border-radius:var(--r-sm)}
    @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}

    /* ── LAYOUT ── */
    .container{max-width:860px;margin:0 auto;padding:0 1.5rem}
    .wide{max-width:1100px}

    /* ── NAV ── */
    .navbar{position:fixed;top:0;left:0;right:0;z-index:100;background:rgba(20,19,18,.85);backdrop-filter:blur(16px);-webkit-backdrop-filter:blur(16px);border-bottom:1px solid var(--bdr);transition:background .3s}
    [data-theme="light"] .navbar{background:rgba(247,246,242,.88)}
    .navbar-inner{max-width:1100px;margin:0 auto;padding:.75rem 1.5rem;display:flex;align-items:center;justify-content:space-between;gap:1rem}
    .logo{display:flex;align-items:center;gap:.625rem;font-family:var(--font-display);font-weight:800;font-size:1.05rem;color:var(--txt);text-decoration:none}
    .logo-icon{width:30px;height:30px;flex-shrink:0}
    .nav-links{display:flex;align-items:center;gap:.25rem}
    .nav-link{font-size:.8rem;font-weight:600;color:var(--txtm);padding:.4rem .75rem;border-radius:var(--r-full);text-decoration:none;transition:color .18s,background .18s;white-space:nowrap}
    .nav-link:hover{color:var(--txt);background:var(--surfdyn)}
    .theme-btn{width:34px;height:34px;border-radius:var(--r-full);background:var(--surfoff);border:1px solid var(--bdr);color:var(--txtm);display:flex;align-items:center;justify-content:center;cursor:pointer;transition:color .18s,background .18s;flex-shrink:0}
    .theme-btn:hover{color:var(--txt);background:var(--surfdyn)}

    /* ── HERO ── */
    .hero{padding:7.5rem 0 4rem;text-align:center;position:relative;overflow:hidden}
    .hero-badge{display:inline-flex;align-items:center;gap:.4rem;background:var(--prhl);color:var(--pr);font-size:.72rem;font-weight:700;padding:.3rem .9rem;border-radius:var(--r-full);letter-spacing:.06em;text-transform:uppercase;margin-bottom:1.5rem}
    .hero-title{font-size:clamp(2.4rem,6vw,4rem);font-weight:900;letter-spacing:-.03em;margin-bottom:1rem;color:var(--txt)}
    .hero-title span{color:var(--pr)}
    .hero-sub{font-size:clamp(1rem,2vw,1.2rem);color:var(--txtm);max-width:56ch;margin:0 auto 2rem;line-height:1.6}
    .hero-actions{display:flex;gap:.75rem;justify-content:center;flex-wrap:wrap;margin-bottom:3rem}
    .btn{display:inline-flex;align-items:center;gap:.45rem;padding:.65rem 1.35rem;border-radius:var(--r-lg);font-family:var(--font-body);font-size:.875rem;font-weight:700;border:none;cursor:pointer;text-decoration:none;transition:all .18s}
    .btn-primary{background:var(--pr);color:#fff}
    .btn-primary:hover{background:var(--prh);box-shadow:var(--sh-md)}
    .btn-ghost{background:transparent;color:var(--txtm);border:1px solid var(--bdr)}
    .btn-ghost:hover{background:var(--surfoff);color:var(--txt)}

    /* scrolling pill badges */
    .pill-track{overflow:hidden;mask:linear-gradient(90deg,transparent,#000 12%,#000 88%,transparent)}
    .pill-row{display:flex;gap:.6rem;width:max-content;animation:scroll-x 28s linear infinite}
    .pill-row:nth-child(2){animation-direction:reverse;animation-duration:22s}
    .pill-track+.pill-track{margin-top:.6rem}
    @keyframes scroll-x{from{transform:translateX(0)}to{transform:translateX(-50%)}}
    .pill{display:inline-flex;align-items:center;gap:.35rem;background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-full);padding:.3rem .85rem;font-size:.75rem;font-weight:600;color:var(--txtm);white-space:nowrap;flex-shrink:0}
    .pill-dot{width:6px;height:6px;border-radius:50%}

    /* ── SECTION ── */
    .section{padding:3.5rem 0;border-top:1px solid var(--bdr)}
    .section-label{font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.1em;color:var(--pr);margin-bottom:.6rem}
    .section-title{font-size:clamp(1.35rem,3vw,1.9rem);font-weight:800;color:var(--txt);margin-bottom:.6rem;letter-spacing:-.025em}
    .section-desc{color:var(--txtm);font-size:.95rem;max-width:60ch;margin-bottom:2rem}

    /* ── STACK GRID ── */
    .tech-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:.75rem}
    .tech-card{background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-xl);padding:1.1rem 1rem;display:flex;flex-direction:column;gap:.5rem;transition:box-shadow .2s,transform .2s}
    .tech-card:hover{box-shadow:var(--sh-md);transform:translateY(-2px)}
    .tech-icon{width:32px;height:32px;border-radius:var(--r-md);display:flex;align-items:center;justify-content:center;font-size:1.15rem;flex-shrink:0}
    .tech-name{font-size:.82rem;font-weight:700;color:var(--txt)}
    .tech-role{font-size:.72rem;color:var(--txtm)}

    /* ── FILE TREE ── */
    .file-tree{background:var(--surf2);border:1px solid var(--bdr);border-radius:var(--r-xl);padding:1.25rem 1.5rem;font-family:monospace;font-size:.82rem;line-height:1.9;overflow-x:auto}
    .file-tree .dir{color:var(--pr);font-weight:700}
    .file-tree .file{color:var(--txt)}
    .file-tree .comment{color:var(--txtm);font-style:italic}
    .file-tree .highlight{color:var(--warn);font-weight:700}

    /* ── STEP CARDS ── */
    .steps{display:flex;flex-direction:column;gap:1.25rem}
    .step-card{background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-xl);padding:1.4rem 1.5rem;display:flex;gap:1.25rem;align-items:flex-start;transition:box-shadow .2s}
    .step-card:hover{box-shadow:var(--sh-md)}
    .step-num{width:36px;height:36px;border-radius:var(--r-full);background:var(--pr);color:#fff;font-family:var(--font-display);font-weight:800;font-size:.95rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;margin-top:2px}
    .step-body{flex:1;min-width:0}
    .step-title{font-family:var(--font-display);font-size:1.05rem;font-weight:800;color:var(--txt);margin-bottom:.35rem}
    .step-desc{font-size:.875rem;color:var(--txtm);margin-bottom:.75rem}
    .step-warn{display:flex;align-items:flex-start;gap:.5rem;background:var(--warnhl);border:1px solid rgba(150,66,25,.2);border-radius:var(--r-md);padding:.6rem .9rem;font-size:.8rem;color:var(--warn);font-weight:600;margin-bottom:.75rem}

    /* ── CODE BLOCKS ── */
    .code-block{background:#0d1117;border-radius:var(--r-lg);overflow:hidden;margin:.5rem 0}
    [data-theme="light"] .code-block{background:#1e1e2e}
    .code-header{display:flex;align-items:center;justify-content:space-between;padding:.55rem 1rem;background:rgba(255,255,255,.04);border-bottom:1px solid rgba(255,255,255,.07)}
    .code-lang{font-size:.7rem;font-weight:700;color:rgba(255,255,255,.4);text-transform:uppercase;letter-spacing:.08em}
    .code-copy{font-size:.7rem;font-weight:600;color:rgba(255,255,255,.4);background:rgba(255,255,255,.07);border:none;border-radius:var(--r-sm);padding:.25rem .6rem;cursor:pointer;transition:color .15s,background .15s}
    .code-copy:hover{color:#fff;background:rgba(255,255,255,.14)}
    .code-block pre{padding:1rem 1.1rem;overflow-x:auto;font-size:.8rem;line-height:1.75;color:#e6edf3;margin:0}
    .code-block code .k{color:#ff7b72}
    .code-block code .s{color:#a5d6ff}
    .code-block code .c{color:#8b949e;font-style:italic}
    .code-block code .v{color:#ffa657}
    .code-block code .n{color:#79c0ff}
    .code-block code .p{color:#e6edf3}

    /* ── ENV TABLE ── */
    .env-table{width:100%;border-collapse:collapse;font-size:.83rem}
    .env-table th{text-align:left;padding:.55rem .9rem;background:var(--surfoff);color:var(--txtm);font-size:.7rem;font-weight:700;text-transform:uppercase;letter-spacing:.07em}
    .env-table th:first-child{border-radius:var(--r-md) 0 0 var(--r-md)}
    .env-table th:last-child{border-radius:0 var(--r-md) var(--r-md) 0}
    .env-table td{padding:.55rem .9rem;border-bottom:1px solid var(--bdr);color:var(--txt);vertical-align:top}
    .env-table td code{background:var(--surfdyn);padding:.1rem .35rem;border-radius:.25rem;font-size:.78rem;color:var(--pr)}
    .env-req{display:inline-block;background:rgba(150,66,25,.12);color:var(--warn);font-size:.67rem;font-weight:700;padding:.1rem .45rem;border-radius:var(--r-full);text-transform:uppercase;letter-spacing:.05em;white-space:nowrap}

    /* ── API TABLE ── */
    .api-group{margin-bottom:1.5rem}
    .api-group-title{font-size:.75rem;font-weight:700;text-transform:uppercase;letter-spacing:.09em;color:var(--pr);padding:.4rem .8rem;background:var(--prhl);border-radius:var(--r-md);display:inline-block;margin-bottom:.75rem}
    .api-list{display:flex;flex-direction:column;gap:.4rem}
    .api-row{display:flex;align-items:center;gap:.75rem;background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-lg);padding:.6rem .9rem}
    .api-method{font-size:.7rem;font-weight:800;padding:.2rem .55rem;border-radius:var(--r-sm);min-width:52px;text-align:center;flex-shrink:0}
    .method-get{background:rgba(67,122,34,.15);color:var(--suc)}
    .method-post{background:rgba(79,152,163,.15);color:var(--pr)}
    .method-patch{background:rgba(150,66,25,.15);color:var(--warn)}
    .api-path{font-family:monospace;font-size:.8rem;color:var(--txt);flex:1}
    .api-desc{font-size:.78rem;color:var(--txtm);text-align:right}
    .role-badge{font-size:.65rem;font-weight:700;background:var(--surfdyn);color:var(--txtm);padding:.15rem .45rem;border-radius:var(--r-full);white-space:nowrap}

    /* ── TROUBLE TABLE ── */
    .trouble-list{display:flex;flex-direction:column;gap:.6rem}
    .trouble-card{background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-lg);overflow:hidden}
    .trouble-q{display:flex;align-items:flex-start;gap:.7rem;padding:.85rem 1.1rem;cursor:pointer}
    .trouble-icon{color:var(--warn);flex-shrink:0;margin-top:1px}
    .trouble-title{font-size:.875rem;font-weight:700;color:var(--txt);flex:1}
    .trouble-chevron{color:var(--txtm);flex-shrink:0;transition:transform .22s}
    .trouble-card.open .trouble-chevron{transform:rotate(180deg)}
    .trouble-ans{max-height:0;overflow:hidden;transition:max-height .28s cubic-bezier(.16,1,.3,1)}
    .trouble-card.open .trouble-ans{max-height:300px}
    .trouble-inner{padding:.1rem 1.1rem 1rem 2.7rem;font-size:.835rem;color:var(--txtm);line-height:1.65}
    .trouble-inner code{background:var(--surfdyn);padding:.1rem .35rem;border-radius:.25rem;font-size:.78rem;color:var(--pr)}

    /* ── SCROLLREVEAL ── */
    .reveal{opacity:0}
    @supports(animation-timeline:scroll()){
      .reveal{
        clip-path:inset(15px 0 0 0);opacity:0;
        animation:rv linear both;
        animation-timeline:view();animation-range:entry 0% entry 90%;
      }
      @keyframes rv{to{opacity:1;clip-path:inset(0 0 0 0)}}
    }

    /* ── FOOTER ── */
    .footer{border-top:1px solid var(--bdr);padding:2.5rem 0;margin-top:1rem;text-align:center}
    .footer-txt{font-size:.8rem;color:var(--txtm)}
    .footer-txt a{color:var(--pr);text-decoration:none}

    @media(max-width:640px){
      .nav-links{display:none}
      .hero{padding:6rem 0 3rem}
      .tech-grid{grid-template-columns:repeat(auto-fill,minmax(130px,1fr))}
      .step-card{flex-direction:column;gap:.75rem}
      .api-desc{display:none}
    }
  </style>
</head>
<body>

<!-- NAV -->
<nav class="navbar" role="navigation" aria-label="Main navigation">
  <div class="navbar-inner">
    <a href="#" class="logo" aria-label="SaaS PM home">
      <svg class="logo-icon" viewBox="0 0 30 30" fill="none" aria-hidden="true">
        <rect width="30" height="30" rx="8" fill="var(--pr)"/>
        <path d="M7 10h5v10H7V10zM13 7h4v13h-4V7zM19 13h4v7h-4v-7z" fill="#fff" opacity=".9"/>
      </svg>
      SaaS&thinsp;PM
    </a>
    <div class="nav-links">
      <a href="#stack" class="nav-link">Stack</a>
      <a href="#structure" class="nav-link">Structure</a>
      <a href="#setup" class="nav-link">Setup</a>
      <a href="#env" class="nav-link">.env</a>
      <a href="#api" class="nav-link">API</a>
      <a href="#troubleshoot" class="nav-link">Troubleshoot</a>
    </div>
    <button class="theme-btn" data-theme-toggle aria-label="Toggle theme">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
    </button>
  </div>
</nav>

<!-- HERO -->
<header class="hero">
  <div class="container">
    <div class="hero-badge">
      <svg width="10" height="10" viewBox="0 0 10 10" fill="currentColor"><circle cx="5" cy="5" r="5"/></svg>
      v1.0.0 &nbsp;·&nbsp; MIT License
    </div>
    <h1 class="hero-title">SaaS Project<br><span>Management System</span></h1>
    <p class="hero-sub">Multi-tenant platform with role-based access control, attendance tracking, project/task management, leave approvals, and subscription billing.</p>
    <div class="hero-actions">
      <a href="#setup" class="btn btn-primary">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
        Get Started
      </a>
      <a href="#api" class="btn btn-ghost">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
        API Docs
      </a>
    </div>

    <!-- Scrolling pills -->
    <div class="pill-track">
      <div class="pill-row" aria-hidden="true">
        <span class="pill"><span class="pill-dot" style="background:var(--suc)"></span>Node.js + Express</span>
        <span class="pill"><span class="pill-dot" style="background:var(--pr)"></span>MySQL</span>
        <span class="pill"><span class="pill-dot" style="background:var(--warn)"></span>Alpine.js</span>
        <span class="pill"><span class="pill-dot" style="background:var(--err)"></span>JWT Auth</span>
        <span class="pill"><span class="pill-dot" style="background:var(--suc)"></span>bcryptjs</span>
        <span class="pill"><span class="pill-dot" style="background:var(--pr)"></span>CORS</span>
        <span class="pill"><span class="pill-dot" style="background:var(--warn)"></span>dotenv</span>
        <span class="pill"><span class="pill-dot" style="background:var(--suc)"></span>Role-Based Access</span>
        <span class="pill"><span class="pill-dot" style="background:var(--pr)"></span>Multi-Tenant</span>
        <span class="pill"><span class="pill-dot" style="background:var(--warn)"></span>Attendance Tracking</span>
        <span class="pill"><span class="pill-dot" style="background:var(--err)"></span>Leave Management</span>
        <span class="pill"><span class="pill-dot" style="background:var(--suc)"></span>Subscriptions</span>
        <!-- duplicate for seamless loop -->
        <span class="pill"><span class="pill-dot" style="background:var(--suc)"></span>Node.js + Express</span>
        <span class="pill"><span class="pill-dot" style="background:var(--pr)"></span>MySQL</span>
        <span class="pill"><span class="pill-dot" style="background:var(--warn)"></span>Alpine.js</span>
        <span class="pill"><span class="pill-dot" style="background:var(--err)"></span>JWT Auth</span>
        <span class="pill"><span class="pill-dot" style="background:var(--suc)"></span>bcryptjs</span>
        <span class="pill"><span class="pill-dot" style="background:var(--pr)"></span>CORS</span>
        <span class="pill"><span class="pill-dot" style="background:var(--warn)"></span>dotenv</span>
        <span class="pill"><span class="pill-dot" style="background:var(--suc)"></span>Role-Based Access</span>
        <span class="pill"><span class="pill-dot" style="background:var(--pr)"></span>Multi-Tenant</span>
        <span class="pill"><span class="pill-dot" style="background:var(--warn)"></span>Attendance Tracking</span>
        <span class="pill"><span class="pill-dot" style="background:var(--err)"></span>Leave Management</span>
        <span class="pill"><span class="pill-dot" style="background:var(--suc)"></span>Subscriptions</span>
      </div>
    </div>
  </div>
</header>

<!-- TECH STACK -->
<section class="section" id="stack">
  <div class="container">
    <div class="section-label reveal">Tech Stack</div>
    <h2 class="section-title reveal">What's under the hood</h2>
    <p class="section-desc reveal">A clean, dependency-light stack chosen for simplicity and speed.</p>
    <div class="tech-grid">
      <div class="tech-card reveal">
        <div class="tech-icon" style="background:rgba(67,122,34,.12)">🟢</div>
        <div class="tech-name">Node.js</div>
        <div class="tech-role">Runtime · v14+</div>
      </div>
      <div class="tech-card reveal">
        <div class="tech-icon" style="background:rgba(79,152,163,.12)">⚡</div>
        <div class="tech-name">Express</div>
        <div class="tech-role">Backend framework</div>
      </div>
      <div class="tech-card reveal">
        <div class="tech-icon" style="background:rgba(0,100,148,.12)">🐬</div>
        <div class="tech-name">MySQL</div>
        <div class="tech-role">Database · v5.7+</div>
      </div>
      <div class="tech-card reveal">
        <div class="tech-icon" style="background:rgba(150,66,25,.12)">🔐</div>
        <div class="tech-name">JWT</div>
        <div class="tech-role">Authentication</div>
      </div>
      <div class="tech-card reveal">
        <div class="tech-icon" style="background:rgba(122,57,187,.12)">🛡️</div>
        <div class="tech-name">bcryptjs</div>
        <div class="tech-role">Password hashing</div>
      </div>
      <div class="tech-card reveal">
        <div class="tech-icon" style="background:rgba(161,44,123,.12)">🌐</div>
        <div class="tech-name">Alpine.js</div>
        <div class="tech-role">Frontend reactivity</div>
      </div>
      <div class="tech-card reveal">
        <div class="tech-icon" style="background:rgba(67,122,34,.12)">📦</div>
        <div class="tech-name">dotenv</div>
        <div class="tech-role">Env config</div>
      </div>
      <div class="tech-card reveal">
        <div class="tech-icon" style="background:rgba(79,152,163,.12)">🔄</div>
        <div class="tech-name">CORS</div>
        <div class="tech-role">Cross-origin access</div>
      </div>
    </div>
  </div>
</section>

<!-- PROJECT STRUCTURE -->
<section class="section" id="structure">
  <div class="container">
    <div class="section-label reveal">Project Structure</div>
    <h2 class="section-title reveal">Folder layout</h2>
    <p class="section-desc reveal">Copy files into this exact structure before running setup.</p>
    <div class="file-tree reveal">
<span class="dir">saas-project/</span>
├── <span class="dir">backend/</span>
│   ├── <span class="dir">middleware/</span>
│   │   ├── <span class="file">auth.js</span>          <span class="comment"># JWT verification</span>
│   │   └── <span class="file">rbac.js</span>          <span class="comment"># Role-based access</span>
│   ├── <span class="dir">routes/</span>
│   │   ├── <span class="file">auth.js</span>          <span class="comment"># Login & Register</span>
│   │   ├── <span class="file">admin.js</span>         <span class="comment"># Admin endpoints</span>
│   │   ├── <span class="file">manager.js</span>       <span class="comment"># Manager endpoints</span>
│   │   ├── <span class="file">employee.js</span>      <span class="comment"># Employee endpoints</span>
│   │   ├── <span class="file">attendance.js</span>    <span class="comment"># Clock in/out, leaves</span>
│   │   ├── <span class="file">profile.js</span>       <span class="comment"># User profile</span>
│   │   ├── <span class="file">owner.js</span>         <span class="comment"># SaaS owner routes</span>
│   │   └── <span class="file">subscription.js</span>  <span class="comment"># Plan management</span>
│   ├── <span class="file">server.js</span>            <span class="comment"># Main Express app</span>
│   ├── <span class="file">package.json</span>         <span class="comment"># Node dependencies</span>
│   └── <span class="highlight">.env</span>                 <span class="comment"># ⚠️ YOU MUST CREATE THIS</span>
│
├── <span class="dir">frontend/</span>
│   ├── <span class="file">landing.html</span>         <span class="comment"># Home / marketing</span>
│   ├── <span class="file">login.html</span>           <span class="comment"># Login page</span>
│   ├── <span class="file">register.html</span>        <span class="comment"># Sign up page</span>
│   ├── <span class="file">dashboard.html</span>       <span class="comment"># Main app (all roles)</span>
│   ├── <span class="file">profile.html</span>         <span class="comment"># Profile management</span>
│   └── <span class="file">attendance.html</span>      <span class="comment"># Attendance standalone</span>
│
└── <span class="dir">database/</span>
    └── <span class="file">saas_pm_*.sql</span>        <span class="comment"># 18 schema files</span></div>
  </div>
</section>

<!-- SETUP STEPS -->
<section class="section" id="setup">
  <div class="container">
    <div class="section-label reveal">Setup Guide</div>
    <h2 class="section-title reveal">Running on a new PC</h2>
    <p class="section-desc reveal">Follow these 8 steps in order. The whole process takes under 15 minutes.</p>
    <div class="steps">

      <div class="step-card reveal">
        <div class="step-num">1</div>
        <div class="step-body">
          <div class="step-title">Install Prerequisites</div>
          <div class="step-desc">Download and install Node.js (v14+) and MySQL (v5.7+). Git is optional.</div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">bash</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code>node --version    <span style="color:#8b949e"># Must be v14 or higher</span>
npm --version     <span style="color:#8b949e"># Should show 6+</span>
mysql --version   <span style="color:#8b949e"># Should show 5.7+ or 8.x</span></code></pre>
          </div>
        </div>
      </div>

      <div class="step-card reveal">
        <div class="step-num">2</div>
        <div class="step-body">
          <div class="step-title">Copy Project Files</div>
          <div class="step-desc">Place all files in the folder structure shown above. If using Git, clone first.</div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">bash</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code>git clone &lt;your-repo-url&gt; saas-project
cd saas-project</code></pre>
          </div>
        </div>
      </div>

      <div class="step-card reveal">
        <div class="step-num">3</div>
        <div class="step-body">
          <div class="step-title">Install Node Dependencies</div>
          <div class="step-desc">Run <code style="background:var(--surfdyn);padding:.1rem .35rem;border-radius:.2rem;font-size:.82rem;color:var(--pr)">npm install</code> inside the backend folder to download all packages.</div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">bash</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code>cd backend
npm install</code></pre>
          </div>
        </div>
      </div>

      <div class="step-card reveal" id="env" style="border-color:rgba(150,66,25,.35)">
        <div class="step-num" style="background:var(--warn)">4</div>
        <div class="step-body">
          <div class="step-title">Create the <code style="font-size:.95rem">.env</code> File ⚠️</div>
          <div class="step-warn">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink:0;margin-top:1px"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
            This file is never committed to Git. You must create it manually in the backend/ folder.
          </div>
          <div class="step-desc">Create a file named <strong>.env</strong> inside <strong>backend/</strong> and paste the template below.</div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">bash — create the file</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code><span style="color:#8b949e"># Windows</span>
type nul > .env

<span style="color:#8b949e"># macOS / Linux</span>
touch .env</code></pre>
          </div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">.env — paste and edit</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code><span style="color:#8b949e"># Server</span>
PORT=3000
NODE_ENV=development

<span style="color:#8b949e"># Database (MySQL)</span>
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=<span style="color:#ffa657">your_mysql_password_here</span>
DB_NAME=saas_pm

<span style="color:#8b949e"># JWT — generate: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"</span>
JWT_SECRET=<span style="color:#ffa657">replace_with_a_long_random_string</span>

<span style="color:#8b949e"># CORS (frontend origin)</span>
CORS_ORIGIN=http://localhost:5500</code></pre>
          </div>
        </div>
      </div>

      <div class="step-card reveal">
        <div class="step-num">5</div>
        <div class="step-body">
          <div class="step-title">Create Database &amp; Import Schema</div>
          <div class="step-desc">Create the <code style="background:var(--surfdyn);padding:.1rem .35rem;border-radius:.2rem;font-size:.82rem;color:var(--pr)">saas_pm</code> database, then import all 18 SQL files.</div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">sql — create db</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code>CREATE DATABASE saas_pm
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE saas_pm;</code></pre>
          </div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">bash — import all files</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code>cd database
for f in saas_pm_*.sql; do
  mysql -u root -p saas_pm &lt; "$f"
done

<span style="color:#8b949e"># Windows (run each line):</span>
mysql -u root -p saas_pm &lt; saas_pm_tenants.sql
mysql -u root -p saas_pm &lt; saas_pm_roles.sql
<span style="color:#8b949e"># ... repeat for all 18 files</span></code></pre>
          </div>
        </div>
      </div>

      <div class="step-card reveal">
        <div class="step-num">6</div>
        <div class="step-body">
          <div class="step-title">Start the Backend</div>
          <div class="step-desc">Run the Express server. You should see the startup banner on port 3000.</div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">bash — terminal 1</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code>cd backend
node server.js

<span style="color:#8b949e"># Expected output:</span>
<span style="color:#7ee787">━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SaaS PM Server running
📡 http://localhost:3000
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span></code></pre>
          </div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">bash — verify</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code>curl http://localhost:3000/api/health
<span style="color:#8b949e"># → {"success":true,"message":"SaaS PM API is running"}</span></code></pre>
          </div>
        </div>
      </div>

      <div class="step-card reveal">
        <div class="step-num">7</div>
        <div class="step-body">
          <div class="step-title">Start the Frontend</div>
          <div class="step-desc">Serve the static HTML files on port 5500. Pick any option below.</div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">bash — terminal 2</span><button class="code-copy" onclick="copy(this)">Copy</button></div>
            <pre><code>cd frontend

<span style="color:#8b949e"># Option A — Python (easiest)</span>
python -m http.server 5500

<span style="color:#8b949e"># Option B — Node</span>
npx http-server -p 5500

<span style="color:#8b949e"># Option C — VS Code</span>
<span style="color:#8b949e"># Right-click landing.html → Open with Live Server</span></code></pre>
          </div>
        </div>
      </div>

      <div class="step-card reveal">
        <div class="step-num">8</div>
        <div class="step-body">
          <div class="step-title">Open the App 🎉</div>
          <div class="step-desc">Both servers are running. Open your browser and register the first account (auto-becomes Admin).</div>
          <div class="code-block">
            <div class="code-header"><span class="code-lang">urls</span></div>
            <pre><code><span style="color:#79c0ff">Landing  </span>  http://localhost:5500/landing.html
<span style="color:#79c0ff">Register </span>  http://localhost:5500/register.html
<span style="color:#79c0ff">Login    </span>  http://localhost:5500/login.html
<span style="color:#79c0ff">Dashboard</span>  http://localhost:5500/dashboard.html
<span style="color:#79c0ff">API Base </span>  http://localhost:3000/api</code></pre>
          </div>
        </div>
      </div>

    </div>
  </div>
</section>

<!-- ENV VARS -->
<section class="section">
  <div class="container">
    <div class="section-label reveal">Configuration</div>
    <h2 class="section-title reveal">Environment Variables Reference</h2>
    <p class="section-desc reveal">Every variable your <code style="background:var(--surfdyn);padding:.1rem .35rem;border-radius:.2rem;font-size:.85rem;color:var(--pr)">.env</code> file needs.</p>
    <div class="reveal" style="overflow-x:auto;border-radius:var(--r-xl);border:1px solid var(--bdr)">
      <table class="env-table">
        <thead>
          <tr>
            <th>Variable</th><th>Description</th><th>Default / Example</th><th>Required</th>
          </tr>
        </thead>
        <tbody>
          <tr><td><code>PORT</code></td><td>Backend server port</td><td><code>3000</code></td><td></td></tr>
          <tr><td><code>NODE_ENV</code></td><td>Runtime environment</td><td><code>development</code></td><td></td></tr>
          <tr><td><code>DB_HOST</code></td><td>MySQL host</td><td><code>localhost</code></td><td></td></tr>
          <tr><td><code>DB_PORT</code></td><td>MySQL port</td><td><code>3306</code></td><td></td></tr>
          <tr><td><code>DB_USER</code></td><td>MySQL username</td><td><code>root</code></td><td></td></tr>
          <tr><td><code>DB_PASSWORD</code></td><td>Your MySQL password</td><td><code>SecurePass123!</code></td><td><span class="env-req">Must set</span></td></tr>
          <tr><td><code>DB_NAME</code></td><td>Database name</td><td><code>saas_pm</code></td><td><span class="env-req">Must set</span></td></tr>
          <tr><td><code>JWT_SECRET</code></td><td>JWT signing key (32+ chars)</td><td>Random hex string</td><td><span class="env-req">Must set</span></td></tr>
          <tr><td><code>CORS_ORIGIN</code></td><td>Allowed frontend URL</td><td><code>http://localhost:5500</code></td><td></td></tr>
        </tbody>
      </table>
    </div>
    <p class="reveal" style="font-size:.8rem;color:var(--txtm);margin-top:.75rem">
      Generate <code style="background:var(--surfdyn);padding:.1rem .35rem;border-radius:.2rem;color:var(--pr)">JWT_SECRET</code> with: 
      <code style="background:var(--surfdyn);padding:.1rem .35rem;border-radius:.2rem;color:var(--pr)">node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"</code>
    </p>
  </div>
</section>

<!-- API REFERENCE -->
<section class="section" id="api">
  <div class="container">
    <div class="section-label reveal">API Reference</div>
    <h2 class="section-title reveal">Available Endpoints</h2>
    <p class="section-desc reveal">Base URL: <code style="background:var(--surfdyn);padding:.1rem .4rem;border-radius:.2rem;color:var(--pr)">http://localhost:3000</code> — Protected routes require <code style="background:var(--surfdyn);padding:.1rem .4rem;border-radius:.2rem;color:var(--pr)">Authorization: Bearer &lt;token&gt;</code></p>

    <div class="api-group reveal">
      <div class="api-group-title">Authentication — Public</div>
      <div class="api-list">
        <div class="api-row"><span class="api-method method-post">POST</span><span class="api-path">/api/auth/register</span><span class="api-desc">Create tenant + admin account</span></div>
        <div class="api-row"><span class="api-method method-post">POST</span><span class="api-path">/api/auth/login</span><span class="api-desc">Login, returns JWT token</span></div>
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/health</span><span class="api-desc">Server health check</span></div>
      </div>
    </div>

    <div class="api-group reveal">
      <div class="api-group-title">Attendance — JWT Required</div>
      <div class="api-list">
        <div class="api-row"><span class="api-method method-post">POST</span><span class="api-path">/api/attendance/clock-in</span><span class="role-badge">Employee · Manager</span></div>
        <div class="api-row"><span class="api-method method-post">POST</span><span class="api-path">/api/attendance/clock-out</span><span class="role-badge">Employee · Manager</span></div>
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/attendance/my</span><span class="role-badge">All roles</span></div>
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/attendance/team</span><span class="role-badge">Manager · Admin</span></div>
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/attendance/all</span><span class="role-badge">Admin</span></div>
        <div class="api-row"><span class="api-method method-post">POST</span><span class="api-path">/api/attendance/leave-request</span><span class="role-badge">Employee · Manager</span></div>
        <div class="api-row"><span class="api-method method-patch">PATCH</span><span class="api-path">/api/attendance/leave-request/:id</span><span class="role-badge">Manager · Admin</span></div>
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/attendance/pending-leaves</span><span class="role-badge">Manager · Admin</span></div>
      </div>
    </div>

    <div class="api-group reveal">
      <div class="api-group-title">Admin — Admin JWT Required</div>
      <div class="api-list">
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/admin/users</span><span class="api-desc">List all users</span></div>
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/admin/teams</span><span class="api-desc">List all teams</span></div>
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/admin/projects</span><span class="api-desc">List all projects</span></div>
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/admin/tasks</span><span class="api-desc">List all tasks</span></div>
        <div class="api-row"><span class="api-method method-patch">PATCH</span><span class="api-path">/api/admin/user/:id/role</span><span class="api-desc">Change user role</span></div>
      </div>
    </div>

    <div class="api-group reveal">
      <div class="api-group-title">Profile & Subscriptions</div>
      <div class="api-list">
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/profile</span><span class="api-desc">Get own profile</span></div>
        <div class="api-row"><span class="api-method method-patch">PATCH</span><span class="api-path">/api/profile</span><span class="api-desc">Update own profile</span></div>
        <div class="api-row"><span class="api-method method-get">GET</span><span class="api-path">/api/subscription</span><span class="api-desc">Get current plan</span></div>
      </div>
    </div>
  </div>
</section>

<!-- TROUBLESHOOT -->
<section class="section" id="troubleshoot">
  <div class="container">
    <div class="section-label reveal">Troubleshooting</div>
    <h2 class="section-title reveal">Common Issues</h2>
    <p class="section-desc reveal">Click any error to expand the fix.</p>
    <div class="trouble-list reveal">

      <div class="trouble-card">
        <div class="trouble-q" onclick="toggle(this)">
          <svg class="trouble-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          <span class="trouble-title">Cannot find module 'express' / 'mysql2'</span>
          <svg class="trouble-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="trouble-ans"><div class="trouble-inner">You forgot to run <code>npm install</code> in the <code>backend/</code> folder. Run <code>cd backend && npm install</code> and try again.</div></div>
      </div>

      <div class="trouble-card">
        <div class="trouble-q" onclick="toggle(this)">
          <svg class="trouble-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          <span class="trouble-title">Error: connect ECONNREFUSED / DB won't connect</span>
          <svg class="trouble-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="trouble-ans"><div class="trouble-inner">MySQL is not running, or your <code>.env</code> credentials are wrong. Verify MySQL is alive with <code>mysql -u root -p -e "SELECT 1;"</code>. Double-check <code>DB_PASSWORD</code> and <code>DB_NAME</code> in <code>.env</code>.</div></div>
      </div>

      <div class="trouble-card">
        <div class="trouble-q" onclick="toggle(this)">
          <svg class="trouble-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          <span class="trouble-title">405 Method Not Allowed / fetch going to port 5500</span>
          <svg class="trouble-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="trouble-ans"><div class="trouble-inner">Your frontend JS is calling <code>/api/...</code> relative to the static server (port 5500) instead of the API (port 3000). Set <code>API_BASE = "http://localhost:3000"</code> in your <code>attendanceApp()</code> / Alpine component and prefix every <code>fetch()</code> call with it.</div></div>
      </div>

      <div class="trouble-card">
        <div class="trouble-q" onclick="toggle(this)">
          <svg class="trouble-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          <span class="trouble-title">Unexpected end of JSON input</span>
          <svg class="trouble-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="trouble-ans"><div class="trouble-inner">The server returned HTML (a 404/405 error page) and the frontend tried to <code>.json()</code> it. Add an <code>if (!r.ok)</code> guard before calling <code>r.json()</code> in your fetch handlers, and confirm the correct port is being used.</div></div>
      </div>

      <div class="trouble-card">
        <div class="trouble-q" onclick="toggle(this)">
          <svg class="trouble-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          <span class="trouble-title">CORS error in browser console</span>
          <svg class="trouble-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="trouble-ans"><div class="trouble-inner">The <code>CORS_ORIGIN</code> in <code>.env</code> must match the exact URL your frontend runs on. If VS Code Live Server uses <code>http://127.0.0.1:5500</code>, that is different from <code>http://localhost:5500</code>. Add both to the <code>origin</code> array in <code>server.js</code>.</div></div>
      </div>

      <div class="trouble-card">
        <div class="trouble-q" onclick="toggle(this)">
          <svg class="trouble-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          <span class="trouble-title">Invalid token / Unauthorized after login</span>
          <svg class="trouble-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="trouble-ans"><div class="trouble-inner">Make sure <code>JWT_SECRET</code> in <code>.env</code> is not empty. Open browser DevTools → Application → Local Storage → clear all keys, then log in again to get a fresh token.</div></div>
      </div>

      <div class="trouble-card">
        <div class="trouble-q" onclick="toggle(this)">
          <svg class="trouble-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
          <span class="trouble-title">Alpine Warning: x-if can only be used on &lt;template&gt;</span>
          <svg class="trouble-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
        </div>
        <div class="trouble-ans"><div class="trouble-inner">Alpine's <code>x-if</code> only works on a <code>&lt;template&gt;</code> tag. Use <code>x-show</code> on a regular element (<code>&lt;section&gt;</code>, <code>&lt;div&gt;</code>), or wrap the section in a <code>&lt;template x-if="..."&gt;</code> tag.</div></div>
      </div>

    </div>
  </div>
</section>

<!-- SECURITY -->
<section class="section">
  <div class="container">
    <div class="section-label reveal">Security</div>
    <h2 class="section-title reveal">Before going to production</h2>
    <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:.75rem" class="reveal">
      <div style="background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-xl);padding:1.1rem 1.1rem">
        <div style="font-size:1.3rem;margin-bottom:.4rem">🔒</div>
        <div style="font-size:.875rem;font-weight:700;color:var(--txt);margin-bottom:.25rem">Never commit .env</div>
        <div style="font-size:.78rem;color:var(--txtm)">Add <code style="background:var(--surfdyn);border-radius:.2rem;padding:.05rem .3rem;color:var(--pr)">backend/.env</code> to <code style="background:var(--surfdyn);border-radius:.2rem;padding:.05rem .3rem;color:var(--pr)">.gitignore</code></div>
      </div>
      <div style="background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-xl);padding:1.1rem 1.1rem">
        <div style="font-size:1.3rem;margin-bottom:.4rem">🔑</div>
        <div style="font-size:.875rem;font-weight:700;color:var(--txt);margin-bottom:.25rem">Strong JWT Secret</div>
        <div style="font-size:.78rem;color:var(--txtm)">Use 32+ random characters, never a plain word</div>
      </div>
      <div style="background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-xl);padding:1.1rem 1.1rem">
        <div style="font-size:1.3rem;margin-bottom:.4rem">🌐</div>
        <div style="font-size:.875rem;font-weight:700;color:var(--txt);margin-bottom:.25rem">Restrict CORS</div>
        <div style="font-size:.78rem;color:var(--txtm)">In production point to your real domain only</div>
      </div>
      <div style="background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-xl);padding:1.1rem 1.1rem">
        <div style="font-size:1.3rem;margin-bottom:.4rem">🔐</div>
        <div style="font-size:.875rem;font-weight:700;color:var(--txt);margin-bottom:.25rem">Use HTTPS</div>
        <div style="font-size:.78rem;color:var(--txtm)">HTTP in prod exposes JWTs. Use a reverse proxy (Nginx + Certbot)</div>
      </div>
      <div style="background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-xl);padding:1.1rem 1.1rem">
        <div style="font-size:1.3rem;margin-bottom:.4rem">🛡️</div>
        <div style="font-size:.875rem;font-weight:700;color:var(--txt);margin-bottom:.25rem">Audit Dependencies</div>
        <div style="font-size:.78rem;color:var(--txtm)">Run <code style="background:var(--surfdyn);border-radius:.2rem;padding:.05rem .3rem;color:var(--pr)">npm audit fix</code> regularly</div>
      </div>
      <div style="background:var(--surf);border:1px solid var(--bdr);border-radius:var(--r-xl);padding:1.1rem 1.1rem">
        <div style="font-size:1.3rem;margin-bottom:.4rem">⚙️</div>
        <div style="font-size:.875rem;font-weight:700;color:var(--txt);margin-bottom:.25rem">NODE_ENV=production</div>
        <div style="font-size:.78rem;color:var(--txtm)">Hides raw error messages from API responses</div>
      </div>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer class="footer">
  <div class="container">
    <div style="display:flex;align-items:center;justify-content:center;gap:.6rem;margin-bottom:.6rem">
      <svg viewBox="0 0 30 30" fill="none" width="22" height="22" aria-hidden="true">
        <rect width="30" height="30" rx="8" fill="var(--pr)"/>
        <path d="M7 10h5v10H7V10zM13 7h4v13h-4V7zM19 13h4v7h-4v-7z" fill="#fff" opacity=".9"/>
      </svg>
      <span style="font-family:var(--font-display);font-weight:800;color:var(--txt);font-size:.95rem">SaaS PM</span>
    </div>
    <p class="footer-txt">v1.0.0 &nbsp;·&nbsp; MIT License &nbsp;·&nbsp; April 2026</p>
  </div>
</footer>

<script>
  // Theme toggle
  (function(){
    const btn=document.querySelector('[data-theme-toggle]'),r=document.documentElement;
    let d=r.getAttribute('data-theme')||'dark';
    function setTheme(v){d=v;r.setAttribute('data-theme',d);btn&&(btn.innerHTML=d==='dark'?'<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>':'<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>')}
    setTheme(d);
    btn&&btn.addEventListener('click',()=>setTheme(d==='dark'?'light':'dark'));
  })();

  // Accordion
  function toggle(el){
    const card=el.closest('.trouble-card');
    document.querySelectorAll('.trouble-card.open').forEach(c=>{if(c!==card)c.classList.remove('open')});
    card.classList.toggle('open');
  }

  // Copy button
  function copy(btn){
    const code=btn.closest('.code-block').querySelector('pre').innerText;
    navigator.clipboard.writeText(code).then(()=>{
      btn.textContent='Copied!';
      setTimeout(()=>btn.textContent='Copy',1800);
    });
  }

  // Scroll reveal fallback (for browsers without scroll-driven animations)
  if(!CSS.supports('animation-timeline','scroll()')){
    const obs=new IntersectionObserver((entries)=>{
      entries.forEach(e=>{
        if(e.isIntersecting){e.target.style.transition='opacity .5s ease, transform .5s ease';e.target.style.opacity='1';e.target.style.transform='none';obs.unobserve(e.target)}
      })
    },{threshold:.1});
    document.querySelectorAll('.reveal').forEach(el=>{el.style.opacity='0';el.style.transform='translateY(14px)';obs.observe(el)});
  }
</script>
</body>
</html>