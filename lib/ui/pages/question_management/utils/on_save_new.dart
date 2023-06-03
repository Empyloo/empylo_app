// File: onSaveNew.dart
import 'package:flutter/material.dart';
import 'package:empylo_app/models/question_bucket.dart';
import 'package:empylo_app/state_management/questions/question_buckets_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> onSaveNew(
    BuildContext context,
    WidgetRef ref,
    QuestionBucket updatedBucket,
    String accessToken,
    String userId,
    String userRole,
    String companyId,
    TextEditingController nameController,
    TextEditingController descriptionController,
    TextEditingController dataKeyController,
    TextEditingController dataValueController) async {
  final messenger = ScaffoldMessenger.of(context);
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
      nameController.clear();
      descriptionController.clear();
      dataKeyController.clear();
      dataValueController.clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Bucket created successfully')),
      );
    }
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('Failed to create bucket: $e')),
    );
  }
}
