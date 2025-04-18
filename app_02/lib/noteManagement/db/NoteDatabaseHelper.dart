
import "../model/Note.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDatabaseHelper {
  static final NoteDatabaseHelper instance = NoteDatabaseHelper._init();
  final supabase = Supabase.instance.client;

  NoteDatabaseHelper._init();


  // --- Các phương thức CRUD  ---

  // Create - Thêm notes mới
  Future<Note?> insertNote(Note note) async {
    final response = await supabase.from('notes').insert(note.toMap()).select().single();
    return Note.fromMap(response);
  }
  // Read all
  Future<List<Note>> getAllNotes() async {
    final data = await supabase.from('notes').select().order('created_at', ascending: false);
    print(">>> getAllNotes() trả về ${data.length} ghi chú");
    return data.map<Note>((item) => Note.fromMap(item)).toList();
  }

  // Read by ID
  Future<Note?> getNoteById(int id) async {
    final data = await supabase.from('notes').select().eq('id', id).maybeSingle();
    return data != null ? Note.fromMap(data) : null;
  }

  // Update
  Future<Note?> updateNote(Note note) async {
    final response = await supabase
        .from('notes')
        .update(note.toMap())
        .eq('id', note.id!)
        .select()
        .single();
    return Note.fromMap(response);
  }

  // Delete
  Future<bool> deleteNote(int id) async {
    await supabase.from('notes').delete().eq('id', id);
    return true;
  }
  // Read - Lấy ghi chú theo mức độ ưu tiên
  Future<List<Note>> getNotesByPriority(int? priority) async {
    // Nếu priority là null, trả về tất cả ghi chú
    if (priority == null) {
      final data = await supabase.from('notes').select();
      return data.map<Note>((item) => Note.fromMap(item)).toList();
    } else {
      final data = await supabase.from('notes').select().eq('priority', priority);
      return data.map<Note>((item) => Note.fromMap(item)).toList();
    }
  }


  // Search by keyword
  Future<List<Note>> searchNotes(String query) async {
    if (query.trim().isEmpty) {
      // Nếu query rỗng thì trả về tất cả ghi chú
      return getAllNotes();
    }

    final data = await supabase
        .from('notes')
        .select()
        .or('title.ilike.%$query%,content.ilike.%$query%');
    return data.map<Note>((item) => Note.fromMap(item)).toList();
  }


  Future<int> countNotes() async {
    final notes = await getAllNotes();
    return notes.length;
  }

}
