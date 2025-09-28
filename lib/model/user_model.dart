class User {
  String? userId;
  String? name;
  String? email;
  int? age;
  String? createdAt;
  String? updatedAt;

  User(
      {this.userId,
      this.name,
      this.email,
      this.age,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['_id'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    age = json['age'] ?? 0;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['age'] = age;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
   User copyWith({
    String? userId,
    String? name,
    String? email,
    int? age,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
