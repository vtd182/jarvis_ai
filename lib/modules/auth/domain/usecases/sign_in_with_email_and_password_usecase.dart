import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/data/repositories/auth_repository.dart';

@lazySingleton
class SignInWithEmailAndPasswordUseCase {
  final AuthRepository _authRepository;
  const SignInWithEmailAndPasswordUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<void> run({required String email, required String password}) async {
    await _authRepository.signInWithEmailAndPassword(email: email, password: password);
  }
}
