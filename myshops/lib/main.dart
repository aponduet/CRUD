import 'package:flutter/material.dart';
import 'package:myshops/screens/create_user.dart';
import 'package:myshops/screens/edit_user.dart';
import 'package:myshops/screens/home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  final HttpLink link = HttpLink('http://localhost:5000/graphql');
  await initHiveForFlutter();

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient>? client;
  const MyApp({Key? key, this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter GraphQl App',
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const AllUserPage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/create': (context) => const CreateUserForm(),
          '/editUser': (context) => const EditUser(),
        },
      ),
    );
  }
}
