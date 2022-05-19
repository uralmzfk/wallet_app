class UserModel {
  String? uid;
  String? email;
  String? name;
  String? surname;
  String? balance;

  UserModel({this.uid, this.email, this.name, this.surname, this.balance});

  ///получение данных с сервера
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      surname: map['surname'],
      balance: map['balance'],
    );
  }

  ///отправка данных на сервер
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'surname': surname,
      'balance': balance,
    };
  }
}

/*class UserBalance {
  String? balance;

  UserBalance({this.balance});

  Map<String, dynamic> toBase() {
    return {
      'balance': balance,
    };
  }
}*/
