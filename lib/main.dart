import 'package:eval_ex/expression.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF16a085),
        surface: Color(0xFF1a1b2e),
        onSurface: Color(0xFFF5F5F5),
      ),
      ),
      home: const MyHomePage(title: 'calculator'),
    );
  }
}

Widget addButton(String text, callback) {
  return MaterialButton(
    onPressed: callback,
    color: Color(0xFF16a085),
    child: Text(
      text,
      style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 26
      ),
    ),

  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool justComputed = false;
  TextEditingController inputController = new TextEditingController();
  TextEditingController resultController = new TextEditingController();

  void write(String text) {
    setState(() {
      if (justComputed) {
        this.justComputed = false;

        if (this.resultController.text == 'Error') {
          inputController.text = text;

        } else {
          // If input is function, and the calculator just computed, the function is inserted before the result
          if (text.length > 1 && text.endsWith('(')) {
            inputController.text = text + resultController.text;

          } else {
            this.inputController.text = this.resultController.text + text;
          }
        }

        this.resultController.text = "";

      } else {
        inputController.text += text;
      }
    });
  }

  void clear() {
    setState(() {
      inputController.text = "";
      resultController.text = "";

      if (justComputed) {
        justComputed = false;
      }
    });
  }

  void delete() {
    setState(() {
      inputController.text = inputController.text.substring(0, inputController.text.length - 1);;
    });
  }

  void calculate() {
    var text = this.inputController.text.replaceAll('π', '3.141592653589793');
    text.replaceAll("e", '2.718281828459045');

    var expression = Expression(text);

    setState(() {
      try {
        this.resultController.text = expression.eval().toString();
      } catch (e) {
        print(e);
        this.resultController.text = "Error";
      }

      justComputed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF16a085),
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              TextField(
                controller: inputController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF16a085)
                    )
                  ),
                  fillColor: Color(0xFF16a085)
                ),
                style: TextStyle(
                  color: Color(0xFFFFFFFF)
                ),
                readOnly: true,
                minLines: 4,
                maxLines: 4,
              ),
              Spacer(),
              TextField(
                controller: resultController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF16a085)
                    )
                  ),
                  fillColor: Color(0xFF16a085)
                ),
                style: TextStyle(
                  color: Color(0xFFFFFFFF)
                ),
                readOnly: true,
                minLines: 4,
                maxLines: 4,
              ),
              Spacer(),
              SizedBox(
                height: 5 / 9 * screen.height,
                child: GridView.count(
                  primary: false,
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.75,

                  children: [
                    addButton('(', () => this.write("(")), addButton(')', () => this.write(")")), addButton('AC', this.clear), addButton('<', this.delete),
                    addButton('log', () => this.write('log(')), addButton('√', () => this.write('sqrt(')), addButton('^', () => this.write('^')),addButton('deg', () => this.write('deg(')),
                    addButton('sin', () => this.write("sin(")), addButton('cos', () => this.write("cos(")), addButton('tan', () => this.write("tan(")), addButton('rad', () => this.write("rad(")),
                    addButton('π', () => this.write("π")), addButton('e', () => this.write("e")), addButton('g', () => this.write("9.81")), addButton('/', () => this.write("/")),
                    addButton('7', () => this.write("7")), addButton('8', () => this.write("8")), addButton('9', () => this.write("9")), addButton('*', () => this.write("*")),
                    addButton('4', () => this.write("4")), addButton('5', () => this.write("5")), addButton('6', () => this.write("6")), addButton('-', () => this.write("-")),
                    addButton('1', () => this.write("1")), addButton('2', () => this.write("2")), addButton('3', () => this.write("3")), addButton('+', () => this.write("+")),
                    addButton('!', () => this.write("!")), addButton('0', () => this.write("0")), addButton('.', () => this.write(".")), addButton('=', this.calculate)
                  ]
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
