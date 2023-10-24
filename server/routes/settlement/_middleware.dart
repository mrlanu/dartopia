import 'package:dart_frog/dart_frog.dart';

import '../../repositories/settlement_repository.dart';
import '../../services/settlements_service.dart';

final _settlementRepository = SettlementRepositoryMongoImpl();
final _settlementService =
    SettlementServiceImpl(settlementRepository: _settlementRepository);

Handler middleware(Handler handler) {
  return handler
      .use(provider<SettlementService>((_) => _settlementService));
}
