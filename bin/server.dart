import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:onde_gastei_api/application/config/application_config.dart';
import 'package:onde_gastei_api/application/middlewares/cors/cors_middlewares.dart';
import 'package:onde_gastei_api/application/middlewares/default_content_type/default_content_type.dart';
import 'package:onde_gastei_api/application/middlewares/security/security_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

Future<void> main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final router = Router();
  final appConfig = ApplicationConfig();
  await appConfig.loadConfigApplication(router);

  final getIt = GetIt.I;

  final _handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(SecurityMiddleware(getIt.get()).handler)
      .addMiddleware(
          DefaultContentType('application/json;charset=utf-8').handler)
      .addMiddleware(CorsMiddlewares().handler)
      .addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  //Log().debug('Server listening on port ${server.port}');
  print('Server listening on port ${server.port}');
}
