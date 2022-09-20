import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class st {
  String a = 'dat';
  st(this.a);
}
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Provider<st>(
create: (context) => st('dat'),
child: Text(
"${Provider.of<st>(context).a}"
),
);
}
}
