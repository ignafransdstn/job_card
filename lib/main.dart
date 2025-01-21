import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_card/features/login/presentation/pages/wo_task_page.dart';
// import 'package:job_card/features/login/domain/entities/task_list_request.dart';
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
// import 'features/login/presentation/pages/wo_task_page.dart';
import 'features/login/presentation/state/user_session_provider.dart';

void main() {
  // Initialize dependencies
  final httpClient = http.Client();

  // Repositories
  final loginRepository = LoginRepositoryImpl(httpClient);
  final jobSearchRepository = JobSearchRepositoryImpl(httpClient);
  final taskListRepository = WoTaskRepositoryImpl(httpClient);

  // Use Cases
  final loginUseCase = LoginUseCase(loginRepository);
  final fetchWoTasksUseCase = FetchWoTasksUseCase(taskListRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSession()),
        RepositoryProvider.value(value: jobSearchRepository),
        RepositoryProvider.value(value: taskListRepository),
        BlocProvider(create: (_) => LoginCubit(loginUseCase)),
        // BlocProvider(create: (_) => WoTaskCubit(fetchWoTasksUseCase)),
      ],
      child: MyApp(
        fetchWoTasksUseCase: fetchWoTasksUseCase,
        jobSearchRepository: null,
        loginUseCase: null,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FetchWoTasksUseCase? fetchWoTasksUseCase;

  const MyApp(
      {super.key,
      required this.fetchWoTasksUseCase,
      required jobSearchRepository,
      required loginUseCase});

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
              builder: (_) => BlocProvider(
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
                child: const WoTaskPage(
                  username: '',
                  password: '',
                  position: '',
                  district: '',
                  workOrder: '',
                  districtCode: '',
                ),
              ),
            );

          // case '/woTaskPage':
          //   final args = settings.arguments;

          //   if (args == null || args is! Map<String, dynamic>) {
          //     print('Error: Invalid arguments in main.dart for WoTaskPage');
          //     return MaterialPageRoute(
          //       builder: (_) => Scaffold(
          //         appBar: AppBar(title: const Text('Error')),
          //         body: const Center(
          //           child: Text(
          //             'Invalid arguments. Please go back and try again.',
          //             style: TextStyle(color: Colors.red),
          //           ),
          //         ),
          //       ),
          //     );
          //   }

          //   print('Arguments received in main.dart for WoTaskPage: $args');
          //   return MaterialPageRoute(
          //     builder: (_) => BlocProvider(
          //       create: (_) => WoTaskCubit(fetchWoTasksUseCase!),
          //       child: const WoTaskPage(),
          //     ),
          //   );

          // case '/woTaskPage':
          //   final args = settings.arguments;
          //   // final workOrder = args?['workOrder'] ?? 'Unknown Work Order';

          //   print('Building WoTaskPage with arguments: $args');

          //   return MaterialPageRoute(
          //     builder: (_) => BlocProvider(
          //       create: (_) => WoTaskCubit(fetchWoTasksUseCase!),
          //         // ..fetchWoTasks(WoTaskRequest(
          //         //   username: args?['username'] ?? '',
          //         //   password: args?['password'] ?? '',
          //         //   position: args?['position'] ?? '',
          //         //   district: args?['district'] ?? '',
          //         //   workOrder: workOrder,
          //         //   districtCode: args?['districtCode'] ?? '',
          //         // )),
          //       child: const WoTaskPage(),
          //     ),
          //   );

          // case '/woTaskPage':
          //   final args = settings.arguments as Map<String, dynamic>?;
          //   if (args == null || args['workOrder'] == null) {
          //     print('Error: arguments or workOrder is null');
          //   } else {
          //     print(
          //         'Navigating to WoTaskPage with workOrder: ${args['workOrder']}');
          //   }
          //   final workOrder = args?['workOrder'] ?? 'Unknown Work Order';
          //   return MaterialPageRoute(
          //     builder: (_) => BlocProvider(
          //       create: (_) => WoTaskCubit(fetchWoTasksUseCase!)
          //         ..fetchWoTasks(WoTaskRequest(
          //           username: args?['username'] ?? '',
          //           password: args?['password'] ?? '',
          //           position: args?['position'] ?? '',
          //           district: args?['district'] ?? '',
          //           workOrder: workOrder,
          //           // workOrder: args['workOrder'],
          //           districtCode: args?['districtCode'],
          //         )),
          //       child: const WoTaskPage(),
          //     ),
          //   );
          default:
            return MaterialPageRoute(builder: (_) => LoginPage());
        }
      },
    );
  }
}
