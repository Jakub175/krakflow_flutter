import 'package:flutter/material.dart';

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

class TaskRepository {
  static List<Task> tasks = [
    Task(title: "zadanie fizyka", deadline: "za tydzien"),
    Task(title: "projekt na chemie", deadline: "za miesiac"),
    Task(title: "powtorka na sieci komputerowe", deadline: "pojutrze"),
    Task(title: "projekt programowaie", deadline: "jutro"),
  ];
}