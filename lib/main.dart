import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'character_result.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    final HttpLink almansiMeApi =
        HttpLink('https://graphqlzero.almansi.me/api');

    // ignore: omit_local_variable_types
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: almansiMeApi,
        cache: GraphQLCache(
          store: InMemoryStore(),
        ),
      ),
    );
    String createMyPost = '''
mutation myTodo(\$title: String!, \$body: String!){
  createPost(
    input:{
    title: \$title
    body: \$body
  }
  ){
    id
    title
    body
  }
}
''';
    final postTitleController = TextEditingController();
    final postBodyController = TextEditingController();
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Material App',
        home: Mutation(
          // ignore: deprecated_member_use
          options: MutationOptions(documentNode: gql(createMyPost)),
          builder: (runMutation, result) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: postTitleController,
                      decoration: const InputDecoration(
                        hintText: 'Post Title',
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: postBodyController,
                      decoration: const InputDecoration(
                        hintText: 'Post Title',
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        runMutation({
                          'title': postTitleController.text,
                          'body': postBodyController.text,
                        });
                      },
                      child: const Text('Create Post'),
                    ),
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.white,
                        child: Text(
                          result.data == null
                              ? '''Post details coming up shortly,'''
                                  ''' Kindly enter details and create a post'''
                              : result.data.toString(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     https: //graphqlzero.almansi.me/api
//     // ignore: omit_local_variable_types
//     final HttpLink rickAndMortyHttpLink =
//         HttpLink('https://rickandmortyapi.com/graphql');
//     // ignore: omit_local_variable_types
//     ValueNotifier<GraphQLClient> client = ValueNotifier(
//       GraphQLClient(
//         link: rickAndMortyHttpLink,
//         cache: GraphQLCache(
//           store: InMemoryStore(),
//         ),
//       ),
//     );
//     const rickCharacters = '''
//   query characters {
//       characters(page: 1, filter: { name: "rick" }) {
//         info {
//           count
//         }
//         results {
//           name
//           status
//         }
//       }
//   }
//   ''';
//     return GraphQLProvider(
//       client: client,
//       child: MaterialApp(
//         title: 'Material App',
//         home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Complete GraphQl Guide'),
//             backgroundColor: Colors.black,
//           ),
//           body: Query(
//             options: QueryOptions(
//               document: gql(rickCharacters),
//             ),
//             builder: (result, {fetchMore, refetch}) {
//               // If stements here to check handle different states;
//               if (result.isLoading) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               return Column(
//                 children: [
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   const Text(
//                     'Characters with name Rick',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: result.data['characters']['results'].length,
//                       itemBuilder: (context, index) {
//                         return CharactersResult(
//                           result: result.data['characters']['results'],
//                           index: index,
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
