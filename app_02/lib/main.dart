// import 'package:app_02/my_widgets_01//MyButton_2.dart';
// import 'MyScaffold.dart';
// import 'my_widgets/MyAppBar.dart';
// import 'MyContainer.dart';
// import 'MyColumnAndRow.dart';
// import 'MyTextField.dart';
// import 'my_widgets_01/MyTexFieid2.dart';
// import 'package:app_02/userMS_API/view/UserListScreen.dart';
import 'package:flutter/material.dart';
import 'package:app_02/noteManagement/view/NoteListScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://axervqattfkkawvujatg.supabase.co', // <- thay bằng URL của bạn
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF4ZXJ2cWF0dGZra2F3dnVqYXRnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ3MzQ5NDIsImV4cCI6MjA2MDMxMDk0Mn0.4xtPprIKC-ctAThBAJzkV6oWykMjngS1lSGQ05WlFOA',  // <- thay bằng key của bạn
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng Ghi chú',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  NoteListScreen(),
    );
  }
}

