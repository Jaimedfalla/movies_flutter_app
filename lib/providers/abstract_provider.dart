abstract class Searcheable<T>{
  Future<List<T>> search(String query);
}