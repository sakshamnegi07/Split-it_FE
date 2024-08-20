abstract class LandingState {}

class LandingInitial extends LandingState {}

class PageLoading extends LandingState {}

class PageLoaded extends LandingState {
  final int pageIndex;

  PageLoaded(this.pageIndex);
}
