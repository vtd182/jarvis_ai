import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/data/repositories/auth_repository.dart';

@lazySingleton
class SignUpWithEmailAndPasswordUseCase {
  final AuthRepository _authRepository;
  const SignUpWithEmailAndPasswordUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<void> run({required String email, required String password, required String username}) async {
    await _authRepository.signUpWithEmailAndPassword(email: email, password: password, username: username);
  }
}
