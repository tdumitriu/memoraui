import 'message.dart';

class Customer {
    String? email;
  String? firstName;
  String? lastName;
  String? zip;
  int? activatedAt;
  List<Message> messages;

  Customer({this.email,
            this.activatedAt,
            this.firstName,
            this.lastName,
            this.zip,
            List<Message>? messages,
            }) : messages = messages ?? [];

  @override
  String toString() {
    return 'Customer={'
        'email:$email, '
        'firstName:$firstName, '
        'LastName:$lastName, '
        'zip:$zip, '
        'activatedAt:$activatedAt, '
        'messages:$messages'
        '}';
  }
}
