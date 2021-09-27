class SecuritySkipUrl {
  const SecuritySkipUrl({
    required this.url,
    required this.method,
  });

  final String url;
  final String method;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SecuritySkipUrl &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          method == other.method);

  @override
  int get hashCode => url.hashCode ^ method.hashCode;
}
