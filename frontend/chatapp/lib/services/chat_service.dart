import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../models/chat_model.dart';
import 'api_service.dart';

class ChatService {
  final ApiService _apiService = ApiService();

  final List<ChatSession> _sessions = [];
  ChatSession? _currentSession;

  List<ChatSession> get sessions => List.unmodifiable(_sessions);
  ChatSession? get currentSession => _currentSession;

  // CREATE SESSION - BACKEND
  Future<ChatSession> createSession({required String title}) async {
    final response = await _apiService.dio.post(
      '/chat/sessions/create_session',
      data: {'title': title},
    );

    final session = ChatSession.fromJson(
      Map<String, dynamic>.from(response.data),
    );

    _sessions.insert(0, session);
    _currentSession = session;

    return session;
  }

  // GET ALL SESSIONS - BACKEND
  Future<List<ChatSession>> getSessions({int page = 1, int limit = 10}) async {
    final response = await _apiService.dio.get(
      '/chat/sessions/get_sessions',
      queryParameters: {'page': page, 'limit': limit},
    );

    final List<dynamic> data = response.data;

    final sessions = data.map((item) {
      return ChatSession.fromJson(Map<String, dynamic>.from(item));
    }).toList();

    _sessions
      ..clear()
      ..addAll(sessions);

    return sessions;
  }

  // GET SINGLE SESSION - BACKEND
  Future<ChatSession> getSession({required String sessionId}) async {
    final response = await _apiService.dio.get(
      '/chat/sessions/$sessionId/get_session',
    );

    final session = ChatSession.fromJson(
      Map<String, dynamic>.from(response.data),
    );

    final index = _sessions.indexWhere((s) => s.id == sessionId);

    if (index != -1) {
      _sessions[index] = session;
    } else {
      _sessions.insert(0, session);
    }

    _currentSession = session;

    return session;
  }

  // UPDATE SESSION TITLE - BACKEND
  Future<ChatSession> updateSession({
    required String sessionId,
    required String title,
  }) async {
    final response = await _apiService.dio.put(
      '/chat/sessions/$sessionId/update_session',
      data: {'title': title},
    );

    final updatedSession = ChatSession.fromJson(
      Map<String, dynamic>.from(response.data),
    );

    final index = _sessions.indexWhere((s) => s.id == sessionId);

    if (index != -1) {
      _sessions[index].title = updatedSession.title;
    }

    if (_currentSession?.id == sessionId) {
      _currentSession!.title = updatedSession.title;
    }

    return updatedSession;
  }

  // DELETE SESSION - BACKEND
  Future<Map<String, dynamic>> deleteChatSession({
    required String sessionId,
  }) async {
    final response = await _apiService.dio.delete(
      '/chat/sessions/$sessionId/delete_session',
    );

    _sessions.removeWhere((s) => s.id == sessionId);

    if (_currentSession?.id == sessionId) {
      _currentSession = _sessions.isNotEmpty ? _sessions.first : null;
    }

    return Map<String, dynamic>.from(response.data);
  }

  // ADD USER MESSAGE - BACKEND
  Future<ChatMessage> addMessage({
    required String sessionId,
    required String content,
    String role = 'user',
  }) async {
    final response = await _apiService.dio.post(
      '/chat/sessions/$sessionId/messages',
      data: {'content': content, 'role': role},
    );

    final message = ChatMessage.fromJson(
      Map<String, dynamic>.from(response.data),
    );

    final index = _sessions.indexWhere((s) => s.id == sessionId);

    if (index != -1) {
      _sessions[index].messages.add(message);
      _sessions[index].lastMessageAt = message.timestamp;
    } else if (_currentSession?.id == sessionId) {
      _currentSession!.messages.add(message);
      _currentSession!.lastMessageAt = message.timestamp;
    }

    return message;
  }

  // GET MESSAGES - BACKEND
  Future<List<ChatMessage>> getMessages({
    required String sessionId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiService.dio.get(
      '/chat/sessions/$sessionId/messages',
      queryParameters: {'page': page, 'limit': limit},
    );

    final List<dynamic> data = response.data;

    final messages = data.map((item) {
      return ChatMessage.fromJson(Map<String, dynamic>.from(item));
    }).toList();

    final index = _sessions.indexWhere((s) => s.id == sessionId);

    if (index != -1) {
      _sessions[index].messages
        ..clear()
        ..addAll(messages);
    }

    if (_currentSession?.id == sessionId) {
      _currentSession!.messages
        ..clear()
        ..addAll(messages);
    }

    return messages;
  }

Future<Map<String, dynamic>> uploadDocument({
    required String filename,
    required Uint8List bytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      });
      print("UPLOAD HEADERS: ${_apiService.dio.options.headers}");

      final response = await _apiService.dio.post(
        '/rag/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      print('UPLOAD STATUS: ${e.response?.statusCode}');
      print('UPLOAD ERROR DETAIL: ${e.response?.data}');
      print('UPLOAD REQUEST URL: ${e.requestOptions.uri}');
      rethrow;
    }
  }

  // ASK DOCUMENT - RAG BACKEND
  Future<Map<String, dynamic>> askDocument({
    required String question,
    String? documentId,
    int k = 4,
  }) async {
    final response = await _apiService.dio.post(
      '/rag/query',
      data: {'question': question, 'document_id': documentId, 'k': k},
    );

    return Map<String, dynamic>.from(response.data);
  }

