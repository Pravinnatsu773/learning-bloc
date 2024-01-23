import 'dart:convert';

String meditationCategoryModelToJson(List<MeditationCategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MeditationCategoryModel {
  String img;
  String name;
  String id;

  MeditationCategoryModel(
      {required this.img, required this.name, required this.id});

  factory MeditationCategoryModel.fromJson(Map<String, dynamic> json) =>
      MeditationCategoryModel(
          img: json["img"], name: json["name"], id: json["id"]);

  Map<String, dynamic> toJson() => {
        "img": img,
        "name": name,
      };
}
