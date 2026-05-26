import 'package:echo_llm/dataHandlers/firstTimeUser.dart';
import 'package:echo_llm/state_management/textfieldState.dart';
import 'package:echo_llm/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({
    super.key,
  });

  final chatController = TextEditingController();
  final bool isNewUser = isFirstTimeUser();
  Widget build(BuildContext context) {
    final textfieldState = Provider.of<Textfieldstate>(context);
    final String welcomeText =
        isNewUser ? 'Welcome to EchoLLM' : 'Welcome Back';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 30),
          Text(
            welcomeText,
            style: GoogleFonts.ubuntu(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'What would you like to know today?',
            style: GoogleFonts.ubuntu(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 18,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          if (!textfieldState.isExpanded) ...[
            Container(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureCard(
                        icon: Icons.lightbulb_outline,
                        title: 'Creative Ideas',
                        description:
                            'Brainstorm concepts and explore possibilities',
                      ),
                      const SizedBox(width: 20),
                      _buildFeatureCard(
                        icon: Icons.code,
                        title: 'Code Assistance',
                        description: 'Get help with programming problems',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureCard(
                        icon: Icons.article_outlined,
                        title: 'Content Creation',
                        description: 'Draft emails, articles, and documents',
                      ),
                      const SizedBox(width: 20),
                      _buildFeatureCard(
                        icon: Icons.search,
                        title: 'Research Help',
                        description: 'Explore topics and find information',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 50),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ChatTextField(chatController: chatController),
          ),
          const SizedBox(height: 30),
          Text(
            'Or select a chat from the sidebar to continue',
            style: GoogleFonts.ubuntu(
              color: isDark ? Colors.grey[500] : Colors.grey[500],
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (isDark ? const Color(0xFF1E2733) : const Color(0xFFF0F2F5))
              .withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF4A90E2), size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.ubuntu(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: GoogleFonts.ubuntu(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
