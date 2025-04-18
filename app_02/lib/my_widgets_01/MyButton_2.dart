import "package:flutter/material.dart";

class Mybutton_2 extends StatelessWidget {
  const Mybutton_2({super.key});

  @override
  Widget build(BuildContext context) {
    // Tra ve Scaffold - widget cung cap bo cuc Material Design co ban
    // Man hinh
    return Scaffold(
      // Tiêu đề của ứng dụng
      appBar: AppBar(
        // Tieu de
        title: Text("App 02"),
        // Mau nen
        backgroundColor: Colors.yellow,
        // Do nang/ do bong cua AppBar
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              print("b1");
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              print("b2");
            },
            icon: Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {
              print("b3");
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: Center(child: Column(
          children: [
            // Tao mot khoang cach
             SizedBox(height: 50,),
            // ElevatedButton là một button nổi với hiệu ứng đổ bóng,
            // thường được sử dụng cho các hành động chính trong ứng dụng.
            ElevatedButton(
                onPressed: (){print("ElevatedButton");}, 
                child: Text("ElevatedButton", style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15
                  ),
                  elevation: 15,

                ),
            ),
            SizedBox(height: 50,),
            TextButton(
                onPressed: (){print("TextButton");},
                child: Text("TextButton", style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10
                ),
                elevation: 30,
                ),

            ),

            SizedBox(height: 50,),
          InkWell(
            onTap: (){
              print("InWell duoc nhan!");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color:Colors.blue),
              ),
              child: Text("Button tuy chinh voi InWell"),
            ),
          )

          ]
      )),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },
        child: const Icon(Icons.add_ic_call),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}
