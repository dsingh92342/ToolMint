import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PDFStudioState {
  final List<File> selectedFiles;
  final bool isProcessing;
  final File? resultFile;

  PDFStudioState({
    this.selectedFiles = const [],
    this.isProcessing = false,
    this.resultFile,
  });

  PDFStudioState copyWith({
    List<File>? selectedFiles,
    bool? isProcessing,
    File? resultFile,
  }) {
    return PDFStudioState(
      selectedFiles: selectedFiles ?? this.selectedFiles,
      isProcessing: isProcessing ?? this.isProcessing,
      resultFile: resultFile ?? this.resultFile,
    );
  }
}

class PDFStudioNotifier extends StateNotifier<PDFStudioState> {
  PDFStudioNotifier() : super(PDFStudioState());

  void addFiles(List<File> files) {
    state = state.copyWith(selectedFiles: [...state.selectedFiles, ...files]);
  }

  void removeFile(int index) {
    final newList = List<File>.from(state.selectedFiles);
    newList.removeAt(index);
    state = state.copyWith(selectedFiles: newList);
  }

  Future<void> createPDFFromImages() async {
    if (state.selectedFiles.isEmpty) return;
    state = state.copyWith(isProcessing: true);

    try {
      final pdf = pw.Document();

      for (var file in state.selectedFiles) {
        final image = pw.MemoryImage(await file.readAsBytes());
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(child: pw.Image(image));
            },
          ),
        );
      }

      final tempDir = await getTemporaryDirectory();
      final resultFile = File('${tempDir.path}/toolmint_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await resultFile.writeAsBytes(await pdf.save());

      state = state.copyWith(resultFile: resultFile, isProcessing: false);
    } catch (e) {
      state = state.copyWith(isProcessing: false);
    }
  }
}

final pdfStudioProvider = StateNotifierProvider<PDFStudioNotifier, PDFStudioState>((ref) {
  return PDFStudioNotifier();
});
