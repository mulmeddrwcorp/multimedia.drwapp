const { PrismaClient } = require('@prisma/client');
require('dotenv').config();

const prisma = new PrismaClient();

async function seedDatabase() {
  console.log('🌱 Starting database seeding...');

  try {
    // Create sample Facebook Pages
    console.log('📄 Creating sample Facebook Pages...');
    const facebookPage1 = await prisma.facebookPage.upsert({
      where: { facebookPageId: '123456789' },
      update: {},
      create: {
        facebookPageId: '123456789',
        facebookPageName: 'Sample Business Page',
        pageCategory: 'Business',
        pageAbout: 'This is a sample business page for testing',
        followersCount: 1500,
        likesCount: 1200,
        priority: 'high',
        status: 'active'
      }
    });

    const facebookPage2 = await prisma.facebookPage.upsert({
      where: { facebookPageId: '987654321' },
      update: {},
      create: {
        facebookPageId: '987654321',
        facebookPageName: 'Sample Brand Page',
        pageCategory: 'Brand',
        pageAbout: 'This is a sample brand page for testing',
        followersCount: 2500,
        likesCount: 2000,
        priority: 'medium',
        status: 'active'
      }
    });

    console.log('✅ Facebook Pages created:', [facebookPage1.facebookPageName, facebookPage2.facebookPageName]);

    // Create sample Instagram Accounts
    console.log('📱 Creating sample Instagram Accounts...');
    const instagramAccount1 = await prisma.instagramAccount.upsert({
      where: { igBusinessAccountId: 'ig_123456789' },
      update: {},
      create: {
        igBusinessAccountId: 'ig_123456789',
        facebookPageId: '123456789',
        igUsername: 'samplebusiness',
        igName: 'Sample Business',
        igFollowers: 3200,
        igFollowing: 150,
        igMediaCount: 120,
        priority: 'high',
        status: 'active'
      }
    });

    const instagramAccount2 = await prisma.instagramAccount.upsert({
      where: { igBusinessAccountId: 'ig_987654321' },
      update: {},
      create: {
        igBusinessAccountId: 'ig_987654321',
        facebookPageId: '987654321',
        igUsername: 'samplebrand',
        igName: 'Sample Brand',
        igFollowers: 5500,
        igFollowing: 200,
        igMediaCount: 250,
        priority: 'medium',
        status: 'active'
      }
    });

    console.log('✅ Instagram Accounts created:', [instagramAccount1.igUsername, instagramAccount2.igUsername]);

    // Create sample Ad Account
    console.log('💰 Creating sample Ad Account...');
    const adAccount = await prisma.adAccount.upsert({
      where: { adAccountId: 'act_123456789' },
      update: {},
      create: {
        adAccountId: 'act_123456789',
        adAccountName: 'Sample Ad Account',
        facebookPageId: '123456789',
        accountStatus: 'ACTIVE',
        businessName: 'Sample Business LLC',
        currency: 'USD',
        amountSpent: 1250.50,
        balance: 500.00
      }
    });

    console.log('✅ Ad Account created:', adAccount.adAccountName);

    // Create sample Campaign
    console.log('🎯 Creating sample Campaign...');
    const campaign = await prisma.campaign.upsert({
      where: { campaignId: 'camp_123456789' },
      update: {},
      create: {
        adAccountId: 'act_123456789',
        campaignId: 'camp_123456789',
        campaignName: 'Sample Brand Awareness Campaign',
        objective: 'REACH',
        status: 'ACTIVE',
        dailyBudget: 50.00,
        bidStrategy: 'LOWEST_COST_WITHOUT_CAP'
      }
    });

    console.log('✅ Campaign created:', campaign.campaignName);

    // Create sample Facebook Posts
    console.log('📝 Creating sample Facebook Posts...');
    const facebookPost1 = await prisma.facebookPost.upsert({
      where: { postId: 'post_123456789' },
      update: {},
      create: {
        facebookPageId: '123456789',
        postId: 'post_123456789',
        message: 'Welcome to our new product launch! 🚀',
        type: 'photo',
        isPublished: true,
        createdTime: new Date('2024-01-15T10:00:00Z')
      }
    });

    const facebookPost2 = await prisma.facebookPost.upsert({
      where: { postId: 'post_987654321' },
      update: {},
      create: {
        facebookPageId: '123456789',
        postId: 'post_987654321',
        message: 'Check out our latest video! 🎥',
        type: 'video',
        isPublished: true,
        createdTime: new Date('2024-01-16T14:30:00Z')
      }
    });

    console.log('✅ Facebook Posts created:', [facebookPost1.postId, facebookPost2.postId]);

    // Create sample Instagram Media
    console.log('📸 Creating sample Instagram Media...');
    const instagramMedia1 = await prisma.instagramMedia.upsert({
      where: { mediaId: 'ig_media_123456789' },
      update: {},
      create: {
        igBusinessAccountId: 'ig_123456789',
        mediaId: 'ig_media_123456789',
        mediaType: 'IMAGE',
        mediaProductType: 'FEED',
        caption: 'Behind the scenes at our office! #work #team',
        likeCount: 45,
        commentsCount: 8,
        timestamp: new Date('2024-01-15T12:00:00Z')
      }
    });

    const instagramMedia2 = await prisma.instagramMedia.upsert({
      where: { mediaId: 'ig_media_987654321' },
      update: {},
      create: {
        igBusinessAccountId: 'ig_123456789',
        mediaId: 'ig_media_987654321',
        mediaType: 'VIDEO',
        mediaProductType: 'REELS',
        caption: 'Quick tutorial on using our product! 📱',
        likeCount: 120,
        commentsCount: 25,
        timestamp: new Date('2024-01-16T16:00:00Z')
      }
    });

    console.log('✅ Instagram Media created:', [instagramMedia1.mediaId, instagramMedia2.mediaId]);

    // Create sample metrics for yesterday
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    yesterday.setHours(0, 0, 0, 0);

    console.log('📊 Creating sample metrics...');
    
    // Facebook Page Metrics
    await prisma.facebookPageMetrics.upsert({
      where: {
        facebookPageId_metricDate: {
          facebookPageId: '123456789',
          metricDate: yesterday
        }
      },
      update: {},
      create: {
        facebookPageId: '123456789',
        metricDate: yesterday,
        pageImpressions: 2500,
        pageImpressionsUnique: 1800,
        pageViewsTotal: 350,
        pageEngagedUsers: 120,
        pageFanAdds: 15,
        pageVideoViews: 450
      }
    });

    // Instagram Account Metrics
    await prisma.instagramAccountMetrics.upsert({
      where: {
        igBusinessAccountId_metricDate: {
          igBusinessAccountId: 'ig_123456789',
          metricDate: yesterday
        }
      },
      update: {},
      create: {
        igBusinessAccountId: 'ig_123456789',
        metricDate: yesterday,
        impressions: 1800,
        reach: 1200,
        profileViews: 85,
        followerCount: 3200
      }
    });

    // Campaign Metrics
    await prisma.campaignMetrics.upsert({
      where: {
        campaignId_metricDate: {
          campaignId: 'camp_123456789',
          metricDate: yesterday
        }
      },
      update: {},
      create: {
        campaignId: 'camp_123456789',
        metricDate: yesterday,
        impressions: 5000,
        reach: 3500,
        clicks: 150,
        spend: 45.50,
        cpm: 9.10,
        cpc: 0.30,
        ctr: 3.0
      }
    });

    // Daily Summary
    await prisma.dailySummary.upsert({
      where: {
        facebookPageId_metricDate: {
          facebookPageId: '123456789',
          metricDate: yesterday
        }
      },
      update: {},
      create: {
        facebookPageId: '123456789',
        metricDate: yesterday,
        organicImpressions: 2500,
        organicReach: 1800,
        organicEngagement: 120,
        paidImpressions: 5000,
        paidReach: 3500,
        paidClicks: 150,
        totalSpend: 45.50,
        totalImpressions: 7500,
        totalReach: 5300,
        totalEngagement: 270,
        blendedEngagementRate: 3.6,
        costPerImpression: 0.00607
      }
    });

    console.log('✅ Sample metrics created for yesterday');

    console.log('\n🎉 Database seeding completed successfully!');
    console.log('📋 Summary:');
    console.log('  - 2 Facebook Pages');
    console.log('  - 2 Instagram Accounts');
    console.log('  - 1 Ad Account');
    console.log('  - 1 Campaign');
    console.log('  - 2 Facebook Posts');
    console.log('  - 2 Instagram Media');
    console.log('  - Sample metrics for yesterday');

  } catch (error) {
    console.error('❌ Seeding failed:', error.message);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

// Run seeding if this file is executed directly
if (require.main === module) {
  seedDatabase().catch((error) => {
    console.error(error);
    process.exit(1);
  });
}

module.exports = { seedDatabase };
