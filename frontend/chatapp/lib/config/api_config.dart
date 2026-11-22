import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? '';
  }

  static String get githubClientId {
    return dotenv.env['GITHUB_CLIENT_ID'] ?? '';
  }
}
