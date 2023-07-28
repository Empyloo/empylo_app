import 'package:empylo_app/models/answer.dart';
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/survey/survey_notifier.dart';
import 'package:empylo_app/state_management/token_provider.dart';
import 'package:empylo_app/state_management/user_provider.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyPage extends ConsumerWidget {
  final Map<String, String> queryParams;

  const SurveyPage({super.key, required this.queryParams});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.notifier);
    final accessBox = ref.watch(accessBoxProvider);
    final surveyNotifier = ref.watch(surveyProvider.notifier);
    final pageController = PageController();

    // Call handleTokenValidation here
    ref.read(tokenValidationStateProvider.notifier).handleTokenValidation(
          accessToken: queryParams['access_token'] ?? '',
          refreshToken: queryParams['refresh_token'] ?? '',
          ref: ref,
          context: context,
        );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      surveyNotifier.loadQuestions(
        queryParams['surveyId'] ?? '',
        queryParams['access_token'] ?? '',
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Page'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final tokenValidationState = ref.watch(tokenValidationStateProvider);
        final surveyState = ref.watch(surveyProvider);

        return tokenValidationState.when(
          data: (hasValidTokens) {
            if (!hasValidTokens) {
              return const ErrorPage("Invalid Tokens/Session.");
            }

            if (surveyState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (surveyState.questions.isNotEmpty) {
              return DefaultTabController(
                length: surveyState.questions.length,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Survey'),
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: List<Widget>.generate(
                        surveyState.questions.length,
                        (index) => Tab(text: 'Question ${index + 1}'),
                      ),
                    ),
                  ),
                  body: TabBarView(
                    children: surveyState.questions.map((question) {
                      // Return a widget that displays the question and answer options
                      return QuestionTab(
                        question: question,
                        onAnswer: (answer) {
                          surveyNotifier.answerQuestion(question.id, answer);
                        },
                      );
                    }).toList(),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => surveyNotifier
                        .submitAnswers(queryParams['surveyId'] ?? ''),
                    child: const Icon(Icons.check),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No questions available.'));
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const ErrorPage("An unexpected error occurred."),
        );
      }),
    );
  }
}

class QuestionTab extends StatefulWidget {
  final Question question;
  final void Function(Answer) onAnswer;

  const QuestionTab({
    Key? key,
    required this.question,
    required this.onAnswer,
  }) : super(key: key);

  @override
  _QuestionTabState createState() => _QuestionTabState();
}

class _QuestionTabState extends State<QuestionTab> {
  late final Stopwatch _stopwatch = Stopwatch()..start();
  double _sliderValue = 0;
  String _comment = '';

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.question.question),
          const SizedBox(height: 16),
          Slider(
            value: _sliderValue,
            onChanged: (value) => setState(() => _sliderValue = value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Optional comment'),
            onChanged: (value) => _comment = value,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final answer = Answer(
                id: widget.question.id,
                floatAnswer: _sliderValue,
                comment: _comment,
                durationToAnswer: _stopwatch.elapsed.inSeconds,
              );
              widget.onAnswer(answer);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
