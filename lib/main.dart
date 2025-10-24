import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Supabase.initialize(
      url: 'https://pqgdzihnjaogyepbxiti.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBxZ2R6aWhuamFvZ3llcGJ4aXRpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEzMzIyMTAsImV4cCI6MjA3NjkwODIxMH0.hNDGITVAyWk25jdPzg9xYYi_-ZMytJetGvg4VPrqDRY',
      debug: true,
      realtimeClientOptions: const RealtimeClientOptions(
        eventsPerSecond: 2,
      ),
    );
    print('Supabase инициализирован успешно');
  } catch (e) {
    print('Ошибка инициализации Supabase: $e');
  }
  
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ProfilesPage(),
    );
  }
}

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({super.key});

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _addProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Попытка добавить профиль: ${_nameController.text}, ${_emailController.text}');
      
      final response = await supabase.from('profiles').insert({
        'name': _nameController.text,
        'email': _emailController.text,
      }).select();

      print('Ответ от Supabase: $response');

      _nameController.clear();
      _emailController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль добавлен успешно')),
        );
      }

      await _loadProfiles();
    } catch (error) {
      print('Ошибка добавления профиля: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadProfiles() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      print('Попытка загрузить профили...');
      final data = await supabase.from('profiles').select();
      print('Загружено профилей: ${data.length}');
      
      if (mounted) {
        setState(() {
          _profiles = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (error) {
      print('Ошибка загрузки профилей: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addProfile,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Добавить'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loadProfiles,
                    child: const Text('Загрузить'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Список пользователей:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _profiles.isEmpty
                      ? const Center(child: Text('Нет данных'))
                      : ListView.builder(
                          itemCount: _profiles.length,
                          itemBuilder: (context, index) {
                            final profile = _profiles[index];
                            return Card(
                              child: ListTile(
                                title: Text(profile['name'] ?? ''),
                                subtitle: Text(profile['email'] ?? ''),
                                trailing: Text(
                                  DateTime.parse(profile['created_at'])
                                      .toLocal()
                                      .toString()
                                      .split('.')[0],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}