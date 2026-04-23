import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('挑战'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {},
            tooltip: '排行榜',
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: '路段挑战'),
                Tab(text: '成就徽章'),
                Tab(text: '活动'),
              ],
              labelColor: Color(0xFF00D4AA),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF00D4AA),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildSegmentsTab(),
                  _buildBadgesTab(),
                  _buildEventsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSegmentCard(
          rank: 1,
          name: '苏州河滨河路',
          distance: '5.2km',
          elevation: '12m',
          kom: '18:30',
          komName: '王五',
          qom: '20:15',
          qomName: '赵六',
          yourRecord: '25:30',
          yourRank: 156,
        ),
        _buildSegmentCard(
          rank: 2,
          name: '外滩滨江',
          distance: '3.8km',
          elevation: '5m',
          kom: '10:20',
          komName: '钱七',
          qom: '11:45',
          qomName: '孙八',
          yourRecord: '15:20',
          yourRank: 89,
        ),
        _buildSegmentCard(
          rank: 3,
          name: '佘山爬坡',
          distance: '2.1km',
          elevation: '98m',
          kom: '8:15',
          komName: '周九',
          qom: '9:30',
          qomName: '吴十',
          yourRecord: '12:45',
          yourRank: 45,
        ),
      ],
    );
  }

  Widget _buildSegmentCard({
    required int rank,
    required String name,
    required String distance,
    required String elevation,
    required String kom,
    required String komName,
    required String qom,
    required String qomName,
    required String yourRecord,
    required int yourRank,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildRankBadge(rank),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$distance · 爬升 $elevation',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4AA),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('挑战'),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildRecordItem('🥇 KOM', kom, komName),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildRecordItem('🥈 QOM', qom, qomName),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '你的记录',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Row(
                  children: [
                    Text(
                      yourRecord,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '第$yourRank名',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color color;
    String text;
    
    if (rank == 1) {
      color = Colors.amber;
      text = '🔥';
    } else if (rank == 2) {
      color = Colors.grey[400]!;
      text = '⭐';
    } else {
      color = Colors.brown;
      text = '$rank';
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: rank > 2
            ? Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                text,
                style: const TextStyle(fontSize: 20),
              ),
      ),
    );
  }

  Widget _buildRecordItem(String label, String time, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          name,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBadgesTab() {
    final badges = [
      {'name': '首骑纪念', 'desc': '完成第一次骑行', 'icon': '🎉', 'unlocked': true},
      {'name': '百公里骑士', 'desc': '累计骑行 100 公里', 'icon': '💯', 'unlocked': true},
      {'name': '清晨骑士', 'desc': '完成 10 次晨骑', 'icon': '🌅', 'unlocked': true},
      {'name': '佘山征服者', 'desc': '完成佘山爬坡 10 次', 'icon': '⛰️', 'unlocked': false},
      {'name': '夜骑达人', 'desc': '完成 20 次夜骑', 'icon': '🌙', 'unlocked': false},
      {'name': '百公里挑战', 'desc': '单次骑行 100 公里', 'icon': '🚴', 'unlocked': false},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  badge['icon'] as String,
                  style: TextStyle(fontSize: 48).copyWith(
                    color: (badge['unlocked'] as bool ? Colors.white : Colors.white30),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  badge['name'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: badge['unlocked'] as bool ? Colors.white : Colors.white54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  badge['desc'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: badge['unlocked'] as bool ? Colors.grey[600] : Colors.grey[800],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildEventCard(
          title: '周末苏州河团骑',
          date: '3 月 30 日 周六 8:00',
          location: '外白渡桥集合',
          participants: 28,
          distance: '20km',
          status: '报名中',
        ),
        _buildEventCard(
          title: '佘山爬坡挑战赛',
          date: '4 月 6 日 周日 7:30',
          location: '佘山地铁站',
          participants: 56,
          distance: '30km',
          status: '报名中',
        ),
        _buildEventCard(
          title: '夜骑外滩',
          date: '4 月 13 日 周六 19:00',
          location: '人民广场',
          participants: 42,
          distance: '15km',
          status: '已满',
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String location,
    required int participants,
    required String distance,
    required String status,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == '报名中' ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: status == '报名中' ? Colors.green : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const Spacer(),
                Icon(Icons.directions_bike, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  distance,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$participants人',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: status == '报名中' ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D4AA),
                  foregroundColor: Colors.white,
                ),
                child: Text(status == '报名中' ? '立即报名' : '报名已满'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
