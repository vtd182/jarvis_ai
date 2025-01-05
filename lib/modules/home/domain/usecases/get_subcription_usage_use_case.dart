import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/data/repositories/subscription_repository.dart';
import 'package:jarvis_ai/modules/home/domain/models/subscription_usage.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetSubscriptionUsageUseCase extends Usecase {
  final SubscriptionRepository _subscriptionRepository;
  const GetSubscriptionUsageUseCase({required SubscriptionRepository subscriptionRepository}) : _subscriptionRepository = subscriptionRepository;

  Future<SubscriptionUsage> run() async {
    final subscriptionUsage = await _subscriptionRepository.getSubscriptionUsage();
    return subscriptionUsage;
  }
}
