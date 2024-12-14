
part of 'odds_cubit.dart';

class OddsLoadedState extends ApiState {
  final List<BookmakerBets> bookmakerBets;

  const OddsLoadedState(this.bookmakerBets);

  @override
  List<Object> get props => [bookmakerBets];
}