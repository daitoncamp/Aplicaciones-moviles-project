import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Crear pantalla de bienvenida',
      description: 'Mostrar saludo, mensaje motivacional e icono',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 2,
      title: 'Agregar estado de tareas',
      description: 'Usar setState para agregar y completar tareas',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 3,
      title: 'Mostrar listado local de tareas',
      description: 'Construir TaskCard con ListView.builder',
      priority: 'Media',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 4,
      title: 'Navegar entre listado y detalle',
      description: 'Configurar go_router con la ruta /task/:id',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 5,
      title: 'Definir alcance y modelo de TaskFlow',
      description: 'Escribir el README con historias y contrato de API',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
  ];

  @override
  List<Task> getTasks() => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
