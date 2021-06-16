import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/RoomsModel.dart';
import 'package:flutter_chat/models/UserModel.dart';
import 'package:flutter_chat/repos/ChatRoomRepo.dart';
import 'package:flutter_chat/screens/ChatRooms.dart';
import 'package:flutter_chat/screens/Register.dart';
import 'package:flutter_chat/screens/SignIn.dart';
import 'package:flutter_chat/services/Auth.dart';
import 'package:flutter_chat/services/Database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  late AuthUser _authUser;

  @override
  Widget build(BuildContext context) {

    _authUser = Provider.of<AuthUser>(context,listen: false);
    _authUser.getUserIdFromLocalStorage();

    return Consumer<AuthUser>(
      builder: (context, value, widget) {
        return FutureBuilder(
          future: value.getUserIdFromLocalStorage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamProvider<bool>.value(
                value: _authUser.getSession,
                initialData: true,
                catchError: (_, __) => false,
                child: WrapperWidget(),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}

class WrapperWidget extends StatefulWidget {
  const WrapperWidget({Key? key}) : super(key: key);

  @override
  _WrapperWidgetState createState() => _WrapperWidgetState();
}

class _WrapperWidgetState extends State<WrapperWidget> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {

    bool res = Provider.of<bool>(context);

    return res == false
        ? showSignIn
            ? SignIn(toggle: toggleView)
            : Register(toggle: toggleView)
        : StreamProvider<List<RoomsModel>>.value(
            initialData: [],
            value: Database().getChatRooms,
            child: ChatRooms(),
          );
  }
}
