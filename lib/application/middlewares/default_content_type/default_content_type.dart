import 'package:onde_gastei_api/application/middlewares/middlewares.dart';
import 'package:shelf/shelf.dart';

class DefaultContentType extends Middlewares {
  DefaultContentType(this.contentType);

  final String contentType;

  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);
    return response.change(headers: {'content-type': contentType});
  }
}
