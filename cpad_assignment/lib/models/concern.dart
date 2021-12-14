class Concerns {
  List<Concern>? concernList;

  Concerns({this.concernList});

  factory Concerns.fromJson(List<Map<String, dynamic>> jsonList) => Concerns(
        concernList:
            List<Concern>.from(jsonList.map((e) => Concern.fromJson(e))),
      );
}

class Concern {
  String? id;
  String? userID;
  String? title;
  String? content;
  String? date;
  bool? isResolved;

  Concern({
    this.id,
    this.userID,
    this.content,
    this.date,
    this.isResolved,
    this.title,
  });

  @override
  String toString() {
    return 'Concern{id: $id, userID: $userID, content: $content, date: $date, isResolved: $isResolved}';
  }

  factory Concern.fromJson(Map<String, dynamic> json) => Concern(
        id: json['id'] == null ? '' : json['id'],
        userID: json['userID'] == null ? '' : json['userID'],
        title: json['title'] == null ? '' : json['title'],
        content: json['content'] == null ? '' : json['content'],
        date: json['date'] == null ? '' : json['date'],
        isResolved: json['isResolved'] == null ? false : json['isResolved'],
      );

  Map<String, dynamic> toJson({required String id}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userID'] = this.userID;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;
    data['isResolved'] = this.isResolved;

    return data;
  }
}
