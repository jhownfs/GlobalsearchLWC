public with sharing class LookupTrainingSpec extends CompositeSpecification {
  protected String searchKey;

  public LookupTrainingSpec(String keyterm) {
    this.searchKey = '\'%' + String.escapeSingleQuotes(keyterm) + '%\'';
  }

  public override Boolean isSatisfiedBy(Object candidate) {
    return null;
  }

  public override String toSOQLClauses() {
    return 'Name LIKE ' + this.searchKey;
  }
}
