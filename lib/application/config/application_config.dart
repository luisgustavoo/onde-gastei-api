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

  void _loadDatabaseConfig() {
    final databaseConfig = DatabaseConnectionConfiguration(
      host: Platform.environment['DB_HOST']!,
      user: Platform.environment['DB_USER']!,
      password: Platform.environment['DB_PASSWORD']!,
      port: int.tryParse(
            Platform.environment['DB_PORT']!,
          ) ??
          0,
      databaseName: Platform.environment['DB_NAME']!,
    );

    GetIt.I.registerSingleton(databaseConfig);
  }
}
