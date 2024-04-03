import 'package:flutter/material.dart';

class ShowDataView extends StatefulWidget {
  const ShowDataView({super.key});

  @override
  State<StatefulWidget> createState() => _ShowDataView();
}

class _ShowDataView extends State<ShowDataView> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Text("데이터 차트 구성 예정"),
    );
  }
}
