import 'dart:math';
import '../models/chat_model.dart';

class ChatService {
  final List<ChatSession> _sessions = [];
  ChatSession? _currentSession;

  List<ChatSession> get sessions => List.unmodifiable(_sessions);
  ChatSession? get currentSession => _currentSession;

  // Create a new chat session
  ChatSession createNewChat() {
    final session = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Chat',
    );
    _sessions.insert(0, session);
    _currentSession = session;
    return session;
  }

  // Switch to an existing session
  void switchToSession(String sessionId) {
    _currentSession = _sessions.firstWhere((s) => s.id == sessionId);
  }

  // Delete a session
  void deleteSession(String sessionId) {
    _sessions.removeWhere((s) => s.id == sessionId);
    if (_currentSession?.id == sessionId) {
      _currentSession = _sessions.isNotEmpty ? _sessions.first : null;
    }
  }

  // Rename a session
  void renameSession(String sessionId, String newTitle) {
    final session = _sessions.firstWhere((s) => s.id == sessionId);
    session.title = newTitle;
  }

  // Send a message and get AI response
  ChatMessage sendMessage(String text) {
    if (_currentSession == null) {
      createNewChat();
    }

    final userMessage = ChatMessage(text: text, isUser: true);
    _currentSession!.messages.add(userMessage);
    _currentSession!.lastMessageAt = DateTime.now();

    // Auto-title the chat based on first message
    if (_currentSession!.messages.where((m) => m.isUser).length == 1) {
      _currentSession!.title = text.length > 30 ? '${text.substring(0, 30)}...' : text;
    }

    return userMessage;
  }

  // Generate a simulated AI response
  ChatMessage generateAIResponse(String userMessage) {
    final response = _getSimulatedResponse(userMessage);
    final aiMessage = ChatMessage(text: response, isUser: false);
    _currentSession!.messages.add(aiMessage);
    return aiMessage;
  }

  String _getSimulatedResponse(String message) {
    final lowerMessage = message.toLowerCase();

    // Campus info responses
    if (lowerMessage.contains('library') || lowerMessage.contains('timings') || lowerMessage.contains('timing')) {
      return '📚 Library Timings:\n\n'
          '• Monday - Friday: 8:00 AM - 10:00 PM\n'
          '• Saturday: 9:00 AM - 6:00 PM\n'
          '• Sunday: 10:00 AM - 4:00 PM\n\n'
          'The digital library is accessible 24/7 through the campus portal.';
    }

    if (lowerMessage.contains('hostel') || lowerMessage.contains('facilities')) {
      return '🏠 Hostel Facilities:\n\n'
          '• Wi-Fi available in all rooms\n'
          '• Common room with TV and indoor games\n'
          '• Laundry service: Mon, Wed, Fri\n'
          '• Hot water: 6-8 AM & 6-9 PM\n'
          '• 24/7 security with CCTV surveillance\n\n'
          'For maintenance requests, contact the hostel warden.';
    }

    if (lowerMessage.contains('campus') || lowerMessage.contains('info')) {
      return '🏫 Campus Information:\n\n'
          '• Main gate opens at 6:00 AM\n'
          '• Cafeteria: 7:30 AM - 9:30 PM\n'
          '• Medical center: 9:00 AM - 5:00 PM\n'
          '• Sports complex: 5:00 PM - 8:00 PM\n'
          '• Wi-Fi available campus-wide\n\n'
          'Need specific info? Just ask!';
    }

    // Study help responses
    if (lowerMessage.contains('dsa') || lowerMessage.contains('data structure')) {
      return '💻 Data Structures & Algorithms:\n\n'
          'Key topics to focus on:\n'
          '1. Arrays & Strings\n'
          '2. Linked Lists\n'
          '3. Stacks & Queues\n'
          '4. Trees & Graphs\n'
          '5. Dynamic Programming\n'
          '6. Sorting & Searching\n\n'
          'Tip: Practice on LeetCode & GeeksforGeeks daily!';
    }

    if (lowerMessage.contains('study') || lowerMessage.contains('studies') ||
        lowerMessage.contains('help') || lowerMessage.contains('explain')) {
      return '📖 I can help you with your studies!\n\n'
          'Here are some ways I can assist:\n'
          '• Explain complex concepts\n'
          '• Solve doubts in any subject\n'
          '• Suggest study resources\n'
          '• Help with assignment structure\n'
          '• Provide practice questions\n\n'
          'What subject or topic would you like help with?';
    }

    // Placement responses
    if (lowerMessage.contains('placement') || lowerMessage.contains('interview')) {
      return '💼 Placement Preparation:\n\n'
          '• Aptitude: Practice quantitative & logical reasoning\n'
          '• Coding: Solve 2-3 problems daily on LeetCode\n'
          '• Core subjects: Revise OS, DBMS, CN, OOPs\n'
          '• Projects: Have 2-3 solid projects ready\n'
          '• Resume: Keep it 1 page, highlight achievements\n\n'
          'Upcoming placement drive: TCS (Oct 15), Infosys (Oct 22)';
    }

    // Mess menu
    if (lowerMessage.contains('mess') || lowerMessage.contains('menu') || lowerMessage.contains('food')) {
      return '🍽️ Today\'s Mess Menu:\n\n'
          '🌅 Breakfast (7:30-9:00 AM):\n'
          '   Poha, Bread-Butter, Tea/Coffee\n\n'
          '🌞 Lunch (12:30-2:00 PM):\n'
          '   Dal, Rice, Roti, Mixed Veg, Salad\n\n'
          '🌙 Dinner (7:30-9:00 PM):\n'
          '   Paneer Curry, Rice, Roti, Sweet';
    }

    // Project ideas
    if (lowerMessage.contains('project') || lowerMessage.contains('idea')) {
      return '💡 Project Ideas:\n\n'
          '1. 🤖 AI Chatbot for Campus (like this one!)\n'
          '2. 📱 Student Attendance App with QR\n'
          '3. 🌐 E-Commerce Platform\n'
          '4. 📊 Data Analytics Dashboard\n'
          '5. 🎮 Multiplayer Quiz Game\n'
          '6. 🏥 Health Monitoring System\n\n'
          'Want detailed info on any of these?';
    }

    // Events
    if (lowerMessage.contains('event') || lowerMessage.contains('fest')) {
      return '🎉 Upcoming Campus Events:\n\n'
          '• Oct 5 - Hackathon 2026 (CSE Dept)\n'
          '• Oct 10 - Cultural Fest "Utsav"\n'
          '• Oct 15 - Guest Lecture on AI/ML\n'
          '• Oct 20 - Sports Day\n'
          '• Oct 25 - Project Exhibition\n\n'
          'Register through the campus app!';
    }

    // Summarize
    if (lowerMessage.contains('summarize') || lowerMessage.contains('summary') || lowerMessage.contains('document')) {
      return '📄 Document Summarization:\n\n'
          'I can help summarize your documents!\n\n'
          'Supported formats:\n'
          '• PDF files\n'
          '• Text documents\n'
          '• Notes & articles\n'
          '• Research papers\n\n'
          'Just paste the text you\'d like summarized, and I\'ll provide a concise overview.';
    }

    // RAG
    if (lowerMessage.contains('rag') || lowerMessage.contains('retrieval')) {
      return '🔍 RAG (Retrieval Augmented Generation):\n\n'
          'RAG is a technique that combines:\n\n'
          '1. **Retrieval**: Fetching relevant documents from a knowledge base\n'
          '2. **Augmentation**: Adding retrieved context to the prompt\n'
          '3. **Generation**: LLM generates answers using the context\n\n'
          'Benefits:\n'
          '• More accurate responses\n'
          '• Reduces hallucination\n'
          '• Uses up-to-date information\n\n'
          'It\'s widely used in enterprise chatbots!';
    }

    // Greetings
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi') ||
        lowerMessage.contains('hey') || lowerMessage.contains('good')) {
      final greetings = [
        'Hello! 👋 Welcome to NovaChat. How can I help you today?',
        'Hi there! 😊 I\'m your campus AI assistant. Ask me anything!',
        'Hey! 🌟 Ready to help you with campus info, studies, or anything else!',
      ];
      return greetings[Random().nextInt(greetings.length)];
    }

    // Default responses
    final defaults = [
      '🤔 That\'s an interesting question! Let me think about it...\n\nI can help you with:\n• Campus information\n• Study assistance\n• Project ideas\n• Placement prep\n• Document summarization\n\nCould you be more specific?',
      '💬 I appreciate your question! While I\'m still learning, I can best help with campus-related queries, studies, and project ideas. What would you like to know?',
      '🎯 Great question! I\'m here to help with campus info, academics, placements, and more. Feel free to ask about any of these topics!',
    ];
    return defaults[Random().nextInt(defaults.length)];
  }

  // Get formatted date string for chat history
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final chatDate = DateTime(date.year, date.month, date.day);

    if (chatDate == today) return 'Today';
    if (chatDate == yesterday) return 'Yesterday';

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
