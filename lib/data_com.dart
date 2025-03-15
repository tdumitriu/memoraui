import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

import 'customer.dart';
import 'message.dart';

final Logger _logger = Logger('DataCom');

int convertTimePeriodToMonths(String timePeriod) {
  switch (timePeriod) {
    case '1 month':
      return 1;
    case '3 months':
      return 3;
    case '60 months':
      return 60;
    case '1 year':
      return 12;
    case '2 years':
      return 24;
    case '3 years':
      return 36;
    default:
      throw ArgumentError('Invalid time period: $timePeriod');
  }
}

DateTime addMonthsToDate(int months) {
  DateTime today = DateTime.now();
  return DateTime(today.year, today.month + months, today.day);
}

Future<void> submitData(
    BuildContext context,
    TextEditingController customerEmailController,
    TextEditingController emailsController,
    TextEditingController contentController,
    Customer customer,
    Message message,
    DateTime? selectedDate,
    String? selectedTimePeriod,
    Function(String?) onEmailSubmitted,
    Function(String?) onSuccess,
    Function(String?) onError) async {
  final String customerEmail = customerEmailController.text;
  final String emails = emailsController.text;
  final String content = contentController.text;

  _logger.info('[M] Before: Customer: [$customer]');

  if (customer.id == 0) {
    _logger.info('[M] Calling the server...');

    final Map<String, dynamic> requestBody = {
      'customerId': 0,
      'customerEmail': customerEmail,
      'emails': emails,
      'content': content,
    };

    var maturedAt = 0;
    if (selectedDate == null && selectedTimePeriod != null) {
      int numberOfMonths = convertTimePeriodToMonths(selectedTimePeriod);
      DateTime selectedPredefinedDate = addMonthsToDate(numberOfMonths);
      maturedAt = selectedPredefinedDate.millisecondsSinceEpoch;
    } else {
      DateTime selectedSafeDate = (selectedDate ?? DateTime.now().add(Duration(days: 3)));
      maturedAt = selectedSafeDate.millisecondsSinceEpoch;
    }
    requestBody['maturedAt'] = maturedAt;
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
        message.id = data as int;

        final DateTime finalMaturedDate = DateTime.fromMillisecondsSinceEpoch(maturedAt);
        final String formattedDate = DateFormat('yyyy-MM-dd').format(finalMaturedDate);
        onSuccess("Your prediction is saved and you'll get a notification by email on $formattedDate");
      } else {
        _logger.info('[M] Failed to submit data. Status: ${response.statusCode}');
        _logger.info('[M] Failed to submit data. Response: ${response.body}');
        onError(response.body);
      }
    } catch (e) {
      _logger.severe('[M] Exception occurred: $e');
      onError("An error occurred: [$e]");
    }
  } else {
    // final customerEmail = CustomerEmail(context, (email) {
    //   onEmailSubmitted(email);
    // });
    // await customerEmail.showEmailDialog();
    _logger.info('[M] Customer: $customer');
  }
}
