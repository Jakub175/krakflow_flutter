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


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KrakFlow"),
      ),
      body: Center(
        child: Text("Lista zadan"),
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

// Center(
// child: Text("Tutaj bedzie formulaz dodawania taska"),
// ),




