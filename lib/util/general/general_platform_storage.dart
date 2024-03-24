import 'package:dohwaji/interface/storage_interface.dart';

class GeneralStorageUtil extends StorageInterface {
  @override
  void clearStorage() {
    // TODO: implement clear
  }

  @override
  Future<String?> readData(String key) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  void removeData(String key) {
    // TODO: implement remove
  }

  @override
  void saveData(String key, String data) {
    // TODO: implement save
  }

  @override
  bool contains(String key) {
    return false;
  }
}
