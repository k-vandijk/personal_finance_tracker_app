import 'package:financeapp_app/dtos/auth_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  Future<void> loginAsync(AuthRequest dto) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: dto.email, password: dto.password);
  
    // TODO Catch exceptions and return a custom message, to show in AuthScreen...

    return;
  }

  Future<void> registerAsync(AuthRequest dto) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: dto.email, password: dto.password);
  
    // TODO Catch exceptions and return a custom message, to show in AuthScreen...

    return;
  }

  Future<void> logoutAsync() async {
    await FirebaseAuth.instance.signOut();
  }
}
