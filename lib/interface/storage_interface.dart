abstract class StorageInterface {
  Future<String?> readData(String key);
  void saveData(String key, String data);
  void removeData(String key);
  void clearStorage();
  bool contains(String key);
}
