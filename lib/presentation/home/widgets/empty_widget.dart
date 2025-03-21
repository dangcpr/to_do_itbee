import 'package:flutter/material.dart';

import '../../../core/const.dart';

class EmptyWidget extends StatefulWidget {
  final Status? status;
  const EmptyWidget({super.key, this.status});

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset(AppConst.emptyTaskImage),
          SizedBox(height: 10),
          Text(
            widget.status == Status.all
                ? 'You have no tasks'
                : 'You have no ${widget.status?.nameStatus()} tasks',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
