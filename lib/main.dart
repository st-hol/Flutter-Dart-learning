import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stanislav Holovachuk TI-72',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'demo by Stanislav Holovachuk TI-72'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key); //иницализатор

  final String title;

  @override
  _MyHomePageState createState() => // использование лямбда-функций
      _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // _приватный класс

  bool _flag = false;
  List<Student> _students;
  List<String> _studentNames;

  _MyHomePageState()
      : this._students = [Student('Stas', 'TI-72'), Student('Alex', 'TI-72')];

  void _toggleShowStudentsFilteredOrNot() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _studentNames = _flag == true
          ? processStudents(_students)
          : extractNameSurname(_students);

      _flag = !_flag;
    });
  }

  List<String> processStudents(students) => students
      .where(
          (s) => s.name.toString().length > 1)
      .map((s) => addGroupToName(s).call())
      .toList()
      .cast<String>();

  // замыкания
  Function addGroupToName(student) {
    // внешняя функция
    var group = StudentMix
        .group; // некоторая переменная - лексическое окружение функции inner
    String inner() {
      // вложенная функция
      // действия с переменной n
      return student.name + group;
    }

    return inner;
  }

  List<String> extractNameSurname(List<Student> students) => students
      .where((s) => s.name.length > 1)
      .map((s) =>
          s.name + (s.surname ?? " DEFAULT")) // использование синтакс. сахара
      .toList();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          color: Colors.teal,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(30),
          // падинг со всех сторон
          margin: EdgeInsets.only(top: 50),
          // марджин от шапки
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('',
                  style: TextStyle(
                      fontSize: 24, // высота шрифта 24
                      backgroundColor: Colors.purple,
                      color: Colors.yellow)),
              Text(
                (_studentNames??"CLICK BUTTON!").toString(),
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 20, top: 30, bottom: 40),
                child: Text('Текст 18го шрифта c Padding',
                    style: TextStyle(
                        fontSize: 32, // высота шрифта 32
                        color: Colors.pink,
                        decoration: TextDecoration.lineThrough,
                        decorationStyle: TextDecorationStyle.double)),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleShowStudentsFilteredOrNot,
        tooltip: 'SHOW!',
        child: Icon(Icons.android),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

mixin StudentMix {
  static String group;
}

class Student with StudentMix{
  String _name;
  var surname;

  factory Student(name, gr) {

    assert(gr.length > 1);

    StudentMix.group ??= gr; // syntax sugar again
    return Student.fromName(name);
  }

  Student.fromName(this._name, [this.surname]);
  // конструктор с необязательным параметром

  // ignore: unnecessary_getters_setters
  String get name => _name;

  // ignore: unnecessary_getters_setters
  set name(String value) {
    _name = value;
  }

  @override
  String toString() {
    return 'Student{_name: $_name, surname: $surname}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student &&
          runtimeType == other.runtimeType &&
          _name == other._name;

  @override
  int get hashCode => _name.hashCode;
}
