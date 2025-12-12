import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/add_lead_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/commission_screen.dart';
import 'widgets/skeleton_loader.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adhyanguru Agent App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      routes: {
        '/': (context) => const SplashWrapper(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigationScreen(),
      },
      initialRoute: '/',
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isAuthenticated = await _authService.isAuthenticated();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate immediately without splash
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          isAuthenticated ? '/home' : '/login',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: SkeletonLoader(
            width: 50,
            height: 50,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      );
    }

    // This should not be reached, but just in case
    return const Scaffold(
      body: Center(
        child: SkeletonLoader(
          width: 50,
          height: 50,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;
  final PageController _pageController = PageController();
  late List<AnimationController> _iconControllers;
  late List<Animation<double>> _iconAnimations;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ProfileScreen(),
    const CommissionScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize animation controllers for each icon
    _iconControllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    _iconAnimations = _iconControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });

    // Animate the tapped icon
    _iconControllers[index].forward().then((_) {
      _iconControllers[index].reverse();
    });

    // Determine animation direction
    final isForward = index > _previousIndex;
    
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: isForward ? Curves.easeInOutCubic : Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _previousIndex = _currentIndex;
            _currentIndex = index;
          });
        },
        itemCount: _screens.length,
        itemBuilder: (context, index) {
          return _buildPageWithTransition(_screens[index], index);
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            iconAnimations: _iconAnimations,
          ),
        ),
      ),
    );
  }

  Widget _buildPageWithTransition(Widget child, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, _) {
        if (!_pageController.hasClients) {
          return child;
        }

        final page = index.toDouble();
        final currentPage = _pageController.page ?? 0.0;
        final value = (page - currentPage).abs().clamp(0.0, 1.0);
        final opacity = 1.0 - value;
        final scale = 0.95 + (0.05 * opacity);
        final offset = (page - currentPage) * 50.0;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(offset, 0),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<Animation<double>>? iconAnimations;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.iconAnimations,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 80.0 + bottomPadding + 10.0; // Increased height with extra padding
    
    return Container(
      height: navBarHeight,
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: bottomPadding + 10.0, // Extra bottom padding
        left: 8.0,
        right: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(Icons.home, 0, 'Home', screenWidth),
          _buildNavItem(Icons.people, 1, 'Profile', screenWidth),
          _buildNavItem(Icons.currency_rupee, 2, 'Commission', screenWidth),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label, double screenWidth) {
    final isSelected = currentIndex == index;
    final iconSize = screenWidth < 360 ? 22.0 : 24.0;
    final fontSize = screenWidth < 360 ? 10.0 : 11.0;
    final animation = iconAnimations != null && index < iconAnimations!.length
        ? iconAnimations![index]
        : null;
    
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: animation ?? const AlwaysStoppedAnimation(1.0),
                builder: (context, child) {
                  return Transform.scale(
                    scale: animation?.value ?? 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(isSelected ? 4 : 0),
                      decoration: isSelected
                          ? BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.grey[600],
                        size: iconSize,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontSize: fontSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
