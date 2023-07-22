global class RepositoryFactory implements IRepositoryFactory {
  global IRepository create(SObjectType soType) {
    return new Repository(soType, new List<String>{ 'id' });
  }
}
