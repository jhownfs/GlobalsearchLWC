public with sharing class LookupTrainingController {

    @AuraEnabled(cacheable=true)
    public static list<SObject> searchRecords(String keyTerm, String objectSearch){
        list<SObject> listSearchResultRecords = new list<SObject>();
        
        String searchKey = '%' + String.escapeSingleQuotes(keyTerm) + '%';

        String dynamicQuery = 'SELECT Id, Name';
        dynamicQuery += ' FROM ' +  objectSearch;
        dynamicQuery += ' WHERE Name LIKE: searchKey';
       
        try {
           
            listSearchResultRecords = database.query(dynamicQuery); 

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return listSearchResultRecords;
    }

    @AuraEnabled(cacheable=true)
    public static list<String> listObjectsSalesforce(){
        
        List<String> listObjects = new List<String>();

        try {
           
            List< Schema.SObjectType > listaObjType = Schema.getGlobalDescribe().Values();

            for ( Schema.SObjectType objeto : listaObjType ) {  
  
              String[] arrayObjeto = new String[]{objeto.getDescribe().getName()};

              if(Schema.describeSObjects(arrayObjeto)[0].isSearchable() && Schema.describeSObjects(arrayObjeto)[0].isQueryable()){
                listObjects.add(objeto.getDescribe().getName());
              }       
            }
            
            listObjects.sort();
        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return listObjects;
    }
}