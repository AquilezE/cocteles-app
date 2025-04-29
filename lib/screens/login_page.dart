import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false, _error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Please log in',
                    style: Theme.of(context).textTheme.headlineSmall),
                TextField(
                    controller: _userCtrl,
                    decoration: InputDecoration(labelText: 'Username')),
                TextField(
                  controller: _passCtrl,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                if (_error) ...[
                  SizedBox(height: 8),
                  Text('Login failed', style: TextStyle(color: Colors.red)),
                ],
                SizedBox(height: 16),
                _loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text('Log In'),
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                            _error = false;
                          });
                          final auth = context.read<AuthState>();
                          final success =
                              await auth.login(_userCtrl.text, _passCtrl.text);
                          if (!success) {
                            setState(() {
                              _loading = false;
                              _error = true;
                            });
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
