import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EcorouteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final bool hasLeading;
  const EcorouteAppBar({
    super.key,
    required this.title,
    required this.color,
    required this.hasLeading,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AppBar(
        leading: hasLeading
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.chevron_left),
              )
            : null,
        automaticallyImplyLeading: false,
        title: Text(title),
        backgroundColor: color,
      );
    } else {
      return CupertinoNavigationBar(
        leading: hasLeading
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.chevron_left),
              )
            : null,
        automaticallyImplyLeading: false,
        middle: Text(title),
        backgroundColor: color,
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
