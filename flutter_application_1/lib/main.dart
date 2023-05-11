import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/completions';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final TextEditingController _controller = TextEditingController();
  String breakfast = "";
  String lunch = "";
  String dinner = "";
  bool isLoading = false;

  void getResult(String prompt) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        'prompt': "아침 점심 저녁 메뉴추천 ",
        'max_tokens': 1000,
        'temperature': 0.3,
        'top_p': 1,
        'frequency_penalty': 0.5,
        'presence_penalty': 0
      }),
    );

    Map<String, dynamic> newresponse = jsonDecode(utf8.decode(response.bodyBytes));

    String text = newresponse['choices'][0]['text'].replaceAll(RegExp(r'^\\d+\\.\\s'), '');
    List<String> items = text.split('\\n');

    setState(() {
      breakfast = items[2];
      lunch = items[4];
      dinner = items[6];
      isLoading = false;
    });

    print('breakfast: $breakfast');
    print('lunch: $lunch');
    print('dinner: $dinner');
    print(newresponse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff004a45),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 340,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffe76f00),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 79,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffd9d9d9),
                      ),
                    ),
                    SizedBox(width: 13),
                    Container(
                      width: 166,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffd9d9d9),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.50),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffe76f00),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 280,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffd9d9d8),
                      ),
                      child: Center(
                        child: Text(
                          breakfast,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      width: 280,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffd9d9d8),
                      ),
                      child: Center(
                        child: Text(
                          lunch,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      width: 280,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffd9d9d8),
                      ),
                      child: Center(
                        child: Text(
                          dinner,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.30),
              OutlinedButton(
                onPressed: () {
                  String prompt = _controller.text;
                  getResult(prompt);
                },
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text('식단 추천 받기'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.orange[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
