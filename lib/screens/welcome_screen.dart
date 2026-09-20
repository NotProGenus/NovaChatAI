import 'package:chatapp/screens/getstarted_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final titleSize = (width * 0.105).clamp(34.0, 46.0);
          final subtitleSize = (width * 0.035).clamp(13.0, 16.0);
          final buttonWidth = (width * 0.50).clamp(190.0, 240.0);
          final buttonHeight = (height * 0.055).clamp(42.0, 50.0);
          final buttonTextSize = (width * 0.045).clamp(16.0, 20.0);
          final bottomTextSize = (width * 0.045).clamp(16.0, 20.0);

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Transform.translate(
                      offset: Offset(0, -constraints.maxHeight * 0.012),
                      child: Column(
                        children: [
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

                          SizedBox(height: constraints.maxHeight * 0.012),

                          Text(
                            "Your AI Assistant\nfor a Smarter Campus",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subtitleSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: constraints.maxHeight * 0.012),

                    Transform.translate(
                      offset: Offset(0, constraints.maxHeight * 0.06),
                      child: Image.asset(
                        "utils/AI BOT.png",
                        width: constraints.maxWidth * 0.43,
                      ),
                    ),

                    SizedBox(height: constraints.maxHeight * 0.16),

                    SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GetstartedScreen(),
                            ),
                          );
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
                          "Get Started",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: buttonTextSize,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: constraints.maxHeight * 0.025),

                    SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,

                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
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

                    SizedBox(height: constraints.maxHeight * 0.10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(-constraints.maxWidth * 0.05, 0),
                          child: Text(
                            "Learn",
                            style: TextStyle(
                              fontSize: bottomTextSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.09),
                        Text(
                          "Ask",
                          style: TextStyle(
                            fontSize: bottomTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.09),
                        Transform.translate(
                          offset: Offset(constraints.maxWidth * 0.05, 0),
                          child: Text(
                            "Explore",
                            style: TextStyle(
                              fontSize: bottomTextSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
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
