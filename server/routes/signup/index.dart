import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import '../../helpers/helpers.dart';
import '../../services/mongo_service.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => MongoService.startConnection(context, _onPost(context)),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onPost(RequestContext context) async {
  try {
    final request = context.request;

    final requestBody = await request.body();
    final requestData = jsonDecode(requestBody) as Map<String, dynamic>;

    final user = User.fromJson(requestData).copyWith(
      password: hashPassword(requestData['password'] as String),
    );

    final foundUser =
    await MongoService.usersCollection.findOne({'email': user.email});

    if (foundUser != null) {
      return Response.json(
        statusCode: 400,
        body: {
          'status': 400,
          'message': 'A user with the provided email already exists',
          'error': 'user_exists',
        },
      );
    }

    await MongoService.usersCollection.insertOne(user.toJson());
    return Response.json(
      body: {
        'status': 200,
        'message': 'User registered successfully',
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
