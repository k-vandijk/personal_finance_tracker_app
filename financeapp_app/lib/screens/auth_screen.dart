import 'package:financeapp_app/dtos/auth_request.dart';
import 'package:financeapp_app/services/auth_service.dart';
import 'package:financeapp_app/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final AuthService authService = AuthService();

    Future<void> loginAsync(String email, String password) async {
      try {
        await authService.loginAsync(AuthRequest(email: email, password: password));
      } 
      
      on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        switch (e.code) {
          case 'user-disabled':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This account has been disabled.')));
            break;
          case 'invalid-credential':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials.')));
            break;
          case 'wrong-password':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong password.')));
            break;
          case 'user-not-found':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not found.')));
            break;
          case 'invalid-email':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email.')));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
            break;
        }
      }

      catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
        print('Error logging in: $e');
      }
    }

    Future<void> register(String email, String password) async {
      try {
        await authService.registerAsync(AuthRequest(email: email, password: password));
      } 

      on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        switch (e.code) {
          case 'email-already-in-use':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email already in use.')));
            break;
          case 'invalid-email':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email.')));
            break;
          case 'weak-password':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Weak password.')));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
            break;
        }
      }
      
      catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
        print('Error registering: $error');
      }
    }

    return Scaffold(
      body: Center(
        child: AuthForm(
          onLogin: loginAsync,
          onRegister: register,
        ),
      ),
    );
  }
}
