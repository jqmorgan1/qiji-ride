# 🚴 Shanghai Ride - 快速开始

## 环境要求

- **Flutter**: 3.x 或更高版本
- **Dart**: 3.x 或更高版本
- **iOS**: Xcode 14+ (可选)
- **Android**: Android Studio (可选)

## 检查 Flutter 环境

```bash
flutter doctor
```

确保没有严重错误（❌）。

## 安装依赖

```bash
cd /Users/mao/clawd/shanghai-ride
flutter pub get
```

## 运行应用

### 查看可用设备

```bash
flutter devices
```

### 运行 iOS (需要 Mac)

```bash
flutter run
```

### 运行 Android

```bash
flutter run
```

### 运行 Web (浏览器测试)

```bash
flutter run -d chrome
```

## 项目结构

```
shanghai-ride/
├── lib/
│   ├── main.dart                      # 应用入口
│   └── presentation/
│       └── screens/
│           ├── home_screen.dart       # 首页（天气/统计/动态）
│           ├── ride_screen.dart       # 骑行记录页
│           ├── route_screen.dart      # 路线规划页
│           ├── challenges_screen.dart # 挑战页面
│           └── profile_screen.dart    # 个人中心
├── assets/                            # 资源文件
├── docs/                              # 项目文档
└── pubspec.yaml                       # 依赖配置
```

## 核心功能（MVP 演示版）

### ✅ 已实现
- **首页**: 天气卡片、本周统计、热门路段、动态 Feed
- **骑行记录**: 开始/暂停/结束、实时数据（模拟）
- **路线规划**: 推荐路线列表、目的地网格
- **挑战**: 路段挑战、成就徽章、活动报名
- **个人中心**: 用户信息、数据统计、功能菜单

### ⏳ 待实现（需要后端）
- 真实 GPS 定位和轨迹记录
- 用户认证和登录
- 社交功能（点赞/评论）
- 地图集成（高德/百度）
- 数据同步和存储

## 截图预览

运行后可看到 5 个主要页面：

1. **首页** - 天气、统计、路段、动态
2. **骑行** - 记录界面、实时数据
3. **路线** - 推荐路线、导航
4. **挑战** - 路段排行、徽章、活动
5. **我的** - 个人信息、数据统计

## 下一步开发

1. **配置地图**: 集成高德地图 SDK
2. **添加定位**: 实现真实 GPS 记录
3. **后端服务**: 搭建 Supabase/自建后端
4. **用户系统**: 实现登录注册
5. **社交功能**: Feed、点赞、评论

## 常见问题

### Q: Flutter 命令找不到？
A: 安装 Flutter: https://docs.flutter.dev/get-started/install

### Q: 依赖安装失败？
A: 运行 `flutter clean` 然后重新 `flutter pub get`

### Q: iOS 构建失败？
A: 运行 `cd ios && pod install && cd ..`

### Q: 如何打包发布？
A: 
- iOS: `flutter build ipa`
- Android: `flutter build apk`

## 文档

- **产品文档**: `docs/PRD.md`
- **技术架构**: `docs/TECH_STACK.md`
- **开发路线图**: `docs/ROADMAP.md`

---

**祝你骑行愉快！🚴**
