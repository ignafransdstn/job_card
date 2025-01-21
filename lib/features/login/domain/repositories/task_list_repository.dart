import 'package:job_card/features/login/domain/entities/task_list_request.dart';

abstract class WoTaskRepository {
  Future<List<Map<String, String>>> fetchWoTasks(WoTaskRequest request);
}