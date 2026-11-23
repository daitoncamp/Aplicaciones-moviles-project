HEAD
# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Aplicaciones-moviles-project
 3060d3181da83565d664e0be8cb72b9c2650b9a5







## Alcance de TaskFlow

Problema: necesito organizar mis actividades académicas y saber cuáles me faltan por entregar.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
- Lista: tarjetas de tareas y acción para crear.
- Detalle: información completa y futuras acciones de editar o eliminar.
- Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
- La navegación debe tener textos comprensibles.
- Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos
| Método | Ruta | Operación |
|--------|------|-----------|
| GET | /tasks | listar tareas |
| GET | /tasks/:id | consultar detalle |
| POST | /tasks | crear tarea |
| PATCH | /tasks/:id | actualizar tarea |
| DELETE | /tasks/:id | eliminar tarea |

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.

## API de tareas

TaskFlow consulta las tareas con una petición HTTP GET a una API pública de práctica (JSONPlaceholder).

- URL exacta: `https://jsonplaceholder.typicode.com/todos?userId=2`
- Parámetro `userId`: filtra las tareas de un solo usuario. Está definido como constante en `TaskApiService` y se eligió el usuario 2.
- Campos que llegan de la API: `userId`, `id`, `title` y `completed`.
- Valores que TaskFlow completa por defecto: `description` = "Sin descripción (API)" y `priority` = "Sin prioridad (API)", porque la API no los entrega. `completed` se guarda como `isCompleted`.
- Marcar una tarea como completada es un cambio solo local, en memoria. La API de práctica no guarda cambios, así que al reiniciar la app vuelve al valor original.
- Flujo: `TaskApiService` (Dio, HTTP) → `RemoteTaskRepository` → `TasksViewModel` → pantallas con Provider.


## Estados de la lista

La lista de tareas distingue cuatro situaciones. Así se provoca cada una:

| Estado | Qué se ve | Cómo provocarlo |
|--------|-----------|-----------------|
| Carga | Indicador circular | Abrir la app o pulsar Actualizar; con red lenta se ve más tiempo |
| Éxito | Tarjetas de tareas del usuario 2 | Abrir la app con internet |
| Vacío | "Todavía no hay tareas para mostrar." y botón Actualizar | Cambiar temporalmente `userId` a 9999 en `TaskApiService` y reiniciar la app |
| Error | "No se pudieron cargar las tareas." y botón Reintentar | Apagar WiFi y datos del celular y pulsar Actualizar |

Reintentar: con el error en pantalla, volver a activar internet y pulsar **Reintentar**; la lista regresa sin reiniciar la app.

Vacío y error son distintos: una lista vacía es una respuesta válida de la API, y un error significa que no se pudo obtener la respuesta. Al actualizar, la marca local de "completada" se pierde porque se vuelve a leer el servidor.
