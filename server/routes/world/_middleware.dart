import 'package:dart_frog/dart_frog.dart';
import '../../repositories/world_repository.dart';
import '../../services/world_service.dart';

final WorldRepository _worldRepository = WorldRepositoryMongoImpl();
final WorldService _worldService =
    WorldServiceImpl(worldRepository: _worldRepository);

Handler middleware(Handler handler) {
  return handler.use(provider<WorldService>((_) => _worldService));
}
