-- ================================================================
-- MULMED DRWAPP - Complete Database Schema
-- Social Media Analytics & Tracking System
-- Includes: Facebook Pages, Instagram Accounts, Meta Ads, Metrics
-- ================================================================

-- Drop existing tables in reverse order to avoid foreign key conflicts
DROP TABLE IF EXISTS ad_metrics CASCADE;
DROP TABLE IF EXISTS adset_metrics CASCADE;
DROP TABLE IF EXISTS campaign_metrics CASCADE;
DROP TABLE IF EXISTS daily_summary CASCADE;
DROP TABLE IF EXISTS instagram_media_metrics CASCADE;
DROP TABLE IF EXISTS facebook_post_metrics CASCADE;
DROP TABLE IF EXISTS instagram_account_metrics CASCADE;
DROP TABLE IF EXISTS facebook_page_metrics CASCADE;
DROP TABLE IF EXISTS ads CASCADE;
DROP TABLE IF EXISTS ad_sets CASCADE;
DROP TABLE IF EXISTS campaigns CASCADE;
DROP TABLE IF EXISTS ad_accounts CASCADE;
DROP TABLE IF EXISTS instagram_media CASCADE;
DROP TABLE IF EXISTS facebook_posts CASCADE;
DROP TABLE IF EXISTS instagram_accounts CASCADE;
DROP TABLE IF EXISTS facebook_pages CASCADE;

-- ================================================================
-- CORE ACCOUNT TABLES
-- ================================================================

-- Facebook Pages Table (Updated)
CREATE TABLE facebook_pages (
    id SERIAL PRIMARY KEY,
    facebook_page_id VARCHAR(255) UNIQUE NOT NULL,
    facebook_page_name VARCHAR(255),
    page_access_token TEXT,
    page_category VARCHAR(100),
    page_about TEXT,
    page_website VARCHAR(500),
    followers_count INTEGER DEFAULT 0,
    likes_count INTEGER DEFAULT 0,
    priority VARCHAR(50) DEFAULT 'medium',
    max_posts_limit INTEGER DEFAULT 50,
    processing_order INTEGER DEFAULT 0,
    status VARCHAR(50) DEFAULT 'active',
    discovered_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Indexes
    INDEX idx_facebook_pages_id (facebook_page_id),
    INDEX idx_facebook_pages_priority (priority),
    INDEX idx_facebook_pages_status (status)
);

-- Instagram Accounts Table (Updated)
CREATE TABLE instagram_accounts (
    id SERIAL PRIMARY KEY,
    ig_business_account_id VARCHAR(255) UNIQUE NOT NULL,
    facebook_page_id VARCHAR(255) REFERENCES facebook_pages(facebook_page_id) ON DELETE CASCADE,
    ig_username VARCHAR(255),
    ig_name VARCHAR(255),
    ig_followers INTEGER DEFAULT 0,
    ig_following INTEGER DEFAULT 0,
    ig_media_count INTEGER DEFAULT 0,
    profile_picture_url TEXT,
    biography TEXT,
    website VARCHAR(500),
    priority VARCHAR(50) DEFAULT 'medium',
    max_posts_limit INTEGER DEFAULT 50,
    processing_order INTEGER DEFAULT 0,
    status VARCHAR(50) DEFAULT 'active',
    discovered_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Indexes
    INDEX idx_instagram_accounts_id (ig_business_account_id),
    INDEX idx_instagram_accounts_page (facebook_page_id),
    INDEX idx_instagram_accounts_priority (priority),
    INDEX idx_instagram_accounts_status (status)
);

-- ================================================================
-- CONTENT TABLES
-- ================================================================

