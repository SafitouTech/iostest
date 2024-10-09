import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saisie de Mot de Passe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasswordInputPage(),
    );
  }
}

class PasswordInputPage extends StatefulWidget {
  @override
  _PasswordInputPageState createState() => _PasswordInputPageState();
}

class _PasswordInputPageState extends State<PasswordInputPage> {
  final List<String> _password = List.filled(5, '');
  final List<String> _displayPassword = List.filled(5, '');
  final _focusNodes = List.generate(5, (index) => FocusNode());
  Timer? _hideTimer;

  void _onKeyPressed(String value) {
    for (int i = 0; i < _password.length; i++) {
      if (_password[i].isEmpty) {
        setState(() {
          _password[i] = value;
          _displayPassword[i] = value;
        });
        if (_hideTimer != null && _hideTimer!.isActive) {
          _hideTimer!.cancel();
        }

        _hideTimer = Timer(Duration(seconds: 1), () {
          setState(() {
            _displayPassword[i] = '*' ;// Remplace le chiffre par une étoile après 1 seconde
          });
        });

        if (i < _password.length - 1) {
          _focusNodes[i + 1].requestFocus();
        }
        break;
      }
    }
  }

  void _onDelete() {
    for (int i = _password.length - 1; i >= 0; i--) {
      if (_password[i].isNotEmpty) {
        setState(() {
          _password[i] = '';
          _displayPassword[i] = '';
        });
        if (i > 0) {
          _focusNodes[i - 1].requestFocus();
        }
        break;
      }
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Icon(Icons.arrow_back, size: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: ClipRect(
                  child: Image(
                    image: AssetImage('images/logo1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Choisir un code secret',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 40),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Champs de saisie du mot de passe
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    return SizedBox(
                      width: 40,
                      height: 40,
                      //pas ca je doit le perso
                      child: Center(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(100),
                             // borderSide: BorderSide(color: Color(0xFF1EEB3344))
                            ),
                            hintText: _displayPassword[index], // Affichage du chiffre temporaire ou étoile
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 10),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Choisir un code secretChoisir un code secret',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ), Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Choisir un code secret',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.redAccent
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 30),
                //  my clavier numérique personnalisé
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 colonnes
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2, // Ajuste la taille des boutons
                  ),
                  itemCount: 12, // 12 boutons
                  itemBuilder: (context, index) {
                    String buttonText;
                    if (index < 9) {
                      buttonText = (index + 1).toString();
                    } else if (index == 9) {
                      buttonText = '';
                    } else if (index == 10) {
                      buttonText = '0';
                    } else {
                      buttonText = '⌫';
                    }

                    return buttonText.isEmpty
                        ? SizedBox.shrink()
                        : GestureDetector(
                      onTap: () {
                        if (buttonText == '⌫') {
                          _onDelete();
                        } else {
                          _onKeyPressed(buttonText);
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade100,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Valider',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
