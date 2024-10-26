import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sortfood/ui/setting_page.dart';
import 'package:provider/provider.dart';
import 'package:sortfood/provider/user_provider.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({super.key});

  @override
  State<SettingsList> createState() => _SettingsList();
}

class _SettingsList extends State<SettingsList> {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            color: Colors.white,
            child: ListView(
              children: [
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                        title: "Profile",
                        icon: Icons.person,
                        action: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SettingPage()));
                        },),
                    const _CustomListTile(
                        title: "Notifications",
                        icon: Icons.notifications_none_rounded),
                    const _CustomListTile(
                        title: "Security Status",
                        icon: CupertinoIcons.lock_shield),
                  ],
                ),
                _SingleSection(
                  title: "Organization",
                  children: [
                    const _CustomListTile(
                        title: "Help & Feedback",
                        icon: Icons.help_outline_rounded),
                    const _CustomListTile(
                        title: "About", icon: Icons.info_outline_rounded),
                    _CustomListTile(
                      title: "Sign out", 
                      icon: Icons.exit_to_app_rounded, 
                      action: () async {
                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                        await userProvider.clearUser();  
                        Navigator.pushReplacementNamed(context, '/signIn'); 
                      },
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function()? action;
  
  const _CustomListTile({required this.title, required this.icon, this.trailing, this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: action,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
