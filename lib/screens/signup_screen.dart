import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
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
              colors: [
                Colors.cyan,
                Colors.deepPurple,
                Colors.pinkAccent,
              ],
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

                    // Title
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: height * 0.008),

                    // Subtitle
                    Text(
                      "Join NovaChat",
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: height * 0.04),

                    // Full Name Field
                    _buildTextField(
                      controller: _fullNameController,
                      hintText: "Full Name",
                      prefixIcon: Icons.person_outline,
                      fontSize: fieldTextSize,
                    ),

                    SizedBox(height: height * 0.018),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      hintText: "Email",
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      fontSize: fieldTextSize,
                    ),

                    SizedBox(height: height * 0.018),

                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      fontSize: fieldTextSize,
                      suffixIcon: IconButton(
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

                    // Confirm Password Field
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword,
                      fontSize: fieldTextSize,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: height * 0.035),

                    // Sign Up Button
                    SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
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

                    // OR Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                          ),
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
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.025),

                    // Continue with Google
                    _buildSocialButton(
                      width: buttonWidth,
                      height: socialButtonHeight,
                      label: "Continue with Google",
                      fontSize: fieldTextSize,
                      icon: _buildGoogleIcon(),
                      onPressed: () {
                        // TODO: Implement Google sign up
                      },
                    ),

                    SizedBox(height: height * 0.015),

                    // Continue with GitHub
                    _buildSocialButton(
                      width: buttonWidth,
                      height: socialButtonHeight,
                      label: "Continue with GitHub",
                      fontSize: fieldTextSize,
                      icon: const Icon(
                        Icons.code,
                        color: Colors.black87,
                        size: 22,
                      ),
                      onPressed: () {
                        // TODO: Implement GitHub sign up
                      },
                    ),

                    SizedBox(height: height * 0.04),

                    // Already have an account? Sign In
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required double fontSize,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: fontSize,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.grey[500],
          size: 20,
        ),
        suffixIcon: suffixIcon,
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

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = w * 0.45;

    // Blue arc (top-right)
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -0.8,
      1.5,
      false,
      bluePaint,
    );

    // Green arc (bottom-right)
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      0.7,
      1.2,
      false,
      greenPaint,
    );

    // Yellow arc (bottom-left)
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      1.9,
      1.0,
      false,
      yellowPaint,
    );

    // Red arc (top-left)
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.18
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      2.9,
      1.3,
      false,
      redPaint,
    );

    // Blue horizontal bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(cx - w * 0.02, cy - h * 0.09, w * 0.52, h * 0.18),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
