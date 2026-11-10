import 'package:chatapp/screens/getstarted_screen.dart';
import 'package:chatapp/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final titleSize = r.sp(38);
            final subtitleSize = r.sp(14);
            final buttonWidth = r.w(200);
            final buttonHeight = r.h(48);
            final buttonTextSize = r.sp(17);
            final bottomTextSize = r.sp(17);

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: r.symmetricPadding(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: r.h(100)),

                        // Title
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [
                                Colors.cyan,
                                Colors.deepPurple,
                                Colors.pinkAccent,
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            "NovaChat",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: r.h(10)),

                        Text(
                          "Your AI Assistant\nfor a Smarter Campus",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: subtitleSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: r.h(20)),

                        // Bot image — constrained to available space
                        Image.asset(
                          "utils/AI BOT.png",
                          width: r.w(160),
                          height: r.h(200),
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: r.h(50)),

                        // Get Started button
                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const GetstartedScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(r.r(30)),
                              ),
                            ),
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: buttonTextSize,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: r.h(18)),

                        // Sign Up button
                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SignupScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(r.r(30)),
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

                        SizedBox(height: r.h(60)),

                        // Bottom tagline row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Learn",
                              style: TextStyle(
                                fontSize: bottomTextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Ask",
                              style: TextStyle(
                                fontSize: bottomTextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Explore",
                              style: TextStyle(
                                fontSize: bottomTextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: r.h(30)),
                      ],
                    ),
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
