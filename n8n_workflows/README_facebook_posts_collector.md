# 🔄 Facebook Posts Collector Workflow

## 📋 **Workflow Overview**
**File**: `facebook_posts_collector.json`  
**Purpose**: Collect all posts from active Facebook pages daily  
**Trigger**: Daily at 2:00 AM (Asia/Jakarta timezone)  
**Duration**: ~5-15 minutes depending on number of pages

## 🏗️ **Workflow Structure**

### **1. Daily FB Posts Trigger**
- **Type**: Schedule Trigger
- **Schedule**: Daily at 2:00 AM
- **Timezone**: Asia/Jakarta

### **2. Load Active FB Pages**
- **Type**: PostgreSQL Query
- **Purpose**: Get all active Facebook pages with valid access tokens
- **Query**:
```sql
SELECT 
  facebook_page_id,
  facebook_page_name,
  page_access_token,
  priority,
  max_posts_limit,
  ('exec_posts_' || EXTRACT(epoch FROM NOW())::bigint) as execution_id,
  NOW() as started_at
FROM facebook_pages 
WHERE status = 'active' 
  AND page_access_token IS NOT NULL
ORDER BY priority DESC, processing_order ASC;
```

### **3. Process Pages One by One**
- **Type**: Split in Batches
- **Purpose**: Process each Facebook page sequentially to avoid rate limits
- **Batch Size**: 1 (one page at a time)

### **4. Get FB Posts via Graph API**
- **Type**: HTTP Request
- **Method**: GET
- **URL**: `https://graph.facebook.com/v19.0/{page-id}/posts`
- **Parameters**:
  - `fields`: id,message,story,description,created_time,updated_time,type,status_type,permalink_url,picture,full_picture,is_published,is_hidden
  - `limit`: Dynamic based on `max_posts_limit` (default: 50)
  - `access_token`: Page-specific access token

### **5. Transform Posts Data**
- **Type**: Code (JavaScript)
- **Purpose**: Transform Facebook API response to database format
- **Features**:
  - Handle API errors gracefully
  - Transform post data structure
  - Add metadata (execution_id, processing timestamps)
  - Validate data types
  - Prepare for pagination (future enhancement)

### **6. Split Out Posts**
- **Type**: Split Out
- **Purpose**: Convert posts array to individual items for database insertion
- **Field**: `facebook_posts`

### **7. Upsert Facebook Posts**
- **Type**: PostgreSQL Upsert
- **Purpose**: Insert new posts or update existing ones
- **Table**: `facebook_posts`
- **Match Column**: `post_id`
- **Features**:
  - Prevents duplicates
  - Updates changed posts
  - Handles NULL values properly

### **8. Log Collection Success**
- **Type**: PostgreSQL Query  
- **Purpose**: Log successful execution for monitoring
- **Table**: `api_error_logs`
- **Log Type**: SUCCESS

## 📊 **Expected Data Collection**

### **Post Types Collected**:
- ✅ **Photos** - Single image posts
- ✅ **Videos** - Video posts  
- ✅ **Links** - Shared links
- ✅ **Status Updates** - Text-only posts
- ✅ **Albums** - Photo albums
- ✅ **Events** - Event posts
- ✅ **Offers** - Promotional offers

### **Data Fields Captured**:
```json
{
  "facebook_page_id": "123456789",
  "post_id": "123456789_987654321", 
  "message": "Post text content",
  "story": "Auto-generated story",
  "description": "Link description",
  "permalink_url": "https://facebook.com/...",
  "picture_url": "https://scontent.xx.fbcdn.net/...",
  "full_picture_url": "https://scontent.xx.fbcdn.net/...",
  "type": "photo|video|link|status|event|offer|note",
  "status_type": "mobile_status_update|created_note|added_photos",
  "is_published": true,
  "is_hidden": false,
  "created_time": "2024-01-15T10:00:00.000Z",
  "updated_time": "2024-01-15T10:05:00.000Z",
  "discovered_at": "2024-01-16T02:00:00.000Z"
}
```

## 🚀 **How to Use**

### **1. Import Workflow**
```bash
# Copy facebook_posts_collector.json to your N8N instance
# Import via N8N UI: Workflows -> Import from File
```

### **2. Configure Credentials**
- Ensure PostgreSQL credential `MULTIMEDIA-POSTGRES` is configured
- Verify database connection

### **3. Test Workflow**
```bash
# Manual test execution
# N8N UI: Execute Workflow -> Manual
```

### **4. Activate Schedule**
```bash
# N8N UI: Activate workflow for daily scheduling
```

## ⚠️ **Important Notes**

### **Rate Limits**:
- Facebook Graph API: 200 calls per hour per app
- Workflow processes pages sequentially to avoid limits
- Each page uses 1 API call

### **Error Handling**:
- API errors are logged to `api_error_logs` table
- Failed pages won't stop other pages from processing
- Workflow continues even if some pages fail

### **Data Updates**:
- Uses UPSERT to avoid duplicates
- Updates existing posts if they changed
- New posts are automatically added

## 🔍 **Monitoring & Troubleshooting**

### **Check Execution Status**:
```sql
-- View recent executions
SELECT * FROM api_error_logs 
WHERE api_type = 'graph_api' 
  AND endpoint = 'facebook_posts_collection'
ORDER BY created_at DESC 
LIMIT 10;
```

### **Check Collected Posts**:
```sql
-- View latest posts
SELECT 
  fp.facebook_page_name,
  fpost.type,
  fpost.message,
  fpost.created_time,
  fpost.discovered_at
FROM facebook_posts fpost
JOIN facebook_pages fp ON fpost.facebook_page_id = fp.facebook_page_id
ORDER BY fpost.discovered_at DESC 
LIMIT 20;
```

### **Common Issues**:
1. **Invalid Access Token**: Update token in `facebook_pages` table
2. **Page Not Found**: Check if page still exists
3. **Permission Denied**: Verify page permissions for app

## ✅ **Success Criteria**
- ✅ Daily execution at 2 AM
- ✅ All active pages processed
- ✅ Posts stored in database
- ✅ No API rate limit violations  
- ✅ Error logging working

## 🎯 **Next Steps**
After this workflow is working:
1. **Instagram Media Collector** - Similar workflow for IG
2. **Facebook Post Metrics** - Collect engagement metrics
3. **Instagram Media Metrics** - Collect IG insights

---
**Ready to import and test! 🚀**
