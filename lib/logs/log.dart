import 'package:logger/logger.dart';
import 'package:onde_gastei_api/logs/i_log.dart';

class Log implements ILog {
  Log() {
    var release = true;
    assert(
      () {
        release = false;
        return true;
      }(),
    );

    _logger = Logger(
      filter: release ? ProductionFilter() : DevelopmentFilter(),
    );
  }

  var _logger = Logger();

  @override
  void debug(Object message, [Object? error, StackTrace? stackTrace]) =>
      _logger.d(message, error, stackTrace);

  @override
  void error(Object message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error, stackTrace);

  @override
  void info(Object message, [Object? error, StackTrace? stackTrace]) =>
      _logger.w(message, error, stackTrace);

  @override
  void warning(Object message, [Object? error, StackTrace? stackTrace]) =>
      _logger.i(message, error, stackTrace);
}
