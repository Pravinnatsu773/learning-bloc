import 'dart:convert';

List<QuotesDataModel> quotesDataModelFromJson(String str) =>
    List<QuotesDataModel>.from(
        json.decode(str).map((x) => QuotesDataModel.fromJson(x)));

String quotesDataModelToJson(List<QuotesDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuotesDataModel {
  String img;
  String quote;
  String author;

  QuotesDataModel({
    required this.img,
    required this.quote,
    required this.author,
  });

  factory QuotesDataModel.fromJson(Map<String, dynamic> json) =>
      QuotesDataModel(
        img: json["img"],
        quote: json["quote"],
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "quote": quote,
        "author": author,
      };
}
