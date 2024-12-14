import '../../repositories/tips_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/strings.dart';
import 'package:equatable/equatable.dart';
import '../../models/tip_model.dart';


part 'tip_state.dart';

class TipCubit extends Cubit<TipProcessingState> {
  final TipsRepository _repository;

  TipCubit(this._repository) : super(const TipProcessingInitial(''));

  Future saveTip(Tip tip) async {
    emit(TipProcessing(tip.id == null ? Strings.sharingTip : Strings.savingTip));
    try {
      await _repository.saveTip(tip);
      emit(TipProcessingSuccess(tip.id == null ? Strings.tipShared : Strings.tipSaved));
    } catch (_) {
      emit(TipProcessingError(tip.id == null ? Strings.tipNotShared : Strings.tipNotSaved));
    }
  }

  Future deleteTip(String tipId) async {
    emit(const TipProcessing(Strings.deletingTip));
    try {
      await _repository.deleteTip(tipId);
      emit(const TipProcessingSuccess(Strings.tipDeleted));
    } catch (_) {
      emit(const TipProcessingError(Strings.tipNotDeleted));
    }
  }
}