import 'package:dart_frog/dart_frog.dart';

import '../database/database_client.dart';
import '../repositories/settlement_repository.dart';
import '../repositories/statistics_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/world_repository.dart';
import '../services/authenticator.dart';
import '../services/settlements_service.dart';
import '../services/statistics_service.dart';
import '../services/world_service.dart';

final _databaseClient = DatabaseClient();
final _userRepository = UserRepositoryMongo(databaseClient: _databaseClient);
final _authenticator = Authenticator(userRepository: _userRepository);
final _settlementRepository =
    SettlementRepositoryMongoImpl(databaseClient: _databaseClient);
final StatisticsRepository _statisticsRepository =
    StatisticsRepositoryImpl(databaseClient: _databaseClient);
final _settlementService = SettlementServiceImpl(
    settlementRepository: _settlementRepository,
    statisticsRepository: _statisticsRepository,
    userRepository: _userRepository,);
final WorldRepository _worldRepository =
    WorldRepositoryMongoImpl(databaseClient: _databaseClient);
final WorldService _worldService =
    WorldServiceImpl(worldRepository: _worldRepository);
final StatisticsService _statisticsService =
    StatisticsServiceImpl(statisticsRepository: _statisticsRepository);

Handler middleware(Handler handler) {
  return handler
      .use(provider<SettlementService>((_) => _settlementService))
      .use(provider<StatisticsService>((_) => _statisticsService))
      .use(provider<WorldService>((_) => _worldService))
      .use(provider<Authenticator>((_) => _authenticator))
      .use(provider<UserRepository>((_) => _userRepository));
}
