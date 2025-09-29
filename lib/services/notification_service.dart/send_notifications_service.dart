import 'dart:convert';
import 'dart:developer';
import 'package:sneak_peak/utils/get%20server%20key%20messaging/get_server_key_messaging.dart';
import 'package:http/http.dart' as http;
class SendNotificationsService {

 final String url= 'https://fcm.googleapis.com/v1/projects/western-oarlock-466702-d3/messages:send';
  
 Future<void> sendNotification({ String? token,required String title,required String body, Map<String,dynamic>? data, bool? isForAll})async{

var serverKey= await GetServerKey.getServerKey();



Map<String, String> headers={
  'content-type': 'application/json',
  'authorization':'Bearer $serverKey'
};

if (isForAll==false || isForAll==null) {
  Map<String, dynamic> notification={
   "message":{
      "token":token,
      "notification":{
        "body":body,
        "title":title
      },
      'data': data
   }
};

final response=await http.post(Uri.parse(url), headers: headers, body: jsonEncode(notification));

if (response.statusCode==200|| response.statusCode==201) {
  log('SUCCESSFULLY API POST 200');
}else{
  log('FAILED 404');
}
}else{
   Map<String, dynamic> notification={
   "message":{
      "topic":"all",
      "notification":{
        "body":body,
        "title":title
      },
      'data': data
   }
};

final response=await http.post(Uri.parse(url), headers: headers, body: jsonEncode(notification));

if (response.statusCode==200|| response.statusCode==201) {
  log('SUCCESSFULLY API POST 200');
}else{
  log('FAILED 404');
}
}

}


}