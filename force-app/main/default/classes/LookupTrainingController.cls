public with sharing class LookupTrainingController {
  public static IRepositoryFactory repositoryFactory;

  @AuraEnabled(cacheable=true)
  public static list<SObject> searchRecords(
    String keyTerm,
    String objectSearch
  ) {
    list<SObject> listSearchResultRecords = new List<SObject>();

    SObjectType sObjType = ((SObject) Type.forName(objectSearch).newInstance())
      .getSObjectType();
    repositoryFactory = new RepositoryFactory();
    IRepository repository = repositoryFactory.create(sObjType);
    Specification spec = new LookupTrainingSpec(keyTerm);

    Repository.QueryBuilder queryBuilder = new Repository.QueryBuilder()
      .selectFields(new List<String>{ 'Id', 'Name' })
      .whereSpecification(spec);

    try {
      listSearchResultRecords = repository.queryObjects(queryBuilder);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return listSearchResultRecords;
  }

  @AuraEnabled(cacheable=true)
  public static list<String> listObjectsSalesforce() {
    List<String> lstObjects = new List<String>();

    try {
      List<Schema.SObjectType> listaObjType = Schema.getGlobalDescribe()
        .Values();

      LookupTrainingHelper helper = new LookupTrainingHelper(listaObjType);
      lstObjects.add(helper.getSalesforceObjects);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }

    lstObjects.sort();
    return lstObjects;
  }
}
