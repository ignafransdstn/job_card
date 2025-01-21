import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_card/features/login/domain/entities/task_list_request.dart';
import 'package:job_card/features/login/presentation/bloc/task_list_cubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:job_card/features/login/presentation/bloc/task_list_cubit.dart';
// import 'package:job_card/features/login/domain/entities/task_list_request.dart';
// import 'package:job_card/features/login/domain/entities/task_list_request.dart';
// import 'package:job_card/features/login/presentation/bloc/task_list_cubit.dart';
// import 'package:provider/provider.dart';
// import '../state/user_session_provider.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:job_card/features/login/presentation/bloc/task_list_cubit.dart';

class WoTaskPage extends StatelessWidget {
  final String username;
  final String password;
  final String position;
  final String district;
  final String workOrder;
  final String districtCode;

  const WoTaskPage({
    super.key,
    required this.username,
    required this.password,
    required this.district,
    required this.position,
    required this.workOrder,
    required this.districtCode,
  });

  final bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-JOB CARD'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<WoTaskCubit, WoTaskState>(
                      builder: (context, state) {
                    if (state.isLoading) {
                      return const CircularProgressIndicator();
                    } else if (state.errorMessage != null) {
                      return Center(
                        child: Text(
                          state.errorMessage ?? 'An error occurred',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state.task.isEmpty) {
                      return const Center(
                        child: Text('No tasks found.'),
                      );
                    }

                    return Column(
                      children: state.task.map((task) {
                        return Card(
                          color: Colors.blue.shade100,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            title: Text(
                                '${task['WOTaskNo']} - ${task['WOTaskDesc']}'),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {},
                          ),
                        );
                      }).toList(),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),

      // body: BlocBuilder<WoTaskCubit, WoTaskState>(builder: (context, state) {
      //   if (state.isLoading) {
      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   } else if (state.errorMessage != null) {
      //     return Center(
      //       child: Text(
      //         state.errorMessage ?? 'Terjadi kesalahan',
      //         style: const TextStyle(color: Colors.red),
      //         textAlign: TextAlign.center,
      //       ),
      //     );
      //   } else if (state.task.isEmpty) {
      //     return const Center(
      //       child: Text('No result found'),
      //     );
      //   }

      //   return ListView.builder(
      //       itemCount: state.task.length, itemBuilder: (context, index) {
      //         final taskNo = state.task[index];
      //         return Card(
      //           margin: const EdgeInsets.all(8.0),
      //           child: ListTile(
      //             title: Text('Task No: ${taskNo ['WOTaskNo']}'),
      //             subtitle: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text('Description: ${taskNo['WOTaskDesc']}')
      //               ],
      //             ),
      //           ),
      //         );
      //       });
      // }),
    );
  }
}
