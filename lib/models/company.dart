// Path: lib/models/company.dart

class Company {
  final String id;
  final String name;
  final String email;
  final int size;
  final bool subscribed;
  bool selected;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.size,
    required this.subscribed,
    this.selected = false,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      size: json['size'],
      subscribed: json['subscribed'],
    );
  }
}
