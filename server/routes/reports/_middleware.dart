import 'package:dart_frog/dart_frog.dart';

import '../../repositories/reports_repository.dart';
import '../../services/reports_service.dart';

final _reportsRepository = ReportsRepositoryMongoImpl();
final _reportsService =
    ReportsServiceImpl(reportsRepository: _reportsRepository);

Handler middleware(Handler handler) {
  return handler.use(provider<ReportsService>((_) => _reportsService));
}
