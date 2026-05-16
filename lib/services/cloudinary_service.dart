import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String _cloudName = "de3pdgjo0";
  static const String _uploadPreset = "rincongaditano_presets";

  static Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$_cloudName/image/upload",
    );
    try {
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = _uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final jsonMap = jsonDecode(responseData);

        return jsonMap['secure_url'] as String;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
