import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/data/datasources/auth_remote_datasource.dart';

@lazySingleton
class AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  const AuthRepository(this._authRemoteDataSource);

  Future<dynamic> refreshToken(String refreshToken) {
    return _authRemoteDataSource.refreshToken(refreshToken);
  }

  Future<void> signUpWithEmailAndPassword({required String email, required String password, required String username}) {
    return _authRemoteDataSource.signUpWithEmailAndPassword(email: email, password: password, username: username);
  }

  Future<void> signInWithEmailAndPassword({required String email, required String password}) {
    return _authRemoteDataSource.signInWithEmailAndPassword(email: email, password: password);
  }
}
