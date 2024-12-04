import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'todo.dart';

// تعريف مزود المهام الذي يُستخدم لإدارة الحالة
class TodoProvider with ChangeNotifier {
  // قائمة محلية لتخزين المهام
  List<Todo> _todos = [];
  
  // الوصول إلى قاعدة البيانات باستخدام كائن DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // تعريف Getter لإرجاع قائمة المهام
  List<Todo> get todos => _todos;

  // دالة لتحميل المهام من قاعدة البيانات إلى التطبيق
  Future<void> loadTodos() async {
    // جلب المهام من قاعدة البيانات وتحديث القائمة المحلية
    _todos = await _dbHelper.fetchTodos();
    // إشعار المستمعين (مثل الواجهة) بوجود تحديثات
    notifyListeners();
  }

  // دالة لإضافة مهمة جديدة إلى القائمة وقاعدة البيانات
  Future<void> addTodo(String title) async {
    // إنشاء كائن مهمة جديد باستخدام العنوان
    final todo = Todo(id: DateTime.now().toString(), title: title);
    // إضافة المهمة إلى القائمة المحلية
    _todos.add(todo);
    // تخزين المهمة في قاعدة البيانات
    await _dbHelper.insertTodo(todo);
    // إشعار المستمعين بالتحديث
    notifyListeners();
  }

  // دالة لتغيير حالة إكمال مهمة معينة
  Future<void> toggleTodoStatus(String id) async {
    // البحث عن المهمة باستخدام المعرّف وتغيير حالتها
    final todo = _todos.firstWhere((todo) => todo.id == id);
    todo.isCompleted = !todo.isCompleted;
    // تحديث حالة المهمة في قاعدة البيانات
    await _dbHelper.updateTodoStatus(id, todo.isCompleted);
    // إشعار المستمعين بالتحديث
    notifyListeners();
  }

  // دالة لحذف مهمة معينة من القائمة وقاعدة البيانات
  Future<void> deleteTodo(String id) async {
    // إزالة المهمة من القائمة المحلية
    _todos.removeWhere((todo) => todo.id == id);
    // حذف المهمة من قاعدة البيانات
    await _dbHelper.deleteTodo(id);
    // إشعار المستمعين بالتحديث
    notifyListeners();
  }
}
