import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Task {
  final int? id;
  final String name;
  final String date;
  final String category;
  final int isChecked;

  const Task({this.id, required this.name, required this.date, required this.category, required this.isChecked});

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'date': date,
    'category': category,
    'isChecked': isChecked == 1 ? 1 : 0,
  };

  factory Task.fromJson(Map<String, Object?> json) => Task(
    id: json['id'] as int?,
    name: json['name'] as String,
    date: json['date'] as String,
    category: json['category'] as String,
    isChecked: json['isChecked'] as int
  );

  Task copy({
    int? id,
    String? name,
    String? date,
    String? category,
    int? isChecked
  }) =>
      Task(
        id: id?? this.id,
        name: name?? this.name,
        date: date?? this.date,
        category: category?? this.category,
        isChecked: isChecked?? this.isChecked,
      );
}

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._internal();
  static Database? _database;

  TaskDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'todolist_database.db'),
        version: 1,
        onCreate: _createDatabase
    );
  }

  Future<void> _createDatabase(Database database, int version) async {
    return await database.execute('''
        CREATE TABLE task (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          date TEXT NOT NULL,
          category TEXT NOT NULL,
          isChecked INTEGER NOT NULL
        )
      ''');
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;
    final id = await db.insert('task', task.toJson());
    return task.copy(id: id);
  }

  Future<List<Task>> readAll() async {
    final db = await instance.database;
    final result = await db.query('task');
    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> update(Task task) async {
    final db = await instance.database;
    await db.update('task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<void> updateCheckStatus(int id, int isChecked) async {
    final db = await instance.database;
    await db.update('task', {'isChecked': isChecked}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteTask(int id) async {
    final db = await instance.database;
    await db.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> deleteDatabaseFile() async {
    try {
      final dbPath = join(await getDatabasesPath(), 'todolist_database.db');
      await deleteDatabase(dbPath);
      print('Database deleted successfully!');
    } catch (e){
      print('Error deleting database: $e');
    }
  }
}


class AppState with ChangeNotifier{
  TaskDatabase database = TaskDatabase.instance;

  List<String> category = <String>['All', 'Work', 'Home', 'Others'];
  Map<String, List<Map<String, dynamic>>> categoryItems = {'Work':[], 'Home':[], 'Others':[]};

  Future<void> addTask(Task task) async {
    final newTask = await TaskDatabase.instance.create(task);

    categoryItems.putIfAbsent(task.category, () => []).add(newTask.toJson());
    if (!category.contains(task.category)) {
      category.add(task.category);
    }
    notifyListeners();
  }

  Future<void> toggleCheck(Task task) async {
    final updatedTask = task.copy(isChecked: task.isChecked == 1 ? 0 : 1);

    await TaskDatabase.updateCheckStatus(task.id!, updatedTask.isChecked);

    // Update in-memory cache to avoid full reload
    final items = categoryItems[task.category];
    if (items != null) {
      final index = items.indexWhere((t) => t['id'] == task.id);
      if (index != -1) {
        items[index] = updatedTask.toJson();
        notifyListeners();
        return;
      }
    }

    // Fallback reload if not found
    await reloadTasks();
  }

  Future<void> reloadTasks() async {
    category = ['All', 'Work', 'Home', 'Others'];
    categoryItems = {};

    final allTasks = await database.readAll();

    for (final task in allTasks) {
      final cat = task.category;
      categoryItems.putIfAbsent(cat, () => []).add(task.toJson());

      if (!category.contains(cat)) {
        category.add(cat);
      }
    }
    print(categoryItems);
    notifyListeners();
    print("Reloaded categories: ${categoryItems.keys.toList()}");
  }

  Future<void> updateTask(Task task) async {
    await TaskDatabase.instance.update(task);

    final items = categoryItems[task.category];
    if (items != null) {
      final index = items.indexWhere((t) => t['id'] == task.id);
      if (index != -1) {
        items[index] = task.toJson();
        notifyListeners();
        return;
      }
    }

    // Fallback: reload everything if item wasn't found (category change, etc.)
    await reloadTasks();
  }

  Future<void> deleteTask(Task task) async {
    await TaskDatabase.deleteTask(task.id!);
    categoryItems[task.category]?.removeWhere((t) => t['id'] == task.id);
    notifyListeners();
  }

  String? selectedCategory;
  DateTime? selectedDate;

  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }

  void reset() {
    selectedCategory = null;
    selectedDate = null;
    notifyListeners();
  }
}