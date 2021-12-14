import 'dart:math';

import 'package:cpad_assignment/ui/styles.dart';
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final EdgeInsetsGeometry? titlePadding;

  const CustomExpansionTile(
      {required this.title, required this.children, this.titlePadding});

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: ListTileTheme.merge(
            dense: true,
            minVerticalPadding: 0,
            child: ExpansionTile(
                initiallyExpanded: true,
                trailing: Transform.rotate(
                  angle: isExpanded ? 180 * pi / 180 : 0,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 26,
                  ),
                ),
                onExpansionChanged: (value) {
                  setState(() {
                    isExpanded = value;
                  });
                },
                tilePadding: widget.titlePadding ?? EdgeInsets.zero,
                title: widget.title,
                children: widget.children),
          ),
        ),
      ),
    );
  }
}
