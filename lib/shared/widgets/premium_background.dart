import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:toolmint/core/theme.dart';

class PremiumBackground extends StatefulWidget {
  final Widget child;
  const PremiumBackground({super.key, required this.child});

  @override
  State<PremiumBackground> createState() => _PremiumBackgroundState();
}

class _PremiumBackgroundState extends State<PremiumBackground> with TickerProviderStateMixin {
  late MeshGradientController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MeshGradientController(
      points: [
        MeshGradientPoint(
          position: const Offset(0.2, 0.2),
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
        ),
        MeshGradientPoint(
          position: const Offset(0.8, 0.2),
          color: AppTheme.secondaryColor.withValues(alpha: 0.3),
        ),
        MeshGradientPoint(
          position: const Offset(0.5, 0.8),
          color: const Color(0xFFC471ED).withValues(alpha: 0.3),
        ),
        MeshGradientPoint(
          position: const Offset(0.1, 0.9),
          color: AppTheme.accentColor.withValues(alpha: 0.2),
        ),
      ],
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MeshGradient(
            controller: _controller,
            options: MeshGradientOptions(
              blend: 3,
              noiseIntensity: 0.05,
            ),
          ),
        ),
        Container(
          color: AppTheme.backgroundColor.withValues(alpha: 0.6),
        ),
        widget.child,
      ],
    );
  }
}
