import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants/app_textstyle.dart';
import '/constants/color_constants.dart';
import '/data/card_data.dart';
import '/data/transaction_data.dart';
import '/widgets/my_card.dart';
import '/widgets/transaction_card.dart';

class HomeScreen extends StatefulWidget {
  final String? id;

  const HomeScreen({Key? key, this.id}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  String? email;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(widget.id).get();

    // Check if the widget is still in the tree
    if (mounted) {
      // If so, safely call setState
      setState(() {
        name = userDoc['name'];
        email = userDoc['email'];
      });
    }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Hello, $name",
          style: TextStyle(
            fontFamily: "Poppins",
            color: kPrimaryColor,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage("https://placeimg.com/640/480/people"),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_active_outlined,
              color: Colors.black,
              size: 27,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 10,
                    );
                  },
                  itemCount: myCards.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return MyCard(
                      card: myCards[index],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Recent Transactions",
                style: ApptextStyle.BODY_TEXT,
              ),
              SizedBox(
                height: 15,
              ),
              ListView.separated(
                itemCount: myTransactions.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  return TransactionCard(transaction: myTransactions[index]);
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dark Mode",
                    style: theme.textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                    activeColor: kPrimaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }
}