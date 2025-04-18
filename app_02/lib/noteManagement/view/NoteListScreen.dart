import 'package:flutter/material.dart';
import "../model/Note.dart";
import "../db/NoteDatabaseHelper.dart";
import '../view/NoteItem.dart';
import '../view/NoteDetailScreen.dart';



class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key}) : super(key: key);


  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}


class _NoteListScreenState extends State<NoteListScreen> {
  final dbHelper = NoteDatabaseHelper.instance;
  List<Note> _notes = []; // Danh sách ghi chú hiện tại
  bool _isLoading = true;
  String _searchQuery = '';
  int? _filterPriority; // null nghĩa là không lọc


  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  // Hàm tải lại danh sách ghi chú (có áp dụng tìm kiếm và lọc)
  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Note> fetchedNotes = [];

      // Trường hợp: có cả search và filter
      if (_searchQuery.isNotEmpty && _filterPriority != null) {
        final searchResult = await dbHelper.searchNotes(_searchQuery);
        fetchedNotes = searchResult.where((note) => note.priority == _filterPriority).toList();
      }

      // Trường hợp: chỉ tìm kiếm
      else if (_searchQuery.isNotEmpty) {
        fetchedNotes = await dbHelper.searchNotes(_searchQuery);
      }

      // Trường hợp: chỉ lọc ưu tiên
      else if (_filterPriority != null) {
        fetchedNotes = await dbHelper.getNotesByPriority(_filterPriority!);
      }

      // Trường hợp: không search, không filter (TẤT CẢ)
      else {
        fetchedNotes = await dbHelper.getAllNotes();
      }

      print("Kết quả sau khi lọc/tìm kiếm: ${fetchedNotes.length} ghi chú");

      setState(() {
        _notes = fetchedNotes;
        _isLoading = false;
      });
    } catch (e) {
      print("Lỗi khi tải ghi chú: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải ghi chú: $e'), backgroundColor: Colors.red),
      );
    }
  }






  // Điều hướng đến màn hình chi tiết
  void _goToDetailScreen({Note? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailScreen(note: note)),
    );
    if (result == true) { // Nếu có thay đổi thì tải lại danh sách
      _refreshNotes();
    }
  }


  // Xóa ghi chú
  void _deleteNote(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Không đóng khi nhấn bên ngoài
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn xóa ghi chú này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false), // Hủy
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true), // Xóa
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    // Nếu người dùng xác nhận xóa (confirm == true)
    if (confirm == true) {
      try {
        await dbHelper.deleteNote(id);
        _refreshNotes(); // Làm mới lại danh sách
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa ghi chú')),
        );
      } catch (e) {
        print("Lỗi khi xóa ghi chú: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa: $e'), backgroundColor: Colors.red),
        );
      }
    } else {
      _refreshNotes();
      // Người dùng chọn "Hủy"
      print("Người dùng đã huỷ xóa ghi chú");
    }
  }



  // Xử lý tìm kiếm
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filterPriority = null; // Xóa bộ lọc ưu tiên khi tìm kiếm
    });
    _refreshNotes();
  }


  // Xử lý lọc theo ưu tiên
  void _handleFilter(int? priority) {
    print(">>> Đã chọn lọc: priority = $priority");

    setState(() {
      _filterPriority = priority;
      _searchQuery = '';
      _searchController.clear();
    });

    _refreshNotes();
  }

  //Xữ lý làm mới
  void _handleManualRefresh() {
    print(">>> Làm mới thủ công: reset lọc + tìm kiếm");

    setState(() {
      _filterPriority = null;
      _searchQuery = '';
      _searchController.clear();
    });

    _refreshNotes();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chú của tôi'),
        bottom: PreferredSize( // Thêm thanh tìm kiếm vào AppBar
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm ghi chú...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: (){
                  _searchController.clear();
                  _handleSearch('');
                })
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: _handleSearch, // Gọi khi text thay đổi
            ),
          ),
        ),
        actions: [
          // Menu lọc
          PopupMenuButton<int?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Lọc theo ưu tiên',
            onSelected: (value) {
              _handleFilter(value == -1 ? null : value);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int?>>[
              const PopupMenuItem<int?>( value: -1, child: Text('Tất cả ưu tiên')),
              const PopupMenuDivider(),
              const PopupMenuItem<int?>( value: 3, child: Text('Ưu tiên: Cao')),
              const PopupMenuItem<int?>( value: 2, child: Text('Ưu tiên: Trung bình')),
              const PopupMenuItem<int?>( value: 1, child: Text('Ưu tiên: Thấp')),
            ],
          ),
          IconButton( // Nút refresh thủ công (dù đã có tự động)
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
            onPressed: _handleManualRefresh,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? Center(
        child: Text(
          _searchQuery.isNotEmpty || _filterPriority != null
              ? 'Không tìm thấy ghi chú phù hợp.'
              : 'Chưa có ghi chú nào.\nNhấn + để thêm.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80), // Thêm padding để không bị che bởi FAB
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return NoteItem(
            note: note,
            onTap: () => _goToDetailScreen(note: note),
            onDelete: () => _deleteNote(note.id!),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToDetailScreen(),
        tooltip: 'Thêm ghi chú mới',
        child: const Icon(Icons.add),
      ),
    );
  }
}