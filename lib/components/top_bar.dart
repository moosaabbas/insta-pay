import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TopBar(
      {super.key,
      required this.scaffoldKey,
      required this.name,
      required this.imageURL});

  final String name;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 85,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
        decoration: BoxDecoration(
            color: Colors.blue[900],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: ((() => {scaffoldKey.currentState?.openDrawer()})),
                  child: CircleAvatar(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: (imageURL == 'NULL')
                              ? const AssetImage(
                                      'assets/images/profile_avatar.png')
                                  as ImageProvider
                              : NetworkImage(imageURL),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text('Hi, $name',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 19.0)),
              ],
            ),
          ],
        ));
  }
}
