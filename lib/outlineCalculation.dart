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
  String equation = ' ';
  double result = 0;
  String res = '0';
  bool decimalPresent = false;
  double resultFontSize = 30;
  String lastDigit;
  // To display number after removing the trailing zeros at the end of a number after decimal point
  final display = createDisplay(
    length: 12,
    decimal: 8,
  );

  //Function to do the calculation/requisite on pressing a button.
  void math(String buttonPressed) {
    setState(() {
      lastDigit = equation.substring(equation.length - 1);
      if (buttonPressed == 'CLR') {
        equation = ' ';
        res = '0';
        result = 0;
      } else if (buttonPressed == '.') {
        if (decimalPresent == false) {
          equation = equation + buttonPressed;
          decimalPresent = true;
        }
      } else if (buttonPressed == '=') {
        equation = ' ';
        res = display(result); //from package number display.
      } else if (buttonPressed == '+' ||
          buttonPressed == "-" ||
          buttonPressed == '*' ||
          buttonPressed == '/' ||
          buttonPressed == '^') {
        decimalPresent = false;
        //To ignore the previous operator on pressing the another operator soon after.
        if (lastDigit == '+' ||
            lastDigit == "-" ||
            lastDigit == '*' ||
            lastDigit == '/' ||
            lastDigit == '^')
          equation = equation.substring(0, equation.length - 1) + buttonPressed;
        else
          equation = equation + buttonPressed;
      } else {
        if (buttonPressed == 'DLT') {
          decimalPresent = lastDigit == '.' ? false : decimalPresent;
          equation = equation.length != 1
              ? equation.substring(0, equation.length - 1)
              : ' '; //if last element is deleted
        } else //if it is a number
          equation = equation + buttonPressed;
        lastDigit = equation.substring(equation.length - 1);
        if (lastDigit == '+' ||
            lastDigit == "-" ||
            lastDigit == '*' ||
            lastDigit == '/' ||
            lastDigit == '^') {
          //this case arises when a character is deleted.
          try {
            Expression exp = Parser().parse(
              equation.substring(
                  0,
                  equation.length -
                      1), //So that the expression to be evaluated don't end with an operator.
            );
            ContextModel cm = ContextModel();
            result = exp.evaluate(EvaluationType.REAL, cm);
            res = display(result);
          } catch (e) {}
        } else if (equation ==
            ' ') //this case also arises when a character is deleted.
          res = '0';
        else {
          // this case arise when button pressed is a number.
          try {
            Expression exp = Parser().parse(equation);
            ContextModel cm = ContextModel();
            result = exp.evaluate(EvaluationType.REAL, cm);
            res = display(result);
          } catch (e) {}
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
              (result.isInfinite || result.isNaN)
                  ? '=Can\'t divide by zero'
                  : res,
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize:
                      equation == ' ' ? resultFontSize + 20 : resultFontSize),
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
