import 'package:flutter/material.dart';
import 'google_auth.dart';

class CustomerEmail {
  final BuildContext context;
  final Function(String?) onEmailSubmitted;

  CustomerEmail(this.context, this.onEmailSubmitted);

  Future<void> showEmailDialog() async {
    final TextEditingController emailController = TextEditingController();
    String? errorMessage;

    bool isValidEmail(String email) {
      final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      return emailRegex.hasMatch(email);
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Enter your email'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),

              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    signInWithGoogle((email) {
                      onEmailSubmitted(email);
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text('Sign in with Google'),
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    if (isValidEmail(emailController.text)) {
                      onEmailSubmitted(emailController.text);
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        errorMessage = 'Please enter a valid email address';
                      });
                    }
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
}
