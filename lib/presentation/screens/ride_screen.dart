import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  bool _isRecording = false;
  Duration _duration = Duration.zero;
  double _distance = 0.0;
  double _speed = 0.0;
  double _avgSpeed = 0.0;
  int _calories = 0;
  Timer? _timer;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _duration = Duration.zero;
      _distance = 0.0;
      _speed = 0.0;
      _avgSpeed = 0.0;
      _calories = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = Duration(seconds: timer.tick);
        // 模拟数据
        _speed = 15.0 + (timer.tick % 10) * 0.5;
        _distance = timer.tick * 0.005;
        _avgSpeed = _distance / (timer.tick / 3600);
        _calories = (timer.tick * 0.15).round();
      });
    });
  }

  void _pauseRecording() {
    _timer?.cancel();
    setState(() {
      _isRecording = false;
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    setState(() {
      _isRecording = false;
    });

    _showRideSummary();
  }

  void _showRideSummary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('骑行完成'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryItem('距离', '${_distance.toStringAsFixed(2)} km'),
            _buildSummaryItem('时间', _formatDuration(_duration)),
            _buildSummaryItem('平均速度', '${_avgSpeed.toStringAsFixed(1)} km/h'),
            _buildSummaryItem('消耗', '$_calories kcal'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetData();
            },
            child: const Text('完成'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  void _resetData() {
    setState(() {
      _duration = Duration.zero;
      _distance = 0.0;
      _speed = 0.0;
      _avgSpeed = 0.0;
      _calories = 0;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('骑行记录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 地图区域（模拟）
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.grey[900],
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 64, color: Colors.grey[700]),
                        const SizedBox(height: 16),
                        Text(
                          '地图区域',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '实际使用时显示高德地图',
                          style: TextStyle(color: Colors.grey[700], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (_isRecording)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '录制中',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 数据面板
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 主要数据
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDataCard('速度', '${_speed.toStringAsFixed(1)}', 'km/h', Icons.speed),
                      _buildDataCard('距离', _distance.toStringAsFixed(2), 'km', Icons.route),
                      _buildDataCard('时间', _formatDuration(_duration).substring(0, 5), '', Icons.timer),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 次要数据
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDataCard('平均速度', _avgSpeed.toStringAsFixed(1), 'km/h', Icons.speed),
                      _buildDataCard('消耗', '$_calories', 'kcal', Icons.local_fire_department),
                      _buildDataCard('海拔', '25', 'm', Icons.terrain),
                    ],
                  ),

                  const Spacer(),

                  // 控制按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isRecording)
                        _buildButton('开始骑行', Colors.green, _startRecording)
                      else
                        ...[
                          _buildButton('暂停', Colors.orange, _pauseRecording, width: 100),
                          const SizedBox(width: 16),
                          _buildButton('结束', Colors.red, _stopRecording, width: 100),
                        ],
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(String label, String value, String unit, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00D4AA), size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(color: Colors.grey[500], fontSize: 10),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed, {double width = 140}) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