  // SWITCH SESSION - BACKEND
  Future<void> switchToSession(String sessionId) async {
    await getSession(sessionId: sessionId);
    await getMessages(sessionId: sessionId);
  }

  // SEND USER MESSAGE - BACKEND
  Future<ChatMessage> sendMessage(String text) async {
    if (_currentSession == null) {
      throw Exception('No active chat session');
    }

    return await addMessage(sessionId: _currentSession!.id, content: text);
  }

  // DUMMY AI RESPONSE - UNCHANGED
  ChatMessage generateAIResponse(String userMessage) {
    final response = _getSimulatedResponse(userMessage);

    final aiMessage = ChatMessage(text: response, isUser: false);

    _currentSession!.messages.add(aiMessage);

    return aiMessage;
  }

  // DUMMY RESPONSE GENERATOR - UNCHANGED
  String _getSimulatedResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('library') ||
        lowerMessage.contains('timings') ||
        lowerMessage.contains('timing')) {
      return '📚 Library Timings:\n\n'
          '• Monday - Friday: 8:00 AM - 10:00 PM\n'
          '• Saturday: 9:00 AM - 6:00 PM\n'
          '• Sunday: 10:00 AM - 4:00 PM\n\n'
          'The digital library is accessible 24/7 through the campus portal.';
    }

    if (lowerMessage.contains('hostel') ||
        lowerMessage.contains('facilities')) {
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

    if (lowerMessage.contains('dsa') ||
        lowerMessage.contains('data structure')) {
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

    if (lowerMessage.contains('study') ||
        lowerMessage.contains('studies') ||
        lowerMessage.contains('help') ||
        lowerMessage.contains('explain')) {
      return '📖 I can help you with your studies!\n\n'
          'Here are some ways I can assist:\n'
          '• Explain complex concepts\n'
          '• Solve doubts in any subject\n'
          '• Suggest study resources\n'
          '• Help with assignment structure\n'
          '• Provide practice questions\n\n'
          'What subject or topic would you like help with?';
    }

    if (lowerMessage.contains('placement') ||
        lowerMessage.contains('interview')) {
      return '💼 Placement Preparation:\n\n'
          '• Aptitude: Practice quantitative & logical reasoning\n'
          '• Coding: Solve 2-3 problems daily on LeetCode\n'
          '• Core subjects: Revise OS, DBMS, CN, OOPs\n'
          '• Projects: Have 2-3 solid projects ready\n'
          '• Resume: Keep it 1 page, highlight achievements\n\n'
          'Upcoming placement drive: TCS (Oct 15), Infosys (Oct 22)';
    }

    if (lowerMessage.contains('mess') ||
        lowerMessage.contains('menu') ||
        lowerMessage.contains('food')) {
      return '🍽️ Today\'s Mess Menu:\n\n'
          '🌅 Breakfast (7:30-9:00 AM):\n'
          '   Poha, Bread-Butter, Tea/Coffee\n\n'
          '🌞 Lunch (12:30-2:00 PM):\n'
          '   Dal, Rice, Roti, Mixed Veg, Salad\n\n'
          '🌙 Dinner (7:30-9:00 PM):\n'
          '   Paneer Curry, Rice, Roti, Sweet';
    }

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

    if (lowerMessage.contains('event') || lowerMessage.contains('fest')) {
      return '🎉 Upcoming Campus Events:\n\n'
          '• Oct 5 - Hackathon 2026 (CSE Dept)\n'
          '• Oct 10 - Cultural Fest "Utsav"\n'
          '• Oct 15 - Guest Lecture on AI/ML\n'
          '• Oct 20 - Sports Day\n'
          '• Oct 25 - Project Exhibition\n\n'
          'Register through the campus app!';
    }

    if (lowerMessage.contains('summarize') ||
        lowerMessage.contains('summary') ||
        lowerMessage.contains('document')) {
      return '📄 Document Summarization:\n\n'
          'I can help summarize your documents!\n\n'
          'Supported formats:\n'
          '• PDF files\n'
          '• Text documents\n'
          '• Notes & articles\n'
          '• Research papers\n\n'
          'Just paste the text you\'d like summarized, and I\'ll provide a concise overview.';
    }

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

    if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hey') ||
        lowerMessage.contains('good')) {
      final greetings = [
        'Hello! 👋 Welcome to NovaChat. How can I help you today?',
        'Hi there! 😊 I\'m your campus AI assistant. Ask me anything!',
        'Hey! 🌟 Ready to help you with campus info, studies, or anything else!',
      ];

      return greetings[Random().nextInt(greetings.length)];
    }

    final defaults = [
      '🤔 That\'s an interesting question! Let me think about it...\n\nI can help you with:\n• Campus information\n• Study assistance\n• Project ideas\n• Placement prep\n• Document summarization\n\nCould you be more specific?',
      '💬 I appreciate your question! While I\'m still learning, I can best help you with campus-related queries, studies, and project ideas. What would you like to know?',
      '🎯 Great question! I\'m here to help with campus info, academics, placements, and more. Feel free to ask about any of these topics!',
    ];

    return defaults[Random().nextInt(defaults.length)];
  }

  // FORMAT DATE
  static String formatDate(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final chatDate = DateTime(date.year, date.month, date.day);

    if (chatDate == today) return 'Today';
    if (chatDate == yesterday) return 'Yesterday';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}


