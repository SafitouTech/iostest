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
    print('Button pressed: $value'); // Ajoutez cette ligne pour le débogage
    for (int i = 0; i < _password.length; i++) {
      if (_password[i].isEmpty) {
        setState(() {
          _password[i] = value;
          _displayPassword[i] = value;
        });
        if (_hideTimer != null && _hideTimer!.isActive) {
          _hideTimer!.cancel();
        }

        _hideTimer = Timer(Duration(milliseconds: 100), () {
          setState(() {
            _displayPassword[i] = '*';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: AppBar(
          leading: Icon(Icons.arrow_back, size: 35),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: ClipRect(
                  child: Image(
                    image: AssetImage('images/logo_Companion.png'),
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
                    return Container(
                      width: 43,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                        child: Text(
                          _displayPassword[index],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    );
                  }),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Veuillez choisir un code secret et ne le communiquer jamais',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                 Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    '* des chiffres totalement different',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 30),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 colonnes
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: 12,
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
                            behavior: HitTestBehavior.opaque, // Assure que tous les gestes sont capturés
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: buttonText == '⌫'
                                    ? Transform(
                                    transform: Matrix4.skewX(0.3),
                                      child: Icon(
                                        Icons.backspace_rounded,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    )
                              : Text(
                                buttonText,
                                style: TextStyle(
                                  fontSize: 25,
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
                  child: GestureDetector(
                    /*onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OptValidation()),
                      );
                    },*/
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*class OptValidation extends StatefulWidget {
  const OptValidation({super.key});

  @override
  State<OptValidation> createState() => _OptValidationState();
}

class _OptValidationState extends State<OptValidation> {

  final List<String> _code = List.filled(5, '');
  final List<String> _displayCode = List.filled(5, '');
  final _focusNodes = List.generate(5, (index) => FocusNode());
  Timer? _hideTimer;

  void _onKeyPressed(String value) {
    for (int i = 0; i < _code.length; i++) {
      if (_code[i].isEmpty) {
        setState(() {
          _code[i] = value;
          _displayCode[i] = value;
        });
        if (_hideTimer != null && _hideTimer!.isActive) {
          _hideTimer!.cancel();
        }

        _hideTimer = Timer(Duration(milliseconds: 500), () {
          setState(() {
            _displayCode[i] = '*'; // Remplace le chiffre par une étoile après un court délai
          });
        });

        if (i < _code.length - 1) {
          _focusNodes[i + 1].requestFocus();
        }
        break;
      }
    }
  }

  void _onDelete() {
    for (int i = _code.length - 1; i >= 0; i--) {
      if (_code[i].isNotEmpty) {
        setState(() {
          _code[i] = '';
          _displayCode[i] = '';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Entrez le code reçu par SMS',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                return Container(
                  width: 43,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _displayCode[index],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
                childAspectRatio: 1.8,
              ),
              itemCount: 12,
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
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: buttonText == '⌫'
                          ? Icon(Icons.backspace_rounded, color: Colors.black, size: 20)
                          : Text(
                        buttonText,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}*/