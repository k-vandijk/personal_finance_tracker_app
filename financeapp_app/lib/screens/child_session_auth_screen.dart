import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class ChildSessionAuthScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;
  const ChildSessionAuthScreen({super.key, required this.onAuthenticated});

  @override
  _ChildSessionAuthScreenState createState() => _ChildSessionAuthScreenState();
}

class _ChildSessionAuthScreenState extends State<ChildSessionAuthScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool _usePin = false;
  String _enteredPin = '';

  // For demo purposes; in production, securely store the PIN.
  final String _storedPin = '1234';

  @override
  void initState() {
    super.initState();
    _attemptBiometric();
  }

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
    } on PlatformException catch (e) {
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
    } catch (e) {
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
    } else {
      if (_enteredPin.length < 4) {
        setState(() {
          _enteredPin += key;
        });
        if (_enteredPin.length == 4) {
          _submitPin();
        }
      }
    }
  }

  void _submitPin() {
    if (_enteredPin == _storedPin) {
      widget.onAuthenticated();
    } else {
      setState(() {
        _enteredPin = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN. Please try again.')),
      );
    }
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final filled = index < _enteredPin.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? Colors.white : Colors.transparent,
            border: Border.all(color: Colors.white, width: 2),
          ),
        );
      }),
    );
  }

  Widget _buildKey(String label) {
    Icon? icon;
    if (label == 'back') {
      icon = const Icon(Icons.backspace, color: Colors.white);
    }
    return GestureDetector(
      onTap: () => _onKeyPressed(label),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withAlpha(50),
        ),
        child: icon ??
            Text(
              label,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }

  Widget _buildFingerprintKey() {
    return GestureDetector(
      onTap: _attemptBiometric,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withAlpha(50),
        ),
        child: const Icon(Icons.fingerprint, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: 1, 2, 3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
        ),
        const SizedBox(height: 16),
        // Row 2: 4, 5, 6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
        ),
        const SizedBox(height: 16),
        // Row 3: 7, 8, 9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
        ),
        const SizedBox(height: 16),
        // Row 4: Fingerprint, 0, Backspace
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildFingerprintKey(), _buildKey('0'), _buildKey('back')],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticating) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter PIN',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPinDots(),
                  const SizedBox(height: 40),
                  _buildKeypad(),
                ],
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
