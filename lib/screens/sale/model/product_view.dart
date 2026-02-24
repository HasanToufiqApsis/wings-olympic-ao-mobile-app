enum ViewComplexity {
  complex('Complex'),
  moderate('Moderate'),
  simple('Simple');

  final String label;

  const ViewComplexity(this.label);

  static ViewComplexity? fromString(String value) {
    for (var e in ViewComplexity.values) {
      if (e.label.toLowerCase() == value.toLowerCase()) {
        return e;
      }
    }
    return null;
  }
}
