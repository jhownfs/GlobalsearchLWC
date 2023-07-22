global interface Specification {
  Boolean isSatisfiedBy(Object candidate);
  Specification andSpec(Specification other);
  Specification orSpec(Specification other);
  Specification notSpec();

  String toSOQLClauses();
}
