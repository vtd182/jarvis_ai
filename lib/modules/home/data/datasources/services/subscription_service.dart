import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/domain/models/subscription_usage.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../config/config.dart';

part 'subscription_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/v${Config.apiVersion}/subscriptions")
abstract class SubscriptionService {
  @factoryMethod
  factory SubscriptionService(Dio dio) = _SubscriptionService;

  @GET("/me")
  Future<SubscriptionUsage> getSubscriptionUsage();
}
