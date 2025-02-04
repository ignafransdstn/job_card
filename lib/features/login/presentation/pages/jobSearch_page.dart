import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_card/features/login/domain/entities/task_list_request.dart';
import 'package:job_card/features/login/presentation/bloc/job_code0_cubit.dart';
import 'package:job_card/features/login/presentation/bloc/task_list_cubit.dart';
// import 'package:job_card/features/login/domain/entities/task_list_request.dart';
// import 'package:job_card/features/login/presentation/bloc/task_list_cubit.dart';
import '../bloc/job_search_cubit.dart';
import 'package:provider/provider.dart';
import 'package:job_card/features/login/presentation/state/user_session_provider.dart';

class JobSearchPage extends StatelessWidget {
  final String username;
  final String password;
  final String position;
  final String district;
  final String originator;
  final String workOrder;

  JobSearchPage({
    super.key,
    required this.username,
    required this.password,
    required this.position,
    required this.district,
    required this.originator,
    this.workOrder = '',
  });

  bool _isNavigating = false; // Pindahkan ke level class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Job'),
      ),
      body: BlocBuilder<JobSearchCubit, JobSearchState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage != null) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Terjadi kesalahan',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (state.jobDetails.isEmpty) {
            return const Center(
              child: Text('No results found.'),
            );
          }

          return ListView.builder(
            itemCount: state.jobDetails.length,
            itemBuilder: (context, index) {
              final job = state.jobDetails[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                    title: Text('WO Number: ${job['workOrder']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Equipment: ${job['equipment']}'),
                        Text('Description: ${job['description']}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      if (_isNavigating) return; // Cegah navigasi ganda
                      _isNavigating = true;

                      final userSession =
                          Provider.of<UserSession>(context, listen: false);

                      final selectedWorkOrder = job['workOrder'] ?? '';
                      Navigator.pushNamed(
                        context,
                        '/woTaskPage',
                        arguments: {
                          'workOrder': selectedWorkOrder,
                          'username': userSession.username,
                          'password': userSession.password,
                          'position': userSession.position,
                          'district': userSession.district,
                          'districtCode':
                              userSession.districtCode ?? userSession.district,
                        },
                      ).then((_) {
                        _isNavigating =
                            false; // Reset flag setelah navigasi selesai
                      });

                      print('Navigating to WoTaskPage with arguments: {'
                          'workOrder: $selectedWorkOrder, '
                          'username: ${userSession.username}, '
                          'password: ${userSession.password}, '
                          'position: ${userSession.position}, '
                          'district: ${userSession.district}, '
                          'districtCode: ${userSession.districtCode ?? userSession.district}'
                          '}');

                      print('Navigating to WoTaskPage...');
                    }
                    
                    ),
              );
            },
          );
        },
      ),
    );
  }
}
