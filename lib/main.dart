import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  
  List<Task> tasks = [
    Task(title: "zadanie fizyka", deadline: "za tydzien"),
    Task(title: "projekt na chemie", deadline: "za miesiac"),
    Task(title: "powtorka na sieci komputerowe", deadline: "pojutrze"),
    Task(title: "projekt programowaie", deadline: "jutro"),
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("KrakFlow")),
        body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index){
            return Text(tasks[index].title + ": " + tasks[index].deadline);
          },
        )
      ),
    );
  }
}

// Column(
// children: [
// Text("KrakFlow"),
// Text("Organizacja studiow"),
// Text("Dzisiejsze zadania"),
class Task{
  final String title;
  final String deadline;

  Task({required this.title, required this.deadline});
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const TaskCard({super.key, required this.title, required this.subtitle, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle)
      ),
    );
  }
}
