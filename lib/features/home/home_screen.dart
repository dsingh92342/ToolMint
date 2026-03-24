import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/features/cloud_notes/notes_screen.dart';
import 'package:toolmint/features/password_gen/password_gen_screen.dart';
import 'package:toolmint/features/qr_gen/qr_gen_screen.dart';
import 'package:toolmint/features/unit_converter/unit_converter_screen.dart';
import 'package:toolmint/shared/widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              Color(0xFF1E293B),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              _buildToolGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ToolMint',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    letterSpacing: -1,
                  ),
            ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
            const SizedBox(height: 8),
            Text(
              'Your daily essentials, all in one place.',
              style: Theme.of(context).textTheme.bodyLarge,
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildToolGrid(BuildContext context) {
    final tools = [
      _ToolData(
        title: 'Passwords',
        subtitle: 'Secure & Random',
        icon: FontAwesomeIcons.key,
        color: const Color(0xFF00D2FF),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PasswordGenScreen()),
          );
        },
      ),
      _ToolData(
        title: 'Converter',
        subtitle: 'Unit Conversion',
        icon: FontAwesomeIcons.rightLeft,
        color: const Color(0xFFC471ED),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UnitConverterScreen()),
          );
        },
      ),
      _ToolData(
        title: 'QR Code',
        subtitle: 'Generate & Share',
        icon: FontAwesomeIcons.qrcode,
        color: const Color(0xFF00FFC2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRGenScreen()),
          );
        },
      ),
      _ToolData(
        title: 'Cloud Notes',
        subtitle: 'Securely Synced',
        icon: FontAwesomeIcons.noteSticky,
        color: const Color(0xFFFF9A8B),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotesScreen()),
          );
        },
      ),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final tool = tools[index];
            return _ToolCard(tool: tool)
                .animate()
                .fadeIn(delay: (200 + index * 100).ms, duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8));
          },
          childCount: tools.length,
        ),
      ),
    );
  }
}

class _ToolData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _ToolData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _ToolCard extends StatelessWidget {
  final _ToolData tool;

  const _ToolCard({required this.tool});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: tool.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tool.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              tool.icon,
              color: tool.color,
              size: 28,
            ),
          ),
          const Spacer(),
          Text(
            tool.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            tool.subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                ),
          ),
        ],
      ),
    );
  }
}
