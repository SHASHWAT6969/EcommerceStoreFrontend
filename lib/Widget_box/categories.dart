
class Category{
  final int id;
  final String name;
  final String description;
  final String image_url;
  Category({required this.id, required this.name, required this.image_url,required this.description});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json['CategoryID'].toString()),
      name: json['Name'],
      description: json['Description'],
      image_url: json['image_url'],

    );
  }
}




