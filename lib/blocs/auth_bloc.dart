
import 'dart:async';
import 'package:avideo/api/atoto_api.dart';
import 'package:avideo/blocs/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BlocBase {
  final AtotoApi api = AtotoApi();

  final BehaviorSubject<String> _errorController = BehaviorSubject<String>();
  Stream<String> get curError => _errorController.stream;
  Sink<String> get _changeError => _errorController.sink;

  void addError(String data) {
     _changeError.add(data);
  }

  final BehaviorSubject<bool> _successController = BehaviorSubject<bool>();
  Stream<bool> get curSuccess => _successController.stream;
  Sink<bool> get _changeSuccess => _successController.sink;

  void addSuccess(bool data) {
    _changeSuccess.add(data);
  }

  final BehaviorSubject<String> _nameStreamController = BehaviorSubject<String>();
  Stream<String> get curName => _nameStreamController.stream;
  Sink<String> get _changeName => _nameStreamController.sink;

  void addName(String data) {
    _changeName.add(data);
  }

  final BehaviorSubject<String> _passwordStreamController = BehaviorSubject<String>();
  Stream<String> get curPass => _passwordStreamController.stream;
  Sink<String> get _changePass => _passwordStreamController.sink;

  void addPass(String data) {
    _changePass.add(data);
  }

  final BehaviorSubject<bool> _secureStreamController = BehaviorSubject<bool>();
  Stream<bool> get curSecure => _secureStreamController.stream;
  Sink<bool> get _changeSecure => _secureStreamController.sink;

  void changeSecure(bool data) {
    _changeSecure.add(data);
  }

  final BehaviorSubject<String> _promoStreamController = BehaviorSubject<String>();
  Stream<String> get curPromo => _promoStreamController.stream;
  Sink<String> get _changePromo => _promoStreamController.sink;

  void addPromo(String data) {
    _changePromo.add(data);
  }

  final BehaviorSubject<bool>  _promoCheckStreamController = BehaviorSubject<bool>();
  Stream<bool> get curCheck => _promoCheckStreamController.stream;
  Sink<bool> get _changeCheck => _promoCheckStreamController.sink;

  void checkPromo(bool data) {
    _changeCheck.add(data);
  }


  final PublishSubject<String> _provideController = PublishSubject<String>();
  Stream<String> get curUrl => _provideController.stream;
  Sink<String> get _changeUrl => _provideController.sink;

  void addUrl(String data) {
    _changeUrl.add(data);
  }

  @override
  void dispose() {
    _errorController.close();
     _nameStreamController.close();
    _passwordStreamController.close();
    _secureStreamController.close();
    _promoStreamController.close();
    _promoCheckStreamController.close();
    _successController.close();
    _provideController.close();
  }
}
