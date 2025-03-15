import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'model/customer.dart';
import 'model/message.dart';
import 'data_com.dart';
import 'package:intl/intl.dart';
import 'util/time_util.dart';

class MemoraHomePage extends StatefulWidget {
  const MemoraHomePage({super.key, required this.title});
  final String title;

  @override
  State<MemoraHomePage> createState() => _MemoraHomePageState();
}

class _MemoraHomePageState extends State<MemoraHomePage> {
  final Logger _logger = Logger('_MemoraHomePageState');
  final TextEditingController _customerEmailController = TextEditingController();
  final TextEditingController _emailsController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final Customer _customer = Customer();
  final Message _message = Message();
  DateTime? _selectedDate;
  String? _successMessage;
  String? _errorMessage;

  final List<String> _timePeriods = ['1 month', '3 months', '60 months', '1 year', '2 years', '3 years'];
  String? _selectedTimePeriod;

  @override
  void initState() {
    super.initState();
    _logger.info('Memora started');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_successMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _successMessage!,
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            const Text('What is your prediction:'),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter text',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            SizedBox(height: 10),
            const Text('When will it come true?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  hint: const Text('Select period'),
                  value: _selectedTimePeriod,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTimePeriod = newValue;
                      _selectedDate = null; // Reset the date picker
                    });
                  },
                  items: _timePeriods.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                const Text(' or '),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(Duration(days: 1)),
                      firstDate: DateTime.now().add(Duration(days: 1)),
                      lastDate: DateTime.now().add(Duration(days: 11957)),  // 30 years from now
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                        _selectedTimePeriod = null; // Reset the combobox
                      });
                    }
                  },
                  child: Text(
                    _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Pick a date',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            const Text('What is your email?'),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                controller: _customerEmailController,
                maxLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your email',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            SizedBox(height: 10),
            const Text('Who do you want to let know about this?'),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                controller: _emailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter emails',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_contentController.text.isEmpty) {
                  setState(() {
                    _errorMessage = 'Content cannot be empty';
                    _successMessage = null;
                  });
                  return;
                } else {
                  _message.content = _contentController.text;
                }

                if (_selectedDate == null && _selectedTimePeriod == null) {
                  setState(() {
                    _errorMessage = 'You must select either a date or a time period';
                    _successMessage = null;
                  });
                  return;
                } else {
                  _message.maturedAt = getMaturityDay(_selectedTimePeriod, _selectedDate);
                }

                if (_customerEmailController.text.isEmpty) {
                  setState(() {
                    _errorMessage = 'Email field cannot be empty';
                    _successMessage = null;
                  });
                  return;
                } else {
                  _customer.email = _customerEmailController.text;
                }

                if (_emailsController.text.isEmpty) {
                  setState(() {
                    _errorMessage = 'Emails field cannot be empty';
                    _successMessage = null;
                  });
                  return;
                } else {
                  _message.emails = _emailsController.text.split(',');
                }
                _message.status = 'sent';

                submitData(
                  context,
                  _customer,
                  _message,
                  (successMessage) {
                    setState(() {
                      _successMessage = successMessage;
                      _errorMessage = null;
                      // _message.status = 'saved';
                      _customer.messages.add(_message);
                    });
                  },
                  (errorMessage) {
                    setState(() {
                      _errorMessage = errorMessage;
                      _successMessage = null;
                    });
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
