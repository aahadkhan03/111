# Production deployment checklist

## 1) Supabase database + authentication
1. Create a project at Supabase.
2. Run `supabase/schema.sql` in SQL Editor.
3. Copy Project URL, anon key and service-role key into the correct environment settings.
4. Enable email/password auth and configure email verification, password reset and allowed redirect URLs.
5. Create your own admin user, verify it, and put its email in `ADMIN_EMAILS`.
6. Never put the service-role key in Vite/client variables.

## 2) Razorpay
1. Create a Razorpay account and complete the business/KYC steps it requires.
2. Test with test keys first.
3. Set `RAZORPAY_KEY_ID` and `RAZORPAY_KEY_SECRET` on the API host; set only `VITE_RAZORPAY_KEY_ID` in the frontend.
4. Configure and verify payment webhooks for reliable asynchronous payment updates before launch. This starter verifies checkout signatures, but a hardened launch should add signed webhook processing and idempotent event handling.
5. Test success, failure, cancel, duplicate callback and refund scenarios.

## 3) Deploy API to Render
1. Push this folder to a private Git repository.
2. Create a Render Web Service from the repository; set Root Directory to `server`.
3. Build command: `npm install`
4. Start command: `npm start`
5. Add every variable from `server/.env.example` in Render dashboard. Set `NODE_ENV=production`, `CLIENT_ORIGIN=https://YOUR-FRONTEND-DOMAIN`.
6. Deploy and test `https://YOUR-API.onrender.com/health`.

## 4) Deploy frontend to Vercel
1. Import the same Git repository in Vercel.
2. Set Root Directory to `client`; Framework preset Vite.
3. Add `VITE_API_URL=https://YOUR-API.onrender.com`, `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, `VITE_RAZORPAY_KEY_ID`.
4. Deploy. Set the exact Vercel domain in `CLIENT_ORIGIN` on Render and redeploy the API.
5. Add your final domain to Vercel and update Supabase Auth redirect allow-list.

## 5) Domain
Buy a domain from a reputable registrar, then add it in Vercel's domain settings and follow the DNS records shown there. Use the exact DNS values Vercel provides; do not guess them. Ensure HTTPS works before taking orders.

## 6) Before launch
- Add product administration UI (API routes exist; current UI is storefront + dealer form).
- Add user sign-up, email verification, password reset and customer order history.
- Add server-side stock reservation/decrement in a database transaction or RPC to prevent overselling; current API checks stock but does not atomically reserve it.
- Add shipping charges, serviceability, GST invoices, returns/refunds, notifications and shipping-provider integration.
- Add Razorpay webhooks, idempotency keys, logging, backups, alerts and database retention policies.
- Add a proper admin UI to manage products, orders and dealers; API endpoints are present but admin pages are not included in this starter.
- Add consent/privacy pages, terms, cancellation/return policy and contact details.
- Review applicable Indian consumer, tax, privacy and payment obligations with qualified professionals.
- Run security testing and a small end-to-end test order before accepting live payments.
