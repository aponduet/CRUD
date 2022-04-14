import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:myshops/screens/home.dart';

// Define a custom Form widget.
class EditUser extends StatefulWidget {
  const EditUser({Key? key}) : super(key: key);
  //Received Single UserInfo Data from Home Page

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final sexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userInfo =
        ModalRoute.of(context)!.settings.arguments as SingleUserInfo;
    //add initial value of the fiels
    nameController.text = "${userInfo.name}";
    ageController.text = "${userInfo.age}";
    sexController.text = "${userInfo.sex}";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
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
                      updateUser), // this is the mutation string you just created
                  // you can update the cache based on results
                  update: (GraphQLDataProxy cache, QueryResult? result) {
                    return cache;
                  },

                  // or do something with the result.data on completion
                  onCompleted: (dynamic resultData) {
                    Navigator.pushNamed(context, '/');
                    print(resultData);
                    //Navigator.pushNamed(context, '/');
                  },
                ),
                builder: (
                  RunMutation runMutation,
                  QueryResult? result,
                ) {
                  return ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Udate Value"),
                    ),
                    onPressed: () => runMutation({
                      'id': userInfo.id,
                      'newName': nameController.text,
                      'newAge': ageController.text.toString(),
                      'newSex': sexController.text,
                    }),
                  );
                }),

            ElevatedButton(
                onPressed: () => print({
                      nameController.text,
                      ageController.text,
                      sexController.text
                    }),
                child: const Text("Check Data"))
          ],
        ),
      ),
    );
  }
}

String updateUser = """
  mutation updateUser(\$id:ID!,\$newName:String!, \$newAge:String!, \$newSex:String! ){
    updateUser(id:\$id,name:\$newName,age:\$newAge,sex:\$newSex){
      name
      age
      sex
    }
  }
""";
