import 'package:flutter/material.dart';
import '../models/api_models.dart';

class RecentTasksWidget extends StatelessWidget {
  final List<Commission>? commissions;
  final List<Student>? students;
  
  const RecentTasksWidget({
    super.key,
    this.commissions,
    this.students,
  });

  List<Map<String, dynamic>> get tasks {
    final List<Map<String, dynamic>> taskList = [];
    
    // Add recent commissions
    if (commissions != null && commissions!.isNotEmpty) {
      for (var commission in commissions!.take(3)) {
        taskList.add({
          'title': 'Commission: ${commission.student?.name ?? "Student"}',
          'progress': commission.status == 'paid' ? 1.0 : 0.5,
          'color': commission.status == 'paid' ? Colors.green : Colors.orange,
          'amount': commission.amount,
        });
      }
    }
    
    // Add recent students
    if (students != null && students!.isNotEmpty) {
      for (var student in students!.take(2)) {
        taskList.add({
          'title': 'New Student: ${student.name ?? "Unknown"}',
          'progress': 1.0,
          'color': Colors.blue,
        });
      }
    }
    
    // If no data, show placeholder
    if (taskList.isEmpty) {
      taskList.add({
        'title': 'No recent activity',
        'progress': 0.0,
        'color': Colors.grey,
      });
    }
    
    return taskList;
  }

  @override
  Widget build(BuildContext context) {

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
            'Recent Activity',
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
                task['amount'] as double?,
              )),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, double progress, Color color, double? amount) {
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
              if (amount != null)
                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                )
              else
                Text(
                  progress == 1.0 ? 'Complete' : '${(progress * 100).toInt()}%',
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

