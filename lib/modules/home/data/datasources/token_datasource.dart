import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/data/datasources/services/token_service.dart';

import '../../domain/models/token_usage.dart';

abstract class TokenDatasource {
  Future<TokenUsage> getTokenUsage();
}

@LazySingleton(as: TokenDatasource)
class TokenDatasourceImpl implements TokenDatasource {
  final TokenService _tokenService;
  TokenDatasourceImpl(this._tokenService);
  @override
  Future<TokenUsage> getTokenUsage() {
    return _tokenService.getTokenUsage();
  }
}
