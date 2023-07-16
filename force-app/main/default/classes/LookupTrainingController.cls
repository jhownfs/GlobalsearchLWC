public with sharing class LookupTrainingController {
  public static IRepository repo;

  @AuraEnabled(cacheable=true)
  public static list<SObject> searchRecords(
    String keyTerm,
    String objectSearch
  ) {
    list<SObject> listSearchResultRecords = new List<SObject>();
    SObjectType sObjType = ((SObject) Type.forName(objectSearch).newInstance())
      .getSObjectType();
    //repo = new Repository(sObjType, new list<String>{ 'id', 'name' } );
    LookupTrainingSpec spec = new LookupTrainingSpec(keyTerm);
    IRepository queryBuild = new Repository.QueryBuilder(
      new List<String>{ 'id', 'name' }
    );
    String dynamicQuery = 'SELECT Id, Name';
    dynamicQuery += ' FROM ' + objectSearch;
    dynamicQuery += ' WHERE Name LIKE: searchKey';

    try {
      //listSearchResultRecords = database.query(dynamicQuery);
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
          Schema.describeSObjects(arrayObjects)[0].isQueryable()
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
