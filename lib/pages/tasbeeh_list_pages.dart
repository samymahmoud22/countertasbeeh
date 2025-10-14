

import 'package:flutter/material.dart';

import 'package:my_first_app/pages/loading_pages.dart';
import 'package:my_first_app/pages/seeting_page.dart';
import 'package:my_first_app/pages/tasbeeh_counter_page.dart';
import '../models/tasbeeh_item.dart';

class TasbeehListScreen extends StatefulWidget {
  const TasbeehListScreen({super.key});

  @override
  State<TasbeehListScreen> createState() => _TasbeehListScreenState();
}

class _TasbeehListScreenState extends State<TasbeehListScreen> {

  final List<TasbeehItem> _defaultTasbeehs = const [
    TasbeehItem(title: 'سبحان الله', maxCount: 33),
    TasbeehItem(title: 'الحمد لله', maxCount: 33),
    TasbeehItem(title: 'الله أكبر', maxCount: 33),
    TasbeehItem(title: 'لا إله إلا الله', maxCount: 100),
    TasbeehItem(title: 'اللهم صل على محمد', maxCount: 100),
  ];

  late List<TasbeehItem> tasbeehs;

  @override
  void initState() {
    super.initState();
    tasbeehs = List.of(_defaultTasbeehs);
  }

  bool _isDefaultItem(TasbeehItem item) =>
      _defaultTasbeehs.any((d) => d.title == item.title && d.maxCount == item.maxCount);

  void _addTasbeeh(String title, int maxCount) {
    setState(() => tasbeehs.add(TasbeehItem(title: title, maxCount: maxCount)));
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً')),
        ],
      ),
    );
  }

  void _showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteTasbeeh(int index) {
    final item = tasbeehs[index];
    if (_isDefaultItem(item)) {
      _showDialog('لا يمكن الحذف', 'هذا الذكر من الأذكار الأساسية.');
      return;
    }

    _showConfirmDialog(
      title: 'تأكيد الحذف',
      message: 'هل أنت متأكد من حذف "${item.title}"؟',
      onConfirm: () => setState(() => tasbeehs.removeAt(index)),
    );
  }


  void _clearCustomTasbeehs() {
    _showConfirmDialog(
      title: 'تأكيد الحذف',
      message: 'هل أنت متأكد من حذف جميع الأذكار المضافة؟',
      onConfirm: () => setState(() => tasbeehs = List.of(_defaultTasbeehs)),
    );
  }

  void _showAddTasbeehDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTasbeehSheet(onAdd: _addTasbeeh),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('قائمة الأذكار', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoadingScreen())),
        ),
        actions: [
         IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasbeehs.length,
        itemBuilder: (context, index) {
          final item = tasbeehs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            elevation: 3,
            child: ListTile(
              title: Text(item.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
              subtitle: Text('الحد الأقصى للدورة: ${item.maxCount}',
                  style: TextStyle(color: Colors.grey.shade600)),
              trailing: const Icon(Icons.chevron_right, color: Colors.teal),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TasbeehCounterScreen(tasbeehItem: item)),
              ),
              onLongPress: () => _deleteTasbeeh(index),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            FloatingActionButton(
              heroTag: 'clearBtn',
              backgroundColor: Colors.red,
              onPressed: _clearCustomTasbeehs,
              child: const Icon(Icons.delete_forever, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 15),

            FloatingActionButton(
              heroTag: 'addBtn',
              backgroundColor: Colors.teal,
              onPressed: () => _showAddTasbeehDialog(context),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


class AddTasbeehSheet extends StatelessWidget {
  final Function(String, int) onAdd;
  const AddTasbeehSheet({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final countController = TextEditingController(text: '33');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('إضافة ذكر جديد',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'اسم الذكر',
              border: OutlineInputBorder(),
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 10),

          TextField(
            controller: countController,
            keyboardType:  TextInputType.numberWithOptions(decimal: false, signed: false), 
            decoration: const InputDecoration(
              labelText: 'الحد الأقصى للدورة',
              border: OutlineInputBorder(),
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final count = int.tryParse(countController.text) ?? 0;
              if (title.isNotEmpty && count > 0) {
                onAdd(title, count);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('إضافة', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}