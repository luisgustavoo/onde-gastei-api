import 'dart:io';

import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  JwtHelper._();

  static String generateJwt(int userId) {
    final jwtSecret = Platform.environment['JWT_SECRET']!;

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
    final jwtSecret = Platform.environment['JWT_SECRET']!;

    return verifyJwtHS256Signature(token, jwtSecret);
  }

  static String refreshToken(String accessToken) {
    final jwtSecret = Platform.environment['JWT_SECRET']!;

    final expiry = int.parse(
      Platform.environment['REFRESH_TOKEN_EXPIRED_DAYS']!,
    );
    final notBefore = int.parse(
      Platform.environment['REFRESH_TOKEN_NOT_BEFORE_HOURS']!,
    );

    final claimSet = JwtClaim(
      issuer: accessToken,
      subject: 'RefreshToken',
      expiry: DateTime.now().add(Duration(days: expiry)),
      notBefore: DateTime.now().add(Duration(hours: notBefore)),
      otherClaims: <String, dynamic>{},
    );

    return issueJwtHS256(claimSet, jwtSecret);
  }
}
