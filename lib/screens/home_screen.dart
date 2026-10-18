import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/suggestion_card.dart';
import '../widgets/history_drawer.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final ThemeNotifier mythemeNotifier;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.mythemeNotifier,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isTyping = false;

  List<ChatMessage> get _currentMessages =>
      _chatService.currentSession?.messages ?? [];

  bool get _hasMessages => _currentMessages.isNotEmpty;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _chatService.sendMessage(text.trim());
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI typing delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _chatService.generateAIResponse(text.trim());
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startNewChat() {
    setState(() {
      _chatService.createNewChat();
      _messageController.clear();
    });
  }

  void _switchToSession(String sessionId) {
    setState(() {
      _chatService.switchToSession(sessionId);
    });
    _scrollToBottom();
  }

  void _deleteSession(String sessionId) {
    setState(() {
      _chatService.deleteSession(sessionId);
    });
  }

  void _renameSession(String sessionId, String newTitle) {
    setState(() {
      _chatService.renameSession(sessionId, newTitle);
    });
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark, Responsive r) {
    return AppBar(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: isDark ? AppColors.darkText : AppColors.lightText,
          size: r.icon(24),
        ),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      centerTitle: true,
      title: ShaderMask(
        shaderCallback: (bounds) {
          return AppGradients.novaChatGradient.createShader(bounds);
        },
        child: Text(
          'NovaChat',
          style: TextStyle(
            color: Colors.white,
            fontSize: r.sp(22),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            size: r.icon(24),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings coming soon!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeView(bool isDark, Responsive r) {
    return SingleChildScrollView(
      child: Padding(
        padding: r.symmetricPadding(vertical: 40),
        child: Column(
          children: [
            // Greeting
            Text(
              'Hello!',
              style: TextStyle(
                fontSize: r.sp(32),
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            SizedBox(height: r.h(8)),
            Text(
              'How can I help you today?',
              style: TextStyle(
                fontSize: r.sp(17),
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            SizedBox(height: r.h(36)),
            // Suggestion cards
            SuggestionGrid(onSuggestionTap: (message) => _sendMessage(message)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = Responsive.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: _buildAppBar(isDark, r),
      drawer: HistoryDrawer(
        chatService: _chatService,
        currentSessionId: _chatService.currentSession?.id,
        onNewChat: _startNewChat,
        onSessionTap: _switchToSession,
        onDeleteSession: _deleteSession,
        onRenameSession: _renameSession,
        onLogout: _logout,
        isDarkMode: widget.mythemeNotifier.isDarkMode,
        onDarkModeToggle: (value) {
          widget.mythemeNotifier.setDarkMode(value);
        },
      ),
      body: Column(
        children: [
          // Chat messages or welcome view
          Expanded(
            child: _hasMessages ? _buildChatView(r) : _buildWelcomeView(isDark, r),
          ),
          // Chat input
          ChatInput(
            controller: _messageController,
            onSend: () => _sendMessage(_messageController.text),
            onMicTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice input coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatView(Responsive r) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(top: r.h(16), bottom: r.h(8)),
      itemCount: _currentMessages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _currentMessages.length) {
          return ChatBubble(message: _currentMessages[index]);
        }
        // Typing indicator
        return _buildTypingIndicator(r);
      },
    );
  }

 Widget _buildTypingIndicator(Responsive r) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: r.symmetricPadding(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Container(
            padding: r.symmetricPadding(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.aiBubbleLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(r.r(18)),
                topRight: Radius.circular(r.r(18)),
                bottomLeft: Radius.circular(r.r(4)),
                bottomRight: Radius.circular(r.r(18)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Padding(
                  padding: r.symmetricPadding(horizontal: 3),
                  child: _BouncingDot(delay: i * 200, dotSize: r.w(8)),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _BouncingDot extends StatefulWidget {
  final int delay;
  final double dotSize;
  const _BouncingDot({required this.delay, this.dotSize = 8});

  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: -6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: widget.dotSize,
            height: widget.dotSize,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
