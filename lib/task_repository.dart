import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../models/task.dart';
import 'dart:math';

class Task{
  final int id;
  final String title;
  final String deadline;
  final String priority;
  bool done;
  Task({required this.id, required this.title, required this.deadline, required this.priority, this.done = false,});
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "deadline": deadline,
      "priority": priority,
      "done": done,
    };
  }
  factory Task.fromMap(Map map) {
    return Task(
      id: map["id"],
      title: map["title"],
      deadline: map["deadline"],
      priority: map["priority"],
      done: map["done"],
    );
  }
}


class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool done;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;
  const TaskCard({super.key, required this.title, required this.subtitle, required this.done, this.onChanged, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          onTap: onTap,
          leading: Checkbox(
	     value: done,
	     onChanged: onChanged,
          ),
          title: Text(
	     title,
	     style: TextStyle(
	        decoration: done
		   ? TextDecoration.lineThrough
		   : TextDecoration.none,
		   color: done ? Colors.grey : Colors.black,
	     ),
	),
          subtitle: Text(
              subtitle,
               style: TextStyle(
               color: done ? Colors.grey : Colors.black,
              ),
          ),
          trailing: Icon(Icons.chevron_right),
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