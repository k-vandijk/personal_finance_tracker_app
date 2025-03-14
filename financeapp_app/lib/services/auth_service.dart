import 'package:financeapp_app/dtos/auth_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  Future<void> loginAsync(AuthRequest dto) async {
    try{
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: dto.email, password: dto.password);
      
      // Save email to local storage to welcome the user back.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', user.user?.email ?? '');
    }

    catch (error) {
      rethrow;
    }
  }

  Future<void> registerAsync(AuthRequest dto) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: dto.email, password: dto.password);
    
      // Save email to local storage to welcome the user back.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', dto.email);
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
