import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart'; // استيراد ملف المزود لإدارة الحالة

class TodoScreen extends StatelessWidget {
  // وحدة تحكم النص لإضافة مهام جديدة
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // الحصول على مزود المهام باستخدام Provider
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      // هيكل التطبيق الرئيسي
      appBar: AppBar(
        // شريط التطبيق مع عنوان باللغة العربية
        title: Text('قائمة المهام', textDirection: TextDirection.rtl),
      ),
      // الجسم الرئيسي للشاشة
      body: FutureBuilder(
        // استدعاء دالة تحميل المهام من المزود
        future: todoProvider.loadTodos(),
        builder: (context, snapshot) {
          // التحقق من حالة الاتصال (ConnectionState)
          // إذا كان التطبيق ينتظر نتيجة التحميل، يعرض مؤشر تحميل
        //  if (snapshot.connectionState == ConnectionState.waiting) {
         //   return Center(child: CircularProgressIndicator());
       //   }

          // عرض باقي مكونات الشاشة بعد تحميل البيانات
          return Column(
            children: [
              // حقل إدخال النص لإضافة مهمة جديدة
              Padding(
                padding: const EdgeInsets.all(8.0), // إضافة مسافة حول الحقل
                child: TextField(
                  controller: _controller, // وحدة التحكم لقراءة النص المدخل
                  textDirection: TextDirection.rtl, // اتجاه النص من اليمين لليسار
                  decoration: InputDecoration(
                    labelText: 'أضف مهمة جديدة', // نص إرشادي داخل الحقل
                    suffixIcon: IconButton(
                      // أيقونة لإضافة المهمة عند الضغط
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // إذا كان النص غير فارغ، أضف المهمة
                        if (_controller.text.isNotEmpty) {
                          todoProvider.addTodo(_controller.text); // استدعاء دالة الإضافة
                          _controller.clear(); // مسح النص من الحقل
                        }
                      },
                    ),
                  ),
                ),
              ),
              // قائمة المهام المعروضة باستخدام ListView.builder
              Expanded(
                child: ListView.builder(
                  itemCount: todoProvider.todos.length, // عدد المهام في القائمة
                  itemBuilder: (context, index) {
                    final todo = todoProvider.todos[index]; // الحصول على المهمة الحالية
                    return ListTile(
                      // عنوان المهمة
                      title: Text(
                        todo.title,
                        textDirection: TextDirection.rtl, // اتجاه النص
                        style: TextStyle(
                          // إذا كانت المهمة مكتملة، يتم إضافة خط عليها
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      // مربع اختيار للتحكم في حالة المهمة (مكتملة/غير مكتملة)
                      leading: Checkbox(
                        value: todo.isCompleted, // حالة المهمة
                        onChanged: (_) =>
                            todoProvider.toggleTodoStatus(todo.id), // تغيير الحالة
                      ),
                      // زر حذف لإزالة المهمة
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            todoProvider.deleteTodo(todo.id), // استدعاء دالة الحذف
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
