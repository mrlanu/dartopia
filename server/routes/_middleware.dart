import 'package:dart_frog/dart_frog.dart';

import '../repositories/user_repository.dart';
import '../services/authenticator.dart';
import '../services/mongo_service.dart';

final _mongo = MongoService();
final _userRepository = UserRepositoryMongo(mongoService: _mongo);
final _authenticator = Authenticator(userRepository: _userRepository);

Handler middleware(Handler handler) {
  return handler
      .use((handler) {
        return (context) async {
          await _mongo.initializeMongo();
          final response = await handler(context);
          return response;
        };
      })
      .use(provider<UserRepository>((_) => _userRepository))
      .use(provider<Authenticator>((_) => _authenticator))
      .use(requestLogger());
}
