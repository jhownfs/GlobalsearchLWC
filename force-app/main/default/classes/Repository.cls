global virtual class Repository implements IRepository {

    private  Schema.SObjectType objectType {get; set;}
    private List<String> defaultFields {get; set;}

    global virtual List<String> getProjection(){
        return defaultFields;
    }

    global virtual Schema.SObjectType getSObjectType(){
        return objectType;
    }

    global Repository(Schema.SObjectType objectType, List<String> defaultFields){
        this.objectType = objectType;
        this.defaultFields = defaultFields;
    } 

   	global virtual void deleteObject(List<SObject> entities) {
		delete entities;
	}
	global virtual void insertObject(List<SObject> entities) {
		insert entities;
	}
	global virtual void updateObject(List<SObject> entities) {
		update entities;
	}
	global virtual void saveObject(List<SObject> entities) {
		upsert entities;
	}

    global virtual void deleteObject(List<SObject> entities, List<String> fields) {
		delete entities;
	}

	global virtual void insertObject(List<SObject> entities, List<String> fields) {
		insert entities;
	}

	global virtual void updateObject(List<SObject> entities, List<String> fields) {
		update entities;
	}

	global virtual void saveObject(List<SObject> entities, List<String> fields) {
        //PermissionHelper.checkPermission(fields,PermissionHelper.CREATEE, entities.getsObjectType());
		upsert entities;
	}

	global SObject get(Id id) {
		SObject result = null;

        QueryBuilder queryBuilder = new QueryBuilder()
           .setIdClause('Id = \'' + id + '\'');

		List<SObject> resultList = queryObjects(queryBuilder);

		if (!resultList.isEmpty()) {
			result = resultList.get(0);
		}

		return result;
	}

      global SObject getCustomFieldsById(String id, List<String> selectFields, Boolean isForView) {
		SObject result = null;
        QueryBuilder queryBuilder;
        if(isForView == true){
            queryBuilder = new QueryBuilder()
            .selectFields(selectFields)
            .setIdClause('Id = \'' + id + '\'')
            .isForView();     
        }else{
            queryBuilder = new QueryBuilder()
            .selectFields(selectFields)
            .setIdClause('Id = \'' + id + '\'');
        }
        

		List<SObject> resultList = queryObjects(queryBuilder);

		if (!resultList.isEmpty()) {
			result = resultList.get(0);
		}

		return result;
	}

    global SObject getCustomFieldsById(String id, List<String> selectFields) {
        SObject result = null;
        QueryBuilder queryBuilder = new QueryBuilder()
            .selectFields(selectFields)
            .setIdClause('Id = \'' + id + '\'');

        List<SObject> resultList = queryObjects(queryBuilder);

        if (!resultList.isEmpty()) {
            result = resultList.get(0);
        }

        return result;
    }

	/*global virtual List<SObject> queryObjects(Specification specification) {
        QueryBuilder queryBuilder = new QueryBuilder()
            .whereSpecification(specification);
        
        return this.queryObjects(queryBuilder);
	}*/

    global virtual List<Sobject> queryObjects(QueryBuilder queryBuilder){
        queryBuilder.fromObjectType(objectType);
        if(queryBuilder.projection == null || queryBuilder.projection.isEmpty()){
            queryBuilder.selectFields(defaultFields);
        }

        //PermissionHelper.checkPermission(queryBuilder.projection,PermissionHelper.ACCESS, objectType);
        String parsedSOQL = queryBuilder.build();
        List<SObject> result = Database.query(parsedSOQL);
        return result;
    }

    global virtual Integer queryCount(QueryBuilder queryBuilder){
        queryBuilder.fromObjectType(objectType);
        if(queryBuilder.projection == null || queryBuilder.projection.isEmpty()){
            queryBuilder.selectFields(defaultFields);
        }
        //PermissionHelper.checkPermission(queryBuilder.projection,PermissionHelper.ACCESS, objectType);
        String parsedSOQL = queryBuilder.build();
        Integer result = Database.countQuery(parsedSOQL);
        
        return result;
    }
  
    global virtual class QueryBuilder {

        global Integer rowLimit {get; set;}
        global Integer offSet {get; set;}
        global Boolean isForView{get; set;}
        global List<String> projection {get; set;}
        global List<String> fieldOrderByList {get; set;}
        global Schema.SObjectType objectType {get; set;}
        protected String idClause {get; set;}

        global String whereSpecificationClause {
            get{
                if(String.isBlank(whereSpecificationClause)){
                    return idClause;
                }
                return whereSpecificationClause;
            }
            set;
        }
        
        global QueryBuilder selectFields(List<String> projection){        
            this.projection =  projection;
            return this;
        }
        
        protected QueryBuilder fromObjectType(Schema.SObjectType objectType){
            this.objectType =  objectType;
            return this;
        }
        
        protected QueryBuilder setIdClause(String idClause){
            this.idClause = idClause;
            return this;
        }
        
        /*global QueryBuilder whereSpecification(Specification whereSpecification){
            if(whereSpecification != null){
                this.whereSpecificationClause = whereSpecification.toSOQLClauses();
            }
            return this;
        }*/
        
        global QueryBuilder orderBy(List<String> fieldOrderByList){
            this.fieldOrderByList = fieldOrderByList;
            return this;
        }
        
        global QueryBuilder rowLimit(Integer rowLimit){
            this.rowLimit = rowLimit;
            return this;
        }
        
        global QueryBuilder offSet(Integer offSet){
            this.offSet = offSet;
            return this;
        }

        global QueryBuilder isForView(){
            this.isForView = true;
            return this;
        }

        protected String build() {
        	/*if(objectType == null || projection == null || projection.isEmpty()){
                	throw new QueryBuilderException('Select Fields and SObjectType are mandatory to build a query '+ 
                                                '[Select Fields: {0} ] [SObjectType: '+ objectType +' ]', 
                                                 projection );
        	}*/
            
            String soql = 'SELECT {0}' +  
                '  FROM {1}';

            String parsedSOQL = String.format(soql, new String[] {
                String.join(projection, ','), 
                    objectType.getDescribe().getName()
             });
            
            if(String.isNotBlank(whereSpecificationClause)){
                parsedSOQL += ' WHERE ' + whereSpecificationClause;
            }
            
            if(fieldOrderByList != null && fieldOrderByList.size() > 0) {
                parsedSOQL += ' ORDER BY ' + String.join(fieldOrderByList, ',');
            }
            
            if (rowLimit != null && rowLimit > 0) {
                parsedSOQL += ' LIMIT ' + rowLimit;
            }
            
            if (offSet != null && offSet > 0) {
                parsedSOQL += ' OFFSET ' + offSet;
            }

            if (isForView != null && isForView){
                parsedSOQL += ' FOR VIEW';
            }
                       
            return parsedSOQL;
        }
        
    }
}