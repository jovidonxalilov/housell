
// 1. Fix PhotosUrl model - API returns 'secure_url' not 'secureUrl'
class PhotosUrl {
  final String secureUrl;

  PhotosUrl({required this.secureUrl});

  factory PhotosUrl.fromJson(Map<String, dynamic> json) {
    return PhotosUrl(
      secureUrl: json['secure_url'] ?? json['secureUrl'] ?? '', // Handle both cases
    );
  }

  Map<String, dynamic> toMap() {
    return {'url': secureUrl};
  }
}
