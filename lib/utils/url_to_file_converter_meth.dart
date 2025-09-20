import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<File?> urlToFile(String imageUrl) async {
 try {
   
 final response = await http.get(Uri.parse(imageUrl));
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
  await file.writeAsBytes(response.bodyBytes);
  return file;

 } catch (e) {
  print(e);
   return null;
 }
}