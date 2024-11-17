import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/get_token_usage_usecase.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../core/abstracts/app_view_model.dart';
import '../../domain/models/token_usage.dart';

@injectable
class HomePageViewModel extends AppViewModel {
  final GetTokenUsageUseCase _getTokenUsageUseCase;

  Rx<TokenUsage> tokenUsage = TokenUsage(
    availableTokens: 0,
    unlimited: false,
    totalTokens: 0,
    date: DateTime.now(),
  ).obs;

  HomePageViewModel(this._getTokenUsageUseCase);

  Future<Unit> getTokenUsage() async {
    print("start get token usage");
    await run(() async {
      final tokenUsage = await _getTokenUsageUseCase.run();
      print("tokenUsage: $tokenUsage");
      this.tokenUsage.value = tokenUsage;
    });
    print("end get token usage");
    return unit;
  }

  @override
  void initState() {
    getTokenUsage();
    super.initState();
  }
}
