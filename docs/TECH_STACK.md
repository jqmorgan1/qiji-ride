# 🛠️ 技术架构文档

**Shanghai Ride / 上海骑行**  
版本：v1.0  
日期：2026-03-24

---

## 1. 技术栈总览

```
┌─────────────────────────────────────────────────────────┐
│                      客户端 (Flutter)                     │
│  ┌──────────┬──────────┬──────────┬──────────┐          │
│  │   首页   │  记录页  │  路线页  │  个人中心 │          │
│  └──────────┴──────────┴──────────┴──────────┘          │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                    API Gateway (Nginx)                    │
└─────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  用户服务    │  │  骑行服务    │  │  社交服务    │
│  (Node.js)   │  │  (Go)        │  │  (Node.js)   │
└──────────────┘  └──────────────┘  └──────────────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────┐
│                    数据层                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ PostgreSQL   │  │    Redis     │  │   对象存储   │  │
│  │  (主数据库)  │  │  (缓存/排行) │  │  (照片/视频) │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## 2. 前端技术栈

### 2.1 核心框架
| 技术 | 选择 | 理由 |
|------|------|------|
| **框架** | Flutter 3.x | iOS+Android 一套代码，性能好，Google 支持 |
| **状态管理** | Riverpod | 轻量、类型安全、易测试 |
| **本地存储** | Hive | 快速、支持加密 |
| **地图** | flutter_amap (高德) | 国内数据准确、骑行路线优化 |

### 2.2 关键依赖包
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 状态管理
  flutter_riverpod: ^2.4.0
  
  # 地图
  flutter_amap: ^1.0.0  # 高德地图
  
  # 定位
  geolocator: ^10.0.0
  geocoding: ^2.1.0
  
  # 蓝牙设备
  flutter_blue_plus: ^1.0.0  # 心率带/功率计
  
  # 网络
  dio: ^5.3.0
  web_socket_channel: ^2.4.0  # 实时团骑
  
  # 本地存储
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # 图片
  cached_network_image: ^3.3.0
  image_picker: ^1.0.0
  
  # 认证
  firebase_auth: ^4.15.0  # 或自建
  
  # 分享
  share_plus: ^7.2.0
```

### 2.3 项目结构
```
lib/
├── main.dart
├── core/
│   ├── constants/       # 常量
│   ├── theme/           # 主题
│   ├── utils/           # 工具函数
│   └── errors/          # 错误处理
├── features/
│   ├── auth/            # 认证
│   ├── ride/            # 骑行记录
│   ├── route/           # 路线规划
│   ├── social/          # 社交
│   ├── segments/        # 路段挑战
│   └── profile/         # 个人中心
├── data/
│   ├── models/          # 数据模型
│   ├── repositories/    # 数据仓库
│   └── sources/         # 数据源 (API/本地)
└── presentation/
    ├── widgets/         # 通用组件
    └── screens/         # 页面
```

---

## 3. 后端技术栈

### 3.1 服务架构
| 服务 | 技术 | 职责 |
|------|------|------|
| **用户服务** | Node.js + Express | 认证、用户资料、车队 |
| **骑行服务** | Go + Gin | GPS 轨迹、实时数据、Segments |
| **社交服务** | Node.js + Express | Feed、点赞、评论 |
| **推送服务** | Node.js | 消息推送、活动通知 |

### 3.2 为什么混合技术栈？
- **Node.js**: 快速开发、社交功能适合
- **Go**: 高性能、适合处理大量 GPS 数据和实时排行

### 3.3 关键依赖

#### Node.js 服务
```json
{
  "dependencies": {
    "express": "^4.18.0",
    "jsonwebtoken": "^9.0.0",
    "bcrypt": "^5.1.0",
    "socket.io": "^4.7.0",
    "pg": "^8.11.0",
    "redis": "^4.6.0",
    "multer": "^1.4.5",
    "nodemailer": "^6.9.0"
  }
}
```

#### Go 服务
```go
require (
    github.com/gin-gonic/gin v1.9.0
    github.com/gorilla/websocket v1.5.0
    github.com/go-redis/redis/v8 v8.11.0
    github.com/lib/pq v1.10.0
    github.com/golang-jwt/jwt/v5 v5.0.0
)
```

---

## 4. 数据库设计

### 4.1 PostgreSQL 表结构

#### 用户表 (users)
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone VARCHAR(20) UNIQUE,
  wechat_openid VARCHAR(100),
  apple_id VARCHAR(100),
  nickname VARCHAR(50),
  avatar_url TEXT,
  gender VARCHAR(10),
  birth_date DATE,
  city VARCHAR(50) DEFAULT '上海',
  total_distance DECIMAL(12,2) DEFAULT 0,
  total_rides INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### 骑行记录表 (rides)
```sql
CREATE TABLE rides (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  distance DECIMAL(10,2),  -- 公里
  duration INTEGER,        -- 秒
  avg_speed DECIMAL(5,2),  -- km/h
  max_speed DECIMAL(5,2),  -- km/h
  elevation_gain DECIMAL(8,2),  -- 米
  calories INTEGER,
  track_data JSONB,        -- GPS 轨迹点数组
  weather JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_rides_user_id ON rides(user_id);
CREATE INDEX idx_rides_start_time ON rides(start_time DESC);
```

