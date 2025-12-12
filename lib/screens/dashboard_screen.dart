import 'package:flutter/material.dart';
import '../widgets/metric_card.dart';
import '../widgets/progress_chart.dart';
import '../widgets/recent_tasks_widget.dart';
import '../widgets/my_levels_widget.dart';
import '../widgets/skeleton_loader.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/api_models.dart';

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
  
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  
  AgentProfile? _profile;
  WalletBalance? _walletBalance;
  StudentSignupAnalytics? _analytics;
  CommissionsResponse? _commissions;
  StudentsResponse? _students;
  bool _isLoading = true;
  String? _error;

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

    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _apiService.getProfile(),
        _apiService.getWalletBalance(),
        _apiService.getStudentSignupAnalytics(),
        _apiService.getMyCommissions(limit: 5),
        _apiService.getMyStudents(limit: 5),
      ]);

      setState(() {
        _profile = results[0] as AgentProfile;
        _walletBalance = results[1] as WalletBalance;
        _analytics = results[2] as StudentSignupAnalytics;
        _commissions = results[3] as CommissionsResponse;
        _students = results[4] as StudentsResponse;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const DashboardSkeleton();
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadDashboardData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  ProgressChart(analytics: _analytics),
                  const SizedBox(height: 20),
                  _buildMetricsGrid(),
                  const SizedBox(height: 20),
                  RecentTasksWidget(
                    commissions: _commissions?.data?.items,
                    students: _students?.data?.items,
                  ),
                  MyLevelsWidget(profile: _profile),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final name = _profile?.name ?? 'Agent';
    final imageUrl = _profile?.image;
    
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
            Text(
              name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!, width: 2),
            color: Colors.grey[200],
          ),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, color: Colors.grey[600]);
                    },
                  ),
                )
              : Icon(Icons.person, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    final totalStudents = _students?.data?.pagination?.total ?? 0;
    final totalCommissions = _commissions?.data?.items?.length ?? 0;
    final walletBalance = _walletBalance?.balance ?? 0.0;
    final currentSignups = _analytics?.currentPeriod?.signups ?? 0;
    
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
                    title: 'Total Students',
                    value: totalStudents.toString(),
                    color: const Color(0xFFE3EBF5),
                    icon: Icons.people,
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
                    title: 'This Month',
                    value: currentSignups.toString(),
                    color: const Color(0xFFE8F5E9),
                    icon: Icons.trending_up,
                    customIcon: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.trending_up,
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
                    title: 'Commissions',
                    value: totalCommissions.toString(),
                    color: const Color(0xFFFFEBEE),
                    icon: Icons.currency_rupee,
                    customIcon: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.currency_rupee,
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
                    title: 'Wallet Balance',
                    value: '₹${walletBalance.toStringAsFixed(0)}',
                    color: Colors.white,
                    icon: Icons.account_balance_wallet,
                    showBorder: true,
                    customIcon: Icon(
                      Icons.account_balance_wallet,
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

