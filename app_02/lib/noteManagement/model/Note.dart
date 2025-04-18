import 'dart:convert';
class Note {
  int? id;
  String title;
  String content;
  int priority;
  DateTime created_at;
  DateTime modified_at;
  List<String>? tags;
  String? color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.created_at,
    required this.modified_at,
    this.tags,
    this.color,
  });

  // Chuyển đối tượng User thành Map

  Map<String, dynamic> toData() {
    return {

      'title': title,
      'content': content,
      'priority': priority,
      'created_at': created_at.toIso8601String(),
      'modified_at': modified_at.toIso8601String(),
      'tags': tags,
      'color': color,
    };
  }

  Map<String, dynamic> toMap() {
    return toData();
  }

  // Chuyển đối tượng User thành Map
  String toJSON() {
    return jsonEncode(toData());
  }

  // Tạo đối tượng User từ Map

  factory Note.fromMap(Map<String, dynamic> map) {

    List<String>? parsedTags;
    if (map['tags'] is String) {
      try {
        var decoded = jsonDecode(map['tags']);
        if (decoded is List) {
          parsedTags = List<String>.from(decoded.map((e) => e.toString()));
        } else {
          parsedTags = map['tags'].toString().split(',');
        }
      } catch (e) {
        parsedTags = map['tags'].toString().split(',');
      }
    } else if (map['tags'] is List) {
      parsedTags = List<String>.from(map['tags'].map((e) => e.toString()));
    }

    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      priority: map['priority'],
      created_at: DateTime.parse(map['created_at']),
      modified_at: DateTime.parse(map['modified_at']),
      tags: parsedTags,
      color: map['color'],
    );

  }

  // Tạo đối tượng User từ JSON

  factory Note.fromJSON( String json) {
    Map<String, dynamic> map =jsonDecode(json);

    List<String>? parsedTags;
    if (map['tags'] is String) {
      parsedTags = map['tags'].toString().split(',');
    } else if (map['tags'] is List) {
      parsedTags = List<String>.from(map['tags'].map((e) => e.toString()));
    }

    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      priority: map['priority'],
      created_at: DateTime.parse(map['created_at']),
      modified_at: DateTime.parse(map['modified_at']),
      tags: parsedTags,
      color: map['color'],
    );

  }

  // Phương thức copy để tạo bản sao với một số thuộc tính được cập nhật

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? priority,
    DateTime? created_at,
    DateTime? modified_at,
    List<String>? tags,
    String? color,

  }) {

    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      created_at: created_at ?? this.created_at,
      modified_at: modified_at ?? this.modified_at,
      tags: tags ?? this.tags,
      color: color ?? this.color,
    );

  }

  @override

  String toString() {

    return 'Note('
        'id: $id, '
        'title: $title, '
        'content: $content, '
        'priority: $priority, '
        'created_at: $created_at, '
        'modified_at: $modified_at,'
        'tags: ${tags?.join(", ")},'
        'color: $color,'
        ')';
  }
}
