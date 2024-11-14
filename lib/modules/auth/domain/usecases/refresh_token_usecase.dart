import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:injectable/injectable.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../storage/spref.dart';
import '../../data/repositories/auth_repository.dart';

@lazySingleton
class RefreshTokenUseCase extends Usecase {
  final AuthRepository _authRepository;

  const RefreshTokenUseCase(this._authRepository);

  Future<bool> run() async {
    final refreshToken = await SPref.instance.getRefreshToken();
    if (refreshToken == null) {
      return false;
    } else {
      try {
        final data = await _authRepository.refreshToken(refreshToken);
        if (data is Map<String, dynamic>) {
          final accessToken = data["token"]["accessToken"];

          // Decode the JWT to get the expiration time
          final jwt = JWT.decode(accessToken);
          final expiresAt = jwt.payload["exp"];
          await SPref.instance.setExpiresAt(expiresAt);

          await SPref.instance.setAccessToken(accessToken);
        }
        return true;
      } catch (e) {
        return false;
      }
    }
  }
}
