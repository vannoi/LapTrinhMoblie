import "dart:io";
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "../model/Note.dart";
import "../db/NoteDatabaseHelper.dart";

import "../view/NoteForm.dart";// Import NoteForm mới

class NoteDetailScreen extends StatefulWidget {
  final Note? note; // Dữ liệu ban đầu (null nếu tạo mới)

  const NoteDetailScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  // Key cho Form, được quản lý bởi màn hình này
  final _formKey = GlobalKey<FormState>();
  final NoteDatabaseHelper dbHelper = NoteDatabaseHelper.instance;


  // Controllers cho các trường text, quản lý bởi màn hình này
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;

  // Các biến trạng thái khác, quản lý bởi màn hình này
  int _selectedPriority = 2;
  String? _selectedColor;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controllers
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _selectedPriority = widget.note?.priority ?? 2;
    _tagsController = TextEditingController(text: widget.note?.tags?.join(',') ?? '');
    _selectedColor = widget.note?.color;
  }

  @override
  void dispose() {
    // Dispose controllers khi màn hình bị hủy
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  // --- Logic xử lý lưu trữ và xóa vẫn nằm ở đây ---
  Future<void> _saveNote() async {
    // Sử dụng _formKey để validate Form bên trong NoteForm
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final tagsList = _tagsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();

      // Tạo đối tượng Note từ giá trị controllers và state
      final noteToSave = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        priority: _selectedPriority, // Lấy từ state
        created_at: widget.note?.created_at ?? now,
        modified_at: now,
        tags: tagsList.isNotEmpty ? tagsList : null,
        color: _selectedColor, // Lấy từ state
      );

      // Logic gọi DB Helper để lưu (giống như trước)
      bool success = false;
      String successMessage = '';
      String errorMessage = '';
      try {
        if (_isEditing) {
          final updatedRows = await dbHelper.updateNote(noteToSave);
          success = updatedRows != null;
          successMessage = 'Cập nhật ghi chú thành công!';
          errorMessage = 'Không thể cập nhật ghi chú.';
        } else {
          final insertedId = await dbHelper.insertNote(noteToSave);
          success = insertedId != null;
          successMessage = 'Tạo ghi chú thành công!';
          errorMessage = 'Không thể tạo ghi chú.';
        }
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(successMessage), duration: const Duration(seconds: 1), backgroundColor: Colors.green.shade600), );
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(errorMessage), backgroundColor: Colors.orange.shade800), );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Lỗi khi lưu ghi chú: $e'), backgroundColor: Colors.red.shade700), );
      }
    }
  }

  // Logic xóa (giữ nguyên)
  Future<void> _deleteNote() async {
    if (!mounted || widget.note == null || widget.note!.id == null) {
      debugPrint("Lỗi: Note hoặc ID bị null");
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Không đóng khi nhấn bên ngoài
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn xóa ghi chú này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );

    // Nếu người dùng xác nhận xóa
    if (confirm == true) {
      try {
        debugPrint("Đang xóa note ID: ${widget.note!.id}");
        await dbHelper.deleteNote(widget.note!.id!);

        // Hiển thị SnackBar thông báo thành công
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ghi chú đã được xóa thành công")),
          );
        }

        // Quay lại màn hình trước đó và yêu cầu refresh
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        debugPrint("Lỗi khi xóa: $e");

        // Hiển thị lỗi nếu có vấn đề khi xóa
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi khi xóa ghi chú")),
          );
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar vẫn được quản lý bởi màn hình này
      appBar: AppBar(
        title: Text(_isEditing ? 'Chi tiết Ghi chú' : 'Tạo Ghi chú mới'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.0), // Tăng khoảng cách lề phải
            child: IconButton(
              icon: const Icon(Icons.save_alt_outlined),
              tooltip: 'Lưu',
              onPressed: _saveNote,
            ),
          ),
          if (_isEditing) // Nút xóa chỉ hiển thị khi sửa
            IconButton(
              icon: const Icon(Icons.delete_outline_outlined, color: Colors.red,),
              tooltip: 'Xóa',
              onPressed: _deleteNote, // Gọi hàm xóa của màn hình này
            ),
        ],
      ),
      // Body giờ chỉ chứa NoteForm
      body: NoteForm(
        formKey: _formKey, // Truyền key vào NoteForm
        titleController: _titleController, // Truyền controller vào
        contentController: _contentController, // Truyền controller vào
        tagsController: _tagsController, // Truyền controller vào
        selectedPriority: _selectedPriority, // Truyền giá trị state
        selectedColor: _selectedColor, // Truyền giá trị state
        initialNote: widget.note, // Truyền note ban đầu nếu đang sửa
        // Callback để cập nhật state của màn hình khi giá trị trong form thay đổi
        onPriorityChanged: (value) {
          if (value != null) {
            setState(() { _selectedPriority = value; });
          }
        },
        onColorChanged: (value) {
          setState(() { _selectedColor = value; });
        },
      ),
    );
  }
}