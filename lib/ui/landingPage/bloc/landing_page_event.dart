abstract class LandingEvent {}

class PageSelected extends LandingEvent {
  final int pageIndex;

  PageSelected(this.pageIndex);
}
