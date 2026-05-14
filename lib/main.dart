import 'package:flutter/material.dart';
import 'task_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../services/task_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:drift/drift.dart';
import 'package:hive_ce/hive.dart';
import 'TaskSyncService.dart';
import 'TaskLocalDatabase.dart';
import 'dart:math';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("settings");
  runApp(MyApp());
}

Task(
  id: Random().nextInt(1000000),
  title: title,
  deadline: deadline,
  priority: priority,
  done: false,
);
//
// Future<void> addTask(Task task) async {
//   await TaskLocalDatabase.addTask(task);
//   await loadTasks();
// }

// class Tasks extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text()();
//   TextColumn get priority => text()();
//   BoolColumn get done => boolean().withDefault(const Constant(false))();
// }



class SettingsService {
  static const String _filterKey = "selected_filter";
  static Future<void> saveSelectedFilter(String filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_filterKey, filter);
  }
  static Future<String> loadSelectedFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_filterKey) ?? "wszystkie";
  }
}


class TaskApiService {
  static const String baseUrl = "https://dummyjson.com";
  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse("$baseUrl/todos"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List todos = data["todos"];
      return todos.map((todo) {
        return Task(
          title: todo["todo"],
          deadline: "brak", // brak w API → mockujemy
          done: todo["completed"],
          priority: "średni", // brak w API → mockujemy
        );
      }).toList();
    } else {
      throw Exception("Błąd pobierania danych");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

// List<Task> tasks = [
//   Task(title: "zadanie fizyka", deadline: "za tydzien"),
//   Task(title: "projekt na chemie", deadline: "za miesiac"),
//   Task(title: "powtorka na sieci komputerowe", deadline: "pojutrze"),
//   Task(title: "projekt programowaie", deadline: "jutro"),
// ];

// Scaffold(
// appBar: AppBar(
// title: Text("KrakFlow"),
// ),
// body: Center(
// child: Text("Lista Zadan"),
// ),
// floatingActionButton: FloatingActionButton(
// onPressed: () {},
// child: Icon(Icons.add),
// ),
// ),
// ListView.builder(
// itemCount: tasks.length,
// itemBuilder: (context, index){
// return Text(tasks[index].title + ": " + tasks[index].deadline);
// Column(
// children: [
// Text("KrakFlow"),
// Text("Organizacja studiow"),
// Text("Dzisiejsze zadania"),
// Navigator.push(
//     context,
//     MaterialPageRoute(
//         builder: (context) => EditTaskScreen(task: task),
//     ),
// );

// ListView.builder(
//   itemCount: TaskRepository.tasks.length,
//   itemBuilder: (context, index) {
//     final task = TaskRepository.tasks[index];
//     return Dismissible(
//       key: ValueKey(task.title),
//       onDismissed: (direction) {
//         setState(() {
//           TaskRepository.tasks.remove(task);
//         });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Zadanie usunięte"),
//       ),
//     );
//      },
//       child: TaskCard(
//         title: task.title,
//         subtitle: task.deadline,
//         icon: Icons.task,
//       ),
//     );
//   },
// )
  
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("KrakFlow"),
//       ),
//       body: Center(
//         child: Text("Lista zadan"),
//       ),
//     );
//   }
// }



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "wszystkie";
  int allTasksCount = 0;
  int doneTasksCount = 0;
  int todoTasksCount = 0;

  void updateCounters(List<Task> tasks) {
    setState(() {
      allTasksCount = tasks.length;
      doneTasksCount = tasks.where((task) => task.done).length;
      todoTasksCount = tasks.where((task) => !task.done).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = TaskRepository.tasks;

    if (selectedFilter == "wykonane") {
      filteredTasks =
          TaskRepository.tasks.where((task) => task.done).toList();
    } else if (selectedFilter == "do zrobienia") {
      filteredTasks =
          TaskRepository.tasks.where((task) => !task.done).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("KrakFlow"),
        actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                            return AlertDialog(
                            title: Text("Potwierdzenie"),
                            content: Text("Czy na pewno chcesz usunąć wszystkie zadania?"),
                            actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Anuluj"),
                                ),
                                TextButton(
                                    onPressed: () {
                                        setState(() {
                                            TaskRepository.tasks.clear(); // usuwa wszystkie elementy z listy
                                        });
                                    Navigator.pop(context); // zamyka dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text("Wszystkie zadania usunięte"),
                                        ),
                                    );
                                    },
                                child: Text("Usuń"),
                                ),
                            ],
                            );
                        },
                    );
                },
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),

          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() => selectedFilter = "wszystkie");
                },
                child: Text("Wszystkie"),
              ),
              TextButton(
                onPressed: () {
                  setState(() => selectedFilter = "do zrobienia");
                },
                child: Text("Do zrobienia"),
              ),
              TextButton(
                onPressed: () {
                  setState(() => selectedFilter = "wykonane");
                },
                child: Text("Wykonane"),
              ),
            ],
          ),

          Expanded(
            // child: TaskListScreen(),
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];

                return Dismissible(
                  key: ValueKey(task.title),
                  onDismissed: (direction) {
                    setState(() {
                      TaskRepository.tasks.remove(task);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Zadanie usunięte")),
                    );
                  },
                  child: TaskCard(
                    title: task.title,
                    subtitle: task.deadline,
                    done: task.done,
                    onChanged: (value) {
                      setState(() {
                        task.done = value!;
                      });
                    },
                    onTap: () async {
                      final Task? updatedTask = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskScreen(task: task),
                        ),
                      );
                      if (updatedTask != null) {
                        await TaskLocalDatabase.updateTask(updatedTask);
                        setState(() {
                          tasksFuture = loadTasks();
                        });
                      }
                    },
                    // onTap: () async {
                    //   final updatedTask = await Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           EditTaskScreen(task: task),
                    //     ),
                    //   );
                    //
                    //   if (updatedTask != null) {
                    //     setState(() {
                    //       final originalIndex =
                    //           TaskRepository.tasks.indexOf(task);
                    //       TaskRepository.tasks[originalIndex] =
                    //           updatedTask;
                    //     });
                    //   }
                    // },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nowe zadanie"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),



              ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: titleController.text,
                  deadline: deadlineController.text,
                );

                Navigator.pop(context, newTask);
              },
              child: Text("Zapisz"),
              ),
            ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(),
                ),
              );
            },
          child: Icon(Icons.add),
        ),
    );
  }
}


