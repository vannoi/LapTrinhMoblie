import 'package:flutter/material.dart';

 class MyAddbar extends StatelessWidget {
  const MyAddbar({super.key});
  @override
  Widget build(BuildContext context) {
// Tra ve Scaffold - widget cung cap bo cuc Material Design co t
// Man hinh
    return Scaffold(
// Tiêu để của ứng dụng
        appBar: AppBar(
          title: Text("App 02"),
        ),
      backgroundColor: Colors.blue,

      body: Center(child: Text("Noi dung chinh"),),

      floatingActionButton: FloatingActionButton(onPressed: ()
          {print("pressed");},
        child: const Icon(Icons.add_ic_call),
      ),

        bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chù"),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tim kiếm"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Ca nhân"),
    ]),
    );

  }
}