-- Facebook Posts Table
CREATE TABLE facebook_posts (
    id SERIAL PRIMARY KEY,
    facebook_page_id VARCHAR(255) REFERENCES facebook_pages(facebook_page_id) ON DELETE CASCADE,
    post_id VARCHAR(255) UNIQUE NOT NULL,
    message TEXT,
    story TEXT,
    description TEXT,
    permalink_url TEXT,
    picture_url TEXT,
    full_picture_url TEXT,
    type VARCHAR(50), -- photo, video, link, status, event, offer, note
    status_type VARCHAR(50), -- mobile_status_update, created_note, added_photos, etc
    is_published BOOLEAN DEFAULT TRUE,
    is_hidden BOOLEAN DEFAULT FALSE,
    created_time TIMESTAMPTZ,
    updated_time TIMESTAMPTZ,
    discovered_at TIMESTAMPTZ DEFAULT NOW(),
    last_metrics_update TIMESTAMPTZ,
    
    -- Indexes
    INDEX idx_facebook_posts_page (facebook_page_id),
    INDEX idx_facebook_posts_created (created_time),
    INDEX idx_facebook_posts_type (type),
    INDEX idx_facebook_posts_published (is_published)
);

-- Instagram Media Table
CREATE TABLE instagram_media (
    id SERIAL PRIMARY KEY,
    ig_business_account_id VARCHAR(255) REFERENCES instagram_accounts(ig_business_account_id) ON DELETE CASCADE,
    media_id VARCHAR(255) UNIQUE NOT NULL,
    media_type VARCHAR(50), -- IMAGE, VIDEO, CAROUSEL_ALBUM, STORY
    media_product_type VARCHAR(50), -- FEED, STORY, REELS, IGTV
    caption TEXT,
    permalink TEXT,
    media_url TEXT,
    thumbnail_url TEXT,
    like_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    is_comment_enabled BOOLEAN DEFAULT TRUE,
    timestamp TIMESTAMPTZ,
    discovered_at TIMESTAMPTZ DEFAULT NOW(),
    last_metrics_update TIMESTAMPTZ,
    
    -- Indexes
    INDEX idx_instagram_media_account (ig_business_account_id),
    INDEX idx_instagram_media_type (media_type),
    INDEX idx_instagram_media_timestamp (timestamp),
    INDEX idx_instagram_media_product_type (media_product_type)
);

-- ================================================================
-- ORGANIC METRICS TABLES
-- ================================================================

