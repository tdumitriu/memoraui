class Message {
  int id;
  String status;
  String content;
  List<String> emails;
  int maturedAt;

  Message({this.id = 0,
    this.status = 'new',
    this.content = "",
    List<String>? emails,
    this.maturedAt = 0,
  }): emails = emails ?? [];

  @override
  String toString() {
    return 'Message{id: $id, '
        'status: $status}'
        'content: $content}'
        'emails: $emails}'
        'maturedAt: $maturedAt}';
  }
}
