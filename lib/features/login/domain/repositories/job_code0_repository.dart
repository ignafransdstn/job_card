import 'package:job_card/features/login/domain/entities/job_code0_request.dart';

abstract class JobCode0Repository {
  Future<List<Map<String, String>>> fetchJobCode0(JobCode0Request request);
}