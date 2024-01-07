import 'package:dartopia/authentication/authentication.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpButton extends StatelessWidget {

  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTap =
              () => Navigator.of(context).push(SignupPage.route()),
        text: '  Register', style: Theme.of(context).textTheme.titleMedium
      ),
    );
  }
}
