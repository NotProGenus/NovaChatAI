import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';

class SuggestionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SuggestionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = Responsive.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(r.w(14)),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.suggestionCardDark
              : AppColors.suggestionCardLight,
          borderRadius: BorderRadius.circular(r.r(16)),
          border: Border.all(
            color: isDark ? AppColors.darkDivider : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(r.w(8)),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.suggestionIconBgDark
                    : AppColors.suggestionIconBg,
                borderRadius: BorderRadius.circular(r.r(10)),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryBlue,
                size: r.icon(22),
              ),
            ),
            SizedBox(height: r.h(10)),
            Text(
              title,
              style: TextStyle(
                fontSize: r.sp(14),
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            SizedBox(height: r.h(3)),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: r.sp(11),
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuggestionGrid extends StatelessWidget {
  final void Function(String message) onSuggestionTap;

  const SuggestionGrid({super.key, required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    final suggestions = [
      {
        'icon': Icons.school_outlined,
        'title': 'Ask about\ncampus info',
        'subtitle': 'Timings, facilities, etc.',
        'message': 'Tell me about campus information like timings and facilities',
      },
      {
        'icon': Icons.auto_stories_outlined,
        'title': 'Help with\nstudies',
        'subtitle': 'Explanations, doubts',
        'message': 'I need help with my studies',
      },
      {
        'icon': Icons.description_outlined,
        'title': 'Summarize\ndocuments',
        'subtitle': 'Notes, PDFs, etc.',
        'message': 'I want to summarize a document',
      },
      {
        'icon': Icons.lightbulb_outline,
        'title': 'Get ideas',
        'subtitle': 'Projects, career, more',
        'message': 'Give me some project ideas',
      },
    ];

    // Calculate a responsive aspect ratio based on screen width
    // Smaller screens need taller cards, larger screens can be wider
    final aspectRatio = r.isSmallPhone ? 1.0 : (r.isLargePhone ? 1.25 : 1.15);

    return Padding(
      padding: r.symmetricPadding(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: r.w(12),
          mainAxisSpacing: r.h(12),
          childAspectRatio: aspectRatio,
        ),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final item = suggestions[index];
          return SuggestionCard(
            icon: item['icon'] as IconData,
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
            onTap: () => onSuggestionTap(item['message'] as String),
          );
        },
      ),
    );
  }
}
