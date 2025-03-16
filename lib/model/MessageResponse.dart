class MessageResponse {
  final String status;
  final String message;
  final int id;

  MessageResponse({required this.status, required this.message, required this.id});

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      status: json['status'],
      message: json['message'],
      id: json['id'],
    );
  }
}
