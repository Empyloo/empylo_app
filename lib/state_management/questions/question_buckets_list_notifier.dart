// Path: lib/state_management/questions/question_buckets_list_notifier.dart
import 'package:empylo_app/services/question_bucket_service.dart';
import 'package:empylo_app/models/question_bucket.dart';
import 'package:empylo_app/state_management/questions/question_bucket_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionBucketsList extends StateNotifier<List<QuestionBucket>> {
  final QuestionBucketService questionBucketService;

  QuestionBucketsList({required this.questionBucketService}) : super([]);

  Future<bool> createQuestionBucket(
      String accessToken,
      QuestionBucket questionBucket,
      String userId,
      String userRole,
      String companyId) async {
    try {
      final questionBucketResponse = await questionBucketService.createQuestionBucket(
          accessToken, questionBucket, userId, userRole, companyId);
      state = [...state, questionBucket];
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getQuestionBuckets(
      String accessToken, String userRole, String companyId) async {
    try {
      final questionBuckets = await questionBucketService.getQuestionBuckets(
          accessToken, userRole, companyId);
      state = questionBuckets;
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  Future<bool> updateQuestionBucket(
      String id,
      Map<String, dynamic> updates,
      String accessToken,
      String userId,
      String userRole,
      String companyId) async {
    try {
      await questionBucketService.updateQuestionBucket(
          accessToken, id, updates, userId, userRole, companyId);
      state = state.map((questionBucket) {
        if (questionBucket.id == id) {
          return questionBucket.copyWith(updates);
        } else {
          return questionBucket;
        }
      }).toList();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteQuestionBucket(String id, String accessToken,
      String userId, String userRole, String companyId) async {
    try {
      await questionBucketService.deleteQuestionBucket(
          accessToken, id, userId, userRole, companyId);
      state = state.where((questionBucket) => questionBucket.id != id).toList();
      return true;
    } catch (e) {
      return false;
    }
  }
}

class QuestionBucketFocus extends StateNotifier<QuestionBucket?> {
  QuestionBucketFocus() : super(null);

  void setFocus(QuestionBucket? questionBucket) {
    state = questionBucket;
  }
}

final questionBucketsListProvider =
    StateNotifierProvider<QuestionBucketsList, List<QuestionBucket>>((ref) {
  final questionBucketService = ref.watch(questionBucketServiceProvider);
  return QuestionBucketsList(questionBucketService: questionBucketService);
});

final questionBucketFocusProvider =
    StateNotifierProvider<QuestionBucketFocus, QuestionBucket?>((ref) {
  return QuestionBucketFocus();
});
