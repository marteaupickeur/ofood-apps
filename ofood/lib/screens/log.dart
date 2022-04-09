import 'package:flutter/material.dart';
import 'package:ofood/models/user.dart';
import 'package:ofood/services/authentification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Log extends StatefulWidget {
  const Log({Key? key}) : super(key: key);

  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  // this var will switch the screen
  // if true sign_in screen
  // if false sign_up screen
  bool switchScreen = true;

  // the form key
  final _fKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // these vars are for FIREBASE
  final AuthenticationService auth = AuthenticationService();
  bool loading = false;
  var firebaseError = '';

  // this function will on each
  // switch screen redefine these vars
  // for appropiated form
  onSwitchScreen() {
    if (mounted) {
      setState(() {
        _fKey.currentState?.reset();
        nameController.text = '';
        numberController.text = '';
        emailController.text = '';
        passwordController.text = '';
        switchScreen = !switchScreen;
        firebaseError = '';
      });
    }
  }

  // validation of your form
  validatonForm() async {
    if (mounted) {
      if (_fKey.currentState!.validate()) {
        setState(() {
          loading = true;
        });
        var name = nameController.text; // Only for register or sign Up widget
        var number =
            numberController.text; // Only for register or sign Up widget
        var email = emailController.text; // for sign_up and sign_in widget
        var password =
            passwordController.text; // for sign_up and sign_in widget

        // the firebase auth depends on switchscreen value
        dynamic result = switchScreen
            ? await auth.signInWithEmailAndPassword(email, password)
            : await auth.registerWithEmailAndPassword(
                name, number, email, password);

        // must use switch case but it works perfectly
        // depends on result vars some actions to do
        // but ( if not errors ) reach the agence screen
        if (result is AppUser) {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("myUserId", result.userId);

          Navigator.pushNamed(context, '/agence');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 900),
            content: Row(
              children: const [
                Expanded(child: SizedBox()),
                Text("Bienvenue",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                Expanded(child: SizedBox()),
              ],
            ),
            backgroundColor: Colors.orange,
          ));
          setState(() {
            loading = false;
          });
        } else if (result == 'not_found') {
          setState(() {
            loading = false;
            firebaseError = 'email inexistant !';
          });
        } else if (result == 'wrong_password') {
          setState(() {
            loading = false;
            firebaseError = 'mot de passe incorrect !';
          });
          //if null problem de connexion internet aussi
          // if user is desactivated on firebase backoffice
        } else if (result == null) {
          setState(() {
            loading = false;
            firebaseError = 'veuillez mettre un email correct !';
          });
        } else if (result == 'weak') {
          setState(() {
            loading = false;
            firebaseError = 'mot de passe faible !';
          });
        } else if (result == 'already') {
          setState(() {
            loading = false;
            firebaseError = 'email déjà utilisé !';
          });
        } else {
          // Anonymous error
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("$result"),
          ));
        }
      }
    }
  }

  // to rlease the memory for this vars
  // when we change the widget focus
  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    numberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // On this widget we have two 2 screens on the same
  // scaffold and we put some switch button to go
  // to a page to an other
  @override
  Widget build(BuildContext context) {
    // WillPopScope will disable the native Back button
    // for this widget
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SafeArea(
              bottom: true,
              child: Center(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 38.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "O'",
                            style:
                                TextStyle(color: Colors.orange, fontSize: 25),
                          ),
                          // check wich screen
                          switchScreen
                              ? const Text("connexion",
                                  style: TextStyle(fontSize: 25))
                              : const Text("inscription",
                                  style: TextStyle(fontSize: 25))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 500,
                      child: Form(
                        key: _fKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // This first TextFormField will be load
                            // according to the switchScreen state.
                            //it will be charge on register and not on sign-in
                            !switchScreen
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 18),
                                    child: TextFormField(
                                      controller: nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Renseigner votre nom complet';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orange,
                                                width: 2.0),
                                          ),
                                          border: OutlineInputBorder(),
                                          label: Text("Nom complet")),
                                    ),
                                  )
                                : Container(),
                            // This first TextFormField will be load
                            // according to the switchScreen state.
                            //it will be charge on sign-up and not on sign-in
                            !switchScreen
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 18),
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      controller: numberController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Renseigner votre numero de téléphone';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orange,
                                                width: 2.0),
                                          ),
                                          border: OutlineInputBorder(),
                                          label: Text("Telephone")),
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Renseigner un email';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.orange, width: 2.0),
                                    ),
                                    border: OutlineInputBorder(),
                                    label: Text("Email")),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 28.0),
                              child: TextFormField(
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Renseigner un mot de passe';
                                  }
                                  // if (value.length < 6) {
                                  //   return 'Mot de passe court minimum 6 caractères !';
                                  // }
                                  return null;
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.orange, width: 2.0),
                                    ),
                                    border: OutlineInputBorder(),
                                    label: Text("Mot de passe")),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // This button will switch on UI the screen
                                TextButton(
                                    style: const ButtonStyle(),
                                    onPressed: () {
                                      onSwitchScreen();
                                    },
                                    child: switchScreen
                                        ? const Text("Inscription")
                                        : const Text("Connexion")),
                                const Expanded(child: SizedBox()),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.orange)),
                                    onPressed: () {
                                      validatonForm();
                                    },
                                    child: loading
                                        ? const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ),
                                          )
                                        : switchScreen
                                            ? const Text("Connexion",
                                                style: TextStyle(
                                                    color: Colors.black))
                                            : const Text("Inscription",
                                                style: TextStyle(
                                                    color: Colors.black)))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: Text(
                                firebaseError,
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ))),
        ),
      ),
    );
  }
}
