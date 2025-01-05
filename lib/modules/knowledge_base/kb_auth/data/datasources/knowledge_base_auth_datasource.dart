import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_auth/data/datasources/services/knowledge_base_auth_service.dart';

abstract class KnowledgeBaseAuthDataSource {
  Future<dynamic> signInFromExternalClient({
    required String token,
  });
  Future<dynamic> refreshToken(String refreshToken);
}

@LazySingleton(as: KnowledgeBaseAuthDataSource)
class KnowledgeBaseAuthDataSourceImpl implements KnowledgeBaseAuthDataSource {
  final KnowledgeBaseAuthService _knowledgeBaseAuthService;

  KnowledgeBaseAuthDataSourceImpl(this._knowledgeBaseAuthService);

  @override
  Future<dynamic> refreshToken(String refreshToken) {
    return _knowledgeBaseAuthService.refreshToken(refreshToken);
  }

  @override
  Future<dynamic> signInFromExternalClient({required String token}) {
    return _knowledgeBaseAuthService.signInFromExternalClient(
      {
        'token': token,
      },
    );
  }
}
