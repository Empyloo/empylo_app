import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';

String getCompanyId({
  String? companyIdController,
  QuestionnaireWithQuestions? questionnaireWithQuestions,
  required UserProfile userProfile,
}) {
  if (companyIdController != null && companyIdController.isNotEmpty) {
    return companyIdController;
  } else if (questionnaireWithQuestions?.questionnaire.companyId != null) {
    return questionnaireWithQuestions!.questionnaire.companyId;
  } else {
    return userProfile.companyID;
  }
}
