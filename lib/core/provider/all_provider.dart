import 'package:get/get.dart';

class AllProvider extends GetConnect {
  // static String urlBase = "https://homerental.hobbbies.id/";
  static String urlBase = "https://iihome.in/";
  static String tokenAPI = 'aG9tZXJlbnRhbDpiMXNtMWxsNGg=';

  Future<Response>? pushResponse(final String path, final String encoded) =>
      post(
        urlBase + path,
        encoded,
        contentType: 'application/json; charset=UTF-8',
        headers: {
          'User-Agent': 'Mozilla/5.0 (Android; Mobile; rv:13.0) Gecko/13.0 Firefox/13.0',
          'x-api-key': tokenAPI,
          'Content-type': 'application/json',
        },
      ).timeout(const Duration(seconds: 290));
}
