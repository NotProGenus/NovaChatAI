import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';

class ApiService {
  late final Dio dio;
  late final Dio _refreshDio;

  final storage = const FlutterSecureStorage();

  Future<String?>? _refreshFuture;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 120),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Separate Dio for refresh API
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 120),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'access_token');

          print("TOKEN EXISTS: ${token != null && token.isNotEmpty}");

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print("AUTH HEADER ATTACHED: YES");
          } else {
            print("AUTH HEADER ATTACHED: NO");
          }

          handler.next(options);
        },

        onError: (error, handler) async {
          final options = error.requestOptions;
          final statusCode = error.response?.statusCode;
          final path = options.path;

          final isAuthEndpoint =
              path.endsWith('/auth/login') ||
              path.endsWith('/auth/signup') ||
              path.endsWith('/auth/google/login') ||
              path.endsWith('/auth/google/signup') ||
              path.endsWith('/auth/github/login') ||
              path.endsWith('/auth/github/signup') ||
              path.endsWith('/auth/refresh');

          if (statusCode != 401 ||
              options.extra['retried'] == true ||
              isAuthEndpoint) {
            return handler.next(error);
          }

          try {
            final newToken = await _refreshAccessToken();

            if (newToken == null) {
              return handler.next(error);
            }

            options.headers['Authorization'] = 'Bearer $newToken';

            options.extra['retried'] = true;

            final response = await dio.fetch(options);

            return handler.resolve(response);
          } catch (e) {
            print("REQUEST RETRY FAILED: $e");
            return handler.next(error);
          }
        },
      ),
    );
  }

  Future<String?> _refreshAccessToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    final future = _performRefresh();
    _refreshFuture = future;

    try {
      return await future;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<String?> _performRefresh() async {
    try {
      final refreshToken = await storage.read(key: 'refresh_token');

      if (refreshToken == null || refreshToken.isEmpty) {
        await storage.delete(key: 'access_token');
        return null;
      }

      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token_jwt'];

      if (newAccessToken == null || newAccessToken.toString().isEmpty) {
        throw Exception('New access token missing');
      }

      await storage.write(
        key: 'access_token',
        value: newAccessToken.toString(),
      );

      print("ACCESS TOKEN REFRESHED: YES");

      return newAccessToken.toString();
    } catch (e) {
      print("TOKEN REFRESH FAILED: $e");

      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');

      return null;
    }
  }
}


