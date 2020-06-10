
class AuthResult extends Object {
  AuthResult(this.success, this.result, this.error);

  AuthResult.fromJSON(Map<String, dynamic> json)
      : success = json['success'],
        result = json['token'],
        error = json['error'] as String;

  final bool success ;
  final String result;
  final String error;

}

class AuthUser extends Object {
  AuthUser(this.id, this.login, this.email, this.type, this.layout);

  AuthUser.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        login = json['login'],
        email = json['email'],
        type = json['type'],
        layout = json['layout'];

  final int id;
  final String login;
  final String email;
  final int type;
  final bool layout;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['email'] = email;
    data['type'] = type;
    data['layout'] = layout;
    return data;
  }
}