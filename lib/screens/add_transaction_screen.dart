import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_pay/constants/app_textstyle.dart';
import 'package:insta_pay/constants/color_constants.dart';

class AddTransactionScreen extends StatefulWidget {
  final String id;

  const AddTransactionScreen({Key? key, required this.id}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _currentBalance = '';

  _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final users = FirebaseFirestore.instance.collection('users');
      final userDoc = users.doc(widget.id);
      final transactions = userDoc.collection('transactions');

      await transactions.add({
        'name': _name,
        'avatar': 'assets/icons/avatar.png',
        'currentBalance': _currentBalance,
      });

      DocumentSnapshot userSnapshot = await userDoc.get();
      Map<String, dynamic> userData = userSnapshot.data()! as Map<String, dynamic>;
      int totalBalance = int.parse(userData.containsKey('totalBalance') ? userData['totalBalance'] : '0') + int.parse(_currentBalance);

      await userDoc.update({'totalBalance': totalBalance.toString()});

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Add Transaction', style: ApptextStyle.MY_CARD_TITLE),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              key: ValueKey('name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: ApptextStyle.BODY_TEXT,
              ),
            ),
            TextFormField(
              key: ValueKey('currentBalance'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a balance';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) {
                _currentBalance = value!;
              },
              decoration: InputDecoration(
                labelText: 'Current Balance',
                labelStyle: ApptextStyle.BODY_TEXT,
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kSecondaryColor),
              ),
              child: Text('Add Transaction', style: ApptextStyle.BODY_TEXT),
              onPressed: _trySubmit,
            )
          ],
        ),
      ),
    );
  }
}
