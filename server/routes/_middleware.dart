import 'package:dart_frog/dart_frog.dart';

import '../repositories/settlement_repository.dart';
import '../repositories/user_repository.dart';
import '../services/authenticator.dart';
import '../services/mongo_service.dart';
import '../services/settlements_service.dart';

final _userRepository = UserRepositoryMongo(mongoService: MongoService.instance);
final _authenticator = Authenticator(userRepository: _userRepository);
final _settlementRepository = SettlementRepositoryMongoImpl();
final _settlementService =
SettlementServiceImpl(settlementRepository: _settlementRepository);

Handler middleware(Handler handler) {
  return handler
      .use(provider<UserRepository>((_) => _userRepository))
      .use(provider<SettlementService>((_) => _settlementService))
      .use(provider<Authenticator>((_) => _authenticator))
      .use(requestLogger());
}
