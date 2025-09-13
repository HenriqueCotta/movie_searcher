abstract class SearchAdaptabilityEvent {}

class WidthChanged extends SearchAdaptabilityEvent {
  final double width;
  WidthChanged(this.width);
}
