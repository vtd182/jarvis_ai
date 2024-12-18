import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/data/datasources/services/auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });
  Future<dynamic> refreshToken(String refreshToken);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService _authService;

  AuthRemoteDataSourceImpl(this._authService);

  @override
  Future<dynamic> refreshToken(String refreshToken) {
    return _authService.refreshToken(refreshToken);
  }

  @override
  Future<void> signUpWithEmailAndPassword({required String email, required String password, required String username}) {
    return _authService.signUpWithEmailAndPassword(
      {
        'email': email,
        'password': password,
        'username': username,
      },
    );
  }

  @override
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    await _authService.signInWithEmailAndPassword(
      {
        'email': email,
        'password': password,
      },
    );
  }
}
