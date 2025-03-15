import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financeapp_app/services/auth_service.dart';
import 'package:financeapp_app/widgets/keypad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthChildScreen extends StatefulWidget {
  final void Function(bool) onAuthenticated;
  const AuthChildScreen({super.key, required this.onAuthenticated});

  @override
  State<StatefulWidget> createState() => _AuthChildScreenState();
}

class _AuthChildScreenState extends State<AuthChildScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool _usePin = false;
  String _enteredPin = '';
  bool? _hasPinSet; // null means not determined yet

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
          widget.onAuthenticated(true);
          return;
        }
      }
    } on PlatformException catch (e) {
      if (e.message != null &&
          e.message!.contains('Security credentials not available')) {
        setState(() {
          _isAuthenticating = false;
          _usePin = true;
        });
        await _checkIfPinExists();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    setState(() {
      _isAuthenticating = false;
      _usePin = true; // Fallback to PIN if biometric fails.
    });
    await _checkIfPinExists();
  }

  /// Checks Firestore for an existing user document with a PIN set.
  Future<void> _checkIfPinExists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = snapshot.data();
      setState(() {
        _hasPinSet = data != null && data['pinHash'] != null;
      });
    }
  }

  void _onKeyPressed(String key) {
    if (key == 'back') {
      if (_enteredPin.isNotEmpty) {
        setState(() {
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        });
      }
      return;
    } else if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += key;
      });
      if (_enteredPin.length == 4) {
        if (_hasPinSet == true) {
          _submitPinAsync();
        } else if (_hasPinSet == false) {
          _setPinAsync();
        }
      }
    }
  }

  /// Verifies the entered PIN against the stored value.
  Future<void> _submitPinAsync() async {
    try {
      await _authService.verifyPinAsync(_enteredPin);
      widget.onAuthenticated(true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        _enteredPin = '';
      });
    }
  }

  /// Sets a new PIN if none exists.
  Future<void> _setPinAsync() async {
    try {
      await _authService.setPinAsync(_enteredPin);
      widget.onAuthenticated(true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        _enteredPin = '';
      });
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
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }
    if (_usePin) {
      if (_hasPinSet == null) {
        // Still checking Firestore for PIN information.
        return const Scaffold(
            body: Center(child: CircularProgressIndicator()));
      }
      final title = _hasPinSet! ? 'Enter PIN' : 'Set PIN';
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: KeypadWidget(
                currentPinLength: _enteredPin.length,
                onKeyPressed: _onKeyPressed,
                onBiometricsPressed: _attemptBiometric,
                title: title,
              ),
            ),
          ),
        ),
      );
    }
    return const Scaffold(
        body: Center(child: CircularProgressIndicator()));
  }
}
