import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "../model/Note.dart";


// Hàm trợ giúp chuyển chuỗi màu thành Color
Color _getColorFromString(String? colorString) {
  if (colorString == null || colorString.isEmpty) return Colors.grey.shade200;
  if (colorString.startsWith('#')) {
    try {
      return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
    } catch (e) { return Colors.grey.shade200; }
  } else {
    switch (colorString.toLowerCase()) {
      case 'lightblue': return Colors.lightBlue.shade100;
      case '#ffcdd2': return const Color(0xFFFFCDD2);
      case '#fff9c4': return const Color(0xFFFFF9C4);
      case '#c8e6c9': return const Color(0xFFC8E6C9);
      case '#cfd8dc': return const Color(0xFFCFD8DC);
      default: return Colors.grey.shade200;
    }
  }
}

// Hàm lấy màu chữ tương phản
Color _getTextColor(Color backgroundColor) {
  return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}


class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete; // Hàm xóa được gọi khi vuốt


  const NoteItem({
    Key? key,
    required this.note,
    required this.onTap,
    required this.onDelete, // Yêu cầu phải có hàm xóa
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final cardColor = _getColorFromString(note.color);
    final textColor = _getTextColor(cardColor);
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');


    String priorityText;
    Color priorityColor;
    switch (note.priority) {
      case 1: priorityText = 'Thấp'; priorityColor = Colors.green; break;
      case 2: priorityText = 'Trung bình'; priorityColor = Colors.orange; break;
      case 3: priorityText = 'Cao'; priorityColor = Colors.red; break;
      default: priorityText = 'N/A'; priorityColor = Colors.grey;
    }


    Widget itemContent = Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                note.content,
                style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.85)),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text( priorityText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: priorityColor)),


                ],
              ),
              if (note.tags != null && note.tags!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 2.0, runSpacing: 4.0,
                  children: note.tags!.map((tag) => Chip(
                    label: Text(tag, style: TextStyle(fontSize: 10, color: _getTextColor(Colors.grey.shade300))),
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                    backgroundColor: Colors.grey.shade300,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
              ],
              const SizedBox(height: 8),
              Text( 'Tạo: ${dateFormat.format(note.created_at)}', style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.7))),
              Text( 'Sửa: ${dateFormat.format(note.modified_at)}', style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.7))),

            ],
          ),
        ),
      ),
    );


    // Bọc bằng Dismissible để cho phép xóa bằng cách vuốt
    return Dismissible(
      key: Key(note.id.toString()), // Key duy nhất
      direction: DismissDirection.endToStart,
      onDismissed: (direction) { onDelete(); }, // Gọi hàm xóa
      background: Container(
        color: Colors.redAccent.shade100, // Màu nền khi vuốt
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
      ),
      child: itemContent,
    );
  }
}