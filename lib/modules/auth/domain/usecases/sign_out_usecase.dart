import 'package:injectable/injectable.dart';
import 'package:suga_core/suga_core.dart';

import '../../data/repositories/auth_repository.dart';

@lazySingleton
class SignOutUseCase extends Usecase {
  final AuthRepository _authRepository;
  const SignOutUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<void> run() async {
    await _authRepository.signOut();
  }
}
