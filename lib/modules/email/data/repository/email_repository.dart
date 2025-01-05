import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/email/data/data_source/email_service.dart';
import 'package:jarvis_ai/modules/email/domain/model/email_idea_suggestion_response.dart';
import 'package:jarvis_ai/modules/email/domain/model/email_reply_response_model.dart';

@lazySingleton
class EmailRepository {
  final EmailService _emailService;

  EmailRepository(this._emailService);

  Future<EmailReplyResponse> reponseEmail({required String email, required String mainIdea, required Map<String, dynamic> metadata}) async {
    return _emailService.responseEmail({
      "email": email,
      "action": "Reply to this email",
      "mainIdea": mainIdea,
      "metadata": metadata,
    });
  }

  Future<EmailIdeaSuggestionResponse> suggestReplyIdeas({required String email, required Map<String, dynamic> metadata}) async {
    final queries = {
      "email": email,
      "action": "Suggest 3 ideas for this email",
      "metadata": metadata,
    };
    return _emailService.suggestReplyIdeas(queries);
  }
}
