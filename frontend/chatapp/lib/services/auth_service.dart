import 'dart:async';

import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  final Dio _githubDio = Dio(
    BaseOptions(
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // NORMAL SIGNUP
  Future<Map<String, dynamic>> normalSignup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiService.dio.post(
      '/auth/signup',
      data: {'name': name, 'email': email, 'password': password},
    );

    return Map<String, dynamic>.from(response.data);
  }

  // NORMAL LOGIN
  Future<Map<String, dynamic>> normalLogin({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    return Map<String, dynamic>.from(response.data);
  }

  // GOOGLE SIGNUP
  Future<Map<String, dynamic>> googleSignup({required String token}) async {
    final response = await _apiService.dio.post(
      '/auth/google/signup',
      data: {'token': token},
    );

    return Map<String, dynamic>.from(response.data);
  }

  // GOOGLE LOGIN
  Future<Map<String, dynamic>> googleLogin({required String token}) async {
    final response = await _apiService.dio.post(
      '/auth/google/login',
      data: {'token': token},
    );

    return Map<String, dynamic>.from(response.data);
  }

  // GITHUB: REQUEST DEVICE CODE
  Future<Map<String, dynamic>> requestGithubDeviceCode() async {
    final response = await _githubDio.post(
      'https://github.com/login/device/code',
      data: {
        'client_id': ApiConfig.githubClientId,
        'scope': 'read:user user:email',
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  // GITHUB: WAIT FOR USER AUTHORIZATION AND GET ACCESS TOKEN
  Future<String> pollGithubAccessToken({
    required String deviceCode,
    required int interval,
    required int expiresIn,
  }) async {
    var pollingInterval = interval;
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));

    while (DateTime.now().isBefore(expiryTime)) {
      await Future.delayed(Duration(seconds: pollingInterval));

      if (!DateTime.now().isBefore(expiryTime)) {
        break;
      }

      final response = await _githubDio.post(
        'https://github.com/login/oauth/access_token',
        data: {
          'client_id': ApiConfig.githubClientId,
          'device_code': deviceCode,
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
        },
      );

      final data = Map<String, dynamic>.from(response.data);

      if (data['access_token'] != null) {
        return data['access_token'].toString();
      }

      final error = data['error'];

      if (error == 'authorization_pending') {
        continue;
      }

      if (error == 'slow_down') {
        pollingInterval += 5;
        continue;
      }

      if (error == 'access_denied') {
        throw Exception('GitHub authorization was denied.');
      }

      if (error == 'expired_token' || error == 'token_expired') {
        throw Exception('GitHub device code expired. Try again.');
      }

      throw Exception(
        data['error_description']?.toString() ??
            'GitHub authentication failed.',
      );
    }

    throw Exception('GitHub device code expired. Try again.');
  }

  // GITHUB SIGNUP
  Future<Map<String, dynamic>> githubSignup({required String token}) async {
    final response = await _apiService.dio.post(
      '/auth/github/signup',
      data: {'token': token},
    );

    return Map<String, dynamic>.from(response.data);
  }

  // GITHUB LOGIN
  Future<Map<String, dynamic>> githubLogin({required String token}) async {
    final response = await _apiService.dio.post(
      '/auth/github/login',
      data: {'token': token},
    );

    return Map<String, dynamic>.from(response.data);
  }

  // LOGOUT
  Future<Map<String, dynamic>> logout() async {
    final response = await _apiService.dio.post('/auth/logout');

    return Map<String, dynamic>.from(response.data);
  }
}

