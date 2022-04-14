import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

//import 'package:myshops/data/datasource.dart';
class SingleUserInfo {
  String? id, name, age, sex;
  SingleUserInfo(this.id, this.name, this.age, this.sex);
}

class AllUserPage extends StatefulWidget {
  const AllUserPage({Key? key}) : super(key: key);

  @override
  _AllUserPageState createState() => _AllUserPageState();
}

class _AllUserPageState extends State<AllUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          title: const Text('All Users'),
          actions: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.search),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add User"),
            )
          ],
          backgroundColor: Colors.purple,
        ),
        body: Query(
          options: QueryOptions(
            document: gql(getUser), // this is the query string you just created
            variables: {},
            //pollInterval: const Duration(seconds: 10),
          ),
          // Just like in apollo refetch() could be used to manually trigger a refetch
          // while fetchMore() can be used for pagination purpose
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Text('Loading');
            }

            List? repositories = result.data?['user'];

            if (repositories != null) {
              print(repositories[0]['name']);
              //return const Text('No repositories');
            }

            return ListView.builder(
                itemCount: repositories?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(
                        "${repositories?[index]['name']}",
                        style: const TextStyle(color: Colors.blue),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                          "${repositories?[index]['age']} \n${repositories?[index]['sex']}"),
                      leading: const Icon(Icons.verified_user_outlined),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(context, '/editUser',
                                    arguments: SingleUserInfo(
                                      repositories?[index]['id'],
                                      repositories?[index]['name'],
                                      repositories?[index]['age'],
                                      repositories?[index]['sex'],
                                    ));
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Mutation(
                                options: MutationOptions(
                                  document: gql(
                                      deleteUser), // this is the mutation string you just created
                                  // you can update the cache based on results
                                  update: (GraphQLDataProxy cache,
                                      QueryResult? result) {
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
                                  return IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => runMutation({
                                      'id': repositories?[index]['id'],
                                    }),
                                  );
                                }),
                          ],
                        ),
                      ));
                });
          },
        ));
  }
}

String getUser = """
 query{
  user{
    id
    name
    age
    sex
  }
}
""";

String deleteUser = """
  mutation deleteUser(\$id:ID!){
    deleteUser(id:\$id){
      name
    }
  }
""";
