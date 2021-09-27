import 'dart:io';

import 'package:onde_gastei_api/application/middlewares/middlewares.dart';
import 'package:shelf/shelf.dart';


class CorsMiddlewares extends Middlewares {
  final headers = <String, String>{
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST,PATCH, DELETE, OPTIONS',
    'Access-Control-Allow-Header':
        '${HttpHeaders.contentTypeHeader}, ${HttpHeaders.authorizationHeader}'
  };

  @override
  Future<Response> execute(Request request) async {
    if (request.method == 'OPTIONS') {
      return Response(HttpStatus.ok, headers: headers);
    }

    final response = await innerHandler(request);

    return response.change(headers: headers);
  }
}
