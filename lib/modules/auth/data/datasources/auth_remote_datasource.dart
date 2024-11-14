import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/data/datasources/services/auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<dynamic> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<dynamic> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });
  Future<dynamic> refreshToken(String refreshToken);
  Future<dynamic> signOut();
  Future<dynamic> signInWithGoogle({required String token});
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
  Future<dynamic> signUpWithEmailAndPassword({required String email, required String password, required String username}) {
    return _authService.signUpWithEmailAndPassword(
      {
        'email': email,
        'password': password,
        'username': username,
      },
    );
  }

  @override
  Future<dynamic> signInWithEmailAndPassword({required String email, required String password}) async {
    return _authService.signInWithEmailAndPassword(
      {
        'email': email,
        'password': password,
      },
    );
  }

  @override
  Future<dynamic> signInWithGoogle({required String token}) {
    return _authService.signInWithGoogle({
      'token': token,
    });
  }

  @override
  Future signOut() {
    return _authService.signOut();
  }
}
