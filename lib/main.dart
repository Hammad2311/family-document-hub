import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isConfigured = SupabaseConfig.isConfigured;

  if (isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  }

  runApp(
    FamilyDocumentHubApp(
      isSupabaseConfigured: isConfigured,
    ),
  );
}

class FamilyDocumentHubApp extends StatelessWidget {
  const FamilyDocumentHubApp({
    required this.isSupabaseConfigured,
    super.key,
  });

  final bool isSupabaseConfigured;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Document Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: SupabaseConnectionPage(
        isConfigured: isSupabaseConfigured,
      ),
    );
  }
}

class SupabaseConnectionPage extends StatefulWidget {
  const SupabaseConnectionPage({
    required this.isConfigured,
    super.key,
  });

  final bool isConfigured;

  @override
  State<SupabaseConnectionPage> createState() =>
      _SupabaseConnectionPageState();
}

class _SupabaseConnectionPageState
    extends State<SupabaseConnectionPage> {
  String _status = 'Connection has not been tested yet.';
  bool _isChecking = false;

  Future<void> _testConnection() async {
    if (!widget.isConfigured) {
      setState(() {
        _status =
            'Configuration missing. Start the app with the required '
            'SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY values.';
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _status = 'Checking Supabase connection...';
    });

    try {
      final rows = await Supabase.instance.client
          .from('document_categories')
          .select('id')
          .limit(1);

      if (!mounted) return;

      setState(() {
        _status =
            'Supabase API responded successfully.\n'
            'Accessible category rows: ${rows.length}.\n\n'
            'An empty result can be normal before login because '
            'our RLS policies restrict category reads to authenticated '
            'users.';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _status = 'Connection check failed:\n$error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Document Hub'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_outlined,
                  size: 64,
                ),
                const SizedBox(height: 20),
                Text(
                  'Supabase Connection Check',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.isConfigured
                      ? 'Configuration loaded.'
                      : 'Configuration is missing.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _isChecking ? null : _testConnection,
                  child: Text(
                    _isChecking
                        ? 'Checking...'
                        : 'Test Supabase Connection',
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(_status),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}