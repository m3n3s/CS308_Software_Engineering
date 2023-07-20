class User {
  final String username;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final bool isAuthenticated;
  final bool isActive;

  User({
    this.username,
    this.name,
    this.email,
    this.password,
    this.phoneNumber,
    this.isAuthenticated = false,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json["phoneNumber"],
      isAuthenticated: json["isAuthenticated"],
      isActive: json["isActive"],
    );
  }
}
