import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        accentColor: Colors.blueGrey,
        fontFamily: 'OpenSans',
        textTheme: const TextTheme(
            headline1: TextStyle(
              color: Colors.blueGrey,
              fontFamily: 'Quicksand',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            headline2: TextStyle(
              color: Colors.blueGrey,
              fontFamily: 'Quicksand',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool switchVal = false;
  final List<Transaction> transactions = [];

  void addTransaction(String tit, double amt, DateTime dt) {
    final tx = Transaction(
      title: tit,
      amount: amt,
      date: dt,
      id: DateTime.now().toString(),
    );
    setState(() {
      transactions.add(tx);
    });
  }

  void startAddTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(addTransaction);
        });
  }

  void deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((element) => element.id == id);
    });
  }

  List<Transaction> get recentTransactions {
    return transactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final landscapemode =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appbar = AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        'Personal Expenses',
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => startAddTransaction(context),
        )
      ],
    );
    final tx = SizedBox(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(transactions, deleteTransaction));
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (landscapemode)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Switch(
                      value: switchVal,
                      onChanged: (val) {
                        setState(() {
                          switchVal = val;
                        });
                      }),
                ],
              ),
            if (landscapemode)
              switchVal
                  ? SizedBox(
                      height: (MediaQuery.of(context).size.height -
                              appbar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.6,
                      child: Chart(recentTransactions))
                  : tx,
            if (!landscapemode)
              SizedBox(
                  height: (MediaQuery.of(context).size.height -
                          appbar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child: Chart(recentTransactions)),
            if (!landscapemode) tx,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => startAddTransaction(context),
      ),
    );
  }
}
