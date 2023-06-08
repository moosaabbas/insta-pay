import 'package:flutter/material.dart';

class DashboardButton extends StatefulWidget{
  
  final String buttonName;
  final String imagePath;
  final void Function() onTap;
  const DashboardButton({super.key, required this.buttonName, required this.imagePath, required this.onTap});
  
  @override
  State<DashboardButton> createState() => _DashboardButton();

}

class _DashboardButton extends State<DashboardButton>{
  
  late String buttonName;
  late String imagePath;
  late void Function() onTap;
  Color? _color = Colors.blue[200];
  _DashboardButton();
  
  @override

  void initState(){
    buttonName = widget.buttonName;
    imagePath = widget.imagePath;
    onTap = widget.onTap;
    super.initState();
  }

@override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        setState(() {
          _color = Colors.blue[800];
        },),
        Future.delayed(const Duration(milliseconds: 20),(){
          setState(() {
          _color = Colors.blue[200];
        },);
        }), 
        onTap()
      },
      child: Container(
        alignment: Alignment.topLeft,
        height: 120,
        width: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: _color,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(6, 3))
            ]),
        child: Column(
          children: [
            const SizedBox(height: 7.0,),
            Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                alignment: Alignment.center,
                child: Image.asset(imagePath, height: 50)),
             Text(
              buttonName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
