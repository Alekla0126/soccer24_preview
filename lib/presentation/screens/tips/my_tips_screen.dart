import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/strings.dart';
import '../../../features/tips/repositories/tips_repository.dart';
import 'tips_list.dart';

class MyTipsScreen extends StatelessWidget {
  const MyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.myTips),
      ),
      body: TipsList(query: context.read<TipsRepository>().getOwnTips()),
    );
  }
}