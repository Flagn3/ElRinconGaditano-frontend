class ResponseApi {
  bool success;
  dynamic data;
  String message;

  ResponseApi({
    required this.success,
    this.data,
    required this.message,
  });

  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
    success: json["success"] ?? false,
    data: json["data"],
    message: json["message"] ?? "",
  );
}