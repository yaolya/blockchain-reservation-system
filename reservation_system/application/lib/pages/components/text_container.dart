import 'package:flutter/material.dart';

import '../../utils/styles.dart';

class TextContainer extends StatelessWidget {
  final String prop;
  final String text;

  const TextContainer({
    Key? key,
    required this.prop,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "$prop: ",
          style: Styles.propertyStyle,
        ),
        Expanded(
          child: Text(
            text,
          ),
        )
      ]),
    );
  }
}
