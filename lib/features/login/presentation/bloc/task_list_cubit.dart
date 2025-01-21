import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_card/features/login/data/repositories/task_list_repository_impl.dart';
import 'package:job_card/features/login/domain/entities/task_list_request.dart';
// import 'package:job_card/features/login/domain/usecase/wo_task_usecase.dart';

class WoTaskState {
  final bool isLoading;
  final List<Map<String, String>> task;
  final String? errorMessage;

  WoTaskState({
    this.isLoading = false,
    this.task = const [],
    this.errorMessage,
  });
}

class WoTaskCubit extends Cubit<WoTaskState> {
  final WoTaskRepositoryImpl useCase;

  WoTaskCubit(this.useCase) : super(WoTaskState());

  Future<void> fetchWoTasks({
    required String username,
    required String password,
    required String position,
    required String district,
    required String workOrder,
    required String districtCode,
  }) async {
    emit(WoTaskState(isLoading: true));

    try {
      final results = await useCase.fetchWoTasks(WoTaskRequest(
          username: username,
          password: password,
          position: position,
          district: district,
          workOrder: workOrder,
          districtCode: districtCode));
      emit(WoTaskState(isLoading: false, task: results));
    } catch (e) {
      emit(WoTaskState(isLoading: false, errorMessage: e.toString()));
    }
  }

  // bool _isFetching = false;

  // Future<void> fetchWoTasks(WoTaskRequest request) async {
  //   if (_isFetching) {
  //     print('fetchWoTasks already in progress...');
  //     return;
  //   }
  //   _isFetching = true;

  //   emit(WoTaskState(isLoading: true));
  //   try {
  //     final taskList = await useCase.execute(request);
  //     print('Fetched Tasks: $taskList');
  //     emit(WoTaskState(isLoading: false, task: taskList));
  //   } catch (e) {
  //     emit(WoTaskState(isLoading: false, errorMessage: e.toString()));
  //   } finally {
  //     _isFetching = false;
  //   }
  // }
}


// class WoTaskCubit extends Cubit<WoTaskState> {
//   final FetchWoTasksUseCase useCase;

//   WoTaskCubit(this.useCase) : super(WoTaskState());

//   Future<void> fetchWoTasks(WoTaskRequest request) async {
//     emit(WoTaskState(isLoading: true));

//     try {
//       final task = await useCase.execute(request);

//       emit(WoTaskState(isLoading: false, task: task));
//     } catch (e) {
//       emit(WoTaskState(isLoading: false, errorMessage: e.toString()));
//     }
//   }
// }
