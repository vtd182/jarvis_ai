import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/domain/models/token_usage.dart';

import '../datasources/token_datasource.dart';

@lazySingleton
class TokenRepository {
  final TokenDatasource _tokenDatasource;
  const TokenRepository(this._tokenDatasource);

  Future<TokenUsage> getTokenUsage() {
    return _tokenDatasource.getTokenUsage();
  }
}
