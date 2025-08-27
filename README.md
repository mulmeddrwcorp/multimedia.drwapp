# 🚀 MULMED DRWAPP - Social Media Analytics & Tracking System

A comprehensive social media analytics platform for tracking Facebook Pages, Instagram Business accounts, and Meta Ads performance with real-time metrics and engagement insights.

## ✨ Features

### 📊 **Comprehensive Analytics**
- **Facebook Pages**: Page insights, post metrics, engagement tracking
- **Instagram Business**: Account metrics, media performance, story analytics  
- **Meta Ads**: Campaign performance, ad spend tracking, ROI analysis
- **Unified Dashboard**: Combined organic + paid performance overview

### 🎯 **Key Metrics Tracked**
- **Impressions & Reach**: Organic and paid visibility
- **Engagement**: Likes, comments, shares, saves, reactions
- **Performance**: CTR, CPM, CPC, ROAS, engagement rates
- **Growth**: Follower growth, fan additions/removals
- **Video**: Video views, watch time, completion rates

### 🔄 **Automation Ready**
- **N8N Integration**: Automated data collection workflows
- **Cron Jobs**: Scheduled metrics gathering
- **API Rate Limiting**: Smart rate limit management
- **Error Handling**: Comprehensive logging and recovery

## 🛠️ Tech Stack

- **Database**: PostgreSQL with Prisma ORM
- **Backend**: Node.js with Express
- **Automation**: N8N workflows
- **APIs**: Meta Graph API & Marketing API
- **Monitoring**: Winston logging

## 🗄️ Database Schema

### Core Tables
- `facebook_pages` - Facebook page data and configurations
- `instagram_accounts` - Instagram business account information
- `ad_accounts` - Meta advertising account details

### Content & Metrics
- `facebook_posts` / `instagram_media` - Content tracking
- `*_metrics` tables - Daily performance metrics for all entities
- `daily_summary` - Aggregated daily performance overview

### Ads Management
- `campaigns` / `ad_sets` / `ads` - Campaign hierarchy
- `*_metrics` tables - Ad performance tracking at all levels

## 🚀 Quick Start

### Prerequisites
- Node.js (v18+)
- PostgreSQL database
- Meta App ID and credentials

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/mulmeddrwcorp/multimedia.drwapp.git
cd multimedia.drwapp
```

2. **Install dependencies**
```bash
npm install
```

3. **Setup environment**
```bash
cp .env.example .env
# Fill in your database URL and Meta API credentials
```

4. **Setup database**
```bash
# Generate Prisma client
npx prisma generate

# Push schema to database
npx prisma db push

# Seed with sample data (optional)
npm run db:seed
```

5. **Test connection**
```bash
npm run test:db
```

## 📝 Available Scripts

```bash
# Development
npm run dev              # Start development server
npm run start           # Start production server

# Database
npm run db:generate     # Generate Prisma client
npm run db:push        # Push schema to database
npm run db:migrate     # Create and run migrations
npm run db:studio      # Open Prisma Studio (http://localhost:5555)
npm run db:reset       # Reset database
npm run db:seed        # Seed sample data
npm run test:db        # Test database connection

# Build
npm run build          # Build for production
```

## ⚙️ Configuration

### Environment Variables

```env
# Database (Required)
DATABASE_URL="postgresql://user:password@host:port/database"

# Meta API (Required)
META_APP_ID=your_app_id
META_APP_SECRET=your_app_secret
META_ACCESS_TOKEN=your_long_lived_token
META_BUSINESS_ID=your_business_id

# Optional
N8N_HOST=http://localhost:5678
N8N_API_KEY=your_n8n_api_key
REDIS_URL=redis://localhost:6379
```

## 📊 Database Relationships

```
FacebookPage (1:many)
├── InstagramAccount
├── FacebookPost
│   └── FacebookPostMetrics (daily)
├── FacebookPageMetrics (daily)
├── AdAccount
│   └── Campaign
│       └── AdSet
│           └── Ad
│               └── AdMetrics (daily)
└── DailySummary (aggregated daily metrics)
```

## 🔗 API Integration

### Meta Graph API
- Page insights and post metrics
- Instagram business account data
- Media performance tracking

### Meta Marketing API  
- Campaign, ad set, and ad performance
- Spend tracking and ROI calculation
- Audience insights

## 🎛️ N8N Workflows

The system is designed to work with N8N automation workflows:

1. **Organic Metrics Collection** - Daily Facebook/Instagram metrics
2. **Ad Performance Tracking** - Campaign and ad metrics every 6 hours
3. **Daily Summary Generation** - Aggregated performance calculation
4. **Error Monitoring** - API error tracking and notifications

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────┐    ┌─────────────────┐
│   Meta APIs     │────│ N8N Workflows│────│   Database      │
│ (FB/IG/Ads)     │    │              │    │  (PostgreSQL)   │
└─────────────────┘    └──────────────┘    └─────────────────┘
                              │                        │
                              │                        │
                       ┌──────────────┐    ┌─────────────────┐
                       │   Cron Jobs  │    │   Dashboard     │
                       │   Scheduler  │    │   (Frontend)    │
                       └──────────────┘    └─────────────────┘
```

## 📈 Sample Metrics

The system tracks comprehensive metrics including:

- **Page/Account Level**: Impressions, reach, engagement, followers
- **Content Level**: Post/media performance, video views, reactions
- **Ad Level**: Spend, conversions, CTR, CPM, CPC, ROAS
- **Calculated**: Engagement rates, cost efficiency, growth rates

## 🛡️ Error Handling

- Comprehensive API error logging
- Rate limit tracking and management
- Automatic retry mechanisms
- Performance monitoring

## 🔮 Roadmap

- [ ] Real-time dashboard interface
- [ ] Advanced analytics and reporting
- [ ] Multi-account management
- [ ] Competitor analysis
- [ ] Automated insights and alerts
- [ ] Export capabilities (PDF, CSV)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Create an issue on GitHub
- Check the documentation in `/docs`
- Review sample data and queries in `/scripts`

---

**Built with ❤️ for comprehensive social media analytics**
