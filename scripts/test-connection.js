const { PrismaClient } = require('@prisma/client');
require('dotenv').config();

const prisma = new PrismaClient();

async function testDatabaseConnection() {
  console.log('🔍 Testing database connection...');
  console.log('Database URL:', process.env.DATABASE_URL ? 'Set ✅' : 'Not set ❌');
  
  try {
    // Test basic connection
    console.log('\n⏳ Attempting to connect to database...');
    await prisma.$connect();
    console.log('✅ Database connected successfully!');

    // Test if we can query the database
    console.log('\n⏳ Testing database query...');
    const result = await prisma.$queryRaw`SELECT current_database() as database_name, version() as version`;
    console.log('✅ Database query successful!');
    console.log('📊 Database info:', result[0]);

    // Check if tables exist
    console.log('\n⏳ Checking existing tables...');
    const tables = await prisma.$queryRaw`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name;
    `;
    
    console.log(`📋 Found ${tables.length} existing tables:`, tables.map(t => t.table_name));

    // Test Prisma client functionality
    console.log('\n⏳ Testing Prisma client...');
    const facebookPagesCount = await prisma.facebookPage.count().catch(() => null);
    
    if (facebookPagesCount !== null) {
      console.log('✅ Prisma models are working!');
      console.log(`📈 Facebook Pages count: ${facebookPagesCount}`);
      
      // Show sample data if exists
      if (facebookPagesCount > 0) {
        const samplePages = await prisma.facebookPage.findMany({
          take: 3,
          select: {
            facebookPageId: true,
            facebookPageName: true,
            status: true
          }
        });
        console.log('📄 Sample pages:', samplePages);
      }
    } else {
      console.log('⚠️  Tables not yet created - need to run migrations');
    }

    console.log('\n🎉 Database connection test completed successfully!');
    
  } catch (error) {
    console.error('❌ Database connection failed:');
    console.error('Error message:', error.message);
    console.error('Error code:', error.code);
    
    if (error.code === 'ENOTFOUND') {
      console.error('💡 Suggestion: Check if the database server is reachable');
    } else if (error.code === 'ECONNREFUSED') {
      console.error('💡 Suggestion: Check if the database server is running on the specified port');
    } else if (error.message.includes('password authentication failed')) {
      console.error('💡 Suggestion: Check your database credentials in .env file');
    } else if (error.message.includes('database') && error.message.includes('does not exist')) {
      console.error('💡 Suggestion: Create the database first or check the database name');
    }
    
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

// Run the test
if (require.main === module) {
  testDatabaseConnection();
}

module.exports = { testDatabaseConnection };
