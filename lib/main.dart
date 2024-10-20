import 'package:clean_architecture/injection.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

// class FirstPage extends StatelessWidget {
//   const FirstPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context)
//                   .pushNamed('/second', arguments: "hello 22 ");
//             },
//             child: const Text("Go to Second Page"),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SecondPage extends StatelessWidget {
  final String data;
  const SecondPage({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(data)),
    );
  }
}
