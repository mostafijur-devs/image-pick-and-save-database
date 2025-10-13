



class MiniGalleryModel {
  int? id;
  String? imagePath;
  String? dateTime;

  MiniGalleryModel({this.id, this.imagePath, this.dateTime});

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'dateTime': dateTime,
    };
  }

  // Create object from Map
  factory MiniGalleryModel.fromMap(Map<String, dynamic> map) {
    return MiniGalleryModel(
      id: map['id'] != null ? map['id'] as int : null,
      imagePath: map['imagePath'] != null ? map['imagePath'] as String : null,
      dateTime: map['dateTime'] != null ? map['dateTime'] as String : null,
    );
  }
}
