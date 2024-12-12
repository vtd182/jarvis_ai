import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_auth/data/repositories/knowledge_base_auth_repository.dart';
import 'package:jarvis_ai/storage/spref.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class KnowledgeBaseSignInUseCase extends Usecase {
  final KnowledgeBaseAuthRepository _knowledgeBaseAuthRepository;
  const KnowledgeBaseSignInUseCase(this._knowledgeBaseAuthRepository);

  Future<Unit> run({required String token}) async {
    final result = await _knowledgeBaseAuthRepository.signInFromExternalClient(
        token: token);
    final accessToken = result["token"]["accessToken"];
    final refreshToken = result["token"]["refreshToken"];

    // Decode the JWT to get the expiration time
    final jwt = JWT.decode(accessToken);
    final expiresAt = jwt.payload["exp"];
    await SPref.instance.setKBExpiresAt(expiresAt);

    await SPref.instance.setKBAccessToken(accessToken);
    await SPref.instance.saveKBRefreshToken(refreshToken);
    return unit;
  }
}
