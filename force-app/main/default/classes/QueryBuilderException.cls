public class QueryBuilderException extends Exception {
  public QueryBuilderException(String message, List<String> lstString) {
    message.replace('{0}', string.join(lstString, ','));

    system.debug(message);
  }
}
