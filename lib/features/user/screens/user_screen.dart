import 'package:flutter/material.dart';
import 'package:flutter_task2/features/user/services/user_services.dart';
import 'package:flutter_task2/features/user/widgets/add_user_button.dart';
import 'package:flutter_task2/model/user_model.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserServices userServices = UserServices();
  List<User>? user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  User? userData;

  void createUser(String name, String email, int age) async {
    userData = await userServices
        .createNewUser(
          context: context,
          user: User(name: name, email: email, age: age),
        )
        .then((_) {
          getAllUser();
          return null;
        });

    if (userData != null) {
      print('User created successfully: ${userData!.toJson()}');
      setState(() {});
    }
  }

 searchUser(String query) async {
  final fetchedUsers = await userServices.getUsers(
    context: context,
    query: query.isNotEmpty ? query :null,
  );
 
  setState(() {
    user = fetchedUsers;
  });
}
 
  getAllUser() async {
    final fetchUser = await userServices.getUsers(context: context);
    setState(() {
      user = fetchUser;
    });
  }

  deleteUser(int index) async {
    await userServices.deleteUser(context: context, user: user![index]);
    setState(() {
      user!.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();

    getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Management")),
      body: user == null 
          ? Center(
            child: CircularProgressIndicator()
            )
          : Column(
             
              children: [
                 Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: searchUser,
            ),
          ),
                Expanded(
                  child:   user!.isEmpty ? Text('No User Found') : ListView.builder(
                    itemCount: user!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text('Name ${user![index].name}'),
                        subtitle: Text("Age: ${user![index].age} "),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteUser(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.black),
                              onPressed: () {
                                updateUser(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      floatingActionButton: AddUserButton(onPressed: createUser),
    );
  }

  void updateUser(int index) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Name"),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: "Enter name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final updatedUser = user![index].copyWith(
                name: nameController.text,
              );

              print('Update ${updatedUser.toJson()}');
              await userServices.updateUser(
                context: context,
                user: updatedUser,
              );

              setState(() {
                user![index] = updatedUser;
                print('User[index] ${user![index].toJson()}');
              });

              Navigator.pop(context);
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
}
