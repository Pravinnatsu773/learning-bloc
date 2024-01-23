import 'package:learning_block/posts/models/post_data_model.dart';

import 'package:http/http.dart' as http;

class PostRepository {
  static Future<List<PostDataModel>> fectPostdata() async {
    var client = http.Client();

    try {
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      List<PostDataModel> postDataList = postDataModelFromJson(response.body);
      return postDataList;
    } catch (e) {
      return [];
    }
  }
}
