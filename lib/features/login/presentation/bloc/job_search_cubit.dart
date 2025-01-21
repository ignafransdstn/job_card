import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_card/features/login/domain/entities/job_search_request.dart';
import 'package:job_card/features/login/data/repositories/job_search_repository_impl.dart';

class JobSearchState {
  final bool isLoading;
  final List<Map<String, String>> jobDetails; // Data berbentuk List<Map<String, String>>
  final String? errorMessage; // Pesan error jika ada masalah

  JobSearchState({
    this.isLoading = false,
    this.jobDetails = const [],
    this.errorMessage,
  });
}

class JobSearchCubit extends Cubit<JobSearchState> {
  final JobSearchRepositoryImpl repository;

  JobSearchCubit(this.repository) : super(JobSearchState());

  Future<void> fetchJobSearch({
    required String username,
    required String password,
    required String position,
    required String district,
    required String originator,
    required String workOrder,
    required String workOrderSearchMethod,
    required String woStatusM
  }) async {
    emit(JobSearchState(isLoading: true));

    try {
      // Panggil repository dan pastikan mengembalikan List<Map<String, String>>
      final results = await repository.jobSearch(JobSearchRequest(
        username: username,
        password: password,
        position: position,
        district: district,
        originatorId: originator,
        workOrder: workOrder,
        workOrderSearchMethod: workOrderSearchMethod,
        woStatusM: woStatusM
      ));

      emit(JobSearchState(isLoading: false, jobDetails: results));
    } catch (e) {
      emit(JobSearchState(isLoading: false, errorMessage: e.toString()));
    }
  }
}
