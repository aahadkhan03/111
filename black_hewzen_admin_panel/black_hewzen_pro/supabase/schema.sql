-- Run in Supabase SQL Editor. Use only after reviewing the schema and your data policy.
create extension if not exists pgcrypto;

create table if not exists public.products (
 id uuid primary key default gen_random_uuid(),
 name text not null,
 category text not null check (category in ('Jackets','Lowers','Essentials')),
 price numeric(10,2) not null check (price > 0),
 wholesale_price numeric(10,2) check (wholesale_price is null or wholesale_price > 0),
 image_url text not null,
 stock integer not null default 0 check (stock >= 0),
 tag text,
 sizes text[] not null default '{}',
 colors text[] not null default '{}',
 pack_size integer not null default 1 check (pack_size >= 1),
 active boolean not null default true,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);

create table if not exists public.dealers (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null unique references auth.users(id) on delete cascade,
 shop_name text not null,
 gst_number text,
 pan_number text,
 mobile text not null,
 address text not null,
 city text not null,
 pincode text not null,
 status text not null default 'pending' check (status in ('pending','approved','rejected')),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);

create table if not exists public.orders (
 id uuid primary key default gen_random_uuid(),
 user_id uuid references auth.users(id) on delete set null,
 customer_name text not null,
 customer_phone text not null,
 shipping_address text not null,
 shipping_city text not null,
 shipping_pincode text not null,
 customer_type text not null default 'retail' check (customer_type in ('retail','wholesale')),
 payment_method text not null check (payment_method in ('cod','online')),
 payment_status text not null default 'pending' check (payment_status in ('pending','authorized','paid','failed','refunded')),
 order_status text not null default 'pending_payment' check (order_status in ('pending_payment','confirmed','processing','packed','shipped','delivered','cancelled')),
 subtotal numeric(10,2) not null check (subtotal >= 0),
 shipping_fee numeric(10,2) not null default 0 check (shipping_fee >= 0),
 total numeric(10,2) not null check (total >= 0),
 razorpay_order_id text unique,
 razorpay_payment_id text,
 items jsonb not null,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);

alter table public.products enable row level security;
alter table public.dealers enable row level security;
alter table public.orders enable row level security;

-- Public storefront reads only active products. Writes are server-side using service role.
drop policy if exists "Public can view active products" on public.products;
create policy "Public can view active products" on public.products for select using (active = true);

-- Sensitive dealer and order records have no direct client policies. Access them only through
-- the API using the service role, with verified auth and server-side authorization.
-- Never expose SUPABASE_SERVICE_ROLE_KEY in the browser.
