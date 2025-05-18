class Hospital {
  final String name;
  final double latitude;
  final double longitude;

  Hospital({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    // coordinates are usually [longitude, latitude]
    final coords = json['location']['coordinates'];
    return Hospital(
      name: json['name'],
      longitude: coords[0],
      latitude: coords[1],
    );
  }
}
