class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phone;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
      };
}
