import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/data/repositories/auth_repository.dart';
import 'package:jarvis_ai/storage/spref.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SignInWithEmailAndPasswordUseCase extends Usecase {
  final AuthRepository _authRepository;
  const SignInWithEmailAndPasswordUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<Unit> run({required String email, required String password}) async {
    final result = await _authRepository.signInWithEmailAndPassword(email: email, password: password);
    final accessToken = result["token"]["accessToken"];
    final refreshToken = result["token"]["refreshToken"];

    // Decode the JWT to get the expiration time
    final jwt = JWT.decode(accessToken);
    final expiresAt = jwt.payload["exp"];
    await SPref.instance.setExpiresAt(expiresAt);

    await SPref.instance.setAccessToken(accessToken);
    await SPref.instance.saveRefreshToken(refreshToken);
    return unit;
  }
}
