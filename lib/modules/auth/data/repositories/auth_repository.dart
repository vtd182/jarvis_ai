import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/data/datasources/auth_remote_datasource.dart';

import '../../domain/models/user_model.dart';

@lazySingleton
class AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  const AuthRepository(this._authRemoteDataSource);

  Future<dynamic> refreshToken(String refreshToken) {
    return _authRemoteDataSource.refreshToken(refreshToken);
  }

  Future<dynamic> signUpWithEmailAndPassword({required String email, required String password, required String username}) {
    return _authRemoteDataSource.signUpWithEmailAndPassword(email: email, password: password, username: username);
  }

  Future<dynamic> signInWithEmailAndPassword({required String email, required String password}) {
    return _authRemoteDataSource.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<dynamic> signInWithGoogle({required String token}) {
    return _authRemoteDataSource.signInWithGoogle(token: token);
  }

  Future<dynamic> signOut() {
    return _authRemoteDataSource.signOut();
  }

  Future<UserModel> getCurrentUser() {
    return _authRemoteDataSource.getCurrentUser();
  }
}
