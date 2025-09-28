import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  
static const splash= 'splash';
static const logged= 'logged';
static const userName='userName';
static const fcm='fcm-token';
static const email='email';
static const  userImg= 'user_img';
static const switcher='swicther';

static Future<void> setBool(String key ,bool value)async{
var sp= await SharedPreferences.getInstance();

sp.setBool(key, value);

}

static Future<bool> getBool(String key)async{
  var sp= await SharedPreferences.getInstance();
  return sp.getBool(key)??false;
}

static Future<bool> getBoolForSwitcher(String key)async{
  var sp= await SharedPreferences.getInstance();
  return sp.getBool(key)??true;
}

static Future<bool> setString(String key, String value)async{
var sp= await SharedPreferences.getInstance();
return sp.setString(key, value);
}

static Future<String> getString(String key)async{
  var sp= await SharedPreferences.getInstance();
  return sp.getString(key)??'';
}

static Future<void> remove(String key)async{
var sp= await SharedPreferences.getInstance();

await sp.remove(key);

}


static Future<void> removeNameEmailImgFromSharedPref(String name, String email, String imgUrl)async{
var sp= await SharedPreferences.getInstance();

await sp.remove(name);
await sp.remove(email);
await sp.remove(imgUrl);
}

}