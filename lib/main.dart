import 'package:flutter/material.dart';
import 'task_repository.dart';

void main() {
  runApp(MyApp());
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
                      final updatedTask = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditTaskScreen(task: task),
                        ),
                      );

                      if (updatedTask != null) {
                        setState(() {
                          final originalIndex =
                              TaskRepository.tasks.indexOf(task);
                          TaskRepository.tasks[originalIndex] =
                              updatedTask;
                        });
                      }
                    },
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




