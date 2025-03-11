import 'package:app/common/widgets/appbar/appbar.dart';
import 'package:app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../data/task_model.dart';
import '../../../../data/user/volunteer_model.dart';
import '../widgets/archive_list_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  VolunteerModel? _volunteer;
  List<TaskModel> _completedTasks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: TSizes.defaultSpace),
            child: Icon(Iconsax.logout),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _volunteer != null
          ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/profile_avatar.png'),
              ),
              SizedBox(height: TSizes.spaceBtwItems),

              Text('${_volunteer!.firstName} ${_volunteer!.lastName}', style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              )),

              Text('ID: ${_volunteer!.dobroId}', style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                fontSize: 18
                )),

              SizedBox(height: TSizes.spaceBtwItems),

              Column(
                children: [
                  Text(_completedTasks.length.toString(), style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24
                  )),
                  
                  Text('Добрые дела', style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18
                  ))
                ],
              ),

              SizedBox(height: TSizes.spaceBtwSections),

              Text('Архив', style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              )),

              SizedBox(height: TSizes.spaceBtwItems),

              ..._completedTasks.map((task) => ArchiveListItem(taskName: task.taskName, taskDate: task.taskEndDate)),

              SizedBox(height: 10),

              Divider(
                color: Colors.grey[300],
                thickness: 1.0,
                height: 16.0,
              ),
            ],
          ),
        ),
      )
          : Center(child: Text('Данные волонтера не найдены')),
    );
  }
}