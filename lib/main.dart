import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UserProfilePage(),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar с названием страницы
      appBar: AppBar(
        title: const Text('Профиль пользователя'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      
      // Основное содержимое с возможностью прокрутки
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // Аватарка пользователя
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
              ),
              
              const SizedBox(height: 20),
              
              // Имя пользователя
              const Text(
                'Александр Прокофьев',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Описание пользователя в контейнере
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Привет',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Иконки действий
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.thumb_up,
                    size: 30,
                    color: Colors.green,
                  ),
                  Icon(
                    Icons.comment,
                    size: 30,
                    color: Colors.orange,
                  ),
                  Icon(
                    Icons.share,
                    size: 30,
                    color: Colors.purple,
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      
      // Плавающая кнопка
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Кнопка избранного нажата!');
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
