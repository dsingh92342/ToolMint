import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/features/pdf_studio/pdf_studio_provider.dart';
import 'package:toolmint/shared/widgets/glass_card.dart';
import 'package:toolmint/shared/widgets/premium_background.dart';

class PDFStudioScreen extends ConsumerWidget {
  const PDFStudioScreen({super.key});

  Future<void> _pickImages(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      ref.read(pdfStudioProvider.notifier).addFiles(
            result.files.where((f) => f.path != null).map((f) => File(f.path!)).toList(),
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pdfStudioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Studio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PremiumBackground(
        child: Column(
          children: [
            Expanded(
              child: state.selectedFiles.isEmpty
                  ? _buildEmptyState(context, ref)
                  : _buildFileList(context, state, ref),
            ),
            if (state.selectedFiles.isNotEmpty) _buildBottomActions(context, state, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(40),
        onTap: () => _pickImages(ref),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf_outlined, size: 80, color: Colors.white24),
            const SizedBox(height: 24),
            const Text(
              'Select images to convert to PDF',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _pickImages(ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('CHOOSE IMAGES'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(BuildContext context, PDFStudioState state, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: state.selectedFiles.length,
      itemBuilder: (context, index) {
        final file = state.selectedFiles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(file, width: 50, height: 50, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    file.path.split('/').last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.white24),
                  onPressed: () => ref.read(pdfStudioProvider.notifier).removeFile(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context, PDFStudioState state, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${state.selectedFiles.length} files selected', style: const TextStyle(color: Colors.white54)),
              TextButton(
                onPressed: () => _pickImages(ref),
                child: const Text('Add More', style: TextStyle(color: AppTheme.primaryColor)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: state.isProcessing ? null : () => ref.read(pdfStudioProvider.notifier).createPDFFromImages(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: state.isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('GENERATE PDF', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          if (state.resultFile != null) ...[
            const SizedBox(height: 12),
            Text(
              'PDF Created Successfully!',
              style: TextStyle(color: AppTheme.accentColor, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
