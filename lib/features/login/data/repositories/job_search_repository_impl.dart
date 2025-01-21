import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:job_card/features/login/domain/entities/job_search_request.dart';
import 'package:job_card/features/login/domain/repositories/job_search_repository.dart';

class JobSearchRepositoryImpl implements JobSearchRepository {
  final http.Client client;

  JobSearchRepositoryImpl(this.client);

  @override
  Future<List<Map<String, String>>> jobSearch(JobSearchRequest request) async {
    final url = Uri.parse('http://10.70.0.41:5229/api/JobsSearch'); //http://10.70.0.41:5229/api/JobsSearch

    // Siapkan body request
    final requestBody = jsonEncode({
      "username": request.username,
      "password": request.password,
      "position": request.position,
      "district": request.district,
      "workOrder": request.workOrder,
      "originatorId": request.originatorId,
      "workOrderSearchMethod": request.workOrderSearchMethod,
      "woStatusM": request.woStatusM,
    });

    try {
      // Debugging log untuk body request
      print('Request URL: $url');
      print('Request Headers: {"Content-Type": "application/json"}');
      print('Request Body: $requestBody'); // Log body sebelum request dikirim

      // Kirim permintaan HTTP
      final response = await client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      // Tambahkan debugging log
      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      // Cek jika respons berupa JSON
      if (response.headers['content-type']?.contains('application/json') ==
              true ||
          response.headers['content-type']
                  ?.contains('application/problem+json') ==
              true) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        final jsonData = jsonResponse['data'] as List;
        return jsonData.map((item) {
          return {
            "workOrder": item['workOrder']?.toString() ?? '',
            "equipment": item['data1732']?.toString() ?? '',
            "description": item['woDesc']?.toString() ?? '',
          };
        }).toList();
      }

      // Jika respons berupa XML
      if (response.headers['content-type']?.contains('xml') == true ||
          response.headers['content-type']?.contains('text/plain') == true) {
        final document = xml.XmlDocument.parse(response.body);

        final workOrders = document
            .findAllElements('ns2:workOrder')
            .map((node) => node.text)
            .toList();
        final equipments = document
            .findAllElements('ns2:data1732')
            .map((node) => node.text)
            .toList();
        final descriptions = document
            .findAllElements('ns2:woDesc')
            .map((node) => node.text)
            .toList();

        final List<Map<String, String>> results = [];
        for (int i = 0; i < workOrders.length; i++) {
          results.add({
            "workOrder": workOrders[i],
            "equipment": equipments.length > i ? equipments[i] : '',
            "description": descriptions.length > i ? descriptions[i] : '',
          });
        }
        return results;
      }

      // Jika content-type tidak dikenali
      throw Exception(
        'Unexpected content-type: ${response.headers['content-type']}',
      );
    } catch (e) {
      print('Error occurred: $e'); // Tambahkan log error
      throw Exception('An error occurred while fetching JobSearch data: $e');
    }
  }
}
