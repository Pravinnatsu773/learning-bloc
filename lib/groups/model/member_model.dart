import 'dart:convert';

List<Member> memberFromJson(String str) =>
    List<Member>.from(json.decode(str).map((x) => Member.fromJson(x)));

String memberToJson(List<Member> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Member {
  String uid;
  String profilePic;

  Member({
    required this.uid,
    required this.profilePic,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        uid: json["id"],
        profilePic: json["profile-pic"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "profile-pic": profilePic,
      };
}
