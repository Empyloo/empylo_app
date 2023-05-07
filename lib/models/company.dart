// Path: lib/models/company.dart

class Company {
  final String? id;
  final String name;
  final String email;
  final int size;
  final bool? subscribed;
  final String? logo;
  final String? phone;
  final String? description;
  final Map<String, dynamic>? data;
  bool selected;

  Company({
    this.id,
    required this.name,
    required this.email,
    required this.size,
    this.subscribed,
    this.logo,
    this.phone,
    this.description,
    this.data,
    this.selected = false,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      size: json['size'],
      subscribed: json['subscribed'],
      logo: json['logo'],
      phone: json['phone'],
      description: json['description'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'size': size,
      'subscribed': subscribed,
      'logo': logo,
      'phone': phone,
      'description': description,
      'data': data,
    };
  }
}
