import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // استيراد مكتبة Provider لإدارة الحالة
import 'todo_provider.dart'; // استيراد ملف مزود المهام (TodoProvider)
import 'todo_screen.dart'; // استيراد شاشة المهام (واجهة التطبيق)

void main() {
  // دالة التشغيل الرئيسية التي تبدأ التطبيق
  runApp(
    MultiProvider(
      providers: [
        // تسجيل مزود الحالة باستخدام ChangeNotifierProvider
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MyApp(), // تمرير التطبيق الرئيسي
    ),
  );
}

// تعريف التطبيق الرئيسي كـ StatelessWidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // إخفاء شعار "debug" من الزاوية
      title: 'Todo List with Provider', // اسم التطبيق
      theme: ThemeData(primarySwatch: Colors.blue), // تخصيص اللون الأساسي للتطبيق
      home: TodoScreen(), // تعيين شاشة البداية
    );
  }
}
