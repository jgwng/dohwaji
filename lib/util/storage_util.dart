

import "package:dohwaji/interface/storage_interface.dart";
import "package:dohwaji/util/general/general_platform_storage.dart";
import "package:dohwaji/util/web/web_platform_storage.dart";
import "package:flutter/foundation.dart";

class LocalStorage{
  static final LocalStorage instance = LocalStorage._internal();
  factory LocalStorage()=>instance;
  LocalStorage._internal();
  StorageInterface get _platformInterface => (kIsWeb) ? WebStorageUtil() : GeneralStorageUtil();

  Future<String?> read(String key) async{
    var data = await _platformInterface.readData(key);
    return data;
  }

  void save(String key,String data) async{
    _platformInterface.saveData(key,data);
  }

  Future remove(String key) async{
    _platformInterface.removeData(key);
  }

  void clear(){
    _platformInterface.clearStorage();
  }

  bool? contain(String key){
    bool hasData = _platformInterface.contains(key);
    return hasData;
  }
}