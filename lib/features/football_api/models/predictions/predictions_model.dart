import 'predictions_details.dart';
import '../paging.dart';

class PredictionsModel {
  final int resultsCount;
  final Paging paging;
  final List<PredictionsDetails> predictions;

  PredictionsModel({
    required this.resultsCount,
    required this.paging,
    required this.predictions,
  });

  factory PredictionsModel.fromJson(Map<String, dynamic> json) => PredictionsModel(
        resultsCount: json['results'],
        paging: Paging.fromJson(json['paging']),
        predictions: List<PredictionsDetails>.from(
            json['response'].map((x) => PredictionsDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': resultsCount,
        'paging': paging.toJson(),
        'response': List<dynamic>.from(predictions.map((x) => x.toJson())),
      };
}