import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:models/models.dart';

import '../../database/database_client.dart';
import '../../repositories/reports_repository.dart';
import '../../services/authenticator.dart';
import '../../services/reports_service.dart';

Handler middleware(Handler handler) {
  return handler.use(
    bearerAuthentication<User>(
      authenticator: (context, token) async {
        final authenticator = context.read<Authenticator>();
        return authenticator.verifyToken(token);
      },
    ),
  ).use(reportsServiceProvider()).use(reportsRepositoryProvider());
}

Middleware reportsRepositoryProvider() {
  return provider<ReportsRepository>(
    (context) => ReportsRepositoryMongoImpl(
      databaseClient: context.read<DatabaseClient>(),
    ),
  );
}

Middleware reportsServiceProvider() {
  return provider<ReportsService>(
    (context) => ReportsServiceImpl(
      reportsRepository: context.read<ReportsRepository>(),
    ),
  );
}
