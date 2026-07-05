import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/widgets/salon_card.dart';
import '../../domain/entities/review.dart';
import 'star_rating.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final initial = review.userName.isNotEmpty
        ? review.userName[0].toUpperCase()
        : '?';

    return SalonListCard(
      margin: const EdgeInsets.only(bottom: 8),
      leading: ShadAvatar(
        null,
        size: const Size(40, 40),
        placeholder: Text(
          initial,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: StarRatingDisplay(rating: review.rating, size: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.userName,
            style: theme.textTheme.p.copyWith(fontWeight: FontWeight.w600),
          ),
          if (review.createdAt != null)
            Text(
              DateFormat.yMMMd().format(review.createdAt!),
              style: theme.textTheme.muted,
            ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(review.comment!, style: theme.textTheme.p),
          ],
        ],
      ),
    );
  }
}
