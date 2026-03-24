import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/features/cloud_notes/notes_screen.dart';
import 'package:toolmint/features/dev_tools/json_formatter_screen.dart';
import 'package:toolmint/features/image_studio/image_studio_screen.dart';
import 'package:toolmint/features/pdf_studio/pdf_studio_screen.dart';
import 'package:toolmint/features/password_gen/password_gen_screen.dart';
import 'package:toolmint/features/qr_gen/qr_gen_screen.dart';
import 'package:toolmint/features/unit_converter/unit_converter_screen.dart';
import 'package:toolmint/shared/widgets/glass_card.dart';
import 'package:toolmint/shared/widgets/premium_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Media', 'Documents', 'Security', 'Dev', 'Utils'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildHeader(context),
              _buildCategorySelector(context),
              _buildToolGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ToolMint',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        letterSpacing: -1.5,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.accentColor],
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1),
                CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  child: const Icon(Icons.person_outline, color: Colors.white70),
                ).animate().scale(delay: 400.ms),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Your digital Swiss Army knife.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white54),
            ).animate().fadeIn(delay: 200.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (val) => setState(() => _selectedCategory = category),
                selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                checkmarkColor: AppTheme.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primaryColor : Colors.white60,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: isSelected ? AppTheme.primaryColor : Colors.white10),
                ),
              ),
            ).animate().fadeIn(delay: (300 + index * 50).ms).slideX(begin: 0.2);
          },
        ),
      ),
    );
  }

  Widget _buildToolGrid(BuildContext context) {
    final allTools = [
      _ToolData(
        title: 'Image Studio',
        subtitle: 'Resize & Compress',
        icon: FontAwesomeIcons.image,
        color: const Color(0xFF00D2FF),
        category: 'Media',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ImageStudioScreen())),
      ),
      _ToolData(
        title: 'PDF Studio',
        subtitle: 'Merge & Split',
        icon: FontAwesomeIcons.filePdf,
        color: const Color(0xFFFF4B2B),
        category: 'Documents',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PDFStudioScreen())),
      ),
      _ToolData(
        title: 'Passwords',
        subtitle: 'Secure & Random',
        icon: FontAwesomeIcons.key,
        color: const Color(0xFFC471ED),
        category: 'Security',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordGenScreen())),
      ),
      _ToolData(
        title: 'Unit Converter',
        subtitle: 'Quick Conversion',
        icon: FontAwesomeIcons.rightLeft,
        color: const Color(0xFF00FFC2),
        category: 'Utils',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UnitConverterScreen())),
      ),
      _ToolData(
        title: 'QR Code',
        subtitle: 'Generate & Share',
        icon: FontAwesomeIcons.qrcode,
        color: const Color(0xFFF9D423),
        category: 'Media',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QRGenScreen())),
      ),
      _ToolData(
        title: 'Cloud Notes',
        subtitle: 'Smart Syncing',
        icon: FontAwesomeIcons.noteSticky,
        color: const Color(0xFFFF9A8B),
        category: 'Documents',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotesScreen())),
      ),
      _ToolData(
        title: 'JSON Formatter',
        subtitle: 'Format & Minify',
        icon: FontAwesomeIcons.code,
        color: const Color(0xFF6A11CB),
        category: 'Dev',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JsonFormatterScreen())),
      ),
    ];

    final filteredTools = _selectedCategory == 'All' 
        ? allTools 
        : allTools.where((t) => t.category == _selectedCategory).toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final tool = filteredTools[index];
            return _ToolCard(tool: tool)
                .animate()
                .fadeIn(delay: (200 + index * 100).ms, duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8));
          },
          childCount: filteredTools.length,
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
  final String category;
  final VoidCallback onTap;

  _ToolData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.category,
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
              color: tool.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: tool.color.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Icon(tool.icon, color: tool.color, size: 24),
          ),
          const Spacer(),
          Text(
            tool.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 4),
          Text(
            tool.subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
