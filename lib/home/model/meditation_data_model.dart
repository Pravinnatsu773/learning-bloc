import 'dart:convert';

List<MeditationDataModel> meditationDataModelFromJson(String str) =>
    List<MeditationDataModel>.from(
        json.decode(str).map((x) => MeditationDataModel.fromJson(x)));

String meditationDataModelToJson(List<MeditationDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MeditationDataModel {
  String audio;
  String img;
  String name;
  String id;

  MeditationDataModel(
      {required this.audio,
      required this.img,
      required this.name,
      required this.id});

  factory MeditationDataModel.fromJson(Map<String, dynamic> json) =>
      MeditationDataModel(
          audio: json["audio"],
          img: json["img"],
          name: json["name"],
          id: json["id"]);

  Map<String, dynamic> toJson() => {
        "audio": audio,
        "img": img,
        "name": name,
      };
}
