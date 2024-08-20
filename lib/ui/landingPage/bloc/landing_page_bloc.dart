import 'package:flutter_bloc/flutter_bloc.dart';
import 'landing_page_event.dart';
import 'landing_page_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc() : super(PageLoaded(0)) {
    on<PageSelected>(_onPageSelected);
  }

  Future<void> _onPageSelected(
      PageSelected event, Emitter<LandingState> emit) async {
    emit(PageLoaded(event.pageIndex));
  }
}