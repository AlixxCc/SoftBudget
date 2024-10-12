import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:softbudget/data/model/add_date.dart';
import 'edit_transaction_screen.dart'; // Import the edit screen

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final box = Hive.box<Add_data>('data');
  List<Add_data> filteredTransactions = [];
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Transactions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF2986B4),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                  filteredTransactions = box.values
                      .where((transaction) =>
                          transaction.name
                              .toLowerCase()
                              .contains(query.toLowerCase()) ||
                          transaction.amount
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .toList();

                  // Sort filtered transactions by date, most recent first
                  filteredTransactions.sort((a, b) => b.datetime.compareTo(a.datetime));
                });
              },
              decoration: InputDecoration(
                labelText: 'Search for a transaction',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                Add_data transaction = filteredTransactions[index];
                return ListTile(
                  title: Text(transaction.name),
                  subtitle: Text(
                      '${transaction.datetime.year}-${transaction.datetime.month}-${transaction.datetime.day}'),
                  trailing: Text(
                    '${transaction.amount}',
                    style: TextStyle(
                      color: transaction.IN == 'Income'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () { 
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditTransactionScreen(transaction: transaction),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}