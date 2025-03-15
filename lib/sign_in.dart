import 'package:flutter/material.dart';
import 'google_auth.dart';
import 'model/customer.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('SignInPopup');

class SignInPopup extends StatelessWidget {
  final Customer customer;
  final Function(String?) onEmailSubmitted;

  const SignInPopup({
    super.key,
    required this.customer,
    required this.onEmailSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    _logger.info('Building sign-in popup');
    return AlertDialog(
      title: const Text('Sign in with Google'),
      content: const Text('Please sign in with your Google account.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            signInWithGoogle((email) {
              onEmailSubmitted(email);
              Navigator.of(context).pop();
            });
          },
          child: const Text('Sign in with Google'),
        ),
      ],
    );
  }
}
