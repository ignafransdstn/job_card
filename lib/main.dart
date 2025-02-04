import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_card/features/login/data/repositories/job_code0_repository_impl.dart';
import 'package:job_card/features/login/domain/repositories/job_code0_repository.dart';
import 'package:job_card/features/login/domain/usecase/job_code0_usecase.dart';
import 'package:job_card/features/login/presentation/bloc/job_code0_cubit.dart';
import 'package:job_card/features/login/presentation/pages/wo_task_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'features/login/data/repositories/login_repository_impl.dart';
import 'features/login/data/repositories/job_search_repository_impl.dart';
import 'features/login/data/repositories/task_list_repository_impl.dart';
import 'features/login/domain/usecase/login_usecase.dart';
import 'features/login/domain/usecase/wo_task_usecase.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/login/presentation/bloc/job_search_cubit.dart';
import 'features/login/presentation/bloc/task_list_cubit.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'features/login/presentation/pages/next_page.dart';
import 'features/login/presentation/pages/jobSearch_page.dart';
import 'features/login/presentation/state/user_session_provider.dart';

void main() {
  final httpClient = http.Client();

  final loginRepository = LoginRepositoryImpl(httpClient);
  final jobSearchRepository = JobSearchRepositoryImpl(httpClient);
  final taskListRepository = WoTaskRepositoryImpl(httpClient);
  final jobCode0Repository = JobCode0RepositoryImpl(httpClient);

  final loginUseCase = LoginUseCase(loginRepository);
  final fetchWoTasksUseCase = FetchWoTasksUseCase(taskListRepository);
  final fetchJobCode0UseCase = JobCode0Usecase(jobCode0Repository as JobCode0Repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSession()),
        RepositoryProvider.value(value: jobSearchRepository),
        RepositoryProvider.value(value: taskListRepository),
        RepositoryProvider.value(value: jobCode0Repository),
        BlocProvider(create: (_) => LoginCubit(loginUseCase)),
      ],
      child: MyApp(
        fetchWoTasksUseCase: fetchWoTasksUseCase,
        fetchJobCode0UseCase: fetchJobCode0UseCase,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FetchWoTasksUseCase? fetchWoTasksUseCase;
  final JobCode0Usecase? fetchJobCode0UseCase;

  const MyApp({
    super.key,
    required this.fetchWoTasksUseCase,
    required this.fetchJobCode0UseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Job Card',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case '/nextPage':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => NextPage(responseValue: args['responseValue']),
            );
          case '/jobSearchPage':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => JobSearchCubit(
                  RepositoryProvider.of<JobSearchRepositoryImpl>(context),
                )..fetchJobSearch(
                    username: args['username'],
                    password: args['password'],
                    position: args['position'],
                    district: args['district'],
                    originator: args['originator'],
                    workOrder: args['workOrder'],
                    workOrderSearchMethod: args['workOrderSearchMethod'],
                    woStatusM: args['woStatusM'],
                  ),
                child: JobSearchPage(
                  district: args['district'],
                  originator: args['originator'],
                  workOrder: args['workOrder'],
                  username: '',
                  password: '',
                  position: '',
                ),
              ),
            );
          case '/woTaskPage':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => WoTaskCubit(
                      RepositoryProvider.of<WoTaskRepositoryImpl>(context),
                    )..fetchWoTasks(
                        username: args['username'],
                        password: args['password'],
                        position: args['position'],
                        district: args['district'],
                        workOrder: args['workOrder'],
                        districtCode: args['districtCode'],
                      ),
                  ),
                  BlocProvider(
                    create: (_) => JobCode0Cubit(
                      RepositoryProvider.of<JobCode0RepositoryImpl>(context),
                    )..fatchJobCode0(
                        username: args['username'],
                        password: args['password'],
                        position: args['position'],
                        district: args['district'],
                      ),
                  ),
                ],
                child: WoTaskPage(
                  username: args['username'],
                  password: args['password'],
                  position: args['position'],
                  district: args['district'],
                  workOrder: args['workOrder'],
                  districtCode: args['districtCode'],
                ),
              ),
            );
          default:
            return MaterialPageRoute(builder: (_) => LoginPage());
        }
      },
    );
  }
}