import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../services/authenticator.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(
      Response(statusCode: HttpStatus.methodNotAllowed),
    ),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  if (email == null || password == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final authenticator = context.read<Authenticator>();

  final user = await authenticator.findByUsernameAndPassword(
    username: email,
    password: password,
  );

  if (user == null) {
    return Response(statusCode: HttpStatus.unauthorized);
  } else {
    return Response.json(
      body: {
        'token': authenticator.generateToken(user: user,),
      },
    );
  }
}