-- Facebook Page Metrics
CREATE TABLE facebook_page_metrics (
    id SERIAL PRIMARY KEY,
    facebook_page_id VARCHAR(255) REFERENCES facebook_pages(facebook_page_id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    
    -- Page Performance Metrics
    page_impressions INTEGER DEFAULT 0,
    page_impressions_unique INTEGER DEFAULT 0,
    page_impressions_paid INTEGER DEFAULT 0,
    page_impressions_organic INTEGER DEFAULT 0,
    
    -- Page Views Metrics
    page_views_total INTEGER DEFAULT 0,
    page_views_unique INTEGER DEFAULT 0,
    page_views_external_referrals INTEGER DEFAULT 0,
    
    -- Fan Metrics
    page_fans INTEGER DEFAULT 0,
    page_fan_adds INTEGER DEFAULT 0,
    page_fan_adds_unique INTEGER DEFAULT 0,
    page_fan_removes INTEGER DEFAULT 0,
    page_fan_removes_unique INTEGER DEFAULT 0,
    
    -- Engagement Metrics
    page_engaged_users INTEGER DEFAULT 0,
    page_post_engagements INTEGER DEFAULT 0,
    page_consumptions INTEGER DEFAULT 0,
    page_places_checkin_total INTEGER DEFAULT 0,
    
    -- Video Metrics
    page_video_views INTEGER DEFAULT 0,
    page_video_views_unique INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(facebook_page_id, metric_date),
    INDEX idx_facebook_page_metrics_date (metric_date),
    INDEX idx_facebook_page_metrics_page (facebook_page_id)
);

-- Facebook Post Metrics
CREATE TABLE facebook_post_metrics (
    id SERIAL PRIMARY KEY,
    post_id VARCHAR(255) REFERENCES facebook_posts(post_id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    
    -- Impression Metrics
    impressions INTEGER DEFAULT 0,
    impressions_unique INTEGER DEFAULT 0,
    impressions_paid INTEGER DEFAULT 0,
    impressions_organic INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    
    -- Engagement Metrics
    engagement INTEGER DEFAULT 0,
    reactions_like INTEGER DEFAULT 0,
    reactions_love INTEGER DEFAULT 0,
    reactions_wow INTEGER DEFAULT 0,
    reactions_haha INTEGER DEFAULT 0,
    reactions_sorry INTEGER DEFAULT 0,
    reactions_anger INTEGER DEFAULT 0,
    comments INTEGER DEFAULT 0,
    shares INTEGER DEFAULT 0,
    
    -- Click Metrics
    clicks INTEGER DEFAULT 0,
    clicks_unique INTEGER DEFAULT 0,
    
    -- Video Metrics (if applicable)
    video_views INTEGER DEFAULT 0,
    video_views_unique INTEGER DEFAULT 0,
    video_avg_time_watched INTEGER DEFAULT 0, -- in seconds
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(post_id, metric_date),
    INDEX idx_facebook_post_metrics_date (metric_date),
    INDEX idx_facebook_post_metrics_post (post_id)
);

-- Instagram Account Metrics
CREATE TABLE instagram_account_metrics (
    id SERIAL PRIMARY KEY,
    ig_business_account_id VARCHAR(255) REFERENCES instagram_accounts(ig_business_account_id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    
    -- Account Performance
    impressions INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    profile_views INTEGER DEFAULT 0,
    website_clicks INTEGER DEFAULT 0,
    
    -- Follower Metrics
    follower_count INTEGER DEFAULT 0,
    follower_count_change INTEGER DEFAULT 0,
    
    -- Story Metrics
    story_impressions INTEGER DEFAULT 0,
    story_reach INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(ig_business_account_id, metric_date),
    INDEX idx_instagram_account_metrics_date (metric_date),
    INDEX idx_instagram_account_metrics_account (ig_business_account_id)
);

-- Instagram Media Metrics
CREATE TABLE instagram_media_metrics (
    id SERIAL PRIMARY KEY,
    media_id VARCHAR(255) REFERENCES instagram_media(media_id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    
    -- Basic Metrics
    impressions INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    engagement INTEGER DEFAULT 0,
    
    -- Interaction Metrics
    likes INTEGER DEFAULT 0,
    comments INTEGER DEFAULT 0,
    shares INTEGER DEFAULT 0,
    saves INTEGER DEFAULT 0,
    
    -- Video Metrics (for video content)
    video_views INTEGER DEFAULT 0,
    
    -- Story Metrics (for story content)
    taps_forward INTEGER DEFAULT 0,
    taps_back INTEGER DEFAULT 0,
    exits INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(media_id, metric_date),
    INDEX idx_instagram_media_metrics_date (metric_date),
    INDEX idx_instagram_media_metrics_media (media_id)
);

-- ================================================================
-- META ADS TABLES
-- ================================================================

-- Ad Accounts Table
CREATE TABLE ad_accounts (
    id SERIAL PRIMARY KEY,
    ad_account_id VARCHAR(255) UNIQUE NOT NULL,
    ad_account_name VARCHAR(255),
    facebook_page_id VARCHAR(255) REFERENCES facebook_pages(facebook_page_id) ON DELETE SET NULL,
    
    -- Account Details
    account_status VARCHAR(50), -- ACTIVE, DISABLED, etc
    business_id VARCHAR(255),
    business_name VARCHAR(255),
    currency VARCHAR(10),
    timezone_name VARCHAR(100),
    timezone_offset_hours_utc INTEGER,
    
    -- Access & Permissions
    access_token TEXT,
    capabilities JSON, -- JSON array of capabilities
    
    -- Financial Info
    amount_spent DECIMAL(15,4) DEFAULT 0,
    balance DECIMAL(15,4) DEFAULT 0,
    spend_cap DECIMAL(15,4),
    
    discovered_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    INDEX idx_ad_accounts_status (account_status),
    INDEX idx_ad_accounts_page (facebook_page_id)
);

-- Campaigns Table
CREATE TABLE campaigns (
    id SERIAL PRIMARY KEY,
    ad_account_id VARCHAR(255) REFERENCES ad_accounts(ad_account_id) ON DELETE CASCADE,
    campaign_id VARCHAR(255) UNIQUE NOT NULL,
    campaign_name VARCHAR(255),
    
    -- Campaign Configuration
    objective VARCHAR(100), -- REACH, TRAFFIC, ENGAGEMENT, LEADS, etc
    status VARCHAR(50), -- ACTIVE, PAUSED, DELETED, etc
    effective_status VARCHAR(50),
    
    -- Budget Information
    budget_remaining DECIMAL(15,2),
    daily_budget DECIMAL(15,2),
    lifetime_budget DECIMAL(15,2),
    budget_rebalance_flag BOOLEAN DEFAULT FALSE,
    
    -- Bidding & Optimization
    bid_strategy VARCHAR(50),
    buying_type VARCHAR(50), -- AUCTION, RESERVED
    
    -- Dates
    start_time TIMESTAMPTZ,
    stop_time TIMESTAMPTZ,
    created_time TIMESTAMPTZ,
    updated_time TIMESTAMPTZ,
    
    discovered_at TIMESTAMPTZ DEFAULT NOW(),
    last_metrics_update TIMESTAMPTZ,
    
    INDEX idx_campaigns_account (ad_account_id),
    INDEX idx_campaigns_status (status),
    INDEX idx_campaigns_objective (objective),
    INDEX idx_campaigns_created (created_time)
);

-- Ad Sets Table
CREATE TABLE ad_sets (
    id SERIAL PRIMARY KEY,
    campaign_id VARCHAR(255) REFERENCES campaigns(campaign_id) ON DELETE CASCADE,
    adset_id VARCHAR(255) UNIQUE NOT NULL,
    adset_name VARCHAR(255),
    
    -- Ad Set Configuration
    optimization_goal VARCHAR(100), -- IMPRESSIONS, REACH, CLICKS, etc
    billing_event VARCHAR(50), -- IMPRESSIONS, CLICKS, etc
    bid_amount DECIMAL(15,4),
    bid_strategy VARCHAR(50),
    
    -- Budget
    daily_budget DECIMAL(15,2),
    lifetime_budget DECIMAL(15,2),
    budget_remaining DECIMAL(15,2),
    
    -- Status
    status VARCHAR(50), -- ACTIVE, PAUSED, DELETED, etc
    effective_status VARCHAR(50),
    
    -- Targeting (stored as JSON for flexibility)
    targeting JSON,
    
    -- Schedule
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    created_time TIMESTAMPTZ,
    updated_time TIMESTAMPTZ,
    
    discovered_at TIMESTAMPTZ DEFAULT NOW(),
    last_metrics_update TIMESTAMPTZ,
    
    INDEX idx_ad_sets_campaign (campaign_id),
    INDEX idx_ad_sets_status (status),
    INDEX idx_ad_sets_optimization (optimization_goal)
);

-- Ads Table
CREATE TABLE ads (
    id SERIAL PRIMARY KEY,
    adset_id VARCHAR(255) REFERENCES ad_sets(adset_id) ON DELETE CASCADE,
    ad_id VARCHAR(255) UNIQUE NOT NULL,
    ad_name VARCHAR(255),
    
    -- Ad Configuration
    status VARCHAR(50), -- ACTIVE, PAUSED, DELETED, etc
    effective_status VARCHAR(50),
    
    -- Creative Information
    creative_id VARCHAR(255),
    creative_name VARCHAR(255),
    
    -- Dates
    created_time TIMESTAMPTZ,
    updated_time TIMESTAMPTZ,
    
    discovered_at TIMESTAMPTZ DEFAULT NOW(),
    last_metrics_update TIMESTAMPTZ,
    
    INDEX idx_ads_adset (adset_id),
    INDEX idx_ads_status (status),
    INDEX idx_ads_creative (creative_id)
);

-- ================================================================
-- ADS METRICS TABLES
-- ================================================================

-- Campaign Metrics
CREATE TABLE campaign_metrics (
    id SERIAL PRIMARY KEY,
    campaign_id VARCHAR(255) REFERENCES campaigns(campaign_id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    
    -- Basic Performance
    impressions INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    unique_clicks INTEGER DEFAULT 0,
    
    -- Financial Metrics
    spend DECIMAL(15,4) DEFAULT 0,
    cpm DECIMAL(15,4) DEFAULT 0, -- Cost per 1000 impressions
    cpc DECIMAL(15,4) DEFAULT 0, -- Cost per click
    cpp DECIMAL(15,4) DEFAULT 0, -- Cost per 1000 people reached
    
    -- Performance Ratios
    ctr DECIMAL(8,4) DEFAULT 0, -- Click-through rate
    frequency DECIMAL(8,4) DEFAULT 0, -- Average impressions per person
    
    -- Conversion Metrics
    conversions INTEGER DEFAULT 0,
    conversion_rate DECIMAL(8,4) DEFAULT 0,
    conversion_value DECIMAL(15,4) DEFAULT 0,
    cost_per_conversion DECIMAL(15,4) DEFAULT 0,
    
    -- Advanced Metrics
    video_views INTEGER DEFAULT 0,
    video_avg_time_watched_actions INTEGER DEFAULT 0,
    link_clicks INTEGER DEFAULT 0,
    outbound_clicks INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(campaign_id, metric_date),
    INDEX idx_campaign_metrics_date (metric_date),
    INDEX idx_campaign_metrics_campaign (campaign_id)
);

-- AdSet Metrics
CREATE TABLE adset_metrics (
    id SERIAL PRIMARY KEY,
    adset_id VARCHAR(255) REFERENCES ad_sets(adset_id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    
    -- Basic Performance
    impressions INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    unique_clicks INTEGER DEFAULT 0,
    
    -- Financial Metrics
    spend DECIMAL(15,4) DEFAULT 0,
    cpm DECIMAL(15,4) DEFAULT 0,
    cpc DECIMAL(15,4) DEFAULT 0,
    cpp DECIMAL(15,4) DEFAULT 0,
    
    -- Performance Ratios
    ctr DECIMAL(8,4) DEFAULT 0,
    frequency DECIMAL(8,4) DEFAULT 0,
    
    -- Conversion Metrics
    conversions INTEGER DEFAULT 0,
    conversion_rate DECIMAL(8,4) DEFAULT 0,
    conversion_value DECIMAL(15,4) DEFAULT 0,
    cost_per_conversion DECIMAL(15,4) DEFAULT 0,
    
    -- Advanced Metrics
    video_views INTEGER DEFAULT 0,
    link_clicks INTEGER DEFAULT 0,
    outbound_clicks INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(adset_id, metric_date),
    INDEX idx_adset_metrics_date (metric_date),
    INDEX idx_adset_metrics_adset (adset_id)
);

-- Ad Metrics
CREATE TABLE ad_metrics (
    id SERIAL PRIMARY KEY,
    ad_id VARCHAR(255) REFERENCES ads(ad_id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    
    -- Basic Performance
    impressions INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    clicks INTEGER DEFAULT 0,
    unique_clicks INTEGER DEFAULT 0,
    
    -- Financial Metrics
    spend DECIMAL(15,4) DEFAULT 0,
    cpm DECIMAL(15,4) DEFAULT 0,
    cpc DECIMAL(15,4) DEFAULT 0,
    cpp DECIMAL(15,4) DEFAULT 0,
    
    -- Performance Ratios
    ctr DECIMAL(8,4) DEFAULT 0,
    frequency DECIMAL(8,4) DEFAULT 0,
    
    -- Conversion Metrics
    conversions INTEGER DEFAULT 0,
    conversion_rate DECIMAL(8,4) DEFAULT 0,
    conversion_value DECIMAL(15,4) DEFAULT 0,
    cost_per_conversion DECIMAL(15,4) DEFAULT 0,
    
    -- Creative Performance
    video_views INTEGER DEFAULT 0,
    video_avg_time_watched_actions INTEGER DEFAULT 0,
    link_clicks INTEGER DEFAULT 0,
    outbound_clicks INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(ad_id, metric_date),
    INDEX idx_ad_metrics_date (metric_date),
    INDEX idx_ad_metrics_ad (ad_id)
);

-- ================================================================
-- SUMMARY & CALCULATED TABLES
-- ================================================================

-- Daily Summary per Facebook Page
CREATE TABLE daily_summary (
    id SERIAL PRIMARY KEY,
    facebook_page_id VARCHAR(255) REFERENCES facebook_pages(facebook_page_id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    
    -- Organic Metrics Summary
    organic_impressions INTEGER DEFAULT 0,
    organic_reach INTEGER DEFAULT 0,
    organic_engagement INTEGER DEFAULT 0,
    organic_video_views INTEGER DEFAULT 0,
    
    -- Instagram Organic (if linked)
    instagram_impressions INTEGER DEFAULT 0,
    instagram_reach INTEGER DEFAULT 0,
    instagram_engagement INTEGER DEFAULT 0,
    
    -- Paid Metrics Summary (from all campaigns linked to this page)
    paid_impressions INTEGER DEFAULT 0,
    paid_reach INTEGER DEFAULT 0,
    paid_clicks INTEGER DEFAULT 0,
    paid_video_views INTEGER DEFAULT 0,
    total_spend DECIMAL(15,4) DEFAULT 0,
    
    -- Combined Totals
    total_impressions INTEGER DEFAULT 0,
    total_reach INTEGER DEFAULT 0,
    total_engagement INTEGER DEFAULT 0,
    
    -- Calculated Performance Metrics
    organic_engagement_rate DECIMAL(8,4) DEFAULT 0, -- organic_engagement / organic_impressions
    paid_ctr DECIMAL(8,4) DEFAULT 0, -- paid_clicks / paid_impressions
    blended_engagement_rate DECIMAL(8,4) DEFAULT 0, -- total_engagement / total_impressions
    cost_per_impression DECIMAL(15,6) DEFAULT 0, -- total_spend / total_impressions
    cost_per_engagement DECIMAL(15,6) DEFAULT 0, -- total_spend / total_engagement
    
    -- ROI Metrics
    roas DECIMAL(8,4) DEFAULT 0, -- Return on Ad Spend
    roi DECIMAL(8,4) DEFAULT 0, -- Return on Investment
    
    -- Efficiency Metrics
    organic_vs_paid_ratio DECIMAL(8,4) DEFAULT 0, -- organic_impressions / paid_impressions
    reach_efficiency DECIMAL(8,4) DEFAULT 0, -- total_reach / total_impressions
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(facebook_page_id, metric_date),
    INDEX idx_daily_summary_date (metric_date),
    INDEX idx_daily_summary_page (facebook_page_id)
);

-- ================================================================
-- UTILITY TABLES
-- ================================================================

-- API Rate Limits Tracking
CREATE TABLE api_rate_limits (
    id SERIAL PRIMARY KEY,
    api_type VARCHAR(50), -- 'graph_api', 'marketing_api'
    endpoint VARCHAR(255),
    account_id VARCHAR(255),
    calls_made INTEGER DEFAULT 0,
    calls_remaining INTEGER DEFAULT 0,
    reset_time TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    INDEX idx_api_rate_limits_type (api_type),
    INDEX idx_api_rate_limits_account (account_id)
);

-- Error Logs for API Calls
CREATE TABLE api_error_logs (
    id SERIAL PRIMARY KEY,
    api_type VARCHAR(50),
    endpoint VARCHAR(255),
    account_id VARCHAR(255),
    error_code VARCHAR(50),
    error_message TEXT,
    request_payload JSON,
    response_payload JSON,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    INDEX idx_api_error_logs_type (api_type),
    INDEX idx_api_error_logs_code (error_code),
    INDEX idx_api_error_logs_date (created_at)
);

-- ================================================================
-- SAMPLE DATA INSERTION (for testing)
-- ================================================================

-- Sample Facebook Page
INSERT INTO facebook_pages (facebook_page_id, facebook_page_name, page_access_token, priority, status) 
VALUES ('123456789', 'Sample Page', 'sample_token_123', 'high', 'active');

-- Sample Instagram Account
INSERT INTO instagram_accounts (ig_business_account_id, facebook_page_id, ig_username, ig_name, priority, status)
VALUES ('987654321', '123456789', 'sample_ig', 'Sample Instagram', 'high', 'active');

-- Sample Ad Account
INSERT INTO ad_accounts (ad_account_id, ad_account_name, facebook_page_id, account_status, currency)
VALUES ('act_123456789', 'Sample Ad Account', '123456789', 'ACTIVE', 'USD');

-- ================================================================
-- USEFUL VIEWS FOR REPORTING
-- ================================================================

-- View: Complete Page Performance
CREATE VIEW page_performance_summary AS
SELECT 
    fp.facebook_page_name,
    ds.metric_date,
    ds.total_impressions,
    ds.total_reach,
    ds.total_engagement,
    ds.total_spend,
    ds.blended_engagement_rate,
    ds.cost_per_impression,
    ds.roas,
    CASE 
        WHEN ds.paid_impressions > 0 THEN 'Mixed'
        ELSE 'Organic Only'
    END as content_type
FROM daily_summary ds
JOIN facebook_pages fp ON ds.facebook_page_id = fp.facebook_page_id
WHERE fp.status = 'active';

-- View: Top Performing Content
CREATE VIEW top_performing_content AS
SELECT 
    'Facebook Post' as content_type,
    fp.post_id as content_id,
    fpm.impressions,
    fpm.engagement,
    (fpm.engagement::DECIMAL / NULLIF(fpm.impressions, 0) * 100) as engagement_rate,
    fpm.metric_date
FROM facebook_post_metrics fpm
JOIN facebook_posts fp ON fpm.post_id = fp.post_id
WHERE fpm.impressions > 0
UNION ALL
SELECT 
    'Instagram Media' as content_type,
    im.media_id as content_id,
    imm.impressions,
    imm.engagement,
    (imm.engagement::DECIMAL / NULLIF(imm.impressions, 0) * 100) as engagement_rate,
    imm.metric_date
FROM instagram_media_metrics imm
JOIN instagram_media im ON imm.media_id = im.media_id
WHERE imm.impressions > 0
ORDER BY engagement_rate DESC;

-- ================================================================
-- STORED PROCEDURES FOR COMMON OPERATIONS
-- ================================================================

-- Calculate Daily Summary (to be run daily)
CREATE OR REPLACE FUNCTION calculate_daily_summary(target_date DATE)
RETURNS VOID AS $$
BEGIN
    INSERT INTO daily_summary (
        facebook_page_id, 
        metric_date,
        organic_impressions,
        organic_reach,
        organic_engagement,
        paid_impressions,
        paid_reach,
        paid_clicks,
        total_spend
    )
    SELECT 
        fp.facebook_page_id,
        target_date,
        COALESCE(organic.impressions, 0),
        COALESCE(organic.reach, 0),
        COALESCE(organic.engagement, 0),
        COALESCE(paid.impressions, 0),
        COALESCE(paid.reach, 0),
        COALESCE(paid.clicks, 0),
        COALESCE(paid.spend, 0)
    FROM facebook_pages fp
    LEFT JOIN (
        SELECT 
            fpm.facebook_page_id,
            SUM(fpm.page_impressions) as impressions,
            SUM(fpm.page_impressions_unique) as reach,
            SUM(fpm.page_engaged_users) as engagement
        FROM facebook_page_metrics fpm
        WHERE fpm.metric_date = target_date
        GROUP BY fpm.facebook_page_id
    ) organic ON fp.facebook_page_id = organic.facebook_page_id
    LEFT JOIN (
        SELECT 
            fp.facebook_page_id,
            SUM(cm.impressions) as impressions,
            SUM(cm.reach) as reach,
            SUM(cm.clicks) as clicks,
            SUM(cm.spend) as spend
        FROM campaign_metrics cm
        JOIN campaigns c ON cm.campaign_id = c.campaign_id
        JOIN ad_accounts aa ON c.ad_account_id = aa.ad_account_id
        JOIN facebook_pages fp ON aa.facebook_page_id = fp.facebook_page_id
        WHERE cm.metric_date = target_date
        GROUP BY fp.facebook_page_id
    ) paid ON fp.facebook_page_id = paid.facebook_page_id
    ON CONFLICT (facebook_page_id, metric_date) 
    DO UPDATE SET
        organic_impressions = EXCLUDED.organic_impressions,
        organic_reach = EXCLUDED.organic_reach,
        organic_engagement = EXCLUDED.organic_engagement,
        paid_impressions = EXCLUDED.paid_impressions,
        paid_reach = EXCLUDED.paid_reach,
        paid_clicks = EXCLUDED.paid_clicks,
        total_spend = EXCLUDED.total_spend,
        total_impressions = EXCLUDED.organic_impressions + EXCLUDED.paid_impressions,
        total_reach = EXCLUDED.organic_reach + EXCLUDED.paid_reach,
        total_engagement = EXCLUDED.organic_engagement + EXCLUDED.paid_clicks,
        updated_at = NOW();
        
    -- Update calculated metrics
    UPDATE daily_summary SET
        organic_engagement_rate = CASE 
            WHEN organic_impressions > 0 THEN (organic_engagement::DECIMAL / organic_impressions * 100)
            ELSE 0
        END,
        paid_ctr = CASE 
            WHEN paid_impressions > 0 THEN (paid_clicks::DECIMAL / paid_impressions * 100)
            ELSE 0
        END,
        blended_engagement_rate = CASE 
            WHEN total_impressions > 0 THEN (total_engagement::DECIMAL / total_impressions * 100)
            ELSE 0
        END,
        cost_per_impression = CASE 
            WHEN total_impressions > 0 THEN (total_spend / total_impressions)
            ELSE 0
        END,
        organic_vs_paid_ratio = CASE 
            WHEN paid_impressions > 0 THEN (organic_impressions::DECIMAL / paid_impressions)
            ELSE organic_impressions
        END,
        reach_efficiency = CASE 
            WHEN total_impressions > 0 THEN (total_reach::DECIMAL / total_impressions)
            ELSE 0
        END
    WHERE metric_date = target_date;
    
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- GRANTS AND PERMISSIONS (adjust as needed)
-- ================================================================

-- Create a user for the application (optional)
-- CREATE USER mulmed_app WITH PASSWORD 'your_secure_password';
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO mulmed_app;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO mulmed_app;

-- ================================================================
-- COMPLETION MESSAGE
-- ================================================================
SELECT 'Database schema created successfully! 🎉' as message;
SELECT COUNT(*) as total_tables FROM information_schema.tables WHERE table_schema = 'public';
