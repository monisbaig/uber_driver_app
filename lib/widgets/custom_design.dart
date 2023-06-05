import 'package:flutter/material.dart';

class CustomDesign extends StatefulWidget {
  final String textInfo;
  final IconData iconData;

  const CustomDesign(
      {super.key, required this.textInfo, required this.iconData});

  @override
  State<CustomDesign> createState() => _CustomDesignState();
}

class _CustomDesignState extends State<CustomDesign> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: Colors.blue,
        ),
        title: Text(
          widget.textInfo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
