import 'package:job_card/features/login/domain/entities/job_code0_request.dart';
import 'package:job_card/features/login/domain/repositories/job_code0_repository.dart';

class JobCode0Usecase {
  final JobCode0Repository repository;

  JobCode0Usecase(this.repository);

  Future<List<Map<String, String>>> execute(JobCode0Request request) {
    return repository.JobCode0(request);
  }
}