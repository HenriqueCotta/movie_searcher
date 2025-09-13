enum SearchBarLayout { compact, tightRow, comfortableRow }

class SearchAdaptabilityState {
  final SearchBarLayout barLayout;
  final int columns;
  const SearchAdaptabilityState({required this.barLayout, required this.columns});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchAdaptabilityState &&
          runtimeType == other.runtimeType &&
          barLayout == other.barLayout &&
          columns == other.columns;

  @override
  int get hashCode => barLayout.hashCode ^ columns.hashCode;
}
