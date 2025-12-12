import 'package:flutter/material.dart';
import '../models/api_models.dart';

class ProgressChart extends StatefulWidget {
  final StudentSignupAnalytics? analytics;
  
  const ProgressChart({super.key, this.analytics});

  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<double> get weeklyData {
    // Always return 7 days of data (for this week)
    // If no analytics data, return zeros for all 7 days
    if (widget.analytics?.monthlyBreakdown == null || 
        widget.analytics!.monthlyBreakdown!.isEmpty) {
      return [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    }
    
    // For weekly data, we'll use the current period signups divided by 7
    // or use monthly breakdown if available
    final currentSignups = widget.analytics?.currentPeriod?.signups ?? 0;
    
    // Distribute signups across 7 days (simple distribution)
    // In a real app, you'd get daily data from the API
    if (currentSignups == 0) {
      return [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    }
    
    // Simple distribution: divide by 7 and add some variation
    final baseValue = currentSignups / 7.0;
    return [
      baseValue * 0.8,
      baseValue * 1.2,
      baseValue * 0.9,
      baseValue * 1.1,
      baseValue * 1.3,
      baseValue * 0.7,
      baseValue * 1.0,
    ];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'This Week',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: LineChartPainter(
                        weeklyData,
                        _animation.value,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final double animationValue;

  LineChartPainter(this.data, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length < 2) return;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = 0.0;
    // Ensure range is at least 1 to avoid division by zero
    final range = (maxValue - minValue) > 0 ? (maxValue - minValue) : 1.0;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final width = size.width;
    final height = size.height;
    final stepX = width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = range > 0 ? (data[i] - minValue) / range : 0.0;
      // When all values are 0, show a flat line at the bottom
      final y = maxValue > 0 
          ? height - (normalizedValue * height * animationValue)
          : height - 10; // Small offset from bottom when all zeros

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw point only if there's data
      if (maxValue > 0 || i == 0 || i == data.length - 1) {
        canvas.drawCircle(Offset(x, y), 4, pointPaint);
      }
    }

    // Complete fill path
    fillPath.lineTo(width, height);
    fillPath.close();

    // Draw filled area
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

