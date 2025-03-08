class Salon {
  final String title;
  final String link;
  final String category;
  final String description;
  final String telephone;
  final String address;
  final String roadAddress;
  final double mapx;
  final double mapy;

  Salon({
    required this.title,
    required this.link,
    required this.category,
    required this.description,
    required this.telephone,
    required this.address,
    required this.roadAddress,
    required this.mapx,
    required this.mapy,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      title: json['title'],
      link: json['link'],
      category: json['category'],
      description: json['description'],
      telephone: json['telephone'],
      address: json['address'],
      roadAddress: json['roadAddress'],
      mapx: json['mapx'],
      mapy: json['mapy'],
    );
  }
}
