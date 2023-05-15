import 'package:flutter/material.dart';

import '../../utils/styles.dart';

class TitleContainer extends StatelessWidget {
  final String title;

  const TitleContainer({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 200, 212, 218),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Styles.titleStyle,
          ),
        ),
      ),
    );
  }
}
