import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../config/config.dart';

part 'auth_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/v${Config.apiVersion}/auth")
abstract class AuthService {
  @factoryMethod
  factory AuthService(Dio dio) = _AuthService;

  @POST("/sign-in")
  Future<dynamic> signInWithEmailAndPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST("/sign-up")
  Future<dynamic> signUpWithEmailAndPassword(
    @Body() Map<String, dynamic> body,
  );

  @GET("")
  Future<dynamic> refreshToken(@Part(name: "refreshToken") String refreshToken);
}
