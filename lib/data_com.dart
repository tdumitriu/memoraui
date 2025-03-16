import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

import 'model/MessageResponse.dart';
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
      final Map<String, dynamic> responseData = responseBody['data'];
      final String action = responseData['action'];
      _logger.info('[M] Saving status: [$action]');
      message.status = 'saved';

      final DateTime finalMaturedDate = DateTime.fromMillisecondsSinceEpoch(message.maturedAt);
      final String formattedDate = DateFormat('yyyy-MM-dd').format(finalMaturedDate);

      if(action == 'Insert') {
        onSuccess("Your prediction is saved and you'll get a notification by email on $formattedDate");
      } else if (action == 'Update') {
        onSuccess("Your prediction is updated and you'll get a notification by email on $formattedDate");
      } else if (action == 'First') {
        onSuccess("Your prediction is saved but you need to activate your account in order to be notified by email on $formattedDate. Check your email for the activation link.");
      } else {
        onError("An error occurred: $action");
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final String errorMessage = responseBody['message'];
      if (errorMessage.contains("is not active")) {
        onError("Your account is not activated. Please check your email for the activation link.");
      } else {
        onError(response.body);
      }
    }
  } catch (e) {
    _logger.severe('[M] Exception occurred: $e');
    onError("An error occurred: [$e]");
  }
}
