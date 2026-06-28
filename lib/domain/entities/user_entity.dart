/// Domain qatlamidagi sof (pure) foydalanuvchi entity'si.
/// Hech qanday data-layer (JSON, API) bog'liqliklarisiz.
class UserEntity {
  final String id;
  final String fullName;
  final String position;
  final String? avatarUrl;
  final String referenceFaceImagePath; // DeepFace solishtirishi uchun

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.position,
    this.avatarUrl,
    required this.referenceFaceImagePath,
  });
}
