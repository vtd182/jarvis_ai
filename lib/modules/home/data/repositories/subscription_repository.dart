import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/data/datasources/subscription_datasource.dart';
import 'package:jarvis_ai/modules/home/domain/models/subscription_usage.dart';

@lazySingleton
class SubscriptionRepository {
  final SubscriptionDatasource _subscriptionDatasource;
  const SubscriptionRepository(this._subscriptionDatasource);

  Future<SubscriptionUsage> getSubscriptionUsage() {
    return _subscriptionDatasource.getSubscriptionUsage();
  }
}
