import 'package:financeapp_app/services/auth_service.dart';
import 'package:financeapp_app/widgets/keypad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthChildScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;
  const AuthChildScreen({super.key, required this.onAuthenticated});

  @override
  State<StatefulWidget> createState() {
    return _AuthChildScreenState();
  }
}

class _AuthChildScreenState extends State<AuthChildScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool _usePin = false;
  String _enteredPin = '';

  final AuthService _authService = AuthService();

  Future<void> _attemptBiometric() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        setState(() {
          _isAuthenticating = true;
        });
        final bool authenticated = await _localAuth.authenticate(
          localizedReason: 'Please authenticate to unlock the app',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          widget.onAuthenticated();
          return;
        }
      }
    } 
    
    on PlatformException catch (e) {
      if (e.message != null &&
          e.message!.contains('Security credentials not available')) {
        setState(() {
          _isAuthenticating = false;
          _usePin = true;
        });
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } 
    
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {
      _isAuthenticating = false;
      _usePin = true; // fallback to PIN if biometric fails
    });
  }

  void _onKeyPressed(String key) {
    if (key == 'back') {
      if (_enteredPin.isNotEmpty) {
        setState(() {
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        });
      }
    } 
    
    else if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += key;
      });
      if (_enteredPin.length == 4) {
        _submitPinAsync();
      }
    }
  }

  Future<void> _submitPinAsync() async {
    try {
      // await _authService.verifyPinAsync(_enteredPin);
      // widget.onAuthenticated();

      if (_enteredPin == '0000') {
        widget.onAuthenticated();
        return;
      }

      // the verifyPinAsync method will throw an exception if the pin is invalid
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _attemptBiometric();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticating) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_usePin) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: KeypadWidget(
                currentPinLength: _enteredPin.length,
                onKeyPressed: _onKeyPressed,
                attemptBiometric: _attemptBiometric,
              ),
            ),
          ),
        ),
      );
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
