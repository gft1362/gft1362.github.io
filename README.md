# 🧬 ژنوم — سامانه هوشمند استعدادیابی

> نقشه استعداد، نه فقط یک عدد.

سامانه‌ی چندوجهی استعدادیابی کودک، نوجوان و بزرگسال با تکالیف عملکردی، پرسشنامه، کنترل اعتبار پاسخ و نقشه اقدام ۶ ماهه.

---

## 📑 فهرست

- [ویژگی‌ها](#-ویژگی‌ها)
- [ساختار پروژه](#-ساختار-پروژه)
- [شروع سریع](#-شروع-سریع)
- [تست محلی](#-تست-محلی)
- [استقرار روی GitHub Pages](#-استقرار-روی-github-pages)
- [متغیرهای قابل تنظیم](#-متغیرهای-قابل-تنظیم)
- [مسیر راه‌اندازی بک‌اند](#-مسیر-راه‌اندازی-بک-اند)
- [مشارکت](#-مشارکت)
- [مجوز](#-مجوز)

---

## ✨ ویژگی‌ها

### 🎯 ارزیابی
- **۸ محور شناختی-رفتاری** برای کودک و نوجوان (۸ تا ۱۸ سال)
- **۱۵ زیراستعداد** در ۵ دامنه برای بزرگسال
- تکالیف عملکردی (نه فقط خوداظهاری)
- کنترل اعتبار پاسخ‌ها (شناسایی پاسخ تصادفی)
- کارنامه با بازه (نه عدد دقیق‌نما)

### 📊 خروجی
- نمودار راداری SVG (بدون کتابخانه خارجی)
- نقشه اقدام ۶ ماهه قابل چاپ
- ذخیره به‌صورت PDF (از طریق چاپ مرورگر)
- ذخیره در مرورگر (localStorage) — پیش‌فرض

### 🔒 حریم خصوصی
- بدون نام کامل، جنسیت یا اطلاعات هویتی
- بدون کوکی ردیابی
- بدون آنالیتیکس شخص ثالث
- بدون پیکسل تبلیغاتی
- سازگار با COPPA برای کودکان

### ♿ دسترس‌پذیری
- کاملاً RTL با `lang="fa"`
- پشتیبانی از keyboard navigation
- focus trap در dialogها
- `aria-label`, `aria-selected`, `aria-live`
- skip link
- پشتیبانی از `prefers-reduced-motion`
- پشتیبانی از `prefers-color-scheme: dark`

### 🚀 عملیاتی
- PWA (قابل نصب با manifest.json)
- Service Worker برای offline
- CSP (Content Security Policy)
- مینیفای نشده برای شفافیت کد

### 📈 SEO
- JSON-LD: `WebSite`, `Organization`, `Service`, `FAQPage`, `BreadcrumbList`
- Open Graph tags
- Twitter Card
- `canonical`, `hreflang`
- `robots.txt` و `sitemap.xml`

---

## 📁 ساختار پروژه

```
genome/
├── index.html              ← صفحه ورودی (ریدایرکت به genome.html)
├── genome.html             ← لندینگ پیج اصلی
├── privacy.html            ← حریم خصوصی و شرایط استفاده
├── questionnaire.html      ← پرسشنامه تعاملی
├── result.html             ← کارنامه و نقشه اقدام
├── manifest.json           ← PWA manifest
├── sw.js                   ← Service Worker
├── robots.txt              ← دستورالعمل موتورهای جستجو
├── sitemap.xml             ← نقشه سایت
├── .gitignore              ← نادیده‌گیری‌های گیت
└── README.md               ← همین فایل
```

---

## 🚀 شروع سریع

### روش ۱: استفاده مستقیم (ساده‌ترین)

فایل‌ها را در یک پوشه دانلود کنید و `index.html` را در مرورگر باز کنید. به‌جز فرم لیست انتظار (که نیاز به بک‌اند دارد)، همه‌ی قابلیت‌ها بدون سرور کار می‌کنند.

```bash
# کلون کنید
git clone https://github.com/YOUR_USERNAME/genome.git
cd genome

# در مرورگر باز کنید
open index.html        # macOS
xdg-open index.html    # Linux
start index.html       # Windows
```

### روش ۲: سرور محلی (توصیه‌شده)

برای تست کامل Service Worker و `fetch` به `/api/waitlist`، یک سرور محلی اجرا کنید:

```bash
# با Python
python3 -m http.server 8000

# یا با Node.js
npx serve .

# سپس در مرورگر باز کنید:
# http://localhost:8000
```

---

## 🧪 تست محلی

### تست عملی با Playwright (اختیاری)

اگر `agent-browser` را نصب دارید:

```bash
npm install -g agent-browser
agent-browser install

agent-browser open http://localhost:8000
agent-browser screenshot --full preview.png
```

### تست‌های دستی پیشنهادی

| تست | انتظار |
|-----|--------|
| خالی گذاشتن فرم و کلیک ثبت‌نام | پیام خطا: «ایمیل یا شماره موبایل معتبر وارد کنید» |
| ایمیل نامعتبر `abc` | همان پیام خطا |
| موبایل صحیح `09123456789` بدون تیک consent | «برای ثبت‌نام، موافقت با سیاست حریم خصوصی لازم است» |
| موبایل صحیح + تیک consent | «حالت آزمایشی: سرور متصل نیست؛ ثبت‌نام فقط در همین مرورگر ذخیره شد» |
| ۲ ثبت‌نام پشت سر هم زیر ۵ ثانیه | «برای جلوگیری از ارسال بیش از حد، ۵ ثانیه صبر کنید» |
| کلیک روی «خلاصه سیاست حریم خصوصی» | دیالوگ باز می‌شود |
| زدن Escape در دیالوگ | دیالوگ بسته می‌شود |
| کلیک تب «بزرگسال» | محتوای کارنامه تغییر می‌کند |
| کلید Arrow Left/Right در تب‌ها | بین تب‌ها جابه‌جا می‌شود |
| اسکرول عمودی > 500px | دکمه «بازگشت به بالا» ظاهر می‌شود |
| اندازه 375×812 (موبایل) | منوی burger فعال، جدول مقایسه اسکرول‌پذیر |

---

## 🌐 استقرار روی GitHub Pages

GitHub Pages به‌صورت رایگان به شما یک دامنه‌ی `username.github.io/repo-name` می‌دهد.

### گام ۱: ساخت مخزن در گیت‌هاب

1. به [github.com/new](https://github.com/new) بروید
2. نام مخزن: `genome` (یا هر نام دیگر)
3. **Public** انتخاب کنید
4. **Initialize with README** را **فعال نکنید** (ما README خودمان را داریم)
5. روی **Create repository** کلیک کنید

### گام ۲: کلون و آماده‌سازی

```bash
git clone https://github.com/YOUR_USERNAME/genome.git
cd genome

# فایل‌های پروژه را در این پوشه کپی کنید
# (یا از پوشه‌ی /home/z/my-project/download/github/ همه را کپی کنید)

git add .
git status   # بررسی فایل‌های اضافه‌شده
```

### گام ۳: commit و push

```bash
git commit -m "feat: نسخه اولیه سامانه ژنوم

- لندینگ پیج کامل با ۱۱ بخش
- صفحه حریم خصوصی با ۹ بخش
- پرسشنامه تعاملی ۸ سوالی
- کارنامه با نقشه اقدام ۶ ماهه
- PWA با Service Worker
- پشتیبانی کامل RTL و dark mode
- JSON-LD برای SEO"

git branch -M main
git push -u origin main
```

### گام ۴: فعال‌سازی GitHub Pages

1. در صفحه‌ی مخزن، به **Settings** → **Pages** بروید
2. در بخش **Source**، گزینه‌ی **Deploy from a branch** را انتخاب کنید
3. در بخش **Branch**، `main` و `/root` را انتخاب کنید
4. روی **Save** کلیک کنید

### گام ۵: انتظار برای deploy

- حدود ۱ تا ۲ دقیقه طول می‌کشد
- سپس سایت شما در آدرس زیر در دسترس خواهد بود:

```
https://YOUR_USERNAME.github.io/genome/
```

### گام ۶: تنظیم `canonical` و `sitemap.xml`

در `genome.html` و `privacy.html`، جست‌وجو و جایگزین کنید:

| جست‌وجو | جایگزین با |
|---------|------------|
| `genome.example.com` | `YOUR_USERNAME.github.io/genome` |
| `genome_ir` (تلگرام/اینستاگرام) | کانال‌های واقعی شما |
| `09123456789` | شماره تماس واقعی |
| `privacy@genome.example.com` | ایمیل واقعی |

---

## ⚙️ متغیرهای قابل تنظیم

### در `genome.html`

| متغیر | خط | توضیح |
|-------|----|-------|
| نام‌ها و تخصص‌های تیم | بخش `#team` | نام‌های واقعی تیم خود را قرار دهید |
| نظرات کاربران | بخش `.testimonials` | شهادت‌نامه‌های واقعی (با اجازه‌ی صاحبان) |
| ایمیل‌ها و شماره‌ها | footer و privacy.html | اطلاعات تماس واقعی |
| شبکه‌های اجتماعی | footer | لینک‌های واقعی کانال‌ها |

### در `manifest.json`

```json
"shortcuts": [
  {"name": "شروع ارزیابی", "url": "./questionnaire.html"},
  ...
]
```

می‌توانید shortcutهای دلخواه اضافه کنید.

### در `sw.js`

```javascript
const CACHE = 'genome-v1';
const STATIC_ASSETS = [...];  // فایل‌های کش‌شده را مدیریت کنید
```

برای به‌روزرسانی کش، نسخه‌ی `genome-v1` را به `genome-v2` تغییر دهید.

---

## 🔌 مسیر راه‌اندازی بک‌اند (اختیاری)

فرم لیست انتظار به `/api/waitlist` نیاز دارد. در حالت آزمایشی، داده‌ها در `localStorage` ذخیره می‌شوند. برای تولید واقعی، یکی از گزینه‌های زیر را پیشنهاد می‌کنیم:

### گزینه ۱: Cloudflare Workers (رایگان، بدون سرور)

```javascript
// worker.js
addEventListener('fetch', e => {
  if (e.request.method !== 'POST') return new Response('Method Not Allowed', {status: 405});
  
  e.respondWith(handlePost(e.request));
});

async function handlePost(req) {
  const {contact, path} = await req.json();
  // اعتبارسنجی
  if (!contact || !path) return new Response('Invalid', {status: 422});
  // ذخیره در KV
  await KV.put(`wl:${Date.now()}`, JSON.stringify({contact, path}));
  return new Response('OK', {status: 200});
}
```

### گزینه ۲: GitHub Actions (با Google Sheets API)

یک Google Sheet بسازید، Service Account ایجاد کنید، و از GitHub Actions برای append استفاده کنید.

### گزینه ۳: Vercel/Netlify Functions

```javascript
// /api/waitlist.js (Next.js / Vercel)
export default async function handler(req, res) {
  if (req.method !== 'POST') return res.status(405).end();
  const {contact, path} = req.body;
  // ذخیره در دیتابیس (مثل Supabase)
  res.status(200).json({ok: true});
}
```

### گزینه ۴: Firebase Realtime Database

ساده‌ترین گزینه برای شروع — Firebase Free Tier کاملاً کافی است.

---

## 🤝 مشارکت

PR و issue‌ها خوشامد است. لطفاً قبل از شروع، یک issue باز کنید تا درباره‌ی تغییر مورد نظر صحبت کنیم.

### قوانین مشارکت

1. کد باید بدون ESLint خطا باشد
2. تست‌های دستی بالا باید پاس شوند
3. در صورتی که CSS تغییر می‌دهید، مطمئن شوید dark mode و RTL هنوز کار می‌کنند
4. accessibility checklist:
   - [ ] همه‌ی inputها `aria-label` یا `<label>` دارند
   - [ ] همه‌ی buttonها متن یا `aria-label` دارند
   - [ ] keyboard navigation کار می‌کند
   - [ ] رنگ‌های متضاد کافی هستند (WCAG AA)

---

## 📜 مجوز

این پروژه تحت مجوز **MIT** منتشر شده است.

```
MIT License

Copyright (c) 2025 Genome Platform

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files...
```

برای جزئیات کامل، فایل [LICENSE](LICENSE) را ببینید.

---

## 🛡️ سلب مسئولیت

این سامانه **ابزار آموزشی و رفتاری** است، نه ابزار تشخیص بالینی یا آزمون رسمی تیزهوشی. کارنامه ارائه‌شده نمایه شناختی-رفتاری برای هدایت است و نباید جایگزین مشاوره روان‌شناختی، تشخیص پزشکی یا آزمون‌های استاندارد شود.

نام رانزولی و سایر پژوهشگران صرفاً برای اشاره علمی به نظریه‌های عمومی آمده و این سامانه با هیچ دانشگاه یا شرکت ثالثی وابستگی یا همکاری رسمی ندارد.

---

## 📞 تماس

- 📧 ایمیل: your-email@example.com
- ✈ تلگرام: [@your_channel](https://t.me/your_channel)
- 🐛 گزارش باگ: [Issues](https://github.com/YOUR_USERNAME/genome/issues)

---

<div align="center">

**ساخته‌شده با ❤ برای استعدادهای در حال رشد**

</div>
