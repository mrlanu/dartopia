import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:models/models.dart';

import '../config/config.dart';
import '../helpers/hash.dart';
import '../repositories/user_repository.dart';

class Authenticator {
  Authenticator({required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  Future<User?> findByUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    final foundUser = await _userRepository.findByEmail(email: username);
    final foundUserPassword = foundUser?.password;
    final hashedPassword = hashPassword(
      password,
    );
    if (foundUser == null || hashedPassword != foundUserPassword) {
      return Future(() => null);
    }
    return foundUser;
  }

  String generateToken({
    required User user,
  }) {
    final jwt = JWT(
      {
        'id': user.id,
        'name': user.name,
        'email': user.email,
      },
    );

    return jwt.sign(SecretKey(Config.jwtSecret));
  }

  Future<User?> verifyToken(String token) async {
    try {
      final payload = JWT.verify(
        token,
        SecretKey(Config.jwtSecret),
      );

      final payloadData = payload.payload as Map<String, dynamic>;

      final email = payloadData['email'] as String;
      return _findByEmail(email: email);
    } catch (e) {
      return Future(() => null);
    }
  }

  Future<User?> _findByEmail({required String email}) async {
    return _userRepository.findByEmail(email: email);
  }
}