class EditTaskScreen extends StatelessWidget {
  final Task task;
  EditTaskScreen({super.key, required this.task});

  late final TextEditingController titleController = TextEditingController(text: task.title);
  late final TextEditingController deadlineController = TextEditingController(text: task.deadline);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edytuj zadanie"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),
             SizedBox(height: 16),

            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: "Deadline",
                border: OutlineInputBorder(),
              ),
            ),


              ElevatedButton(
              onPressed: () {
                final editTask = Task(
                  title: titleController.text,
                  deadline: deadlineController.text,
                  done: task.done,
                );
                Navigator.pop(context, editTask);
              },
              child: Text("Zapisz"),
              ),
            ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  const MyButton({
    super.key,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text("Kliknij"),
    );
  }
}

// MyButton(
//   onTap: () {
//     print("Kliknięcie w przycisk");
//   },
// )

// Center(
// child: Text("Tutaj bedzie formulaz dodawania taska"),
// ),

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> tasksFuture;
  @override
  void initState() {
    super.initState();
    // tasksFuture = TaskApiService.fetchTasks();
    tasksFuture = loadTasks();
  }

  Future<List<Task>> loadTasks() async {
    await TaskSyncService.loadInitialDataIfNeeded();
    return TaskLocalDatabase.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(),
            );
        }
        if (snapshot.hasError) {
            return Center(
                child: Text("Błąd: ${snapshot.error}"),
            );
        }
        final tasks = snapshot.data ?? [];
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
              final task = tasks[index];

            return TaskCard(
              title: task.title,
              subtitle: task.deadline,
              done: task.done,
              onChanged: (value) {
                setState(() {
                  task.done = value ?? false;
                });
              },
            );
          },
        );
      },
    );
  }
}

// void initState() {
//   super.initState();
//   tasksFuture = TaskApiService.fetchTasks();
// }



