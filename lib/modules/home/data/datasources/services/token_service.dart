import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../config/config.dart';
import '../../../domain/models/token_usage.dart';

part 'token_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/v${Config.apiVersion}/tokens")
abstract class TokenService {
  @factoryMethod
  factory TokenService(Dio dio) = _TokenService;

  @GET("/usage")
  Future<TokenUsage> getTokenUsage();
}
