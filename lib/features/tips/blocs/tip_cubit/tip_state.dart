part of 'tip_cubit.dart';

sealed class TipProcessingState extends Equatable {
  final String message;

  const TipProcessingState(this.message);

  @override
  List<Object> get props => [message];
}

final class TipProcessingInitial extends TipProcessingState {
  const TipProcessingInitial(super.message);
}

final class TipProcessing extends TipProcessingState {
  const TipProcessing(super.message);
}

final class TipProcessingSuccess extends TipProcessingState {
  const TipProcessingSuccess(super.message);
}

final class TipProcessingError extends TipProcessingState {
  const TipProcessingError(super.message);
}
