import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_card/features/login/domain/entities/job_code0_request.dart';
import 'package:job_card/features/login/domain/repositories/job_code0_repository.dart';
import 'package:xml/xml.dart' as xml;

class JobCode0RepositoryImpl implements JobCode0Repository{
  final http.Client client;

  JobCode0RepositoryImpl(this.client);

  @override
  Future<List<Map<String, String>>> fetchJobCode0(JobCode0Request request) async {
    final url = Uri.parse('http://10.70.0.44:5229/api/RetrieveW0');

    final requestBody = jsonEncode({
      "username": request.username,
      "password": request.password,
      "position": request.position,
      "district": request.district
    });

    try {
      print('Fetching JobCode0 with parameters:');
      print('  Username: ${request.username}');
      print('  Password: ${request.password}');
      print('  Position: ${request.position}');
      print('  District: ${request.district}');

      print('Request URL: $url');
      print('Request Headers: {"Content-Type": "application/json"}');
      print('Request Body Sent: $requestBody');

      final response = await client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.headers['content-type']?.contains('application/json') ==
              true ||
          response.headers['content-type']
                  ?.contains('application/problem+json') ==
              true) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        final jsonData = jsonResponse['data'] as List;
        return jsonData.map((item) {
          return {
            "tableCode": item['tableCode']?.toString() ?? '',
            "codeDescription": item['codeDescription']?.toString() ?? '',
          };
        }).toList();
      }

      if (response.headers['content-type']?.contains('text/plain') == true ||
          response.headers['content-type']?.contains('xml') == true) {
        final document = xml.XmlDocument.parse(response.body);

        final code0Numbers = document
            .findAllElements('ns1:tableCode')
            .map(
              (node) => node.text,
            )
            .toList();

        final code0Descriptions = document
            .findAllElements('ns1:codeDescription')
            .map((node) => node.text)
            .toList();

        final List<Map<String, String>> results = [];
        for (int i = 0; i < code0Numbers.length; i++) {
          results.add({
            "tableCode": code0Numbers[i],
            "codeDescription":
                code0Descriptions.length > i ? code0Descriptions[i] : '',
          });
        }
        return results;
      }

      throw Exception(
        'Unexpected content-type: ${response.headers['content-type']}',
      );
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('An error occurred while fetching JobSearch data: $e');
    }
  }
}
