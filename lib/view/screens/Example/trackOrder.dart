import 'package:flutter/material.dart';
import 'package:flutter_restaurant/navigation_bloc/navigation_bloc.dart';

class TrackPrder extends StatelessWidget with NavigationStates {
  final Function onMenuTap;

  const TrackPrder({Key key, this.onMenuTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ToDoImplementBuild
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                child: Icon(Icons.menu, color: Colors.white),
                onTap: onMenuTap,
              ),
              Text("Track Order ",
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              Icon(Icons.settings, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
