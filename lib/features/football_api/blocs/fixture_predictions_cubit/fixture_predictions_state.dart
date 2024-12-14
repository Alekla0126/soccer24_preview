import '../../models/predictions/predictions_details.dart';
import '../api_state.dart';

class FixturePredictionsLoadedState extends ApiState {
  final PredictionsDetails? predictions;

  const FixturePredictionsLoadedState({required this.predictions});

  @override
  List<Object?> get props => [predictions];
}
