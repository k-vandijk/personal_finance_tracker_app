import 'package:financeapp_app/dtos/auth_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  Future<void> loginAsync(AuthRequest dto) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: dto.email, password: dto.password);
    }

    catch (error) {
      rethrow;
    }
  }

  Future<void> registerAsync(AuthRequest dto) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: dto.email, password: dto.password);
    }

    catch (error) {
      rethrow;
    }
  }

  Future<void> logoutAsync() async {
    try {
      await FirebaseAuth.instance.signOut();
    }

    catch (error) {
      rethrow;
    }
  }
}
