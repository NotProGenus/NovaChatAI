import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onMicTap;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onMicTap,
  });

  void _handleSend() {
    if (controller.text.trim().isNotEmpty) {
      onSend();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = Responsive.of(context);

    return Container(
      padding: r.symmetricPadding(horizontal: 12, vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.grey[100],
                  borderRadius: BorderRadius.circular(r.r(24)),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontSize: r.sp(15),
                          ),
                          border: InputBorder.none,
                          contentPadding: r.symmetricPadding(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                          fontSize: r.sp(15),
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                    // Mic button
                    GestureDetector(
                      onTap: onMicTap ?? () {},
                      child: Padding(
                        padding: EdgeInsets.only(right: r.w(8)),
                        child: Icon(
                          Icons.mic_none_rounded,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          size: r.icon(24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: r.w(8)),
            // Send button
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                width: r.w(44),
                height: r.w(44),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: r.icon(22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
