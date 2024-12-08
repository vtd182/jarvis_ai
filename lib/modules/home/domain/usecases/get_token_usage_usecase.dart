import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/data/repositories/token_repository.dart';
import 'package:jarvis_ai/modules/home/domain/models/token_usage.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetTokenUsageUseCase extends Usecase {
  final TokenRepository _tokenRepository;
  const GetTokenUsageUseCase({required TokenRepository tokenRepository}) : _tokenRepository = tokenRepository;

  Future<TokenUsage> run() async {
    final tokenUsage = await _tokenRepository.getTokenUsage();
    return tokenUsage;
  }
}
