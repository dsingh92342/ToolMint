import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toolmint/core/supabase_config.dart';
import 'package:toolmint/core/theme.dart';
import 'package:toolmint/features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase only if valid credentials are provided
  if (SupabaseConfig.url != 'YOUR_SUPABASE_URL' &&
      SupabaseConfig.anonKey != 'YOUR_SUPABASE_ANON_KEY') {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  runApp(
    const ProviderScope(
      child: ToolMintApp(),
    ),
  );
}

class ToolMintApp extends StatelessWidget {
  const ToolMintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToolMint',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
