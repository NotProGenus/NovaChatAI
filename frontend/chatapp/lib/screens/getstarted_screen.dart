import 'package:chatapp/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:chatapp/main.dart';
import '../utils/responsive.dart';

class GetstartedScreen extends StatefulWidget {
  const GetstartedScreen({super.key});

  @override
  State<GetstartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetstartedScreen> {
  bool showEmailPassError = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
        prefixIcon: Icon(myprefixIcon, color: Colors.grey[500], size: r.icon(20)),
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
        onPressed: onPressed,
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

                      // Error message - only show when needed
                      if (showEmailPassError) ...[
                        Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red, size: r.icon(20)),
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

                      // Forgot Password - properly right-aligned
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: r.sp(13),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: r.h(16)),

                      SizedBox(
                        width: buttonWidth,
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            final email = emailController.text.trim();

                            setState(() {
                              if (email.isEmpty ||
                                  !email.contains("@") ||
                                  !email.contains(".")) {
                                showEmailPassError = true;
                              } else {
                                showEmailPassError = false;
                              }
                            });

                            if (!showEmailPassError) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    userName: emailController.text
                                        .split('@')
                                        .first,
                                    mythemeNotifier: themeNotifier,
                                  ),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(r.r(30)),
                            ),
                          ),
                          child: Text(
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
                            child: Divider(color: Colors.grey[400], thickness: 1),
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
                            child: Divider(color: Colors.grey[400], thickness: 1),
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
                        onPressed: () {
                          // TODO: Implement Google sign up
                        },
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
                        onPressed: () {
                          // TODO: Implement GitHub sign up
                        },
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
                              "Sign In",
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
