import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_card/features/login/data/repositories/job_code0_repository_impl.dart';
import 'package:job_card/features/login/domain/entities/job_code0_request.dart';

class JobCode0State {
  final bool isLoading;
  final List<Map<String, String>> jobCode0Details;
  final String? errorMessage;

  JobCode0State({
    this.isLoading = false,
    this.jobCode0Details = const [],
    this.errorMessage,
  });
}

class JobCode0Cubit extends Cubit<JobCode0State> {
  final JobCode0RepositoryImpl repository;

  JobCode0Cubit(this.repository) : super(JobCode0State());

  Future<void> fatchJobCode0({
    required String username,
    required String password,
    required String position,
    required String district,
  }) async {
    emit(JobCode0State(isLoading: true));

    try {
      final results = await repository.fetchJobCode0(JobCode0Request(username: username, password: password, position: position, district: district));
      emit(JobCode0State(isLoading: false, jobCode0Details: results));
    } catch (e) {
      emit(JobCode0State(isLoading: false, errorMessage: e.toString()));
    }
  }
}