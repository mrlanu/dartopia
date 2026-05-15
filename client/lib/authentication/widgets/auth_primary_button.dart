import 'package:dartopia/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.buttonKey,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: enabled
              ? const LinearGradient(
                  colors: [
                    Color(0xFF1B5E20),
                    Color(0xFF2E7D32),
                    Color(0xFF43A047),
                  ],
                )
              : null,
          color: enabled ? null : DartopiaColors.lighterGrey,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: DartopiaColors.primary.withValues(alpha: 0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: buttonKey,
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(16.r),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 26.w,
                      height: 26.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
