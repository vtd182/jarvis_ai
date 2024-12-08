import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/data/repositories/auth_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SignUpWithEmailAndPasswordUseCase extends Usecase {
  final AuthRepository _authRepository;
  const SignUpWithEmailAndPasswordUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<dynamic> run({required String email, required String password, required String username}) async {
    return _authRepository.signUpWithEmailAndPassword(email: email, password: password, username: username);
  }
}
