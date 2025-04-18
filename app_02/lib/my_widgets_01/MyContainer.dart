import 'package:flutter/material.dart';

 class Mycontainer extends StatelessWidget {
  const Mycontainer({super.key});
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

      body: Center(
        child: Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.green,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),

              ),
            ]
          ),


          child: Align(
            alignment: Alignment.center,
            child: const Text(
              "Duong van noi",
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),

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
