public with sharing class LookupTrainingSpec implements Specification {
  protected String searchKey;

  public LookupTrainingSpec(String keyterm) {
    this.searchKey = '%' + String.escapeSingleQuotes(keyterm) + '%';
  }

  public String whereSpecification() {
    return 'WHERE Name LIKE: this.searchKey';
  }

  public String toSOQLClauses() {
    return '';
  }
}
