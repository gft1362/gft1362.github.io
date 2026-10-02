#!/bin/bash
# =====================================================
# setup-github.sh — راه‌اندازی خودکار مخزن گیت‌هاب
# =====================================================
# استفاده: 
#   chmod +x setup-github.sh
#   ./setup-github.sh YOUR_GITHUB_USERNAME YOUR_REPO_NAME
# مثال:
#   ./setup-github.sh johndoe genome
# =====================================================

set -e

# --- اعتبارسنجی ورودی ---
if [ "$#" -lt 2 ]; then
  echo "❌ خطا: نیاز به دو پارامتر"
  echo ""
  echo "نحوه استفاده:"
  echo "  $0 <GITHUB_USERNAME> <REPO_NAME>"
  echo ""
  echo "مثال:"
  echo "  $0 johndoe genome"
  exit 1
fi

USERNAME=$1
REPO=$2
EMAIL="${USERNAME}@users.noreply.github.com"

echo "═══════════════════════════════════════════════════"
echo "🧬 راه‌اندازی مخزن گیت‌هاب برای سامانه ژنوم"
echo "═══════════════════════════════════════════════════"
echo ""
echo "👤 GitHub Username: $USERNAME"
echo "📦 Repository Name: $REPO"
echo "🌐 آدرس نهایی:     https://$USERNAME.github.io/$REPO/"
echo ""

# --- بررسی وجود git ---
if ! command -v git &> /dev/null; then
  echo "❌ خطا: git نصب نیست. ابتدا نصب کنید:"
  echo "  sudo apt install git    # Ubuntu/Debian"
  echo "  brew install git         # macOS"
  echo "  choco install git        # Windows"
  exit 1
fi

# --- جایگزینی example.com با URL واقعی در فایل‌های HTML ---
echo "🔄 جایگزینی example.com با آدرس واقعی..."

# تابع جایگزینی (cross-platform با sed)
replace_in_files() {
  local search=$1
  local replace=$2
  shift 2
  for file in "$@"; do
    if [ -f "$file" ]; then
      # macOS sed نیاز به "" بعد از -i دارد، Linux نیاز ندارد
      if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|$search|$replace|g" "$file"
      else
        sed -i "s|$search|$replace|g" "$file"
      fi
      echo "  ✓ $file"
    fi
  done
}

# آدرس GitHub Pages نهایی
BASE_URL="https://$USERNAME.github.io/$REPO"

# جایگزینی genome.example.com با آدرس واقعی
replace_in_files "genome.example.com" "$USERNAME.github.io/$REPO" \
  genome.html privacy.html

echo ""

# --- git init ---
echo "📁 مقداردهی اولیه git..."
git init -b main 2>/dev/null || git init && git branch -M main 2>/dev/null

# --- پیکربندی git (در صورت نیاز) ---
if [ -z "$(git config user.name)" ]; then
  echo "⚙ تنظیم نام git..."
  git config user.name "$USERNAME"
fi
if [ -z "$(git config user.email)" ]; then
  echo "⚙ تنظیم ایمیل git..."
  git config user.email "$EMAIL"
fi

# --- add و commit ---
echo ""
echo "📦 اضافه‌کردن فایل‌ها..."
git add .
git status --short

echo ""
echo "💾 commit اولیه..."
git commit -m "feat: نسخه اولیه سامانه ژنوم

- لندینگ پیج کامل با ۱۱ بخش (Hero, Paths, Steps, Dimensions, Sample, Compare, Team, Testimonials, Trust, FAQ, Waitlist)
- صفحه حریم خصوصی با ۹ بخش
- پرسشنامه تعاملی ۸ سوالی با progress bar
- کارنامه با نمودار راداری SVG و نقشه اقدام ۶ ماهه
- PWA با Service Worker (offline support)
- پشتیبانی کامل RTL، dark mode و دسترس‌پذیری
- JSON-LD برای SEO (FAQPage, Organization, Service, BreadcrumbList)
- CSP, focus trap, keyboard navigation
- بدون کوکی ردیابی، بدون آنالیتیکس شخص ثالث" 2>&1 | tail -3

echo ""
echo "═══════════════════════════════════════════════════"
echo "🎉 آماده‌ی push!"
echo "═══════════════════════════════════════════════════"
echo ""
echo "حالا این دستورها را به‌ترتیب اجرا کنید:"
echo ""
echo "۱. در گیت‌هاب یک مخزن جدید بسازید (بدون README):"
echo "   https://github.com/new"
echo "   - Repository name: $REPO"
echo "   - Public"
echo "   - بدون کلیک روی «Add a README»"
echo "   - روی «Create repository» کلیک کنید"
echo ""
echo "۲. اضافه‌کردن remote و push:"
echo "   git remote add origin https://github.com/$USERNAME/$REPO.git"
echo "   git push -u origin main"
echo ""
echo "۳. فعال‌سازی GitHub Pages:"
echo "   - به Settings → Pages بروید"
echo "   - Source: Deploy from a branch"
echo "   - Branch: main / (root)"
echo "   - روی Save کلیک کنید"
echo ""
echo "۴. پس از ۱-۲ دقیقه، سایت شما در آدرس زیر در دسترس خواهد بود:"
echo ""
echo "   🌐 https://$USERNAME.github.io/$REPO/"
echo ""
echo "═══════════════════════════════════════════════════"
