import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/add_lead_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/commission_screen.dart';

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
      home: const SplashWrapper(),
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showMainApp = false;

  @override
  Widget build(BuildContext context) {
    if (_showMainApp) {
      return const MainNavigationScreen();
    }

    return SplashScreen(
      onAnimationComplete: () {
        setState(() {
          _showMainApp = true;
        });
      },
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
    const CalendarScreen(),
    const AddLeadScreen(),
    const ProfileScreen(),
    const CommissionScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize animation controllers for each icon
    _iconControllers = List.generate(
      5,
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
        child: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          iconAnimations: _iconAnimations,
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
    final navBarHeight = 70.0 + bottomPadding;
    
    return Container(
      height: navBarHeight,
      padding: EdgeInsets.only(bottom: bottomPadding),
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(Icons.home, 0, 'Home', screenWidth),
                _buildNavItem(Icons.calendar_today, 1, 'Calendar', screenWidth),
                SizedBox(width: screenWidth * 0.15), // Space for center button
                _buildNavItem(Icons.people, 3, 'Profile', screenWidth),
                _buildNavItem(Icons.currency_rupee, 4, 'Commission', screenWidth),
              ],
            ),
          ),
          Positioned(
            left: screenWidth / 2 - 30,
            top: -25,
            child: _buildCenterButton(),
          ),
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

  Widget _buildCenterButton() {
    final isSelected = currentIndex == 2;
    final animation = iconAnimations != null && 2 < iconAnimations!.length
        ? iconAnimations![2]
        : null;
    
    return GestureDetector(
      onTap: () => onTap(2),
      child: AnimatedBuilder(
        animation: animation ?? const AlwaysStoppedAnimation(1.0),
        builder: (context, child) {
          return Transform.scale(
            scale: animation?.value ?? 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.black,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: isSelected ? 15 : 10,
                    offset: Offset(0, isSelected ? 8 : 5),
                  ),
                ],
              ),
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: isSelected ? 0.125 : 0.0,
                child: Icon(
                  Icons.add,
                  color: isSelected ? Colors.black : Colors.white,
                  size: 28,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
