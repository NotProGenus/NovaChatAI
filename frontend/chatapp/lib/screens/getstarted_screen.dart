import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:chatapp/screens/signup_screen.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:chatapp/main.dart';

import '../utils/responsive.dart';
import '../services/auth_service.dart';

class GetstartedScreen extends StatefulWidget {
  const GetstartedScreen({super.key});

  @override
  State<GetstartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetstartedScreen> {
  bool showEmailPassError = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();

  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty ||
        !email.contains('@') ||
        !email.contains('.') ||
        password.isEmpty) {
      setState(() {
        showEmailPassError = true;
      });
      return;
    }

    setState(() {
      showEmailPassError = false;
      isLoading = true;
    });

    try {
      final response = await authService.normalLogin(
        email: email,
        password: password,
      );

      final user = response['user'];

      final userName = user is Map
          ? user['name']?.toString() ?? email.split('@').first
          : email.split('@').first;

      await _saveTokenAndNavigate(response, userName);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? e.response?.data['detail']?.toString()
          : null;

      _showMessage(message ?? 'Login failed');
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _googleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate();

      final googleAuth = account.authentication;
      final googleIdToken = googleAuth.idToken;

      if (googleIdToken == null || googleIdToken.isEmpty) {
        throw Exception('Google ID token not received');
      }

      final response = await authService.googleLogin(token: googleIdToken);

      final user = response['user'];

      final userName = user is Map
          ? user['name']?.toString() ??
                account.displayName ??
                account.email.split('@').first
          : account.displayName ?? account.email.split('@').first;

      await _saveTokenAndNavigate(response, userName);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? e.response?.data['detail']?.toString()
          : null;

      _showMessage(message ?? 'Google login failed');
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _githubLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final deviceData = await authService.requestGithubDeviceCode();

      final deviceCode = deviceData['device_code'].toString();
      final userCode = deviceData['user_code'].toString();
      final verificationUrl = deviceData['verification_uri'].toString();

      final expiresIn = int.parse(deviceData['expires_in'].toString());
      final interval = int.parse(deviceData['interval'].toString());

      if (!mounted) return;

      final authorized = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('GitHub Verification'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Open github and enter this code:'),
                const SizedBox(height: 16),
                SelectableText(
                  userCode,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Click continue after completing github authorization.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final opened = await launchUrl(
                    Uri.parse(verificationUrl),
                    mode: LaunchMode.externalApplication,
                  );

                  if (!opened && dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('Unable to open GitHub')),
                    );
                  }
                },
                child: const Text('Open GitHub'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: const Text('Continue'),
              ),
            ],
          );
        },
      );

      if (authorized != true) return;

      final githubToken = await authService.pollGithubAccessToken(
        deviceCode: deviceCode,
        interval: interval,
        expiresIn: expiresIn,
      );

      final response = await authService.githubLogin(token: githubToken);

      final user = response['user'];

      final userName = user is Map
          ? user['name']?.toString() ?? 'User'
          : 'User';

      await _saveTokenAndNavigate(response, userName);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? e.response?.data['detail']?.toString()
          : null;

      _showMessage(message ?? 'GitHub login failed');
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _saveTokenAndNavigate(
    Map<String, dynamic> response,
    String userName,
  ) async {
    final accessToken = response['access_token_jwt'];
    final refreshToken = response['refresh_token_jwt'];

    if (accessToken == null || accessToken.toString().isEmpty) {
      throw Exception('Backend token missing');
    }

    if (refreshToken == null || refreshToken.toString().isEmpty) {
      throw Exception('Backend refresh token missing');
    }

   // Save Access Token
    await storage.write(key: 'access_token', value: accessToken.toString());

    // Save Refresh Token
    await storage.write(key: 'refresh_token', value: refreshToken.toString());

    print('ACCESS TOKEN SAVED: YES');
    print('REFRESH TOKEN SAVED: YES');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomeScreen(userName: userName, mythemeNotifier: themeNotifier),
      ),
      (route) => false,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField({
    required TextEditingController mycontroller,
    required String myhint,
    required IconData myprefixIcon,
    required double myfontSize,
    required Responsive r,
    bool myobscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? mysuffixIcon,
  }) {
    return TextField(
      controller: mycontroller,
      obscureText: myobscureText,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: myfontSize),
      decoration: InputDecoration(
        hintText: myhint,
        hintStyle: TextStyle(color: Colors.black, fontSize: myfontSize),
        prefixIcon: Icon(
          myprefixIcon,
          color: Colors.grey[500],
          size: r.icon(20),
        ),
        suffixIcon: mysuffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: r.symmetricPadding(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(12)),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(12)),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r.r(12)),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required double width,
    required double height,
    required String label,
    required double fontSize,
    required Widget icon,
    required VoidCallback onPressed,
    required Responsive r,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: icon,
        label: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.r(30)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: r.icon(20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Colors.cyan, Colors.deepPurple, Colors.pinkAccent],
            ).createShader(bounds);
          },
          child: Text(
            "NovaChat",
            style: TextStyle(
              color: Colors.white,
              fontSize: r.sp(22),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final titleSize = r.sp(28);
            final subtitleSize = r.sp(14);
            final fieldTextSize = r.sp(15);
            final buttonWidth = r.w(320);
            final buttonHeight = r.h(50);
            final buttonTextSize = r.sp(16);
            final socialButtonHeight = r.h(48);
            final orTextSize = r.sp(14);
            final bottomTextSize = r.sp(14);
            final socialIconSize = r.w(24);

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: r.symmetricPadding(horizontal: 30),
                  child: Column(
                    children: [
                      SizedBox(height: r.h(110)),
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: r.h(6)),
                      Text(
                        "Log in to continue",
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: r.h(30)),
                      if (showEmailPassError) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: r.icon(20),
                            ),
                            SizedBox(width: r.w(8)),
                            Expanded(
                              child: Text(
                                "Please enter a valid email or Password",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: r.sp(13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: r.h(12)),
                      ],
                      _buildTextField(
                        mycontroller: emailController,
                        myhint: "Email",
                        myprefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        myfontSize: fieldTextSize,
                        r: r,
                      ),
                      SizedBox(height: r.h(14)),
                      _buildTextField(
                        mycontroller: passwordController,
                        myhint: "Password",
                        myprefixIcon: Icons.lock_outline,
                        myobscureText: _obscurePassword,
                        myfontSize: fieldTextSize,
                        r: r,
                        mysuffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[500],
                            size: r.icon(20),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: r.h(16)),
                      SizedBox(
                        width: buttonWidth,
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(r.r(30)),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: buttonTextSize,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: r.h(20)),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: r.symmetricPadding(horizontal: 16),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontSize: orTextSize,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.h(20)),
                      _buildSocialButton(
                        width: buttonWidth,
                        height: socialButtonHeight,
                        label: "Continue with Google",
                        fontSize: fieldTextSize,
                        r: r,
                        icon: Image.asset(
                          "utils/Google Icon.png",
                          width: socialIconSize,
                          height: socialIconSize,
                        ),
                        onPressed: _googleLogin,
                      ),
                      SizedBox(height: r.h(12)),
                      _buildSocialButton(
                        width: buttonWidth,
                        height: socialButtonHeight,
                        label: "Continue with GitHub",
                        fontSize: fieldTextSize,
                        r: r,
                        icon: Image.asset(
                          "utils/GitHub Icon.png",
                          width: socialIconSize,
                          height: socialIconSize,
                        ),
                        onPressed: _githubLogin,
                      ),
                      SizedBox(height: r.h(30)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Do not have an Account? ",
                            style: TextStyle(
                              fontSize: bottomTextSize,
                              color: Colors.grey[600],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: bottomTextSize,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.h(24)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
