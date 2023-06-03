// Path: lib/ui/pages/question_management/question_bucket_list.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/questions/question_buckets_list_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:empylo_app/ui/molecules/widgets/questions/question_bucket_card.dart';
import 'package:empylo_app/ui/molecules/widgets/questions/question_bucket_tile.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/question_bucket.dart';

final questionBucketCreatingProvider = StateProvider<bool>((ref) => false);
final questionBucketEditingProvider = StateProvider<bool>((ref) => false);
final questionBucketSelectedProvider = StateProvider<QuestionBucket?>((ref) => null);


class QuestionBucketList extends ConsumerWidget {
  const QuestionBucketList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionBuckets = ref.watch(questionBucketsListProvider);
    final authState = ref.watch(authStateProvider);
    final userProfile = ref.watch(userProfileNotifierProvider);

    final messenger = ScaffoldMessenger.of(context);

    try {
      if (questionBuckets.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final accessToken = await getAccessToken(ref);
          await ref
              .read(questionBucketsListProvider.notifier)
              .getQuestionBuckets(
                  accessToken, authState.role.name, userProfile!.companyID);
        });
        return const Center(child: CircularProgressIndicator());
      }
    } catch (e) {
      return ErrorPage('$e');
    }

    return SizedBox(
      width: Sizes.massive,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Company List",
                    style: EmpyloTypography.caption
                        .copyWith(color: ColorTokens.textLight),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: ColorTokens.secondaryDark,
                    onPressed: () {
                      ref.read(questionBucketCreatingProvider.notifier).state =
                          true;
                    },
                  ),
                ],
              ),
            ),
            // show QuestionBucketCard for new QuestionBucket if creating is true
            if (ref.watch(questionBucketCreatingProvider) == true)
              QuestionBucketCard(),
            VerticalSpacing.m,
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => ListView.builder(
                  itemCount: questionBuckets.length,
                  itemBuilder: (context, index) {
                    final bucket = questionBuckets[index];
                    
                    return Padding(
                      padding: EmpyloEdgeInserts.s,
                      child: QuestionBucketTile(
                        bucket: bucket,
                        onTap: () {
                          ref
                              .read(questionBucketFocusProvider.notifier)
                              .setFocus(bucket);
                          ref
                              .read(questionBucketEditingProvider.notifier)
                              .state = true;
                              
                        },
                        onDelete: () async {
                          final accessToken = await getAccessToken(ref);
                          final userId =
                              ref.read(userProfileNotifierProvider)!.id;
                          final userRole = authState.role.name;
                          final companyId =
                              ref.read(userProfileNotifierProvider)!.companyID;
                          final bucketId = bucket.id!;
                          final deleted = await ref
                              .read(questionBucketsListProvider.notifier)
                              .deleteQuestionBucket(bucketId, accessToken,
                                  userId, userRole, companyId);
                          if (deleted) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Question bucket deleted'),
                              ),
                            );
                          } else {
                            messenger.showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Failed to delete question bucket'),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
