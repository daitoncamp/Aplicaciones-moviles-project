import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'task_card.dart';
import 'task_form_screen.dart';
import 'tasks_view_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TasksViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            tooltip: 'Actualizar tareas',
            onPressed: viewModel.isLoading
                ? null
                : () => context.read<TasksViewModel>().loadTasks(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(context, viewModel),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final draft = await context.push<TaskDraft>('/new');
          if (!context.mounted || draft == null) return;
          final dueDate = draft.dueDate;
          final dateText = dueDate == null
              ? 'sin fecha límite'
              : 'límite ${dueDate.day.toString().padLeft(2, '0')}/'
                    '${dueDate.month.toString().padLeft(2, '0')}/${dueDate.year}';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Formulario válido: ${draft.title} · ${draft.priority} · $dateText',
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TasksViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48),
            const SizedBox(height: 12),
            Text(viewModel.errorMessage!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<TasksViewModel>().loadTasks(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    if (viewModel.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 48),
            const SizedBox(height: 12),
            const Text('Todavía no hay tareas para mostrar.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<TasksViewModel>().loadTasks(),
              child: const Text('Actualizar'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<TasksViewModel>().loadTasks(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
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
