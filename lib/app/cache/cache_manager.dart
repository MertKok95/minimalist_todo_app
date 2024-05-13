import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/base_model.dart';

class CacheManager {
  static CacheManager? _cacheManager;
  SharedPreferences? _preferences;

  static CacheManager get getInstance {
    _cacheManager ??= CacheManager._internal();
    return _cacheManager!;
  }

  CacheManager._internal() {
    initPreferences();
  }

  Future<void> initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> addCacheItem<T extends IBaseModel>(String id, T model) async {
    try {
      final stringModel = jsonEncode(model.toJson());
      final guid = '$T-$id';
      return await _preferences!.setString(guid, stringModel);
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeCacheItem<T extends IBaseModel>(String id, T model) async {
    final guid = '$T-$id';
    return await _preferences!.remove(guid);
  }

  T? getCacheItem<T extends IBaseModel>(String id, T model) {
    final cacheData = _preferences!.getString('$T-$id') ?? '';

    try {
      if (cacheData.isNotEmpty) {
        final modelJson = jsonDecode(cacheData);
        return model.fromJson(modelJson);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
