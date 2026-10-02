import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';
import '../utils/constants.dart';

class HistoryDrawer extends StatelessWidget {
  final ChatService chatService;
  final VoidCallback onNewChat;
  final void Function(String sessionId) onSessionTap;
  final void Function(String sessionId) onDeleteSession;
  final void Function(String sessionId, String newTitle) onRenameSession;
  final VoidCallback onLogout;
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeToggle;
  final String? currentSessionId;

  const HistoryDrawer({
    super.key,
    required this.chatService,
    required this.onNewChat,
    required this.onSessionTap,
    required this.onDeleteSession,
    required this.onRenameSession,
    required this.onLogout,
    required this.isDarkMode,
    required this.onDarkModeToggle,
    this.currentSessionId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sessions = chatService.sessions;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return AppGradients.novaChatGradient.createShader(bounds);
                    },
                    child: const Text(
                      'NovaChat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // New Chat button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onNewChat();
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text(
                    'New Chat',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    side: const BorderSide(color: AppColors.primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Previous Chats header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Previous Chats',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ),

            // Chat history list
            Expanded(
              child: sessions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No chats yet',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final isActive = session.id == currentSessionId;
                        return _ChatHistoryTile(
                          session: session,
                          isActive: isActive,
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(context);
                            onSessionTap(session.id);
                          },
                          onDelete: () => onDeleteSession(session.id),
                          onRename: (newTitle) =>
                              onRenameSession(session.id, newTitle),
                        );
                      },
                    ),
            ),

            // Bottom section
            Divider(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),

            // Settings
            ListTile(
              leading: Icon(
                Icons.settings_outlined,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontSize: 15,
                ),
              ),
              dense: true,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings coming soon!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            // Dark Mode toggle
            ListTile(
              leading: Icon(
                Icons.dark_mode_outlined,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontSize: 15,
                ),
              ),
              dense: true,
              trailing: Switch(
                value: isDarkMode,
                onChanged: onDarkModeToggle,
                activeThumbColor: AppColors.primaryBlue,
              ),
            ),

            // Logout
            ListTile(
              leading: Icon(
                Icons.logout_outlined,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontSize: 15,
                ),
              ),
              dense: true,
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ChatHistoryTile extends StatelessWidget {
  final ChatSession session;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final void Function(String newTitle) onRename;

  const _ChatHistoryTile({
    required this.session,
    required this.isActive,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark
                ? AppColors.primaryBlueDark.withValues(alpha: 0.2)
                : AppColors.primaryBlue.withValues(alpha: 0.08))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.chat_bubble_outline,
          size: 20,
          color: isActive
              ? AppColors.primaryBlue
              : (isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary),
        ),
        title: Text(
          session.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        subtitle: Text(
          ChatService.formatDate(session.lastMessageAt),
          style: TextStyle(
            fontSize: 11,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            size: 18,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            } else if (value == 'rename') {
              _showRenameDialog(context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'rename',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Rename'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: session.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Chat'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter new name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                onRename(newTitle);
                Navigator.pop(context);
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}
