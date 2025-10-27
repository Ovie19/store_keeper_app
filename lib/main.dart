import 'package:flutter/material.dart';
import 'package:store_keeper_app/data/db/db_helper.dart';
import 'package:store_keeper_app/presentation/screens/add_product_screen.dart';
import 'package:store_keeper_app/presentation/screens/edit_product_screen.dart';
import 'package:store_keeper_app/presentation/screens/home_screen.dart';
import 'package:store_keeper_app/presentation/screens/product_details_screen.dart';
import 'package:store_keeper_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductProvider())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final DbHelper _dbHelper = DbHelper.instance;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      await _dbHelper.database;
      debugPrint('Database Initialized');
    } catch (e) {
      debugPrint('Error initializing database: $e');
    }
  }

  @override
  void dispose() {
    _dbHelper.close();
    debugPrint('Database closed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        scaffoldBackgroundColor: Colors.grey[50],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF007AFF),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen(),
        AddProductScreen.path: (_) => AddProductScreen(),
        EditProductScreen.path: (_) => EditProductScreen(),
        ProductDetailsScreen.path: (_) => ProductDetailsScreen(),
      },
    );
  }
}
