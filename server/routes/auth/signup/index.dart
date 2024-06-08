import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../exceptions/exceptions.dart';
import '../../../helpers/hash.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/authenticator.dart';
import '../../../services/settlements_service.dart';
import '../../../services/statistics_service.dart';
import '../../../services/world_service.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final request = context.request;
  final userRepository = context.read<UserRepository>();
  final settlementService = context.read<SettlementService>();
  final worldService = context.read<WorldService>();
  final statisticsService = context.read<StatisticsService>();

  final requestBody = await request.body();
  final requestData = jsonDecode(requestBody) as Map<String, dynamic>;

  final user = User.fromJson(requestData).copyWith(
    id: ObjectId().$oid,
    name: _trimEmail(requestData['email'] as String),
    password: hashPassword(requestData['password'] as String),
  );

  try {
    await userRepository.findByEmail(email: user.email);
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: const FailureModel(message: 'Email already exists.').toJson(),
    );
  } on NoUserFoundException catch (_) {
    await userRepository.insertOne(user: user);
    final firstSettlement = await _foundNewSettlement(
      user: user,
      settlementService: settlementService,
      worldService: worldService,
    );
    await statisticsService.createStatistics(
        playerId: user.id!,
        playerName: user.name,
        buildings: firstSettlement.buildings);
    final authenticator = context.read<Authenticator>();

    return Response.json(
      body: {
        'name': user.name,
        'id': user.id,
        'email': user.email,
        'token': authenticator.generateToken(
          user: user,
        ),
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {
        'status': 500,
        'message': 'Server error. Something went wrong',
        'error': e.toString(),
      },
    );
  }
}

Future<Settlement> _foundNewSettlement({
  required User user,
  required SettlementService settlementService,
  required WorldService worldService,
}) async {
  final settlement =
      await settlementService.foundNewSettlement(userId: user.id!);
  await worldService.insertSettlement(
    settlementId: settlement!.id.$oid,
    x: settlement.x,
    y: settlement.y,
  );
  return settlement;
}

String _trimEmail(String email) {
  final atIndex = email.indexOf('@');
  if (atIndex != -1) {
    final name = email.substring(0, atIndex);
    return _capitalizeFirst(name);
  } else {
    return email;
  }
}

String _capitalizeFirst(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
