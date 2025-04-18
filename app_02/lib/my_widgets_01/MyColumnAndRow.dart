import 'package:flutter/material.dart';

 class MyColumnAndRow extends StatelessWidget {
  const MyColumnAndRow({super.key});
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
        child:Column(
          children: [
            Row(
              children: [
                const SizedBox(height: 50,),
                const Icon(Icons.access_alarm_outlined),
                const Icon(Icons.ac_unit),
                const Icon(Icons.access_alarm_rounded),

              ],
            ),
            Row(
              children: [
                Text("Tex1.........."),
                Text("Tex2.........."),
                Text("Tex3.........."),
              ],
            )
          ],
        )
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
