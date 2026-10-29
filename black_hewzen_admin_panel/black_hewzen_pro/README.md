# BLACK HEWZEN — B2B + B2C ecommerce starter

This is a deployable **starter scaffold**, not a fully audited production store. It includes:
- Responsive storefront with retail/wholesale mode
- Product list from API with demo fallback
- Dealer registration and admin approval API
- Admin-protected product/dealer/order routes
- Razorpay order creation + signature verification
- COD order creation
- Supabase SQL schema with Row Level Security starter policies
- Deployment guide

## Stack
- Frontend: Vite + React
- Backend: Node.js + Express
- Database/auth: Supabase (Postgres + Auth)
- Online payment: Razorpay Checkout (server creates and verifies orders)
- Hosting: Vercel (frontend) + Render (API) + Supabase (database)

## Run locally
1. Install Node.js 20+.
2. Create a Supabase project. In SQL Editor, run `supabase/schema.sql`.
3. Copy `server/.env.example` to `server/.env` and fill values.
4. In one terminal:
   ```bash
   cd server
   npm install
   npm run dev
   ```
5. In another terminal:
   ```bash
   cd client
   npm install
   cp .env.example .env
   npm run dev
   ```
6. Open the Vite URL printed in the terminal.

## Critical setup
- Set `ADMIN_EMAILS` to your own verified admin email(s), comma-separated. This scaffold uses Supabase Auth bearer tokens and checks admin email on the server.
- Create the first admin user in Supabase Auth and verify the email.
- Configure Supabase Auth URL allow-list for local and production domains.
- Configure Razorpay keys in server environment. Never put `RAZORPAY_KEY_SECRET` in frontend variables.
- Set the official WhatsApp number in `client/src/App.jsx` if you want WhatsApp links.
- Replace demo product photos/prices with your real catalogue and confirm stock/pack rules.
- Use HTTPS in production. Set strict CORS `CLIENT_ORIGIN`.
- Add shipping integration, email/SMS notifications, returns/refunds, tax invoices, backups, monitoring and security review before accepting real orders.

## Security / production notes
- Do not store card data. Razorpay Checkout handles payment details.
- Never trust a frontend price or payment status; server fetches product prices and verifies payment signature.
- The sample COD route is intentionally basic and should be extended with rate limits, address validation, idempotency, and fraud controls.
- Dealer KYC data should be minimized, access-restricted, encrypted where appropriate, and retained only as long as needed. Avoid collecting Aadhaar unless you have a lawful, necessary process.
- This starter does not claim legal/tax compliance or PCI certification. Have the final system reviewed before launch.
