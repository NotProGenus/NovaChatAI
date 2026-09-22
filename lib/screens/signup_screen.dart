import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController mycontroller,
    required String myhint,
    required IconData myprefixIcon,
    required double myfontSize,
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
        prefixIcon: Icon(myprefixIcon, color: Colors.grey[500], size: 20),
        suffixIcon: mysuffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Colors.cyan, Colors.deepPurple, Colors.pinkAccent],
            ).createShader(bounds);
          },
          child: const Text(
            "NovaChat",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final titleSize = (width * 0.07).clamp(24.0, 32.0);
          final subtitleSize = (width * 0.035).clamp(13.0, 16.0);
          final fieldTextSize = (width * 0.038).clamp(14.0, 16.0);
          final buttonWidth = (width * 0.85).clamp(280.0, 400.0);
          final buttonHeight = (height * 0.058).clamp(46.0, 54.0);
          final buttonTextSize = (width * 0.042).clamp(15.0, 18.0);
          final socialButtonHeight = (height * 0.054).clamp(44.0, 50.0);
          final orTextSize = (width * 0.035).clamp(13.0, 15.0);
          final bottomTextSize = (width * 0.035).clamp(13.0, 15.0);

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.13),

                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: height * 0.008),

                    Text(
                      "Join NovaChat",
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: height * 0.04),

                    _buildTextField(
                      mycontroller: fullNameController,
                      myhint: "Full Name",
                      myprefixIcon: Icons.person_outline,
                      myfontSize: fieldTextSize,
                    ),

                    SizedBox(height: height * 0.018),

                    _buildTextField(
                      mycontroller: emailController,
                      myhint: "Email",
                      myprefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      myfontSize: fieldTextSize,
                    ),

                    SizedBox(height: height * 0.018),

                    _buildTextField(
                      mycontroller: passwordController,
                      myhint: "Password",
                      myprefixIcon: Icons.lock_outline,
                      myobscureText: _obscurePassword,
                      myfontSize: fieldTextSize,
                      mysuffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: height * 0.018),

                    _buildTextField(
                      mycontroller: confirmPasswordController,
                      myhint: "Confirm Password",
                      myprefixIcon: Icons.lock_outline,
                      myobscureText: _obscureConfirmPassword,
                      myfontSize: fieldTextSize,
                      mysuffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: height * 0.035),

                    SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          final email = emailController.text;

                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter your email"),
                              ),
                            );
                          } else if (!email.contains("@") ||
                              !email.contains(".")) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a valid email"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Valid email")),
                            );
                          }
                          // TODO: Implement sign up logic
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: buttonTextSize,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.025),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey[400], thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                          ),
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

                    SizedBox(height: height * 0.025),

                    _buildSocialButton(
                      width: buttonWidth,
                      height: socialButtonHeight,
                      label: "Continue with Google",
                      fontSize: fieldTextSize,
                      icon: Image.asset(
                        "utils/Google Icon.png",
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        // TODO: Implement Google sign up
                      },
                    ),

                    SizedBox(height: height * 0.015),

                    _buildSocialButton(
                      width: buttonWidth,
                      height: socialButtonHeight,
                      label: "Continue with GitHub",
                      fontSize: fieldTextSize,
                      icon: Image.asset(
                        "utils/GitHub Icon.png",
                        width: 24,
                        height: 24,
                      ),

                      onPressed: () {
                        // TODO: Implement GitHub sign up
                      },
                    ),

                    SizedBox(height: height * 0.04),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontSize: bottomTextSize,
                            color: Colors.grey[600],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
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

                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
