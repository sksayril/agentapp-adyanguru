import 'package:flutter/material.dart';
import 'dart:math' as math;

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0.0),
              end: Alignment(1.0 - _controller.value * 2, 0.0),
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// Dashboard Skeleton
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

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
                // Header skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader(
                          width: 120,
                          height: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        SkeletonLoader(
                          width: 180,
                          height: 28,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    SkeletonLoader(
                      width: 50,
                      height: 50,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Chart skeleton
                SkeletonLoader(
                  width: double.infinity,
                  height: 200,
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(height: 20),
                // Metrics grid skeleton
                Row(
                  children: [
                    Expanded(
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Recent tasks skeleton
                SkeletonLoader(
                  width: double.infinity,
                  height: 200,
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(height: 20),
                // Levels skeleton
                SkeletonLoader(
                  width: double.infinity,
                  height: 150,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Profile Skeleton
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile header skeleton
              SkeletonLoader(
                width: double.infinity,
                height: 200,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 20),
              // Referral section skeleton
              SkeletonLoader(
                width: double.infinity,
                height: 180,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 20),
              // Share section skeleton
              SkeletonLoader(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 20),
              // Menu items skeleton
              ...List.generate(5, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: SkeletonLoader(
                      width: double.infinity,
                      height: 60,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// Commission Skeleton
class CommissionSkeleton extends StatelessWidget {
  const CommissionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Commission',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total commission skeleton
              SkeletonLoader(
                width: double.infinity,
                height: 150,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 20),
              // Wallet balance skeleton
              SkeletonLoader(
                width: double.infinity,
                height: 140,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 20),
              // Withdrawal request skeleton
              SkeletonLoader(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 30),
              // Section header skeleton
              SkeletonLoader(
                width: 150,
                height: 24,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 15),
              // Transaction items skeleton
              ...List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: SkeletonLoader(
                      width: double.infinity,
                      height: 80,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// Simple skeleton for small loading states
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerEffect({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0.0),
              end: Alignment(1.0 - _controller.value * 2, 0.0),
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

