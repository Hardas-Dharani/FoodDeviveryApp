import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class DashBoardLayout extends StatelessWidget {
  final double xOffset;

  final double yOffset;

  final double scaleFactor;

  final bool isMenuOpened;

  final Function onMenuTap;

  final Widget child;

  const DashBoardLayout(
      {Key key,
      this.xOffset,
      this.yOffset,
      this.scaleFactor,
      this.isMenuOpened,
      this.onMenuTap,
      this.child})
      : super(key: key);

  @override
  Widget build(Object context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor),
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMenuOpened ? 40 : 0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(-5, 7), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMenuOpened ? 40 : 0),
        child: GestureDetector(
          child: isMenuOpened
              ? AbsorbPointer(
                  child: child,
                )
              : child,
          onTap: isMenuOpened ? onMenuTap : null,
        ),
      ),
    );
  }
}
