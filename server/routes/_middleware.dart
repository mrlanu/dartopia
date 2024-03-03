import 'package:dart_frog/dart_frog.dart';

import '../database/database_client.dart';
import '../repositories/settlement_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/world_repository.dart';
import '../services/authenticator.dart';
import '../services/settlements_service.dart';
import '../services/world_service.dart';

final _databaseClient = DatabaseClient();
final _userRepository = UserRepositoryMongo(databaseClient: _databaseClient);
final _authenticator = Authenticator(userRepository: _userRepository);
final _settlementRepository =
    SettlementRepositoryMongoImpl(databaseClient: _databaseClient);
final _settlementService =
    SettlementServiceImpl(settlementRepository: _settlementRepository);
final WorldRepository _worldRepository =
    WorldRepositoryMongoImpl(databaseClient: _databaseClient);
final WorldService _worldService =
    WorldServiceImpl(worldRepository: _worldRepository);

Handler middleware(Handler handler) {
  return handler
      .use(provider<SettlementService>((_) => _settlementService))
      .use(provider<WorldService>((_) => _worldService))
      .use(provider<Authenticator>((_) => _authenticator))
      .use(provider<UserRepository>((_) => _userRepository))
      .use(requestLogger());
}
