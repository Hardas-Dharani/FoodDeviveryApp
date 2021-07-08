class StaticModel {
  int id;
  int type;
  String content;
  String createddatetime;

  StaticModel({
    int id,
    int type,
    String content,
    String createddatetime,
  }) {
    this.id = id;
    this.type = type;
    this.content = content;
    this.createddatetime = createddatetime;
  }

  StaticModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    content = json['content'];
    createddatetime = json['created_date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['content'] = this.content;
    data['created_date_time'] = this.createddatetime;
    return data;
  }
}
