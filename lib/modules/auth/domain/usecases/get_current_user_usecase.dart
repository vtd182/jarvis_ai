import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/data/repositories/auth_repository.dart';
import 'package:jarvis_ai/modules/auth/domain/models/user_model.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCurrentUserUseCase extends Usecase {
  final AuthRepository _authRepository;
  const GetCurrentUserUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<UserModel> run() async {
    return _authRepository.getCurrentUser();
  }
}
