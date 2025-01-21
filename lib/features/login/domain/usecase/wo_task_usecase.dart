import 'package:job_card/features/login/domain/entities/task_list_request.dart';
import 'package:job_card/features/login/domain/repositories/task_list_repository.dart';

class FetchWoTasksUseCase {
  final WoTaskRepository repository;

  FetchWoTasksUseCase(this.repository);

  Future<List<Map<String, String>>> execute(WoTaskRequest request) {
    return repository.fetchWoTasks(request);
  }
}