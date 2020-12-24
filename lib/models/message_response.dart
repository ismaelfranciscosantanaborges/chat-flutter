// To parse this JSON data, do
//
//     final messageResponse = messageResponseFromJson(jsonString);

import 'dart:convert';

MessageResponse messageResponseFromJson(String str) =>
    MessageResponse.fromJson(json.decode(str));

String messageResponseToJson(MessageResponse data) =>
    json.encode(data.toJson());

class MessageResponse {
  MessageResponse({
    this.ok,
    this.messages,
  });

  bool ok;
  List<Message> messages;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        ok: json["ok"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    this.from,
    this.to,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  String from;
  String to;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json["from"],
        to: json["to"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "from": fromValues.reverse[from],
        "to": fromValues.reverse[to],
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

enum From {
  THE_5_FDA9585_F15770045_D90_CA06,
  THE_5_FDC2869165_F3_F3_EB40_CE1_F6
}

final fromValues = EnumValues({
  "5fda9585f15770045d90ca06": From.THE_5_FDA9585_F15770045_D90_CA06,
  "5fdc2869165f3f3eb40ce1f6": From.THE_5_FDC2869165_F3_F3_EB40_CE1_F6
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
