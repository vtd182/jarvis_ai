import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_auth/data/repositories/knowledge_base_auth_repository.dart';
import 'package:jarvis_ai/storage/spref.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class KnowledgeBaseRefreshTokenUseCase extends Usecase {
  final KnowledgeBaseAuthRepository _knowledgeBaseAuthRepository;

  const KnowledgeBaseRefreshTokenUseCase(this._knowledgeBaseAuthRepository);

  Future<bool> run() async {
    final refreshToken = await SPref.instance.getKBRefreshToken();
    print("refreshToken: $refreshToken");
    if (refreshToken == null) {
      return false;
    } else {
      try {
        final data = await _knowledgeBaseAuthRepository.refreshToken(refreshToken);
        if (data is Map<String, dynamic>) {
          final accessToken = data["token"]["accessToken"];

          // Decode the JWT to get the expiration time
          final jwt = JWT.decode(accessToken);
          final expiresAt = jwt.payload["exp"];
          await SPref.instance.setKBExpiresAt(expiresAt);
          await SPref.instance.setKBAccessToken(accessToken);
        }
        return true;
      } catch (e) {
        return false;
      }
    }
  }
}
