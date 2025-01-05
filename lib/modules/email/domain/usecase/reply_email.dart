import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/email/data/repository/email_repository.dart';
import 'package:jarvis_ai/modules/email/domain/model/email_reply_response_model.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ReplyEmailUsecase extends Usecase {
  final EmailRepository _emailRepository;
  const ReplyEmailUsecase({required EmailRepository emailRepository})
      : _emailRepository = emailRepository;

  Future<EmailReplyResponse> run(
      {required String email,
      required String mainIdea,
      required Map<String, dynamic> metadata}) async {
    return _emailRepository.reponseEmail(
      email: email,
      mainIdea: mainIdea,
      metadata: metadata,
    );
  }
}
