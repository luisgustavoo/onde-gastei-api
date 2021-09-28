import 'dart:convert';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:onde_gastei_api/application/middlewares/middlewares.dart';
import 'package:onde_gastei_api/application/middlewares/security/security_skip_url.dart';
import 'package:onde_gastei_api/helpers/jwt_helper.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:shelf/shelf.dart';

class SecurityMiddleware extends Middlewares {
  SecurityMiddleware(this.log);

  final ILog log;

  final skipUrl = <SecuritySkipUrl>[
    const SecuritySkipUrl(url: '/auth/register', method: 'POST'),
    const SecuritySkipUrl(url: '/auth/', method: 'POST'),
  ];

  @override
  Future<Response> execute(Request request) async {
    try {
      if (skipUrl.contains(SecuritySkipUrl(
          url: '/${request.url.path}', method: request.method))) {
        return innerHandler(request);
      }

      final authHeader = request.headers['Authorization'];

      if (authHeader == null || authHeader.isEmpty) {
        throw JwtException.invalidToken;
      }

      final authHeaderContent = authHeader.split(' ');

      if (authHeaderContent[0] != 'Bearer') {
        throw JwtException.invalidToken;
      }

      final authorizationToken = authHeaderContent[1];

      final claims = JwtHelper.getClaims(authorizationToken);

      if (request.url.path != 'auth/refresh') {
        claims.validate();
      }

      final claimsMap = claims.toJson();

      final userId = claimsMap['sub'].toString();

      final securityHeaders = <String, dynamic>{
        'users': userId,
        'access_token': authorizationToken,
      };

      return innerHandler(request.change(headers: securityHeaders));
    } on Exception catch (e, s) {
      log.error('Erro ao criar security middleware', e, s);
      return Response.forbidden(jsonEncode(<String, dynamic>{}));
    }
  }
}
