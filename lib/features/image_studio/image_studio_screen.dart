import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/features/image_studio/image_studio_provider.dart';
import 'package:toolmint/shared/widgets/glass_card.dart';
import 'package:toolmint/shared/widgets/premium_background.dart';

class ImageStudioScreen extends ConsumerWidget {
  const ImageStudioScreen({super.key});

  Future<void> _pickImage(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      ref.read(imageStudioProvider.notifier).setImage(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageStudioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Studio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PremiumBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildImagePreview(context, state, ref),
              const SizedBox(height: 32),
              if (state.originalImage != null) ...[
                _buildSettingsCard(context, state, ref),
                const SizedBox(height: 40),
                _buildActionButtons(context, state, ref),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, ImageStudioState state, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      onTap: state.originalImage == null ? () => _pickImage(ref) : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: state.originalImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate_outlined, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text('Tap to select an image', style: TextStyle(color: Colors.white24)),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: state.processedImage != null
                    ? Image.file(state.processedImage!, fit: BoxFit.contain)
                    : Image.file(state.originalImage!, fit: BoxFit.contain),
              ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, ImageStudioState state, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('OPTIONS', style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text('Quality'),
                   Text('${(state.quality * 100).toInt()}%', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: state.quality,
                activeColor: AppTheme.primaryColor,
                onChanged: (val) => ref.read(imageStudioProvider.notifier).setQuality(val),
              ),
              const Divider(color: Colors.white10, height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Format'),
                  Row(
                    children: ['jpg', 'png'].map((f) {
                      final isSelected = state.format == f;
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(f.toUpperCase()),
                          selected: isSelected,
                          onSelected: (_) => ref.read(imageStudioProvider.notifier).setFormat(f),
                          selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                          checkmarkColor: AppTheme.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryColor : Colors.white60,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ImageStudioState state, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: state.isProcessing ? null : () => ref.read(imageStudioProvider.notifier).processImage(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: state.isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('PROCESS IMAGE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        if (state.processedImage != null) ...[
          const SizedBox(height: 16),
          Text(
            'Success! Check your temp folder.',
            style: TextStyle(color: AppTheme.accentColor, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
