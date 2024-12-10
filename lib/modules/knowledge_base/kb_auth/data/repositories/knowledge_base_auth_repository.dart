import 'package:injectable/injectable.dart';

import '../datasources/knowledge_base_auth_datasource.dart';

@lazySingleton
class KnowledgeBaseAuthRepository {
  final KnowledgeBaseAuthDataSource _knowledgeBaseAuthDataSource;

  KnowledgeBaseAuthRepository({
    required KnowledgeBaseAuthDataSource knowledgeBaseAuthDataSource,
  }) : _knowledgeBaseAuthDataSource = knowledgeBaseAuthDataSource;

  Future<dynamic> refreshToken(String refreshToken) {
    return _knowledgeBaseAuthDataSource.refreshToken(refreshToken);
  }

  Future<dynamic> signInFromExternalClient({required String token}) {
    return _knowledgeBaseAuthDataSource.signInFromExternalClient(
      token: token,
    );
  }
}
