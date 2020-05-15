import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:number_display/number_display.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = '';
  double result;
  String res = '';
  bool decimalPresent = false;
  double resultFontSize = 30;
  // To display number after removing the trailing zeros at the end of a number after decimal point
  final display = createDisplay(
    decimal: 8,
  );

  //Function to do the calculation/requisite on pressing a button.
  void math(String buttonPressed) {
    setState(() {
      if (buttonPressed == 'CLR') {
        equation = '';
        res = '0';
      } else if (buttonPressed == '.') {
        if (decimalPresent == false) {
          equation = equation + buttonPressed;
          decimalPresent = true;
        }
      } else if (buttonPressed == '=') {
        res = display(result); //from package number display.
        equation = '';
      } else if (buttonPressed == '+' ||
          buttonPressed == "-" ||
          buttonPressed == '*' ||
          buttonPressed == '/' ||
          buttonPressed == '^') {
        decimalPresent = false;
        String lastEntered = equation.substring(equation.length - 1);
        //To ignore the previous operand on pressing the another operand soon after.
        if (lastEntered == '+' ||
            lastEntered == "-" ||
            lastEntered == '*' ||
            lastEntered == '/' ||
            lastEntered == '^')
          equation = equation.substring(0, equation.length - 1) + buttonPressed;
        else
          equation = equation + buttonPressed;
      } else {
        if (buttonPressed == 'DLT')
          equation = equation.substring(0, equation.length - 1);
        else //if it is a number
          equation = equation + buttonPressed;
//On deleting the previous character, if last character is not an operand, do the calculation.. else do the calculation ignoring the last operand.
        if (equation.substring(equation.length - 1) != '+' &&
            equation.substring(equation.length - 1) != '-' &&
            equation.substring(equation.length - 1) != '*' &&
            equation.substring(equation.length - 1) != '/' &&
            equation.substring(equation.length - 1) != '^') {
          try {
            Expression exp = Parser().parse(equation);
            ContextModel cm = ContextModel();
            result = exp.evaluate(EvaluationType.REAL, cm);
            res = display(result);
          } catch (e) {
            res = 'Error';
          }
        } else {
          try {
            Expression exp =
                Parser().parse(equation.substring(0, equation.length - 1));
            ContextModel cm = ContextModel();
            result = exp.evaluate(EvaluationType.REAL, cm);
            res = display(result);
          } catch (e) {
            res = 'Error';
          }
        }
      }
    });
  }

// Material Button which does the calculation on Pressed.
  Widget customButton(String buttonPressed) {
    return Expanded(
      child: MaterialButton(
        onPressed: () {
          math(buttonPressed);
        },
        height: 60,
        color: Colors.white12,
        child: Text(
          buttonPressed,
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }

// This is to get the buttons in a row.
  Widget myRow(String a, String b, String c, String d) {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        customButton(a),
        customButton(b),
        customButton(c),
        customButton(d),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              equation,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text(
              res,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize:
                      equation == '' ? resultFontSize + 30 : resultFontSize),
            ),
          ),
          myRow('CLR', 'DLT', '^', '/'),
          myRow('7', '8', '9', '*'),
          myRow('4', '5', '6', '-'),
          myRow('1', '2', '3', '+'),
          myRow('00', '0', '.', '='),
        ],
      ),
    );
  }
}
