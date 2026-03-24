import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageStudioState {
  final File? originalImage;
  final File? processedImage;
  final bool isProcessing;
  final double quality;
  final int? width;
  final int? height;
  final String format;

  ImageStudioState({
    this.originalImage,
    this.processedImage,
    this.isProcessing = false,
    this.quality = 0.8,
    this.width,
    this.height,
    this.format = 'jpg',
  });

  ImageStudioState copyWith({
    File? originalImage,
    File? processedImage,
    bool? isProcessing,
    double? quality,
    int? width,
    int? height,
    String? format,
  }) {
    return ImageStudioState(
      originalImage: originalImage ?? this.originalImage,
      processedImage: processedImage ?? this.processedImage,
      isProcessing: isProcessing ?? this.isProcessing,
      quality: quality ?? this.quality,
      width: width ?? this.width,
      height: height ?? this.height,
      format: format ?? this.format,
    );
  }
}

class ImageStudioNotifier extends StateNotifier<ImageStudioState> {
  ImageStudioNotifier() : super(ImageStudioState());

  void setImage(File file) {
    state = state.copyWith(originalImage: file, processedImage: null);
  }

  void setQuality(double val) => state = state.copyWith(quality: val);
  void setFormat(String format) => state = state.copyWith(format: format);

  Future<void> processImage() async {
    if (state.originalImage == null) return;
    state = state.copyWith(isProcessing: true);

    try {
      final bytes = await state.originalImage!.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image != null) {
        // Resize if width/height is set
        if (state.width != null || state.height != null) {
          image = img.copyResize(image, width: state.width, height: state.height);
        }

        List<int> encoded;
        switch (state.format) {
          case 'png':
            encoded = img.encodePng(image);
            break;
          default:
            encoded = img.encodeJpg(image, quality: (state.quality * 100).toInt());
        }

        final tempDir = await getTemporaryDirectory();
        final resultFile = File('${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.${state.format}');
        await resultFile.writeAsBytes(encoded);
        
        state = state.copyWith(processedImage: resultFile, isProcessing: false);
      }
    } catch (e) {
      state = state.copyWith(isProcessing: false);
    }
  }
}

final imageStudioProvider = StateNotifierProvider<ImageStudioNotifier, ImageStudioState>((ref) {
  return ImageStudioNotifier();
});
