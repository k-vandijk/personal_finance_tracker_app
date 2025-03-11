class AuthenticationDTO {
  final String email;
  final String password;

  AuthenticationDTO({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}