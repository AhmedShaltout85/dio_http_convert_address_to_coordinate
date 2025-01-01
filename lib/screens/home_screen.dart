import 'package:pick_location/network/remote/dio_network_repos.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late Future getUsers;
  late Future getLocs;
  @override
  void initState() {
    super.initState();
    // getUsers = UsersDioRepos().getUsers();
    getLocs = DioNetworkRepos().getLoc();
    // getUsers.then((value) => debugPrint(value.toString()));
    getLocs.then((value) => debugPrint(value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address to Coordinate', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
          future: getLocs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index]['address'].toString()),
                      subtitle: Text(
                          snapshot.data![index]['real_address'].toString()),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
