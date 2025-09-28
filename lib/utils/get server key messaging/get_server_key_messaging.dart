import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  static Future<String> getServerKey() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final credential =await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "western-oarlock-466702-d3",
        "private_key_id": "e48a9abd56b25038757d7141da388bd2f151e73d",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDI2IQaGMBUpNI2\nZhER0lwTssFYbxnmGY0oZQOV0Qx3XqUgMme///42bkxA6JanNQuHlgh15eelHgWO\nm1PYiFCT3ZoNatHj3BLw7aMfEFsNZZwkBdLgU82egG4szjCC/YvICxFH8ooMDmbA\n6o9y8g5SamnXqXJmr5EDMHTxYzVamnohW7Y+AGpf3cLXW5qcIg0wLRUHoKChLcch\neW7mewwzODAc5Yr3MZD2lqCywQnlc66I+yiJsNegu9fOk4gF7Rzc7fUmiP+KYxkk\nFwrWt9exlF96ZcWUgbJAkdloFH5WtLRfMIiML/OJwCgjP2pwTzF/Gtcp9ji7n6v/\n/whjR4WnAgMBAAECggEAVMOkRQtLKK4DFfhPnfDk8V9Q4EzLZmREQdcYA0Od+kcU\nc5kyVkLo+/ni7sX6xwjJG+kDGxbzg6k++Seu5ETrlOxClwUNHhiEWfBBFtwlQWsv\n0bgvfoN/1TQoy3od2Tq+oqehHHdNMbdmQGb+Mancx4Wns+AMqy/PiMQLptCS9PBa\nv2zw+Svus7SVeMkZmsElknRGwZ2MhJaeFyVF8JhIxkJLtIysBv8a5U+SPXDMonfp\nrNGQuvjSHO/TQi9y0w3u4lZOcBb1FtGyiyjgLBzhKHDTFIPUlSTyXtB2ryHBTK0V\nnx1Lxfs9V98RCWWl99GhTCLY9OhPLvWABQQTEJJfYQKBgQD8HIaJo0lxcBbhq/jK\n6N2xCDG9OVdUhaWTzAqya6OnnmXeQol5lGl0rex6h3Ww1X+uLdlFpzUvJkmKYSM5\nKge0NU+X7QLs6tzzK1UiSAwiOI6LJnLeMYYA1mwh2En8kqlM4h06jNsMVFBThFkO\nAG00Nungnl8b2nqs9mpRYvAPMQKBgQDL8ZDDOCTKftjQs0yAdJJyPmG3i+cJ8omv\nNAtZXPP63k0KLeDjrPbCdGI4CqGLXSh4TS6WzuJGHxzvu7KDWhkhKYTUgcTjgUwa\nbmty8mFuLJAHY0bjV5ppgqE/IcG1yZNpheDTZ5rYNFTlzdQbD4IXXcrdKzNDR0Ok\nQ2GRWlkcVwKBgQDc2xBxGv6Hxa4F3GWDPCSZpZgNMGJ0xO+cXi8wxmMDwBt1bcyJ\nGZ6YfJShcnGDjETiDYA9KJHK0Du0Ygw9U7iUAe/MI/FgIw+UZu2ZrowSnoEhHXmb\ndL7zlOP9ckC+ZqyxkZQRaruqPWJxB4wMXAtOppyUDak7+VVmmCfjTE0IwQKBgEYd\n82tq7htAqUJ3oqG3cnIcyHPWgcSFwpieCBjdQHTL4SjSxTMB0ITihrJF1WyYxsU1\npALtdhYttEEoAyPt4h3orGZzh0HAvm2H8SE//AdpAsvHciPPhqMn6lBORs89UpVB\nFh8Yy7/xng60SWxUVKG7+Xc41xMWeUcMc4sJyQFZAoGAbOqXYUhXMw0gxLZrNokR\nrs3fD4KYY0krWzs/or3gcbV6uKkDXItr3Y9YJYnvbBxIeRXfWePmLmPS5Q/hvaW3\nc/58emLzwExNiUy6DufkFNcYUjEZ0jv+9qtFlV5fpBbI9d1Ldkxcx21q7ZiMp3a/\nj7jDuLjedoIBEVwAY16/9KA=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@western-oarlock-466702-d3.iam.gserviceaccount.com",
        "client_id": "104289699389376041318",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40western-oarlock-466702-d3.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scopes,
    );
    final accessServeyKey= credential.credentials.accessToken.data;
    return accessServeyKey;
  }
}
