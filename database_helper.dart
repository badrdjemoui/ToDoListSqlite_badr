import 'package:path/path.dart'; // لتحديد مسار قاعدة البيانات
import 'package:sqflite/sqflite.dart'; // مكتبة SQLite لإدارة قواعد البيانات
import 'todo.dart'; // استيراد الكائن Todo

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init(); // إنشاء نسخة واحدة فقط (Singleton)
  static Database? _database; // لتخزين الكائن الخاص بقاعدة البيانات

  DatabaseHelper._init(); // مُنشئ خاص لتجنب إنشاء كائنات جديدة

  // الوصول إلى قاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!; // إذا كانت قاعدة البيانات موجودة، يتم إرجاعها
    _database = await _initDB('todos.db'); // خلاف ذلك، يتم تهيئة قاعدة بيانات جديدة
    return _database!;
  }

  // تهيئة قاعدة البيانات
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // الحصول على مسار التخزين الافتراضي لقاعدة البيانات
    final path = join(dbPath, filePath); // دمج المسار مع اسم ملف قاعدة البيانات

    // فتح قاعدة البيانات وإنشاؤها إذا لم تكن موجودة
    return await openDatabase(
      path,
      version: 1, // إصدار قاعدة البيانات
      onCreate: _createDB, // استدعاء دالة الإنشاء عند إنشاء قاعدة جديدة
    );
  }

  // إنشاء جدول قاعدة البيانات
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id TEXT PRIMARY KEY, // العمود الأساسي
        title TEXT NOT NULL, // عنوان المهمة
        isCompleted INTEGER NOT NULL // حالة إتمام المهمة (0 أو 1)
      )
    ''');
  }

  // إدخال مهمة جديدة في قاعدة البيانات
  Future<void> insertTodo(Todo todo) async {
    final db = await database; // الحصول على قاعدة البيانات
    await db.insert('todos', todo.toMap()); // تحويل المهمة إلى Map وإدخالها
  }

  // استرجاع جميع المهام من قاعدة البيانات
  Future<List<Todo>> fetchTodos() async {
    final db = await database; // الحصول على قاعدة البيانات
    print("Database opened successfully"); // للتحقق من فتح قاعدة البيانات
    final result = await db.query('todos'); // تنفيذ استعلام لاسترجاع كل المهام
    print("Fetched todos: $result"); // عرض البيانات المسترجعة في وحدة التحكم
    return result.map((json) => Todo.fromMap(json)).toList(); // تحويل كل صف إلى كائن Todo
  }

  // تحديث حالة المهمة (مكتملة أو غير مكتملة)
  Future<void> updateTodoStatus(String id, bool isCompleted) async {
    final db = await database; // الحصول على قاعدة البيانات
    await db.update(
      'todos', // اسم الجدول
      {'isCompleted': isCompleted ? 1 : 0}, // تحديث الحالة
      where: 'id = ?', // تحديد المهمة باستخدام معرفها
      whereArgs: [id], // تمرير المعرف كمعامل
    );
  }

  // حذف مهمة من قاعدة البيانات
  Future<void> deleteTodo(String id) async {
    final db = await database; // الحصول على قاعدة البيانات
    await db.delete(
      'todos', // اسم الجدول
      where: 'id = ?', // تحديد المهمة باستخدام معرفها
      whereArgs: [id], // تمرير المعرف كمعامل
    );
  }
}
