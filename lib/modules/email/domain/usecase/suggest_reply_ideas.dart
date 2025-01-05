import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/email/data/repository/email_repository.dart';
import 'package:jarvis_ai/modules/email/domain/model/email_idea_suggestion_response.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SuggestReplyIdeasUsecase extends Usecase {
  final EmailRepository _emailRepository;
  const SuggestReplyIdeasUsecase({required EmailRepository emailRepository}) : _emailRepository = emailRepository;

  Future<EmailIdeaSuggestionResponse> run({required String email, required Map<String, dynamic> metadata}) async {
    return _emailRepository.suggestReplyIdeas(
      email: email,
      metadata: metadata,
    );
  }
}
