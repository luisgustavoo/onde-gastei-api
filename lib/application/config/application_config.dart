import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:onde_gastei_api/application/config/database_connection_configuration.dart';
import 'package:onde_gastei_api/application/config/service_locator_config.dart';
import 'package:onde_gastei_api/application/router/router_configure.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/logs/log.dart';
import 'package:shelf_router/shelf_router.dart';

class ApplicationConfig {
  Future<void> loadConfigApplication(Router router) async {
    _loadDependencies();
    _loadDatabaseConfig();
    _configLogger();
    _loadRoutersConfigure(router);
  }

  void _loadDependencies() => configureDependencies();

  void _loadRoutersConfigure(Router router) =>
      RouterConfigure(router).configure();

  void _configLogger() => GetIt.I.registerLazySingleton<ILog>(Log.new);

  String _loadSecret(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw StateError('Secret não encontrado em $path');
    }

    final content = file.readAsStringSync().trim();
    if (content.isEmpty) {
      throw StateError('Secret em $path está vazio');
    }

    return content;
  }

  void _loadDatabaseConfig() {
    final dbPassword = _loadSecret('/run/secrets/mysql_app_password');

    final databaseConfig = DatabaseConnectionConfiguration(
      host: Platform.environment['DB_HOST']!,
      user: Platform.environment['DB_USER']!,
      password: dbPassword,
      port: int.tryParse(
            Platform.environment['DB_PORT']!,
          ) ??
          0,
      databaseName: Platform.environment['DB_NAME']!,
    );

    GetIt.I.registerSingleton(databaseConfig);
  }
}
