import 'package:flutter/material.dart';
import '../widgets/metric_card.dart';
import '../widgets/progress_chart.dart';
import '../widgets/recent_tasks_widget.dart';
import '../widgets/my_levels_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimations = List.generate(
      4,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.15,
            0.5 + (index * 0.15),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _fadeAnimations = List.generate(
      4,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.15,
            0.5 + (index * 0.15),
            curve: Curves.easeOut,
          ),
        ),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                const ProgressChart(),
                const SizedBox(height: 20),
                _buildMetricsGrid(),
                const SizedBox(height: 20),
                const RecentTasksWidget(),
                const MyLevelsWidget(),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Hard Raviya',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 2),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://i.pravatar.cc/150?img=12',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SlideTransition(
                position: _slideAnimations[0],
                child: FadeTransition(
                  opacity: _fadeAnimations[0],
                  child: MetricCard(
                    title: 'Total leads',
                    value: '108',
                    color: const Color(0xFFE3EBF5),
                    icon: Icons.folder,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: SlideTransition(
                position: _slideAnimations[1],
                child: FadeTransition(
                  opacity: _fadeAnimations[1],
                  child: MetricCard(
                    title: 'Pending leads',
                    value: '32',
                    color: const Color(0xFFE8F5E9),
                    icon: Icons.more_horiz,
                    customIcon: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: SlideTransition(
                position: _slideAnimations[2],
                child: FadeTransition(
                  opacity: _fadeAnimations[2],
                  child: MetricCard(
                    title: 'Rejected leads',
                    value: '76',
                    color: const Color(0xFFFFEBEE),
                    icon: Icons.close,
                    customIcon: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: SlideTransition(
                position: _slideAnimations[3],
                child: FadeTransition(
                  opacity: _fadeAnimations[3],
                  child: MetricCard(
                    title: 'Commission earned',
                    value: '₹3,45,678',
                    color: Colors.white,
                    icon: Icons.arrow_forward_ios,
                    showBorder: true,
                    customIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

