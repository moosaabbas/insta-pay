import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrganizationButton extends StatelessWidget {
  final String imagePath;

  const OrganizationButton({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return SizedBox(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () async {
            final TextEditingController paymentController = TextEditingController();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Enter Payment Amount'),
                  content: TextField(
                    controller: paymentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Enter Amount"),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Pay'),
                      onPressed: () async {
                        double paymentAmount = double.tryParse(paymentController.text) ?? 0.0;
                        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('wallet').doc(userId).get();
                        double balanceUSD = documentSnapshot.get('BalanceUSD') ?? 0.0;

                        if (balanceUSD >= paymentAmount) {
                          balanceUSD -= paymentAmount;
                          await FirebaseFirestore.instance.collection('wallet').doc(userId).update({'BalanceUSD': balanceUSD});
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Payment Successful'),
                                content: Text('Thank you for your payment!'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Insufficient Balance'),
                                content: Text('You do not have enough balance in your wallet to make this payment.'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.grey[100]),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Image.asset(imagePath),
          ),
        ),
      ),
    );
  }
}
