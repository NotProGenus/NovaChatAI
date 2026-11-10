import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.isUser;
    final r = Responsive.of(context);

    return Padding(
      padding: r.symmetricPadding(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: r.w(16),
              backgroundColor: isDark
                  ? AppColors.suggestionIconBgDark
                  : AppColors.suggestionIconBg,
              child: Icon(
                Icons.smart_toy_outlined,
                size: r.icon(18),
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(width: r.w(8)),
          ],
          Flexible(
            child: Container(
              padding: r.symmetricPadding(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.userBubble
                    : (isDark
                        ? AppColors.darkCard
                        : AppColors.aiBubbleLight),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(r.r(18)),
                  topRight: Radius.circular(r.r(18)),
                  bottomLeft: Radius.circular(isUser ? r.r(18) : r.r(4)),
                  bottomRight: Radius.circular(isUser ? r.r(4) : r.r(18)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: r.sp(15),
                      color: isUser
                          ? AppColors.userBubbleText
                          : (isDark
                              ? AppColors.aiBubbleTextDark
                              : AppColors.aiBubbleTextLight),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: r.h(4)),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: r.sp(11),
                      color: isUser
                          ? Colors.white70
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: r.w(8)),
            CircleAvatar(
              radius: r.w(16),
              backgroundColor: AppColors.primaryBlue,
              child: Icon(
                Icons.person,
                size: r.icon(18),
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$hour12:$minute $period';
  }
}
