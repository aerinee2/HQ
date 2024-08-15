import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserFormPage(
        onModeChanged: (String newMode) {
          print('new mode selected: $newMode');
        },
      ),
    );
  }
}

class SelectedModeProvider with ChangeNotifier {
  String _selectedMode = '다이어트';

  String get selectedMode => _selectedMode;

  void setSelectedMode(String newMode) {
    _selectedMode = newMode;
    notifyListeners();
  }
}

class UserFormPage extends StatefulWidget {
  final Function(String)? onModeChanged;

  const UserFormPage({required this.onModeChanged, Key? key}) : super(key: key);

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _goalWeightController = TextEditingController();

  String? _selectedMode;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedModeProvider = Provider.of<SelectedModeProvider>(context);
    final List<String> modes = ['다이어트', '유지', '근력 증진'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('정보 수정하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                cursorColor: Colors.green,
                decoration: const InputDecoration(
                    labelText: '이름',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.green,
                controller: _ageController,
                decoration: const InputDecoration(
                    labelText: '나이',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '나이를 입력해주세요';
                  }
                  if (int.tryParse(value) == null) {
                    return '유효한 숫자를 입력해주세요';
                  }
                  if (int.parse(value) <= 0) {
                    return '0보다 큰 숫자를 입력해주세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.green,
                controller: _weightController,
                decoration: const InputDecoration(
                    labelText: '몸무게 (kg)',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '몸무게를 입력해주세요';
                  }
                  if (double.tryParse(value) == null) {
                    return '유효한 숫자를 입력해주세요';
                  }
                  if (double.parse(value) <= 0) {
                    return '0보다 큰 숫자를 입력해주세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.green,
                controller: _goalWeightController,
                decoration: const InputDecoration(
                    labelText: '희망 몸무게 (kg)',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '목표 몸무게를 입력해주세요';
                  }
                  if (double.tryParse(value) == null) {
                    return '유효한 숫자를 입력해주세요';
                  }
                  if (double.parse(value) <= 0) {
                    return '0보다 큰 숫자를 입력해주세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.green,
                controller: _heightController,
                decoration: const InputDecoration(
                    labelText: '키 (cm)',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '키를 입력해주세요';
                  }
                  if (double.tryParse(value) == null) {
                    return '유효한 숫자를 입력해주세요';
                  }
                  if (double.parse(value) <= 0) {
                    return '0보다 큰 숫자를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "원하는 모드 선택",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedModeProvider.selectedMode,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedModeProvider.setSelectedMode(newValue);
                  }
                },
                items: modes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 3, 199, 90),
                    surfaceTintColor: Color.fromARGB(255, 3, 199, 90),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Pop with the updated user information as result
                      Navigator.pop(context, {
                        'name': _nameController.text,
                        'age': int.parse(_ageController.text),
                        'height': int.parse(_heightController.text),
                        'weight': int.parse(_weightController.text),
                        'goalWeight': int.parse(_goalWeightController.text),
                        'mode': _selectedMode,
                      });
                    }
                  },
                  child: const Text('수정하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
