import 'dart:async';

import 'package:anc_date_calculator/core/theme/app_theme.dart';
import 'package:anc_date_calculator/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // ---------------------------------------------
    // Logo animation
    // ---------------------------------------------

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // ---------------------------------------------
    // Open HomePage
    // ---------------------------------------------

    Timer(const Duration(milliseconds: 10000), _goToHome);
  }

  void _goToHome() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Center(
        child: AnimatedBuilder(
          animation: _controller,

          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,

              child: ScaleTransition(scale: _scaleAnimation, child: child),
            );
          },

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // ==========================================
              // APP LOGO
              // ==========================================
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: kIsWeb ? 180 : 110,
                  height: kIsWeb ? 180 : 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(28),
                      ),

                      child: Icon(
                        Icons.calendar_month_rounded,
                        size: 55,
                        color: theme.colorScheme.onPrimary,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // ==========================================
              // PROGRESS INDICATOR
              // ==========================================
              SizedBox(
                width: 36,
                height: 36,

                child: CircularProgressIndicator(
                  strokeWidth: 3.2,
                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(height: 16),

              // ==========================================
              // LOADING TEXT
              // ==========================================
              Text(
                'Loading...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
