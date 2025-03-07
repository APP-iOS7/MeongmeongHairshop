class Salon {
  final String name;
  final String operatingHours;
  final String address;
  final String telephone;
  final String mapx;
  final String mapy;
  final String link;

  Salon({
    required this.name,
    required this.operatingHours,
    required this.address,
    required this.telephone,
    required this.mapx,
    required this.mapy,
    required this.link,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      name: json['name'],
      operatingHours: json['operatingHours'],
      address: json['address'],
      telephone: json['telephone'],
      mapx: json['mapx'],
      mapy: json['mapy'],
      link: json['link'],
    );
  }
}
