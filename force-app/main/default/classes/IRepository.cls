global interface IRepository {
  SObject get(Id id);
  SObject getCustomFieldsById(String id, List<String> selectFields);
  SObject getCustomFieldsById(
    String id,
    List<String> selectFields,
    Boolean isForView
  );
  void deleteObject(List<SObject> entities);
  void insertObject(List<SObject> entities);
  void updateObject(List<SObject> entities);
  void saveObject(List<SObject> entities);

  void deleteObject(List<SObject> entities, List<String> fields);
  void insertObject(List<SObject> entities, List<String> fields);
  void updateObject(List<SObject> entities, List<String> fields);
  void saveObject(List<SObject> entities, List<String> fields);

  List<Sobject> queryObjects(Repository.QueryBuilder queryBuilder);
  Integer queryCount(Repository.QueryBuilder queryBuilder);
  List<SObject> queryObjects(Specification specification);
}
