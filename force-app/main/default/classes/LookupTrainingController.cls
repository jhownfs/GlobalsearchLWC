public with sharing class LookupTrainingController {

    @AuraEnabled(cacheable=true)
    public static list<SObject> buscaRegistros(String termo, String objeto){
        list<SObject> listaResultadoPesquisa = new list<SObject>();
        
        String termoPesquisa = '%' + String.escapeSingleQuotes(termo) + '%';

        String queryDinamica = 'SELECT Id, Name';
        queryDinamica += ' FROM ' +  objeto;
        queryDinamica += ' WHERE Name LIKE: termoPesquisa';
       
        try {
           
            listaResultadoPesquisa = database.query(queryDinamica); 

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return listaResultadoPesquisa;
    }

    @AuraEnabled(cacheable=true)
    public static list<String> listaObjetos(){
        
        List<String> listaObjetos = new List<String>();

        try {
           
            List< Schema.SObjectType > listaObjType = Schema.getGlobalDescribe().Values();

            for ( Schema.SObjectType objeto : listaObjType ) {  
  
              String[] arrayObjeto = new String[]{objeto.getDescribe().getName()};

              if(Schema.describeSObjects(arrayObjeto)[0].isSearchable() && Schema.describeSObjects(arrayObjeto)[0].isQueryable()){
                ListaObjetos.add(objeto.getDescribe().getName());
              }       
            }
            
            ListaObjetos.sort();
        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return ListaObjetos;
    }
}