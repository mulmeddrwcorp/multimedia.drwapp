# 🗺️ N8N Workflows Roadmap - MULMED DRWAPP

## ✅ **Completed Workflows**
1. **fb_ig_mulmed.drwapp** - Discover Facebook Pages & Instagram Accounts ✅
   - Runs every 4 hours
   - Populates `facebook_pages` and `instagram_accounts` tables

## 🚀 **Next Workflows Priority**

### **PRIORITY 1: Content Collection (Week 1)**

#### **1.1 Facebook Posts Collector** 🔄
**Workflow Name**: `facebook_posts_collector.json`
- **Trigger**: Daily (2 AM)
- **Purpose**: Collect all posts from Facebook pages
- **Flow**:
  - Get active Facebook pages from DB
  - For each page → Get posts via Graph API
  - Upsert to `facebook_posts` table
- **API Endpoint**: `/{page-id}/posts`
- **Fields**: `id,message,story,created_time,type,permalink_url,picture,full_picture`

#### **1.2 Instagram Media Collector** 📸
**Workflow Name**: `instagram_media_collector.json`
- **Trigger**: Daily (3 AM)
- **Purpose**: Collect all media from Instagram accounts
- **Flow**:
  - Get active Instagram accounts from DB
  - For each account → Get media via Graph API
  - Upsert to `instagram_media` table
- **API Endpoint**: `/{ig-user-id}/media`
- **Fields**: `id,media_type,media_url,permalink,caption,timestamp,like_count,comments_count`

### **PRIORITY 2: Organic Metrics Collection (Week 2)**

#### **2.1 Facebook Page Metrics Collector** 📊
**Workflow Name**: `facebook_page_metrics_collector.json`
- **Trigger**: Daily (4 AM)
- **Purpose**: Collect page-level metrics
- **API Endpoint**: `/{page-id}/insights`
- **Metrics**: `page_impressions,page_reach,page_engaged_users,page_fan_adds`

#### **2.2 Facebook Post Metrics Collector** 📈
**Workflow Name**: `facebook_post_metrics_collector.json`
- **Trigger**: Daily (5 AM)
- **Purpose**: Collect post-level metrics
- **API Endpoint**: `/{post-id}/insights`
- **Metrics**: `post_impressions,post_reach,post_reactions_total,post_clicks`

#### **2.3 Instagram Metrics Collector** 📱
**Workflow Name**: `instagram_metrics_collector.json`
- **Trigger**: Daily (6 AM)
- **Purpose**: Collect IG account & media metrics
- **API Endpoints**: 
  - Account: `/{ig-user-id}/insights`
  - Media: `/{ig-media-id}/insights`

### **PRIORITY 3: Meta Ads Data (Week 3)**

#### **3.1 Meta Ads Discovery** 💰
**Workflow Name**: `meta_ads_discovery.json`
- **Purpose**: Discover ad accounts, campaigns, ad sets, ads
- **API Endpoints**: Marketing API

#### **3.2 Meta Ads Metrics** 📊
**Workflow Name**: `meta_ads_metrics.json`
- **Purpose**: Collect ads performance metrics
- **Trigger**: Every 6 hours

### **PRIORITY 4: Summary & Calculations (Week 4)**

#### **4.1 Daily Summary Calculator** 🧮
**Workflow Name**: `daily_summary_calculator.json`
- **Purpose**: Aggregate organic + paid metrics
- **Trigger**: Daily (11 PM)

## 🎯 **Let's Start: Facebook Posts Collector**

Mari kita mulai dengan **Facebook Posts Collector** karena ini foundation untuk metrics:

### **Required Steps:**
1. **Create workflow structure**
2. **Setup database query for active pages** 
3. **Facebook Graph API call for posts**
4. **Handle pagination**
5. **Data transformation & validation**
6. **Upsert to database**
7. **Error handling & logging**

### **Expected Output:**
- Daily collection of all posts from active Facebook pages
- Data stored in `facebook_posts` table
- Ready for metrics collection

---

## 🤔 **Which workflow would you like to start with?**

**Recommendation**: Start with **Facebook Posts Collector** karena:
- ✅ Foundation untuk post metrics nanti
- ✅ Relatif simple (no complex calculations)
- ✅ Uses similar pattern dengan workflow yang sudah ada
- ✅ Critical untuk dashboard content

**Alternative**: Instagram Media Collector (if you prefer)

---

**Ready to build? Let me know which one! 🚀**
