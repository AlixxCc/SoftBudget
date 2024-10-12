import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:softbudget/data/model/add_date.dart';

class EditTransactionScreen extends StatefulWidget {
  final Add_data transaction;

  const EditTransactionScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController explainController = TextEditingController();
  late DateTime selectedDate;
  String? selectedCategory;
  final List<String> categories = [
    "food",
    "Transfer",
    "Transportation",
    "Education",
    "Clothing",
    "Travelling",
    "Salary",
    "Rent",
    "Phone Bills",
    "Other"
    // Add more categories as needed
  ];

  @override
  void initState() {
    super.initState();
    amountController.text = widget.transaction.amount;
    explainController.text = widget.transaction.explain;
    selectedDate = widget.transaction.datetime;
    selectedCategory = widget.transaction.name; // Initialize with the current category
  }

  void saveTransaction() {
    // Update the transaction in the database
    final box = Hive.box<Add_data>('data');
    widget.transaction.amount = amountController.text;
    widget.transaction.explain = explainController.text;
    widget.transaction.datetime = selectedDate;
    widget.transaction.name = selectedCategory!; // Update the category

    // Save the updated transaction
    box.put(widget.transaction.key, widget.transaction);
    Navigator.of(context).pop();
  }

  void deleteTransaction() async {
    final box = Hive.box<Add_data>('data');
    // Confirm deletion
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Transaction'),
          content: Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    // Proceed with deletion if confirmed
    if (confirmDelete == true) {
      box.delete(widget.transaction.key);
      Navigator.of(context).pop(); // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Transaction',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),),
        backgroundColor: Color(0xFF2986B4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              hint: Text('Select Category'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: explainController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2986B4), // Set button color to red
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                ),),
                
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: deleteTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set button color to red
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                ),),
            ),
          ],
        ),
      ),
    );
  }
}