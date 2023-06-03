// Path: lib/ui/molecules/widgets/questions/question_bucket_tile.dart
import 'package:empylo_app/models/question_bucket.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:empylo_app/ui/molecules/widgets/questions/question_bucket_card.dart';
import 'package:empylo_app/ui/pages/question_management/question_bucket_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionBucketTile extends ConsumerWidget {
  final QuestionBucket bucket;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const QuestionBucketTile({
    super.key,
    required this.bucket,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          tileColor: ColorTokens.primaryLight,
          title: Text(bucket.name, style: EmpyloTypography.caption),
          subtitle: Text(bucket.description ?? 'No description',
              style: EmpyloTypography.body),
          onTap: onTap,
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ),
        // onTap load and show QuestionBucketCard
        if (ref.watch(questionBucketEditingProvider) == true)
          QuestionBucketCard(bucket: bucket),
      ],
    );
  }
}
