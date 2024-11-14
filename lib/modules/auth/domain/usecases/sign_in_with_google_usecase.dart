import 'package:injectable/injectable.dart';
import 'package:suga_core/suga_core.dart';

import '../../data/repositories/auth_repository.dart';

@lazySingleton
class SignInWithGoogleUseCase extends Usecase {
  final AuthRepository _authRepository;
  const SignInWithGoogleUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<dynamic> run({required String token}) async {
    return _authRepository.signInWithGoogle(token: token);
  }
}
