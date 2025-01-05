enum DataType {
  boostGauge,
  afrGauge,
}

DataType dataTypeFromString(String input) {
  for (DataType t in DataType.values) {
    if (t.toString() == input) {
      return t;
    }
  }

  throw ArgumentError.value(input);
}
