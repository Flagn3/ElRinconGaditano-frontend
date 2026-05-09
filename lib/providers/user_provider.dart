import 'package:flutter/material.dart';
import 'package:rincongaditano/models/user.dart';
import 'package:rincongaditano/models/response_api.dart';
import 'package:rincongaditano/services/user_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService;
  final _storage = const FlutterSecureStorage();

  User? _activeUser;
  bool _isLoading = false;
  String _errorMessage = '';
  List<User> userList = [];

  User? get activeUser => _activeUser;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  UserProvider(this._userService) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    String? token = await _storage.read(key: 'token');
    String? userId = await _storage.read(key: 'userId');
    if (token != null && userId != null) {
      _activeUser = User(token: token, id: int.parse(userId));
      await getById(int.parse(userId), token);
    }
  }

  //login
  Future<void> login(String email, String password) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _userService.login(email, password);
      if (response.success && response.data != null) {
        _activeUser = User.fromLoginJson(response.data);

        await _storage.write(key: 'token', value: _activeUser!.token);
        await _storage.write(key: 'userId', value: _activeUser!.id.toString());
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //register
  Future<void> register(
    String name,
    String secondName,
    String email,
    String password,
    String address,
  ) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _userService.register(
        name,
        secondName,
        email,
        password,
        address,
      );
      if (!response.success) {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //logout
  Future<void> logout() async {
    _activeUser = null;
    await _storage.deleteAll();
    notifyListeners();
  }

  //get all
  Future<void> getAllUsers() async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      if (_activeUser == null || _activeUser!.token == null) {
        _errorMessage = 'Usuario no autenticado o token inválido';
        return;
      }

      ResponseApi response = await _userService.getAllUsers(
        _activeUser!.token!,
      );

      if (response.success && response.data != null) {
        userList = (response.data as List)
            .map((u) => User.fromJson(u))
            .toList();
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //get by id
  Future<void> getById(int id, String token) async {
    try {
      ResponseApi response = await _userService.getById(id, token);
      if (response.success && response.data != null) {
        _activeUser = User.fromJson(response.data);
        _activeUser!.token = token;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  //delete
  Future<void> deleteUser(int id) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      if (_activeUser == null || activeUser!.token == null) {
        _errorMessage = 'Usuario no autenticado o token inválido';
        return;
      }
      ResponseApi response = await _userService.deleteUser(
        id,
        _activeUser!.token!,
      );

      if (response.success) {
        await getAllUsers();
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //activate or deactivate
  Future<void> editActivation(int id, bool isActive) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      if (_activeUser == null || _activeUser!.token == null) {
        _errorMessage = 'Usuario no autenticado o token inválido';
        return;
      }
      ResponseApi response;

      if (isActive) {
        response = await _userService.deactivateUser(id, _activeUser!.token!);
      } else {
        response = await _userService.activateUser(id, _activeUser!.token!);
      }
      if (response.success) {
        await getAllUsers();
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //update
  Future<void> updateUser(
    int id,
    String name,
    String secondName,
    String address,
  ) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      if (_activeUser == null || _activeUser!.token == null) {
        _errorMessage = 'Usuario no autenticado o token inválido';
        return;
      }
      ResponseApi response = await _userService.updateUser(
        id,
        name,
        secondName,
        address,
        _activeUser!.token!,
      );

      if (response.success) {
        if (_activeUser!.id == id) {
          await getById(id, _activeUser!.token!);
        } else {
          await getAllUsers();
        }
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
