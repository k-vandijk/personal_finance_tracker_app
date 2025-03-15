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
  final AuthService _authService = AuthService();

  bool _isAuthenticating = false;
  bool _usePin = false;
  String _enteredPin = '';
  bool? _hasPinSet; 
  bool _isConfirming = false;
  String _firstPin = '';

  @override
  void initState() {
    super.initState();
    _attemptBiometric();
  }

  /// Attempts biometric authentication and falls back to PIN if needed.
  Future<void> _attemptBiometric() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        setState(() => _isAuthenticating = true);
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
      if (e.message?.contains('Security credentials not available') ?? false) {
        setState(() {
          _isAuthenticating = false;
          _usePin = true;
        });
        await _checkIfPinExists();
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('An error occurred')));
    }
    setState(() {
      _isAuthenticating = false;
      _usePin = true;
    });
    await _checkIfPinExists();
  }

  

  /// Handles key presses from the keypad.
  void _onKeyPressed(String key) {
    // Handle backspace.
    if (key == 'back') {
      if (_enteredPin.isNotEmpty) {
        setState(() {
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        });
      }
      return;
    }

    // Prevent adding more digits if already 4.
    if (_enteredPin.length >= 4) return;

    // Append the key.
    setState(() {
      _enteredPin += key;
    });

    // If PIN is not complete, exit early.
    if (_enteredPin.length < 4) return;

    // At this point, _enteredPin has exactly 4 digits.
    if (_hasPinSet == true) {
      // Verify existing PIN.
      _submitPinAsync();
      return;
    }

    // Setting a new PIN.
    if (!_isConfirming) {
      _firstPin = _enteredPin;
      setState(() {
        _enteredPin = '';
        _isConfirming = true;
      });
      return;
    }

    // Confirming new PIN.
    if (_enteredPin == _firstPin) {
      _setPinAsync();
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PINs do not match')));
      setState(() {
        _enteredPin = '';
        _firstPin = '';
        _isConfirming = false;
      });
    }
  }

  Future<void> _checkIfPinExists() async {
    final bool hasPinSet = await _authService.checkIfPinExistsAsync();
    setState(() {
      _hasPinSet = hasPinSet;
    });
  }

  Future<void> _submitPinAsync() async {
    try {
      await _authService.verifyPinAsync(_enteredPin);
      widget.onAuthenticated(true);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() => _enteredPin = '');
    }
  }

  Future<void> _setPinAsync() async {
    try {
      await _authService.setPinAsync(_enteredPin);
      widget.onAuthenticated(true);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred while setting your PIN')));
      setState(() => _enteredPin = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticating) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    if (_usePin) {
      if (_hasPinSet == null) {
        return const Scaffold(
            body: Center(child: CircularProgressIndicator()));
      }
      final title = _hasPinSet!
          ? 'Enter PIN'
          : (_isConfirming ? 'Confirm PIN' : 'Set PIN');

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
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
