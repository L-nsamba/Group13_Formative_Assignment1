import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:project_task_tracker/models/task.dart';
import 'package:project_task_tracker/models/member.dart';
import 'package:project_task_tracker/services/seed_data.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final pathName = join(databasePath, 'task_tracker.db');

    return await openDatabase(pathName, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE members (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        assigneeId TEXT NOT NULL,
        priority TEXT NOT NULL,
        deadline TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (assigneeId) REFERENCES members (id)
      )
    ''');

    // Insert initial members before tasks.
    final batch = db.batch();

    for (final member in seedMembers) {
      batch.insert('members', member.toMap());
    }

    for (final task in buildSeedTasks()) {
      batch.insert('tasks', task.toMap());
    }

    await batch.commit(noResult: true);
  }

  // MEMBER OPERATIONS

  Future<List<Member>> getMembers() async {
    final db = await database;

    final result = await db.query('members', orderBy: 'name ASC');

    return result.map((map) => Member.fromMap(map)).toList();
  }

  Future<void> insertMember(Member member) async {
    final db = await database;

    await db.insert(
      'members',
      member.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMember(Member member) async {
    final db = await database;

    await db.update(
      'members',
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  Future<void> deleteMember(String id) async {
    final db = await database;

    await db.delete('members', where: 'id = ?', whereArgs: [id]);
  }

  // TASK OPERATIONS

  Future<List<Task>> getTasks() async {
    final db = await database;

    final result = await db.query('tasks', orderBy: 'CAST(id AS INTEGER) DESC');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<void> insertTask(Task task) async {
    final db = await database;

    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    final db = await database;

    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;

    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
