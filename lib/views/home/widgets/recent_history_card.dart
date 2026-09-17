import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/parking_session.dart';

class RecentHistoryCard extends StatelessWidget {
  final List<ParkingSession> history;
  final VoidCallback onSeeAll;
  final void Function(ParkingSession) onItemTap;

  const RecentHistoryCard({
    super.key,
    required this.history,
    required this.onSeeAll,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title & History icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.recentParking,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.history, color: AppColors.textPrimary, size: 24),
                onPressed: onSeeAll,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content: Empty state or recent 2 items
          if (history.isEmpty)
            _buildEmptyState()
          else
            _buildRecentList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            AppStrings.emptyHistory,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          // Notepad outline icon
          Container(
            width: 44,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD6D3CD), width: 1.5),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFD6D3CD), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Expanded(child: Container(height: 2, color: const Color(0xFFD6D3CD))),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFD6D3CD), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Expanded(child: Container(height: 2, color: const Color(0xFFD6D3CD))),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFD6D3CD), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Expanded(child: Container(height: 2, color: const Color(0xFFD6D3CD))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentList() {
    final recentItems = history.take(2).toList();
    return Column(
      children: recentItems.map((session) {
        return InkWell(
          onTap: () => onItemTap(session),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // Thumbnail or Icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 54,
                    height: 54,
                    color: AppColors.primaryContainer,
                    child: session.photoPath != null && File(session.photoPath!).existsSync()
                        ? Image.file(File(session.photoPath!), fit: BoxFit.cover)
                        : const Icon(Icons.local_parking_rounded, color: AppColors.primary, size: 28),
                  ),
                ),
                const SizedBox(width: 14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.placeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      if (session.formattedDetails.isNotEmpty)
                        Text(
                          session.formattedDetails,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormatter.formatFullDateTime(session.parkedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
