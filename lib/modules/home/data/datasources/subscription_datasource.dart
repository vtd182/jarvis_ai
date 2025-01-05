import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/data/datasources/services/subscription_service.dart';
import 'package:jarvis_ai/modules/home/domain/models/subscription_usage.dart';

abstract class SubscriptionDatasource {
  Future<SubscriptionUsage> getSubscriptionUsage();
}

@LazySingleton(as: SubscriptionDatasource)
class SubscriptionDatasourceImpl implements SubscriptionDatasource {
  final SubscriptionService _subscriptionService;
  SubscriptionDatasourceImpl(this._subscriptionService);
  @override
  Future<SubscriptionUsage> getSubscriptionUsage() {
    return _subscriptionService.getSubscriptionUsage();
  }
}
