import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text(
                  'No Transaction added yet!',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/image/waiting.png',
                  ),
                ),
              ],
            );
          })
        : SizedBox(
            height: 400,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  color: Colors.blueGrey,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 2,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: FittedBox(
                          child: Text('\$${transactions[index].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: const TextStyle(
                          fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        DateFormat.yMMMMd().format(transactions[index].date)),
                    trailing: MediaQuery.of(context).size.width > 400
                        ? TextButton.icon(
                            style: TextButton.styleFrom(
                                textStyle:
                                    const TextStyle(color: Colors.blueGrey)),
                            label: const Text('Delete'),
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                deleteTransaction(transactions[index].id),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.delete,
                            ),
                            onPressed: () =>
                                deleteTransaction(transactions[index].id),
                          ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
          );
  }
}
