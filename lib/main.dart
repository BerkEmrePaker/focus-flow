import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _textFieldController = TextEditingController();

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todos.add(TodoItem(
          title: task,
          isCompleted: false,
        ));
      });
      _textFieldController.clear();
    }
  }

  void _deleteTodoItem(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleTodoComplete(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  Future<void> _displayAddTodoDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new task'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Enter task here'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _addTodoItem(_textFieldController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          if (_todos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _todos.removeWhere((todo) => todo.isCompleted);
                });
              },
              tooltip: 'Remove completed',
            ),
        ],
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                'No todos yet. Add one by tapping the + button!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_todos[index].title),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    _deleteTodoItem(index);
                  },
                  child: CheckboxListTile(
                    title: Text(
                      _todos[index].title,
                      style: _todos[index].isCompleted
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    value: _todos[index].isCompleted,
                    onChanged: (bool? value) {
                      _toggleTodoComplete(index);
                    },
                    secondary: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteTodoItem(index);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddTodoDialog(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem {
  String title;
  bool isCompleted;

  TodoItem({
    required this.title,
    required this.isCompleted,
  });
}