import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  JwtHelper._();

  static String generateJwt(int userId) {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final jwtSecret = env['JWT_SECRET'] ?? env['jwt_dev_secret']!;

    final claimSet = JwtClaim(
      issuer: 'ondegastei',
      subject: userId.toString(),
      expiry: DateTime.now().add(const Duration(days: 1)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
      maxAge: const Duration(days: 1),
    );

    return 'Bearer ${issueJwtHS256(claimSet, jwtSecret)}';
  }

  static JwtClaim getClaims(String token) {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final jwtSecret = env['JWT_SECRET'] ?? env['jwt_dev_secret']!;

    return verifyJwtHS256Signature(token, jwtSecret);
  }

  static String refreshToken(String accessToken) {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final jwtSecret = env['JWT_SECRET'] ?? env['jwt_dev_secret']!;

    final expiry = int.parse(
      env['REFRESH_TOKEN_EXPIRED_DAYS'] ?? env['refresh_token_expired_days']!,
    );
    final notBefore = int.parse(
      env['REFRESH_TOKEN_NOT_BEFORE_HOURS'] ??
          env['refresh_token_not_before_hours']!,
    );

    final claimSet = JwtClaim(
      issuer: accessToken,
      subject: 'RefreshToken',
      expiry: DateTime.now().add(Duration(days: expiry)),
      notBefore: DateTime.now().add(Duration(hours: notBefore)),
      otherClaims: <String, dynamic>{},
    );

    return 'Bearer ${issueJwtHS256(claimSet, jwtSecret)}';
  }
}
