abstract class Searcheable<T>{
  void getSuggestonByQuery(String query);
  Stream<List<T>> get suggestionsStream;
 }