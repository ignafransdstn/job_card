import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:job_card/features/login/domain/entities/task_list_request.dart';
import 'package:job_card/features/login/domain/repositories/task_list_repository.dart';

class WoTaskRepositoryImpl implements WoTaskRepository {
  final http.Client client;

  WoTaskRepositoryImpl(this.client);

  @override
  Future<List<Map<String, String>>> fetchWoTasks(WoTaskRequest request) async {
    final url = Uri.parse(
        'http://10.70.0.44:5229/api/WoTask'); //http://10.70.0.41:5229/api/WoTask

    // Siapkan request body
    final requestBody = jsonEncode({
      "username": request.username,
      "password": request.password,
      "position": request.position,
      "district": request.district,
      "workOrder": request.workOrder,
      "districtCode": request.districtCode,
    });

    try {
      print('Fetching WoTasks with parameters:');
      print('  Username: ${request.username}');
      print('  Password: ${request.password}');
      print('  Position: ${request.position}');
      print('  District: ${request.district}');
      print('  WorkOrder: ${request.workOrder}');
      print('  DistrictCode: ${request.districtCode}');

      // Debugging log untuk URL dan request body
      print('Request URL: $url');
      print('Request Headers: {"Content-Type": "application/json"}');
      print('Request Body Sent: $requestBody');

      // Kirim permintaan HTTP POST
      final response = await client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      // Debugging log untuk response
      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      // Jika respons berupa JSON
      if (response.headers['content-type']?.contains('application/json') ==
              true ||
          response.headers['content-type']
                  ?.contains('application/problem+json') ==
              true) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        final jsonData = jsonResponse['data'] as List;
        return jsonData.map((item) {
          return {
            "WOTaskNo": item['WOTaskNo']?.toString() ?? '',
            "WOTaskDesc": item['WOTaskDesc']?.toString() ?? '',
          };
        }).toList();
      }

      if (response.headers['content-type']?.contains('text/plain') == true ||
          response.headers['content-type']?.contains('xml') == true) {
        // Parsing SOAP response dari text/plain
        final document = xml.XmlDocument.parse(response.body);

        final taskNumbers = document
            .findAllElements('ns2:WOTaskNo')
            .map((node) => node.text)
            .toList();

        final taskDescriptions = document
            .findAllElements('ns2:WOTaskDesc')
            .map((node) => node.text)
            .toList();

        final List<Map<String, String>> results = [];
        for (int i = 0; i < taskNumbers.length; i++) {
          results.add({
            "WOTaskNo": taskNumbers[i],
            "WOTaskDesc":
                taskDescriptions.length > i ? taskDescriptions[i] : '',
          });
        }
        return results;
      }

      throw Exception(
        'Unexpected content-type: ${response.headers['content-type']}',
      );
    } catch (e) {
      // Debugging log error
      print('Error occurred: $e');
      throw Exception('An error occurred while fetching JobSearch data: $e');
    }
  }
}
