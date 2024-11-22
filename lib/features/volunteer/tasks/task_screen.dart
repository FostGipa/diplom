import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/data/task_model.dart';
import '../../../data/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TasksScreen(),
    );
  }
}

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _firebaseService.getAllTasks();
      print('Loaded tasks: $tasks'); // Добавьте эту строку для отладки
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error loading tasks: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.taskName),
            subtitle: Text(task.taskDescription),
            trailing: Text(task.taskClient.firstName), // Добавьте проверку на null
          );
        },
      ),
    );
  }
}