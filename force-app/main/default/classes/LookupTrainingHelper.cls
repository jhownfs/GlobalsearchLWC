public with sharing class LookupTrainingHelper {
  public list<Schema.SObjectType> listObjType;

  public LookupTrainingHelper(list<Schema.SObjectType> pListObjType) {
    this.listObjType = new List<Schema.SObjectType>();
    this.listObjType = pListObjType;
  }

  public list<String> getSalesforceObjects() {
    List<String> lstObjects = new List<String>();

    for (Schema.SObjectType obj : this.listaObjType) {
      String[] arrayObjects = new List<String>{ obj.getDescribe().getName() };

      if (
        Schema.describeSObjects(arrayObjects)[0].isSearchable() &&
        Schema.describeSObjects(arrayObjects)[0].isQueryable() &&
        obj.getDescribe().getName() != 'Address'
      ) {
        lstObjects.add(obj.getDescribe().getName());
      }
    }

    return lstObjects;
  }
}
