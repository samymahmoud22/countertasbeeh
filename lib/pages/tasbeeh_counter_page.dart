import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/tasbeeh_item.dart';

class TasbeehCounterScreen extends StatefulWidget {
  final TasbeehItem tasbeehItem;

  const TasbeehCounterScreen({required this.tasbeehItem, super.key});

  @override
  State<TasbeehCounterScreen> createState() => _TasbeehCounterScreenState();
}

class _TasbeehCounterScreenState extends State<TasbeehCounterScreen> {
  int _currentTasbeehCount = 0;
  int _roundCount = 0;

  void _incrementTasbeeh() {
    setState(() {
      _currentTasbeehCount++;
      if (_currentTasbeehCount >= widget.tasbeehItem.maxCount) {
        _roundCount++;
        _currentTasbeehCount = 0;
      }
    });
    HapticFeedback.lightImpact();
  }

  void _resetCurrentRound() => setState(() => _currentTasbeehCount = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.tasbeehItem.title,
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('الدورات المكتملة: $_roundCount',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 50),

         
            GestureDetector(
              onTap: _incrementTasbeeh,
              child: SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: _currentTasbeehCount /
                          widget.tasbeehItem.maxCount,
                      strokeWidth: 15,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation(Colors.teal),
                    ),
                    Text('$_currentTasbeehCount',
                        style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),

      
            FilledButton.icon(
              onPressed: _resetCurrentRound,
              icon: const Icon(Icons.refresh),
              label: const Text('تصفير الدورة الحالية'),
            ),
          ],
        ),
      ),
    );
  }
}