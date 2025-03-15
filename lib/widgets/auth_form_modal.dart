import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthFormWidget extends StatefulWidget {
  const AuthFormWidget({super.key, required this.onLogin, required this.onRegister});

  final void Function(String email, String password) onLogin;
  final void Function(String email, String password) onRegister;

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _enteredEmail = '';
  String _enteredPassword = '';
  bool? _firstLogin;

  @override
  void initState() {
    super.initState();
    _checkFirstLogin();
  }

  Future<void> _checkFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final firstLogin = prefs.getString('email') == null;
    setState(() {
      _firstLogin = firstLogin;
    });
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState!.save();

    if (_isLogin) {
      widget.onLogin(_enteredEmail, _enteredPassword);
    } else {
      widget.onRegister(_enteredEmail, _enteredPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _firstLogin == true
        ? 'Welcome!'
        : (_isLogin ? 'Welcome back' : 'Create an account');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            // A dark semi-transparent overlay that blends with the gradient background.
            color: Colors.black.withAlpha(70),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    labelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredEmail = value!.trim();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPassword = value!.trim();
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withAlpha(50),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isLogin ? 'Login' : 'Sign up',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin ? 'Create an account' : 'I already have an account',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
