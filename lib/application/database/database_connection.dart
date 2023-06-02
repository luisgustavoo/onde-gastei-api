import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:onde_gastei_api/application/config/database_connection_configuration.dart';
import 'package:onde_gastei_api/application/database/i_database_connection.dart';

@LazySingleton(as: IDatabaseConnection)
class DatabaseConnection implements IDatabaseConnection {
  DatabaseConnection(this._configuration);

  final DatabaseConnectionConfiguration _configuration;

  @override
  Future<MySqlConnection> openConnection() async {
    final connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: _configuration.host,
        user: _configuration.user,
        port: _configuration.port,
        password: _configuration.password,
        db: _configuration.databaseName,
      ),
    );

    return connection;
  }
}
