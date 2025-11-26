import 'package:flutter/material.dart';

class RecentTasksWidget extends StatelessWidget {
  const RecentTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      {'title': 'Follow up with Lead #108', 'progress': 0.75, 'color': Colors.blue},
      {'title': 'Complete documentation', 'progress': 0.50, 'color': Colors.green},
      {'title': 'Review pending applications', 'progress': 0.30, 'color': Colors.orange},
      {'title': 'Update client database', 'progress': 0.90, 'color': Colors.purple},
    ];

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Tasks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...tasks.map((task) => _buildTaskItem(
                task['title'] as String,
                task['progress'] as double,
                task['color'] as Color,
              )),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

