import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'task_card.dart';
import 'tasks_view_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TasksViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
              ? Center(child: Text(viewModel.errorMessage!))
              : viewModel.tasks.isEmpty
                  ? const Center(child: Text('No hay tareas para mostrar.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: viewModel.tasks.length,
                      itemBuilder: (context, index) {
                        final task = viewModel.tasks[index];
                        return TaskCard(
                          task: task,
                          onTap: () => context.push('/task/${task.id}'),
                        );
                      },
                    ),
    );
  }
}
