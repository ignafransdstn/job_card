import 'package:job_card/features/login/domain/entities/job_search_request.dart';
import 'package:job_card/features/login/domain/repositories/job_search_repository.dart';

class JobSearchUseCase {
  final JobSearchRepository repository;

  JobSearchUseCase(this.repository);

  Future<List<Map<String, String>>> execute(JobSearchRequest request) {
    return repository.jobSearch(request);
  }
}