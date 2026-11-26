import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onFileTap;

  final String? attachmentName;
  final VoidCallback? onRemoveAttachment;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onFileTap,
    this.attachmentName,
    this.onRemoveAttachment,
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
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.grey[100],
            borderRadius: BorderRadius.circular(r.r(24)),
            border: Border.all(
              color: isDark ? AppColors.darkDivider : Colors.grey[300]!,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selected attachment preview
              if (attachmentName != null)
                Padding(
                  padding: r.symmetricPadding(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.picture_as_pdf_rounded,
                        color: AppColors.primaryBlue,
                        size: r.icon(25),
                      ),

                      SizedBox(width: r.w(8)),

                      Expanded(
                        child: Text(
                          attachmentName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                            fontSize: r.sp(13),
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: onRemoveAttachment,
                        icon: Icon(
                          Icons.close_rounded,
                          size: r.icon(19),
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

              // Input row
              Row(
                children: [
                  // File attachment button
                  IconButton(
                    onPressed: onFileTap,
                    icon: Icon(
                      Icons.attach_file_rounded,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      size: r.icon(23),
                    ),
                  ),

                  // Text field
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
                          horizontal: 4,
                          vertical: 12,
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

                  // Send button
                  GestureDetector(
                    onTap: _handleSend,
                    child: Container(
                      width: r.w(40),
                      height: r.w(40),
                      margin: r.symmetricPadding(horizontal: 6),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: r.icon(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



