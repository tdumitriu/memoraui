class Message {
  String status;
  String content;
  List<String> emails;
  int maturedAt;

  Message({this.status = 'unknown',
    this.content = "",
    List<String>? emails,
    this.maturedAt = 0,
  }): emails = emails ?? [];

  @override
  String toString() {
    return 'Message={'
        'status:$status, '
        'content:$content, '
        'emails:$emails, '
        'maturedAt:$maturedAt'
        '}';
  }
}
