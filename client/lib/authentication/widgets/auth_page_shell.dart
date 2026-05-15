import 'package:dartopia/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:models/models.dart';

/// Full-screen auth layout: gradient backdrop, logo, and scrollable content.
class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    super.key,
    required this.child,
    this.showBackButton = false,
  });

  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _AuthBackground(),
          SafeArea(
            child: Column(
              children: [
                if (showBackButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: DartopiaColors.onPrimary,
                        size: 26.sp,
                      ),
                    ),
                  )
                else
                  SizedBox(height: 8.h),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: showBackButton ? 8.h : 24.h),
                        _AuthLogo(),
                        SizedBox(height: 28.h),
                        child,
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
            Color(0xFF4CAF50),
            Color(0xFFA5D6A7),
          ],
          stops: [0.0, 0.35, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80.h,
            right: -60.w,
            child: _GlowOrb(size: 220.w, opacity: 0.18),
          ),
          Positioned(
            bottom: -100.h,
            left: -80.w,
            child: _GlowOrb(size: 280.w, opacity: 0.14),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.35,
            left: -40.w,
            child: _GlowOrb(size: 120.w, opacity: 0.1),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _AuthLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Image.asset(
            DartopiaImages.logo,
            width: 72.w,
            height: 72.w,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

/// Frosted card wrapping auth forms.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.25),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}
