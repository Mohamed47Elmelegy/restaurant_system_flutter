class BannerModel {
  final int id;
  final String title;
  final String subtitle;
  final String image;
  final String action;

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.action,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      image: json['image'] as String,
      action: json['action'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'action': action,
    };
  }
}
