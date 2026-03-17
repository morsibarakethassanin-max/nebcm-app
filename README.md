# NEBCM Command Center — Deployment Guide

Live URL after deploy: `https://your-project.vercel.app`
Time to deploy: **~15 minutes**

---

## What you're deploying

- **Frontend** → Vercel (free hosting, global CDN, your custom URL)
- **Database** → Supabase (free tier, real-time sync, all businesses stored here)
- **AI Proxy** → Vercel Edge Function (Claude Haiku calls go through this, your API key stays secret)

---

## Step 1 — Create accounts (5 min)

1. **GitHub** — github.com → Sign up (free). You need this to deploy to Vercel.
2. **Vercel** — vercel.com → Sign up with GitHub.
3. **Supabase** — supabase.com → Sign up (free).

---

## Step 2 — Set up Supabase database (5 min)

1. Go to **supabase.com** → New Project
2. Name it `nebcm` → Choose a strong database password → Pick a region close to Morocco (EU West is fine)
3. Wait ~2 minutes for the project to provision
4. Go to **SQL Editor** (left sidebar) → New Query
5. Copy the entire contents of `schema.sql` from this folder and paste it → Click **Run**
6. You should see "Success. No rows returned"

**Get your keys** (you'll need these in Step 4):
- Go to **Settings → API**
- Copy: **Project URL** (looks like `https://xxxxxxxxxxxx.supabase.co`)
- Copy: **anon public** key (long JWT string starting with `eyJ...`)

**Enable Realtime** (for live sync):
- Go to **Database → Replication**
- Find the `businesses` table → Toggle it ON

---

## Step 3 — Push code to GitHub (3 min)

```bash
# In terminal, from this folder:
cd nebcm-app
git init
git add .
git commit -m "NEBCM Command Center"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/nebcm-app.git
git push -u origin main
```

(Create the `nebcm-app` repo on GitHub first — github.com → New Repository → name it `nebcm-app` → don't initialize it)

---

## Step 4 — Deploy to Vercel (3 min)

1. Go to **vercel.com** → New Project
2. Import your `nebcm-app` repository from GitHub
3. Vercel auto-detects the config — **don't change any build settings**
4. Before clicking Deploy, go to **Environment Variables** and add:

| Name | Value |
|------|-------|
| `ANTHROPIC_API_KEY` | `sk-ant-api03-...` (your Anthropic key) |

5. Click **Deploy**
6. In ~30 seconds you get a URL like `https://nebcm-app-xxxx.vercel.app`

---

## Step 5 — First-time setup in the app (2 min)

1. Open your Vercel URL in Chrome
2. The setup screen appears — fill in:
   - **Supabase Project URL** (from Step 2)
   - **Supabase Anon Key** (from Step 2)
   - **Admin PIN** — 4 digits, only you know this (Ziyad won't need it to view)
   - **Your name** (shows in the header)
3. Click **Launch Command Center**
4. The app seeds your full business portfolio into Supabase automatically

**Share the URL with Ziyad** — he can view everything and update content buffer counts. Only you can edit statuses, notes, and add ideas (requires PIN).

---

## Giving Ziyad access

Just send him the URL. That's it.

- **View everything** — no PIN needed
- **Update content buffer** — no PIN needed  
- **Add/edit businesses** — requires your PIN (don't share it)

---

## Custom domain (optional, free)

In Vercel → Project Settings → Domains → Add `nebcm.yourdomain.com`
Then add the DNS record at your domain registrar. Takes 5-10 minutes.

---

## Costs

| Service | Cost |
|---------|------|
| Vercel | Free (Hobby plan) |
| Supabase | Free (500MB, 50K rows) |
| Claude Haiku | ~$0.001 per AI Advisor message |
| Total | **~$0/month** |

---

## Updating the app

Edit `public/index.html` or `api/chat.js` → commit and push to GitHub → Vercel redeploys automatically in ~20 seconds.

---

## Troubleshooting

**"Connection failed" on setup screen**
→ Double-check your Supabase URL and anon key. The URL should end with `.supabase.co` (no trailing slash).

**AI Advisor not responding**
→ Check Vercel → Project → Functions → `api/chat` → View logs. Usually means the `ANTHROPIC_API_KEY` environment variable is missing or wrong.

**Real-time not working (screen doesn't update when Ziyad edits)**
→ Make sure Realtime is enabled for the `businesses` table in Supabase → Database → Replication.

**Businesses not loading**
→ Check that you ran the `schema.sql` in Supabase SQL Editor. Open Supabase → Table Editor → you should see a `businesses` table with rows.
