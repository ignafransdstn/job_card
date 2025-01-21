import 'package:job_card/features/login/domain/entities/job_search_request.dart';

abstract class JobSearchRepository {
  Future<List<Map<String, String>>> jobSearch(JobSearchRequest request);
}