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
      title: json['title']?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '') ?? '',
      link: json['link']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      telephone: json['telephone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      roadAddress: json['roadAddress']?.toString() ?? '',
      // 지도 좌표는 문자열을 double로 변환 후, 원래 스케일에서 변환
      mapx: (double.tryParse(json['mapx']?.toString() ?? '') ?? 0) / 10000000,
      mapy: (double.tryParse(json['mapy']?.toString() ?? '') ?? 0) / 10000000,
    );
  }
}
