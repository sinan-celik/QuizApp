class Category {
  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) => Category(id: json['id'], name: json['name']);

  int id;
  String name;
}
