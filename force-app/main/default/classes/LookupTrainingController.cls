public with sharing class LookupTrainingController {
  @AuraEnabled(cacheable=true)
  public static list<SObject> searchRecords(
    String keyTerm,
    String objectSearch
  ) {
    list<SObject> listSearchResultRecords = new List<SObject>();

    String searchKey = '%' + String.escapeSingleQuotes(keyTerm) + '%';

    String dynamicQuery = 'SELECT Id, Name';
    dynamicQuery += ' FROM ' + objectSearch;
    dynamicQuery += ' WHERE Name LIKE: searchKey';

    try {
      listSearchResultRecords = database.query(dynamicQuery);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return listSearchResultRecords;
  }

  @AuraEnabled(cacheable=true)
  public static map<String, String> listObjectsSalesforce() {
    map<String, String> mapObjects = new Map<String, String>();
    List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
    List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
    List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();

    try {
      List<Schema.SObjectType> listaObjType = Schema.getGlobalDescribe()
        .Values();
      System.debug('listaObjType = ' + listaObjType);
      System.debug('tabDesc = ' + tabDesc);
      for (Schema.SObjectType obj : listaObjType) {
        String[] arrayObjects = new List<String>{ obj.getDescribe().getName() };

        if (
          Schema.describeSObjects(arrayObjects)[0].isSearchable() &&
          Schema.describeSObjects(arrayObjects)[0].isQueryable()
        ) {
          String icon;
          for (Schema.DescribeTabResult tab : tabDesc) {
            System.debug(
              'obj.getDescribe().getName() = ' + obj.getDescribe().getName()
            );
            System.debug('tab.getSobjectName() = ' + tab.getSobjectName());

            if (obj.getDescribe().getName() == tab.getSobjectName()) {
              if (tab.isCustom()) {
                //icon = tab.getIcons();
              } else {
                icon = 'standard:' + obj.getDescribe().getName().toLowerCase();
              }
            }
            mapObjects.put(obj.getDescribe().getName(), icon);
            // listObjects.add(objeto.getDescribe().getName());
          }
        }
      }

      //listObjects.sort();
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }

    System.debug('mapObjects = ' + mapObjects);
    return mapObjects;
  }
}
