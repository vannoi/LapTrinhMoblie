import 'dart:io';
import 'package:img_picker/img_picker.dart';
import 'package:flutter/material.dart';
import "../model/Note.dart";
import 'package:intl/intl.dart';

// Các hàm helper có thể để ở đây hoặc file tiện ích riêng
Color _getColorFromString(String? colorString) {
  if (colorString == null || colorString.isEmpty) return Colors.grey.shade200;
  if (colorString.startsWith('#')) { try { return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000); } catch (e) { return Colors.grey.shade200; } }
  else { switch (colorString.toLowerCase()) { case 'lightblue': return Colors.lightBlue.shade100; case '#ffcdd2': return const Color(0xFFFFCDD2); case '#fff9c4': return const Color(0xFFFFF9C4); case '#c8e6c9': return const Color(0xFFC8E6C9); case '#cfd8dc': return const Color(0xFFCFD8DC); default: return Colors.grey.shade200; } }
}
Color _getTextColor(Color backgroundColor) { return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white; }

class NoteForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController tagsController;
  final int selectedPriority;
  final String? selectedColor;
  final ValueChanged<int?> onPriorityChanged;
  final ValueChanged<String?> onColorChanged;
  final Note? initialNote; // Chỉ dùng để hiển thị ngày tạo/sửa

  const NoteForm({
    Key? key,
    required this.formKey,
    required this.titleController,
    required this.contentController,
    required this.tagsController,
    required this.selectedPriority,
    required this.selectedColor,
    required this.onPriorityChanged,
    required this.onColorChanged,
    this.initialNote, // Truyền note ban đầu vào đây nếu cần
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm'); // Di chuyển vào đây

    return SingleChildScrollView( // Cho phép cuộn nếu nội dung dài
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey, // Sử dụng key được truyền vào
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Tiêu đề ---
            TextFormField(
              controller: titleController, // Sử dụng controller được truyền vào
              decoration: const InputDecoration(
                labelText: 'Tiêu đề *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập tiêu đề' : null,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // --- Nội dung ---
            TextFormField(
              controller: contentController, // Sử dụng controller được truyền vào
              decoration: const InputDecoration(
                labelText: 'Nội dung *',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: null,
              minLines: 5,
              keyboardType: TextInputType.multiline,
              validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập nội dung' : null,
            ),
            const SizedBox(height: 16),

            // --- Mức độ ưu tiên ---
            DropdownButtonFormField<int>(
              value: selectedPriority, // Sử dụng giá trị được truyền vào
              decoration: const InputDecoration(
                labelText: 'Mức độ ưu tiên *',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text('1 - Thấp')),
                DropdownMenuItem(value: 2, child: Text('2 - Trung bình')),
                DropdownMenuItem(value: 3, child: Text('3 - Cao')),
              ],
              onChanged: onPriorityChanged, // Gọi callback khi thay đổi
            ),
            const SizedBox(height: 16),

            // --- Tags ---
            TextFormField(
              controller: tagsController, // Sử dụng controller được truyền vào
              decoration: const InputDecoration(
                labelText: 'Tags (phân cách bởi dấu phẩy)',
                border: OutlineInputBorder(),
                hintText: 'công việc, quan trọng,...',
              ),
            ),
            const SizedBox(height: 16),

            // --- Chọn màu ---
            const Text('Màu sắc:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0, runSpacing: 8.0,
              children: ['lightblue', '#FFCDD2', '#FFF9C4', '#C8E6C9', '#CFD8DC', null]
                  .map((colorCode) => GestureDetector(
                onTap: () => onColorChanged(colorCode), // Gọi callback khi chọn màu
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: _getColorFromString(colorCode),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor == colorCode ? Theme.of(context).primaryColorDark : Colors.grey.shade400,
                      width: selectedColor == colorCode ? 3 : 1.5,
                    ),
                  ),
                  child: selectedColor == colorCode
                      ? Icon(Icons.check, color: _getTextColor(_getColorFromString(colorCode)), size: 20)
                      : (colorCode == null ? const Icon(Icons.format_color_reset_outlined, color: Colors.grey, size: 20,) : null),
                ),
              ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            // --- Thông tin ngày tạo/sửa (chỉ hiển thị) ---
            // Chỉ hiển thị nếu `initialNote` được truyền vào (tức là đang sửa)
            if (initialNote != null) ...[
              Center(
                child: Column(
                  children: [
                    Text( 'Ngày tạo: ${dateFormat.format(initialNote!.created_at)}', style: const TextStyle(color: Colors.grey, fontSize: 12), ),
                    Text( 'Sửa lần cuối: ${dateFormat.format(initialNote!.modified_at)}', style: const TextStyle(color: Colors.grey, fontSize: 12), ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ]
          ],
        ),
      ),
    );
  }
}