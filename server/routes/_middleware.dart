import 'package:dart_frog/dart_frog.dart';

import '../services/authenticator.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<Authenticator>(
      (_) => Authenticator(),
    ),
  );
}
