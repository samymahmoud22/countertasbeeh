// lib/screens/loading_screen.dart

import 'package:flutter/material.dart';
import 'package:my_first_app/pages/tasbeeh_list_pages.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 3), () {
     
     
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TasbeehListScreen()),
        );
         });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Icon(Icons.access_time, size: 80, color: Colors.white),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              'جاري تحميل البيانات...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}