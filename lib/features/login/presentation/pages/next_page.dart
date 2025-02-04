import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/user_session_provider.dart';

class NextPage extends StatefulWidget {
  final String responseValue;

  const NextPage({
    super.key,
    required this.responseValue,
  });

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  final TextEditingController _originatorController = TextEditingController();
  final TextEditingController _workOrderController = TextEditingController();
  String? _selectedDistrict;

  String workOrderSearchMethod = '';
  String woStatusM = '';

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Username (Read-only)
            TextField(
              controller: TextEditingController(text: userSession.username),
              decoration: const InputDecoration(labelText: 'Username'),
              readOnly: true,
            ),
            // Position (Read-only)
            TextField(
              controller: TextEditingController(text: userSession.position),
              decoration: const InputDecoration(labelText: 'Position'),
              readOnly: true,
            ),
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              decoration: const InputDecoration(labelText: 'District'),
              items: const [
                DropdownMenuItem(value: 'BM03', child: Text('BM03')),
                DropdownMenuItem(value: 'BM06', child: Text('BM06')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDistrict = value;

                  final userSession =
                      Provider.of<UserSession>(context, listen: false);
                  if (value != null) {
                    userSession.setDistrict(value);
                    userSession.setDistrictCode(value);
                  }

                  print('Selected District: $value');
                  print(
                      'UserSession DistrictCode: ${userSession.districtCode}');
                });
              },
            ),
            const SizedBox(height: 10),
            // Originator
            TextField(
              controller: _originatorController,
              decoration: const InputDecoration(labelText: 'Originator'),
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    _workOrderController.clear();
                    workOrderSearchMethod = "EM";
                    woStatusM = "A";
                  } else {
                    workOrderSearchMethod = '';
                    woStatusM = '';
                  }
                });
              },
              enabled: _workOrderController.text.isEmpty,
            ),
            const SizedBox(height: 10),
            // Work Order
            TextField(
              controller: _workOrderController,
              decoration: const InputDecoration(labelText: 'Work Order'),
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    _originatorController.clear();
                    workOrderSearchMethod = "EX";
                    woStatusM = '';
                  } else {
                    workOrderSearchMethod = '';
                  }
                });
              },
              enabled: _originatorController.text.isEmpty,
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                final district = _selectedDistrict ?? '';
                final originator = _originatorController.text;
                final workOrder = _workOrderController.text;
                final userSession =
                    Provider.of<UserSession>(context, listen: false);

                userSession.setWorkOrder(workOrder);

                print('Selected District: $_selectedDistrict');
                print('UserSession DistrictCode: ${userSession.districtCode}');

                Navigator.pushNamed(
                  context,
                  '/jobSearchPage',
                  arguments: {
                    'username': userSession.username,
                    'password': userSession.password,
                    'position': userSession.position,
                    'district': district,
                    'districtCode': userSession.districtCode,
                    'originator': originator,
                    'workOrder': workOrder,
                    'workOrderSearchMethod': workOrderSearchMethod,
                    'woStatusM': woStatusM,
                  },
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
