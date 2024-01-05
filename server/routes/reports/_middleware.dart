import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:models/models.dart';

import '../../repositories/reports_repository.dart';
import '../../services/authenticator.dart';
import '../../services/reports_service.dart';

final _reportsRepository = ReportsRepositoryMongoImpl();
final _reportsService =
    ReportsServiceImpl(reportsRepository: _reportsRepository);

Handler middleware(Handler handler) {
  return handler.use(
    bearerAuthentication<User>(
      authenticator: (context, token) async {
        final authenticator = context.read<Authenticator>();
        return authenticator.verifyToken(token);
      },
    ),
  ).use(provider<ReportsService>((_) => _reportsService));
}
