import 'dart:convert';

import 'package:learning_block/groups/model/member_model.dart';

List<GroupModel> groupModelFromJson(String str) =>
    List<GroupModel>.from(json.decode(str).map((x) => GroupModel.fromJson(x)));

String groupModelToJson(List<GroupModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupModel {
  String name;
  String img;
  List<Member> members;
  String id;
  bool isMember;

  GroupModel(
      {required this.name,
      required this.img,
      required this.id,
      required this.members,
      required this.isMember});

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
      name: json["name"],
      img: json["img"],
      id: json['id'],
      members:
          (json['members'] as List).map((e) => Member.fromJson(e)).toList(),
      isMember: json['isMember']);

  Map<String, dynamic> toJson() => {
        "name": name,
        "img": img,
      };
}
