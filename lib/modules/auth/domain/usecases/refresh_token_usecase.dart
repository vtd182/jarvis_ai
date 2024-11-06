import 'package:injectable/injectable.dart';
import 'package:suga_core/suga_core.dart';

import '../../data/repositories/auth_repository.dart';

@lazySingleton
class RefreshTokenUseCase extends Usecase {
  final AuthRepository _authRepository;

  const RefreshTokenUseCase(this._authRepository);

  Future<void> run(String refreshToken) async {
    await _authRepository.refreshToken(refreshToken);
  }
}
