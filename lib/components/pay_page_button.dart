import 'package:flutter/material.dart';

class PayButton extends StatelessWidget {
  
  final String headingText;
  final String subText;
  final void Function() onTap;
  const PayButton({super.key, required this.headingText, required this.subText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: MediaQuery.of(context).size.width - 30,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.blue[500]),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              children: [
                const SizedBox(height: 18.0,),

                  Text(
                    headingText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10.0,),
                 Text(
                    subText,
                    style: const TextStyle(
                      fontSize: 16,
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
