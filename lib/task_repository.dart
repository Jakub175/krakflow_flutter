import 'package:flutter/material.dart';

class Task{
  final String title;
  final String deadline;
  bool done;
  Task({required this.title, required this.deadline, this.done = false,});
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