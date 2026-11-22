import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:taskflow/app/taskflow_app.dart';
import 'package:taskflow/features/tasks/data/local_task_repository.dart';
import 'package:taskflow/features/tasks/presentation/tasks_view_model.dart';

void main() {
  testWidgets('Cambiar el estado de una tarea actualiza el detalle',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<TasksViewModel>(
        create: (_) => TasksViewModel(LocalTaskRepository())..loadTasks(),
        child: const TaskFlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);

    await tester.tap(find.text('Crear pantalla de bienvenida'));
    await tester.pumpAndSettle();

    expect(find.text('Estado: completada'), findsOneWidget);

    await tester.tap(find.text('Marcar como pendiente'));
    await tester.pump();

    expect(find.text('Estado: pendiente'), findsOneWidget);

    await tester.tap(find.text('Volver al listado'));
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
  });
}
