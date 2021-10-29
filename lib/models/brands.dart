// ignore_for_file: unnecessary_this, duplicate_ignore

class Brand {
  int id = 0;
  String description = '';

  Brand({required this.id, required this.description});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals, unnecessary_new
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // ignore: unnecessary_this
    data['id'] = this.id;
    data['description'] = this.description;
    return data;
  }
}
