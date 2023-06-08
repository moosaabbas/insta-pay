import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'screens/base_scren.dart';
import 'sign_up.dart';
import 'components/text_field.dart';
import 'components/my_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isDarkMode = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  void clearController() {
    _emailController.text = '';
    _passwordController.text = '';
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(msg: message);
  }

  void navigateToBaseScreen(String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BaseScreen(id: uid),
      ),
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  void signInUser() {
    _loginBloc.signIn(
      _emailController.text,
      _passwordController.text,
      (uid) {
        hideLoadingDialog(context);
        navigateToBaseScreen(uid);
        clearController();
      },
      (error) {
        hideLoadingDialog(context);
        showErrorToast(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
    );

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
    );

    final currentTheme = isDarkMode ? darkTheme : lightTheme;

    return MaterialApp(
      theme: currentTheme,
      home: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: ListView(
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 48),
                  Container(
                    height: 160.0,
                    width: 180.0,
                    child: Image.asset('assets/images/logo2.png'),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Welcome back, you\'ve been missed',
                    style: TextStyle(
                      color: currentTheme.textTheme.bodyText1?.color,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: MyTextField(
                      fieldName: 'Username',
                      obscureText: false,
                      controller: _emailController,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: MyTextField(
                      fieldName: 'Password',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: MyButton(
                      onTap: signInUser,
                      btnName: 'Sign In',
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'or continue with',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Text(
                      'Not a member? Register Now',
                      style: TextStyle(
                        color: currentTheme.textTheme.bodyText1?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signIn(String email, String password, Function(String) onSuccess, Function(String) onError) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final String uid = userCredential.user!.uid;
      onSuccess(uid);
    } on FirebaseAuthException catch (e) {
      onError(e.code);
    }
  }

  void dispose() {
    _auth.signOut();
  }
}