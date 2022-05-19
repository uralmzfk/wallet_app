// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:wallet_app/models/user_model.dart';
import 'package:wallet_app/screens/home.dart';

class EnterValue extends StatefulWidget {
  const EnterValue({Key? key}) : super(key: key);

  @override
  State<EnterValue> createState() => _EnterValueState();
}

class _EnterValueState extends State<EnterValue> {
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  final valueController = TextEditingController();
  List<bool> isSelected = [false, true];
  var currentValue;
  var resultValue;
  var textValue;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final valueField = TextFormField(
      autofocus: false,
      controller: valueController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        valueController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );

    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xFF00B1C1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          postDetailsToFirestore();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: Text(
          'Сохранить',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF00B1C1),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ToggleButtons(
                      isSelected: isSelected,
                      color: Color(0xFF00B1C1),
                      borderColor: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text('Расход',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              )),
                          //Icon(Iconsax.minus, color: Colors.red),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Text('Доход',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              )),
                          //Icon(Iconsax.add, color: Colors.green),
                        ),
                      ],
                      onPressed: (index) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            if (i == index) {
                              isSelected[i] = true;
                            } else {
                              isSelected[i] = false;
                            }
                          }
                        });
                      },
                    ),
                    SizedBox(height: 40),
                    valueField,
                    SizedBox(height: 30),
                    saveButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _ExpenceIncome() {
    if (isSelected[0]) {
      currentValue = double.parse('${loggedInUser.balance}');
      textValue = double.parse(valueController.text);
      return resultValue = currentValue - textValue;
    } else {
      currentValue = double.parse('${loggedInUser.balance}');
      textValue = double.parse(valueController.text);
      return resultValue = currentValue + textValue;
    }
  }

  postDetailsToFirestore() async {
    ///вызов базы данных
    ///вызов пользователя
    ///отправка этих данных
    FirebaseFirestore baseStore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    ///изменение баланса
    userModel.email = user!.email;

    await baseStore.collection('users').doc(user.uid).update({
      'balance': ('{:.2f}'.format([_ExpenceIncome()])).toString()
    });
  }
}
