class Todo {
  // تعريف الحقول الخاصة بالمهمة
  String id; // معرّف فريد لكل مهمة
  String title; // عنوان المهمة
  bool isCompleted; // حالة المهمة (هل تم إكمالها أم لا)

  // المنشئ لإنشاء كائن جديد من نوع Todo
  Todo({
    required this.id, // المعرّف مطلوب
    required this.title, // العنوان مطلوب
    this.isCompleted = false, // الحالة الافتراضية غير مكتملة
  });

  // لتحويل المهمة إلى Map لتخزينها في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id, // حفظ المعرّف كـ String
      'title': title, // حفظ العنوان كـ String
      'isCompleted': isCompleted ? 1 : 0, // حفظ الحالة كرقم (1 إذا كانت مكتملة، 0 إذا لم تكتمل)
    };
  }

  // مصنع لتحويل Map إلى كائن Todo عند استرجاعه من قاعدة البيانات
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'], // استرجاع المعرّف
      title: map['title'], // استرجاع العنوان
      isCompleted: map['isCompleted'] == 1, // تحويل القيمة العددية إلى قيمة منطقية (true/false)
    );
  }
}
