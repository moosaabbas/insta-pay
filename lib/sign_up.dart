import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/home_screen.dart';
import 'components/text_field.dart';
import 'components/my_button.dart';
import 'components/circle_image_picker.dart';
import 'components/password_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isDarkMode = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String imageURL = 'NULL';

  late SignUpBloc _signUpBloc;

  @override
  void initState() {
    super.initState();
    _signUpBloc = SignUpBloc();
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    super.dispose();
  }

  void imageURLUpdated(String url) {
    imageURL = url;
  }

  void clearController() {
    _nameController.text = '';
    _emailController.text = '';
    _passwordController.text = '';
  }

  void signUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    _signUpBloc.signUp(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      imageURL,
      () {
        Navigator.of(context).pop(); // Close the loading dialog
        Fluttertoast.showToast(msg: 'Account Created');
        clearController();

        // Redirect to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
      (error) {
        Navigator.of(context).pop(); // Close the loading dialog
        Fluttertoast.showToast(msg: error);
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
        body: ListView(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: currentTheme.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.of(context).pop();
                      }),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            CircleImagePicker(
              callback: imageURLUpdated,
            ),
            const SizedBox(
              height: 20.0,
            ),
            MyTextField(
              fieldName: 'Name',
              controller: _nameController,
              obscureText: false,
            ),
            const SizedBox(
              height: 5.0,
            ),
            MyTextField(
              fieldName: 'Email',
              controller: _emailController,
              obscureText: false,
            ),
            const SizedBox(
              height: 5.0,
            ),
            PasswordTextField(
              fieldName: 'Password',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(
              height: 10.0,
            ),
            MyButton(
              onTap: signUp,
              btnName: 'Create',
            ),
            const SizedBox(
              height: 5.0,
            ),
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
    );
  }
}

class SignUpBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void signUp(
    String name,
    String email,
    String password,
    String imageURL,
    Function() onSuccess,
    Function(String) onError,
  ) async {
    Map<String, dynamic> userData = {
      'name': name,
      'imageURL': imageURL,
      'email': email,
    };

    Map<String, dynamic> walletData = {
      'userID': '',
    };

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final userReference = _firestore.collection('users').doc(userCredential.user?.uid);
      userReference.set(userData);

      final walletReference = _firestore.collection('wallet').doc(userCredential.user?.uid);
      walletData['userID'] = userCredential.user?.uid;
      walletReference.set(walletData);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.code);
    }
  }

  void dispose() {
    _auth.signOut();
  }
}