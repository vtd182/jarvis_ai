import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:jarvis_ai/modules/home/domain/usecases/get_token_usage_usecase.dart';
import 'package:suga_core/suga_core.dart';

import '../../../../core/abstracts/app_view_model.dart';
import '../../../auth/domain/models/user_model.dart';
import '../../domain/models/token_usage.dart';

@injectable
class HomePageViewModel extends AppViewModel {
  final GetTokenUsageUseCase _getTokenUsageUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Rx<TokenUsage> tokenUsage = TokenUsage(
    availableTokens: 0,
    unlimited: false,
    totalTokens: 0,
    date: DateTime.now(),
  ).obs;

  Rx<UserModel> currentUser = UserModel(id: '', email: '', username: '', roles: []).obs;

  HomePageViewModel(
    this._getTokenUsageUseCase,
    this._getCurrentUserUseCase,
  );

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

  Future<UserModel> getCurrentUser() async {
    return _getCurrentUserUseCase.run();
  }

  @override
  void initState() {
    getTokenUsage();
    super.initState();
  }
}
