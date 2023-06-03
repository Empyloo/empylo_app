// File: onSaveEdit.dart
import 'package:flutter/material.dart';
import 'package:empylo_app/models/question_bucket.dart';
import 'package:empylo_app/state_management/questions/question_buckets_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> onSaveEdit(
    BuildContext context,
    WidgetRef ref,
    String bucketId,
    Map<String, dynamic> updatedBucketJson,
    String accessToken,
    String userId,
    String userRole,
    String companyId) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await ref.read(questionBucketsListProvider.notifier).updateQuestionBucket(
          bucketId,
          updatedBucketJson,
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
