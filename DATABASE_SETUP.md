# 🎉 MULMED DRWAPP Database Setup Complete!

Database berhasil dibuat dan siap digunakan untuk tracking media sosial Facebook & Instagram!

## 📊 Database Summary

**Database**: `multimedia_db` pada PostgreSQL 15.14  
**Total Tables**: 18 tabel  
**Sample Data**: ✅ Sudah diinput  

## 🗄️ Struktur Tabel

### **Core Account Tables**
- `facebook_pages` - Data halaman Facebook
- `instagram_accounts` - Akun Instagram business (terhubung ke FB pages)
- `ad_accounts` - Akun iklan Meta

### **Content Tables**
- `facebook_posts` - Postingan Facebook
- `instagram_media` - Media Instagram (foto, video, reels, stories)

### **Organic Metrics Tables**
- `facebook_page_metrics` - Metrics harian halaman FB
- `facebook_post_metrics` - Metrics per postingan FB
- `instagram_account_metrics` - Metrics harian akun IG
- `instagram_media_metrics` - Metrics per media IG

### **Ads Tables**
- `campaigns` - Kampanye iklan
- `ad_sets` - Ad sets dalam kampanye
- `ads` - Iklan individual

### **Ads Metrics Tables**
- `campaign_metrics` - Performance kampanye harian
- `adset_metrics` - Performance ad set harian
- `ad_metrics` - Performance iklan individual

### **Summary & Utility Tables**
- `daily_summary` - Ringkasan harian gabungan organic + paid
- `api_rate_limits` - Tracking limit API
- `api_error_logs` - Log error API

## 📋 Sample Data Yang Sudah Dibuat

### **Facebook Pages (2)**
1. **Sample Business Page** - Business category, 1500 followers
2. **Sample Brand Page** - Brand category, 2500 followers

### **Instagram Accounts (2)**
1. **@samplebusiness** - 3200 followers, linked to Sample Business Page
2. **@samplebrand** - 5500 followers, linked to Sample Brand Page

### **Ad Account (1)**
- **Sample Ad Account** - $1,250.50 spent, $500 balance

### **Campaign (1)**
- **Sample Brand Awareness Campaign** - REACH objective, $50/day budget

### **Content (4)**
- 2 Facebook Posts (photo & video)
- 2 Instagram Media (image & reels)

### **Metrics**
- Sample metrics untuk kemarin sudah diinput untuk testing

## 🚀 Cara Menggunakan

### **1. Lihat Data di Prisma Studio**
```bash
npm run db:studio
```
Buka http://localhost:5555 di browser

### **2. Test Koneksi Database**
```bash
npm run test:db
```

### **3. Reset Database (jika perlu)**
```bash
npm run db:reset
```

### **4. Seed Ulang Data Sample**
```bash
npm run db:seed
```

## 🔧 Commands Available

```bash
# Development
npm run dev                 # Start development server
npm run start              # Start production server

# Database
npm run db:generate        # Generate Prisma client
npm run db:push           # Push schema to database
npm run db:migrate        # Create and run migrations
npm run db:studio         # Open Prisma Studio
npm run db:reset          # Reset database
npm run db:seed           # Seed sample data
npm run test:db           # Test database connection
```

## 📝 Next Steps

1. **Setup Meta API Keys** - Update `.env` dengan API keys Facebook/Instagram
2. **Create N8N Workflows** - Buat workflows untuk collect data dari Meta API
3. **Build Dashboard** - Buat frontend untuk menampilkan metrics
4. **Setup Cron Jobs** - Automate data collection

## 🔐 Environment Variables

Pastikan file `.env` sudah diisi dengan benar:
```env
DATABASE_URL="postgresql://..."  ✅ DONE
META_APP_ID=your_app_id          ⚠️  PERLU DIISI
META_APP_SECRET=your_secret      ⚠️  PERLU DIISI
META_ACCESS_TOKEN=your_token     ⚠️  PERLU DIISI
# ... dan lainnya
```

## 📈 Relationship Diagram

```
FacebookPage
├── InstagramAccount (1:many)
├── FacebookPost (1:many)
├── AdAccount (1:many)
│   └── Campaign (1:many)
│       └── AdSet (1:many)
│           └── Ad (1:many)
└── DailySummary (1:many)

Setiap entity memiliki metrics table sendiri
untuk tracking performance harian
```

---

**🎉 Database ready for social media analytics!**  
Sekarang Anda bisa mulai build API dan dashboard untuk tracking Facebook & Instagram metrics.
