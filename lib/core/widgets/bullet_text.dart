import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';

class BulletText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double indent;
  final Color bulletColor;

  const BulletText({
    super.key,
    required this.text,
    this.style,
    this.indent = 8.0,
    this.bulletColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    // We use a Row to combine the bullet widget and the text widget.
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. The Bullet Point Widget
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 6.0),
            child: Icon(
              Icons.circle, // Using an Icon for reliable, colorable bullets
              size: 8.0, 
              color: bulletColor,
            ),
          ),
          // 2. The Text Widget (using Expanded to handle wrapping)
          Expanded(
            child: Text(
              text,
              style: style ?? fontStyleRegular16,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}