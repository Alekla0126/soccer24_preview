import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/tips/models/tip_model.dart';
import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../widgets/banner_ad_injector.dart';
import '../../../extensions/extensions.dart';
import '../../widgets/loading_widget.dart';
import '../../../constants/strings.dart';
import '../../widgets/info_widget.dart';
import 'package:flutter/material.dart';
import '../../widgets/tip_card.dart';


class TipsList extends StatelessWidget {
  const TipsList({super.key, required this.query});

  final Query<Tip> query;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Tip>(
      key: ValueKey(query.toString()),
      query: query,
      pageSize: 5,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const LoadingWidget();
        }

        if (snapshot.hasError) {
          return InfoWidget(
            text: Strings.somethingWentWrong,
            icon: soccer24Icons.error,
            color: context.colorScheme.error,
            padding: EdgeInsets.all(DefaultValues.padding),
            buttonText: Strings.retry,
            onButtonTaped: () => snapshot.fetchMore(),
          );
        }

        if (snapshot.docs.isEmpty) {
          return InfoWidget(
            text: Strings.noTips,
            message: Strings.noTipsMsg,
            icon: soccer24Icons.empty,
            color: context.colorScheme.secondaryContainer,
            padding: EdgeInsets.all(DefaultValues.padding),
          );
        }

        return ListView.builder(
          itemCount: snapshot.docs.length,
          padding: EdgeInsets.only(bottom: DefaultValues.spacing * 4),
          itemBuilder: (context, index) {
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              snapshot.fetchMore();
            }

            final Tip tip = snapshot.docs[index].data();

            return BannerAdInjector(
              condition: index % DefaultValues.bannerAdInterval == 0,
              mrec: index % (DefaultValues.bannerAdInterval * 2) == 0,
              child: TipCard(tip: tip),
            );
          },
        );
      },
    );
  }
}