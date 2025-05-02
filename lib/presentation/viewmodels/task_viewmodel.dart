import 'package:flutter/foundation.dart';
import 'package:taski/data/datasources/database_helper.dart';
import 'package:taski/data/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskViewModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final List<TaskModel> _tasks = [];
  final List<TaskModel> _completedTasks = [];
  final List<TaskModel> _searchResults = [];
  bool _isLoading = false;
  int _currentPage = 0;
  int _completedPage = 0;
  static const int _pageSize = 20;

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get completedTasks => _completedTasks;
  List<TaskModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final tasks = await _databaseHelper.getTasks(
        limit: _pageSize,
        offset: _currentPage * _pageSize,
      );
      _tasks.addAll(tasks.map((task) => TaskModel.fromJson(task)));
      _currentPage++;
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCompletedTasks() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final tasks = await _databaseHelper.getCompletedTasks(
        limit: _pageSize,
        offset: _completedPage * _pageSize,
      );
      _completedTasks.addAll(tasks.map((task) => TaskModel.fromJson(task)));
      _completedPage++;
    } catch (e) {
      debugPrint('Error loading completed tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title, String description) async {
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    try {
      await _databaseHelper.insertTask(task.toJson());
      _tasks.insert(0, task);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    final updatedTask = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      isCompleted: !task.isCompleted,
    );

    try {
      await _databaseHelper.updateTask(updatedTask.toJson());
      
      if (updatedTask.isCompleted) {
        _tasks.removeWhere((t) => t.id == task.id);
        _completedTasks.insert(0, updatedTask);
      } else {
        _completedTasks.removeWhere((t) => t.id == task.id);
        _tasks.insert(0, updatedTask);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    try {
      await _databaseHelper.deleteTask(task.id);
      _tasks.removeWhere((t) => t.id == task.id);
      _completedTasks.removeWhere((t) => t.id == task.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  Future<void> searchTasks(String query) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults.clear();
      if (query.isEmpty) {
        notifyListeners();
        return;
      }

      final searchQuery = '%$query%';
      final db = await _databaseHelper.database;
      final results = await db.query(
        'tasks',
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: [searchQuery, searchQuery],
        orderBy: 'created_at DESC',
      );

      _searchResults.addAll(results.map((task) => TaskModel.fromJson(task)));
    } catch (e) {
      debugPrint('Error searching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 