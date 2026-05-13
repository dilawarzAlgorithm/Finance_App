import 'package:finance_app/screens/add_transaction.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.onTransactionAdded});

  final VoidCallback onTransactionAdded;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Container(
          height: 200,
          color: theme.colorScheme.primary,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(height: 20),
                Text(
                  'Finance App',
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                Spacer(),
                Text(
                  'v1.0',
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 2, thickness: 2),
        ListTile(
          tileColor: theme.colorScheme.tertiary.withAlpha(40),
          leading: Icon(Icons.add, color: theme.colorScheme.primary),
          title: Text(
            'New transaction',
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onTap: () async {
            Navigator.of(context).pop();
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (cntx) => AddTransactionScreen()),
            );
            if (result == true) {
              onTransactionAdded();
            }
          },
        ),
      ],
    );
  }
}
