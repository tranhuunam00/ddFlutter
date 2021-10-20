import 'package:flutter/material.dart';
import '../ui.dart';

class AvatarFriendBtn extends StatelessWidget {
  final String? frName;
  final String? frImage;
  const AvatarFriendBtn({Key? key, this.frName = null, this.frImage = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        print("oki");
      },
      child: Column(
        children: [
          Container(
            width: (size.width - 70) / 3,
            height: (size.width - 70) / 3,
            child: Image.asset(
              frImage ?? 'assets/images/nature6.jpg',
              fit: BoxFit.cover,
            ),
          ),
          frName != null ? Text(frName ?? "", style: AppStyles.h4) : Container()
        ],
      ),
    );
  }
}
