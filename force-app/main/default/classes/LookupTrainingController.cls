public with sharing class LookupTrainingController {
  public static IRepositoryFactory repositoryFactory;

  @AuraEnabled(cacheable=true)
  public static list<SObject> searchRecords(
    String keyTerm,
    String objectSearch
  ) {
    list<SObject> listSearchResultRecords = new List<SObject>();

    system.debug('objectSearch = ' + objectSearch);
    system.debug('keyTerm = ' + keyTerm);
    SObjectType sObjType = ((SObject) Type.forName(objectSearch).newInstance())
      .getSObjectType();
    repositoryFactory = new RepositoryFactory();
    IRepository repository = repositoryFactory.create(sObjType);
    Specification spec = new LookupTrainingSpec(keyTerm);
    system.debug('spec = ' + spec);
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

      for (Schema.SObjectType obj : listaObjType) {
        String[] arrayObjects = new List<String>{ obj.getDescribe().getName() };

        if (
          Schema.describeSObjects(arrayObjects)[0].isSearchable() &&
          Schema.describeSObjects(arrayObjects)[0].isQueryable() &&
          obj.getDescribe().getName() != 'Address'
        ) {
          lstObjects.add(obj.getDescribe().getName());
        }
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }

    lstObjects.sort();
    return lstObjects;
  }
}
