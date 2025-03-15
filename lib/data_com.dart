import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

import 'model/customer.dart';
import 'model/message.dart';

final Logger _logger = Logger('DataCom');

Future<void> submitData(
    BuildContext context,
    Customer customer,
    Message message,
    Function(String?) onSuccess,
    Function(String?) onError) async {

  _logger.info('[M] SUBMIT button pressed');
  _logger.info('[M] BEFORE Customer: [$customer]');
  _logger.info('[M] BEFORE Message:  [$message]');

  final Map<String, dynamic> requestBody = {
    'customerEmail': customer.email,
    'emails': message.emails.join(','),
    'content': message.content,
    'maturedAt': message.maturedAt,
  };

  try {
    final response = await http.post(
      Uri.parse('http://localhost:8883/api/v1/message'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body:jsonEncode(requestBody),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final String data = responseBody['data'];
      _logger.info('[M] Data received: [$data]');
      message.status = 'saved';

      final DateTime finalMaturedDate = DateTime.fromMillisecondsSinceEpoch(message.maturedAt);
      final String formattedDate = DateFormat('yyyy-MM-dd').format(finalMaturedDate);
      onSuccess("Your prediction is saved and you'll get a notification by email on $formattedDate");
      _logger.info('[M] 1 AFTER Customer: [$customer]');
      _logger.info('[M] 1 AFTER Message:  [$message]');
      _logger.info('[M] 1 Done.');
    } else {
      _logger.info('[M] Failed to submit data. Status: ${response.statusCode}');
      _logger.info('[M] Failed to submit data. Response: ${response.body}');
      _logger.info('[M] 2 AFTER Customer: [$customer]');
      _logger.info('[M] 2 AFTER Message:  [$message]');
      _logger.info('[M] 2 Done.');
      onError(response.body);
    }
  } catch (e) {
    _logger.severe('[M] Exception occurred: $e');
    onError("An error occurred: [$e]");
    _logger.info('[M] 3 AFTER Customer: [$customer]');
    _logger.info('[M] 3 AFTER Message:  [$message]');
    _logger.info('[M] 3 Done.');
  }
}
