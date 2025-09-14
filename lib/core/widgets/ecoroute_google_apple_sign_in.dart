import 'package:flutter/material.dart';

import '../utils/constants/constants.dart';

class EcorouteGoogleAppleSignIn extends StatelessWidget {
  final String name;
  final double width;
  const EcorouteGoogleAppleSignIn({
    super.key,
    required this.width,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConstants.s24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConstants.s12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Image.asset(name, width: width),
    );
  }
}
