-- NEBCM Command Center - Supabase Schema
-- Run this entire file in your Supabase SQL Editor

-- Enable realtime on all tables
-- (done via Table Editor > Replication after creation)

-- Businesses table
create table if not exists businesses (
  id text primary key,
  name text not null,
  sub text,
  status text default 'concept',
  track text,
  engine text,
  score jsonb default '{"viability":70,"ops":70,"demand":70,"scale":70}',
  insights jsonb default '[]',
  actions jsonb default '[]',
  notes text default '',
  content_days integer default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Activity log (for the feed)
create table if not exists activity_log (
  id bigserial primary key,
  business_id text references businesses(id) on delete cascade,
  action text not null,
  detail text,
  created_at timestamptz default now()
);

-- Settings table (single row)
create table if not exists app_settings (
  id integer primary key default 1,
  founder_name text default '',
  location text default 'Tamraght/Agadir, Morocco',
  pin_hash text default '',
  updated_at timestamptz default now(),
  constraint single_row check (id = 1)
);

-- Insert default settings row
insert into app_settings (id) values (1) on conflict (id) do nothing;

-- Updated_at trigger
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger businesses_updated_at
  before update on businesses
  for each row execute function update_updated_at();

-- Enable Row Level Security (RLS) - allow all for now (no auth)
alter table businesses enable row level security;
alter table activity_log enable row level security;
alter table app_settings enable row level security;

-- Public read + write policies (PIN enforcement is in the app)
create policy "Public read businesses" on businesses for select using (true);
create policy "Public write businesses" on businesses for insert with check (true);
create policy "Public update businesses" on businesses for update using (true);
create policy "Public delete businesses" on businesses for delete using (true);

create policy "Public read activity" on activity_log for select using (true);
create policy "Public write activity" on activity_log for insert with check (true);

create policy "Public read settings" on app_settings for select using (true);
create policy "Public update settings" on app_settings for update using (true);

-- Enable realtime for businesses table
-- After running this SQL, go to:
-- Supabase Dashboard > Database > Replication
-- and enable replication for the 'businesses' table
