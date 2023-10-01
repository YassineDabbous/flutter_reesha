import 'package:flutter/material.dart';

Future<T?> selectAndPop<T extends Object?>(BuildContext context, Widget screen) async {
  return await Navigator.push<T>(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
    ),
  );
}

class DialogMenuAction {
  Widget? icon;
  String title;
  Function() action;
  // Function(BuildContext)? actionCtx;
  DialogMenuAction({
    this.icon,
    required this.title,
    required this.action,
    // this.actionCtx,
  });
}

dialogMenu({required BuildContext context, required List<DialogMenuAction> items, String? title}) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      // return alert dialog object
      return AlertDialog(
        title: title == null ? null : Text(title),
        content: SizedBox(
          height: items.length * 60.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items
                .map((e) => ListTile(
                      title: Text(e.title),
                      leading: e.icon,
                      onTap: () {
                        Navigator.pop(ctx); // shoould be before action
                        e.action.call();
                      },
                    ))
                .toList(),
          ),
        ),
      );
    },
  );
}

dialogConfirmation({required BuildContext context, String? title, String? content, required Function() onConfirm}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return SizedBox(
        height: 100,
        child: AlertDialog(
          title: title == null ? Text('are you sure') : Text(title),
          content: content == null ? null : Text(content),
          actions: [
            TextButton(
              child: Text('yes'),
              onPressed: () {
                Navigator.pop(ctx);
                onConfirm();
              },
            ),
            ElevatedButton(
              child: Text('no'),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      );
    },
  );
}

void dialogValue({required BuildContext context, String? title, String? hint, required Function(String) onSubmit}) {
  TextEditingController tc = TextEditingController();
  print('cccx');
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: title == null ? null : Text(title),
        content: SizedBox(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: tc,
                decoration: InputDecoration(hintText: hint),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  onSubmit(tc.text);
                  Navigator.pop(ctx);
                },
                child: Text('confirm'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
