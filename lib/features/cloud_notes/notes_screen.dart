import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/features/cloud_notes/notes_provider.dart';
import 'package:toolmint/shared/widgets/glass_card.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final isSupabaseEnabled = ref.read(notesProvider.notifier).isSupabaseEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Notes'),
        actions: [
          _SyncStatusIcon(isEnabled: isSupabaseEnabled),
          const SizedBox(width: 16),
        ],
      ),
      body: notes.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassCard(
                    onTap: () => _viewNote(context, note),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                note.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 20),
                              onPressed: () => ref.read(notesProvider.notifier).deleteNote(note.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white60),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          DateFormat('MMM dd, yyyy • HH:mm').format(note.createdAt),
                          style: const TextStyle(fontSize: 10, color: Colors.white24),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context, ref),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined, size: 80, color: Colors.white10),
          const SizedBox(height: 16),
          Text(
            'No notes yet',
            style: TextStyle(color: Colors.white24, fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(hintText: 'Start writing...'),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                ref.read(notesProvider.notifier).addNote(
                      titleController.text,
                      contentController.text,
                    );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _viewNote(BuildContext context, dynamic note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.title, style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 24),
              Text(note.content, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncStatusIcon extends StatelessWidget {
  final bool isEnabled;
  const _SyncStatusIcon({required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isEnabled ? 'Cloud Sync Enabled' : 'Local Only (Supabase Not Set Up)',
      child: Icon(
        isEnabled ? Icons.cloud_done : Icons.cloud_off,
        color: isEnabled ? AppTheme.primaryColor : Colors.white24,
        size: 20,
      ),
    );
  }
}
