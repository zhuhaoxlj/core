/**
 * 清空 MongoDB 数据库的脚本
 */
const { MongoClient } = require('mongodb')

// 从项目配置中读取连接信息
const MONGO_DB = {
  dbName: process.env.DB_COLLECTION_NAME || 'mx-space',
  host: process.env.DB_HOST || '127.0.0.1',
  port: process.env.DB_PORT || 27017,
  user: process.env.DB_USER || '',
  password: process.env.DB_PASSWORD || '',
  get uri() {
    const userPassword =
      this.user && this.password ? `${this.user}:${this.password}@` : ''
    return `mongodb://${userPassword}${this.host}:${this.port}/${this.dbName}`
  },
  customConnectionString: process.env.DB_CONNECTION_STRING,
}

async function resetDatabase() {
  const uri = MONGO_DB.customConnectionString || MONGO_DB.uri
  console.log(
    `正在连接到数据库: ${uri.replace(/\/\/([^:]+):([^@]+)@/, '//***:***@')}`,
  )

  const client = new MongoClient(uri)

  try {
    await client.connect()
    console.log('连接成功')

    const db = client.db(MONGO_DB.dbName)

    // 获取所有集合
    const collections = await db.listCollections().toArray()

    // 清空每个集合
    for (const collection of collections) {
      await db.collection(collection.name).deleteMany({})
      console.log(`已清空集合: ${collection.name}`)
    }

    console.log('数据库已成功重置')
  } catch (error) {
    console.error('重置数据库时出错:', error)
  } finally {
    await client.close()
    console.log('已关闭数据库连接')
  }
}

resetDatabase()
