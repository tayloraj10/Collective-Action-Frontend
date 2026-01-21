import 'package:collective_action_frontend/services/health_service.dart';
import 'package:flutter/material.dart';

class HealthCheckScreen extends StatefulWidget {
  const HealthCheckScreen({super.key});

  @override
  State<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends State<HealthCheckScreen> {
  String? _healthResult;
  String? _error;
  bool _loading = false;

  Future<void> _checkHealth() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ApiService().getHealth();
      setState(() {
        _healthResult = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backend Health Check')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _checkHealth,
              child: const Text('Check /health endpoint'),
            ),
            const SizedBox(height: 24),
            if (_loading) const CircularProgressIndicator(),
            if (_healthResult != null) ...[
              const Text('Result:'),
              Text(_healthResult!),
            ],
            if (_error != null) ...[
              const Text('Error:', style: TextStyle(color: Colors.red)),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
