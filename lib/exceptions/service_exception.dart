class ServiceException implements Exception {
  const ServiceException([this.message]);

  final String? message;
}
