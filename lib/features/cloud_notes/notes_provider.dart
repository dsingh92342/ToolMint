import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toolmint/core/supabase_config.dart';
import 'package:toolmint/features/cloud_notes/note_model.dart';
import 'package:uuid/uuid.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  final _uuid = const Uuid();

  bool get isSupabaseEnabled =>
      SupabaseConfig.url != 'YOUR_SUPABASE_URL' &&
      SupabaseConfig.anonKey != 'YOUR_SUPABASE_ANON_KEY';

  Future<void> fetchNotes() async {
    if (isSupabaseEnabled) {
      try {
        final response = await Supabase.instance.client
            .from('notes')
            .select()
            .order('created_at', ascending: false);
        state = (response as List).map((m) => Note.fromMap(m)).toList();
      } catch (e) {
        // Handle error (e.g., table doesn't exist yet)
      }
    } else {
      // Mock local data for demonstration if Supabase is not set up
      if (state.isEmpty) {
        state = [
          Note(
            id: _uuid.v4(),
            title: 'Welcome to ToolMint',
            content: 'This is a local note. Set up Supabase to sync across devices!',
            createdAt: DateTime.now(),
          ),
        ];
      }
    }
  }

  Future<void> addNote(String title, String content) async {
    final newNote = Note(
      id: _uuid.v4(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    if (isSupabaseEnabled) {
      try {
        await Supabase.instance.client.from('notes').insert(newNote.toMap());
        state = [newNote.copyWith(isSynced: true), ...state];
      } catch (e) {
        state = [newNote, ...state];
      }
    } else {
      state = [newNote, ...state];
    }
  }

  Future<void> deleteNote(String id) async {
    if (isSupabaseEnabled) {
      try {
        await Supabase.instance.client.from('notes').delete().match({'id': id});
      } catch (e) {
        // Handle error
      }
    }
    state = state.where((n) => n.id != id).toList();
  }
}

extension NoteExtension on Note {
  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    bool? isSynced,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier()..fetchNotes();
});