#### Segments 表 (segments)
```sql
CREATE TABLE segments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100),
  description TEXT,
  start_lat DECIMAL(10,8),
  start_lng DECIMAL(11,8),
  end_lat DECIMAL(10,8),
  end_lng DECIMAL(11,8),
  distance DECIMAL(8,2),   -- 公里
  elevation_gain DECIMAL(8,2),
  category VARCHAR(20),    -- climb/sprint/etc
  kom_user_id UUID REFERENCES users(id),
  kom_time INTEGER,        -- 秒
  qom_user_id UUID REFERENCES users(id),
  qom_time INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### Segment 成绩表 (segment_efforts)
```sql
CREATE TABLE segment_efforts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  segment_id UUID REFERENCES segments(id),
  user_id UUID REFERENCES users(id),
  ride_id UUID REFERENCES rides(id),
  time INTEGER,            -- 秒
  avg_speed DECIMAL(5,2),
  rank INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_efforts_segment ON segment_efforts(segment_id, time);
CREATE INDEX idx_efforts_user ON segment_efforts(user_id);
```

#### 社交动态表 (posts)
```sql
CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  ride_id UUID REFERENCES rides(id),
  content TEXT,
  images TEXT[],
  video_url TEXT,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### 点赞表 (likes)
```sql
CREATE TABLE likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  post_id UUID REFERENCES posts(id),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);
```

#### 车队表 (teams)
```sql
CREATE TABLE teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100),
  description TEXT,
  logo_url TEXT,
  owner_id UUID REFERENCES users(id),
  member_count INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE team_members (
  team_id UUID REFERENCES teams(id),
  user_id UUID REFERENCES users(id),
  role VARCHAR(20),  -- owner/admin/member
  joined_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (team_id, user_id)
);
```

### 4.2 Redis 使用场景

| 用途 | Key 格式 | 过期时间 |
|------|----------|----------|
| 用户 Session | `session:{user_id}` | 7 天 |
| Segments 实时排行 | `segment:{id}:kom` | 永久 |
| 团骑实时位置 | `group_ride:{id}:positions` | 1 小时 |
| 热点数据缓存 | `cache:{type}:{id}` | 5 分钟 |

---

## 5. 云服务架构

### 5.1 阿里云配置
| 服务 | 配置 | 月预算 |
|------|------|--------|
| ECS (应用服务器) | 4 核 8G × 2 | ¥800 |
| RDS (PostgreSQL) | 2 核 4G 高可用 | ¥1200 |
| Redis | 主从版 | ¥400 |
| OSS (对象存储) | 100GB + 流量 | ¥200 |
| CDN | 按量付费 | ¥300 |
| 短信服务 | 按量 | ¥200 |
| **合计** | | **¥3100/月** |

### 5.2 架构图
```
用户请求
    │
    ▼
SLB (负载均衡)
    │
    ├── ECS 1 (用户服务 + 社交服务)
    │
    └── ECS 2 (骑行服务 + 推送服务)
            │
            ├── RDS PostgreSQL (主从)
            ├── Redis (主从)
            └── OSS (照片/视频存储)
```

---

## 6. 关键技术难点与解决方案

### 6.1 GPS 精度问题
**问题**: 城市高楼导致 GPS 漂移

**解决方案**:
- 使用高德定位 SDK（融合 GPS+ 基站+WiFi）
- 轨迹平滑算法（Kalman 滤波）
- 异常点过滤（速度>80km/h 的点丢弃）

### 6.2 后台耗电
**问题**: 长时间 GPS 记录耗电快

**解决方案**:
- 智能采样（速度快时高频，慢时低频）
- 使用后台定位模式优化
- 提供省电模式选项

### 6.3 Segments 防作弊
**问题**: 用户刷榜

**解决方案**:
- 异常速度检测（>60km/h 标记）
- 轨迹相似度分析
- 用户举报机制
- 人工审核热门路段 Top 10

### 6.4 实时团骑
**问题**: 多人实时位置同步

**解决方案**:
- WebSocket 长连接
- 位置更新频率：5 秒/次
- 只同步附近队友（<5km）
- 离线消息队列

### 6.5 地图费用控制
**问题**: 高德 API 调用费用

**解决方案**:
- 客户端缓存路线数据
- 热门路线预加载
- 离线地图下载
- 监控 API 调用量设置告警

---

## 7. API 设计规范

### 7.1 RESTful 风格
```
GET    /api/v1/rides          # 获取骑行列表
POST   /api/v1/rides          # 创建骑行记录
GET    /api/v1/rides/{id}     # 获取骑行详情
PUT    /api/v1/rides/{id}     # 更新骑行记录
DELETE /api/v1/rides/{id}     # 删除骑行记录
```

### 7.2 响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": { },
  "timestamp": 1711267200000
}
```

### 7.3 错误码
| 错误码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权 |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 500 | 服务器错误 |

---

## 8. 安全策略

### 8.1 认证授权
- JWT Token 认证
- Token 有效期 7 天
- Refresh Token 机制
- 敏感操作需二次验证

### 8.2 数据加密
- HTTPS 传输加密
- 密码 bcrypt 加密
- 敏感数据 AES 加密存储

### 8.3 防攻击
- API 限流（100 次/分钟/IP）
- SQL 注入防护
- XSS 过滤
- DDoS 防护（阿里云高防）

---

## 9. 监控与日志

### 9.1 监控指标
- API 响应时间
- 错误率
- 服务器 CPU/内存
- 数据库连接数
- Redis 命中率

### 9.2 日志系统
- 应用日志：ELK Stack
- 访问日志：Nginx
- 错误追踪：Sentry

### 9.3 告警
- 钉钉/企业微信机器人
- 错误率 > 1% 告警
- 响应时间 > 2 秒告警
- 服务器宕机告警

---

**审批**: 待确认  
**状态**: 草稿 📝
