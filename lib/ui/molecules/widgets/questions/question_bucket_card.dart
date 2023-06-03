// Path: lib/ui/molecules/widgets/questions/question_bucket_card.dart
import 'package:empylo_app/models/question_bucket.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/questions/question_buckets_list_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:empylo_app/ui/pages/question_management/question_bucket_list.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionBucketCard extends ConsumerWidget {
  final QuestionBucket? bucket;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dataKeyController = TextEditingController();
  final TextEditingController dataValueController = TextEditingController();

  QuestionBucketCard({Key? key, this.bucket}) : super(key: key) {
    if (bucket == null) {
      nameController.text = '';
      descriptionController.text = '';
      dataKeyController.text = '';
      dataValueController.text = '';
    }

    if (bucket != null) {
      nameController.text = bucket!.name;
      descriptionController.text = bucket!.description ?? '';
      if (bucket!.data != null && bucket!.data!.isNotEmpty) {
        dataKeyController.text = bucket!.data!.keys.first;
        dataValueController.text = bucket!.data![dataKeyController.text] ?? '';
      }
    }
  }

  void clearTextFields() {
    nameController.clear();
    descriptionController.clear();
    dataKeyController.clear();
    dataValueController.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSave(BuildContext context) async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        final updatedBucket = QuestionBucket(
          name: nameController.text,
          description: descriptionController.text,
          data: {dataKeyController.text: dataValueController.text},
          companyId: ref.read(userProfileNotifierProvider)!.companyID,
          createdBy: ref.read(userProfileNotifierProvider)!.id,
          updatedBy: ref.read(userProfileNotifierProvider)!.id,
        );
        final accessToken = await getAccessToken(ref);
        final userId = ref.read(userProfileNotifierProvider)!.id;
        final companyId = ref.read(userProfileNotifierProvider)!.companyID;
        final authState = ref.watch(authStateProvider);
        final userRole = authState.role.name;

        if (bucket == null) {
          try {
            final createResponse = await ref
                .read(questionBucketsListProvider.notifier)
                .createQuestionBucket(
                  accessToken,
                  updatedBucket,
                  userId,
                  userRole,
                  companyId,
                );
            if (createResponse) {
              clearTextFields();
              messenger.showSnackBar(
                const SnackBar(content: Text('Bucket created successfully')),
              );
            }
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(content: Text('Failed to create bucket: $e')),
            );
          }
        } else {
          try {
            await ref
                .read(questionBucketsListProvider.notifier)
                .updateQuestionBucket(
                  bucket!.id!,
                  updatedBucket.toJson(),
                  accessToken,
                  userId,
                  userRole,
                  companyId,
                );
            messenger.showSnackBar(
              const SnackBar(content: Text('Bucket updated successfully')),
            );
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(content: Text('Failed to update bucket: $e')),
            );
          }
        }
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to get access token: $e')),
        );
      }
    }

    void onHide() {
      final isCreating = ref.read(questionBucketCreatingProvider);
      final isEditing = ref.read(questionBucketEditingProvider);
      if (isCreating) {
        clearTextFields();
        ref
            .read(questionBucketCreatingProvider.notifier)
            .update((state) => false);
      } else if (isEditing) {
        ref
            .read(questionBucketEditingProvider.notifier)
            .update((state) => false);
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bucket != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ID: ${bucket!.id}', style: EmpyloTypography.caption),
                  IconButton(
                    iconSize: Sizes.m,
                    color: Colors.grey,
                    icon: const Icon(Icons.content_copy),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: bucket!.id!),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
            ],
            VerticalSpacing.s,
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            VerticalSpacing.s,
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            VerticalSpacing.s,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dataKeyController,
                    decoration: const InputDecoration(
                      labelText: 'Data Key',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: dataValueController,
                    decoration: const InputDecoration(
                      labelText: 'Data Value',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => onSave(context),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onHide,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
