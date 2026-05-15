import 'package:dartopia/consts/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: const Color(0xFF5F6F5F),
        );

    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: 'Register',
              style: baseStyle.copyWith(
                color: DartopiaColors.primary,
                fontWeight: FontWeight.w700,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.go('/login/signup'),
            ),
          ],
        ),
      ),
    );
  }
}
