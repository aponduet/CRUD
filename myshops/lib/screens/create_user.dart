import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// Define a custom Form widget.
class CreateUserForm extends StatefulWidget {
  const CreateUserForm({Key? key}) : super(key: key);

  @override
  _CreateUserFormState createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final sexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to GraphQL'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: sexController,
              decoration: const InputDecoration(
                labelText: 'Sex',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            // Create new user Options

            Mutation(
                options: MutationOptions(
                  document: gql(
                      addUser), // this is the mutation string you just created
                  // you can update the cache based on results
                  update: (GraphQLDataProxy cache, QueryResult? result) {
                    return cache;
                  },

                  // or do something with the result.data on completion
                  onCompleted: (dynamic resultData) {
                    print(resultData);
                    Navigator.pushNamed(context, '/');
                  },
                ),
                builder: (
                  RunMutation runMutation,
                  QueryResult? result,
                ) {
                  return ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Create User"),
                    ),
                    onPressed: () => runMutation({
                      'newName': nameController.text,
                      'newAge': ageController.text.toString(),
                      'newSex': sexController.text,
                    }),
                  );
                })
          ],
        ),
      ),
    );
  }
}

String addUser = """
  mutation newUser(\$newName:String!, \$newAge:String!, \$newSex:String! ){
    addUser(name:\$newName,age:\$newAge,sex:\$newSex){
      name
      age
      sex
    }
  }
""";
