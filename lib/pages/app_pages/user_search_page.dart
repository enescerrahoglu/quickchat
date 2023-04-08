import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickchat/components/icon_component.dart';
import 'package:quickchat/components/text_component.dart';
import 'package:quickchat/components/text_form_field_component.dart';
import 'package:quickchat/constants/app_constants.dart';
import 'package:quickchat/constants/color_constants.dart';
import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/ui_helper.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/providers/provider_container.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:quickchat/routes/route_constants.dart';
import 'package:quickchat/widgets/user_row_widget.dart';

class UserSearchPage extends ConsumerStatefulWidget {
  const UserSearchPage({super.key});

  @override
  ConsumerState<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends ConsumerState<UserSearchPage> {
  UserModel? loggedUser;
  TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;
  List<UserModel> searchListUsers = [];

  @override
  void initState() {
    loggedUser = ref.read(loggedUserProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<ThemeProvider>(
      builder: (context, ThemeProvider themeProvider, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                splashRadius: AppConstants.iconSplashRadius,
                icon: IconComponent(
                  iconData: CustomIconData.chevronLeft,
                  color: themeProvider.isDarkMode ? iconDarkColor : iconLightColor,
                ),
                onPressed: () => _isLoading ? null : Navigator.pop(context),
              ),
              centerTitle: true,
              title: TextComponent(
                text: getTranslated(context, UserSearchPageKeys.newChat),
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
              actions: [
                _isLoading ? Center(child: Transform.scale(scale: 0.7, child: const CircularProgressIndicator())) : const SizedBox(),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormFieldComponent(
                    context: context,
                    textEditingController: textEditingController,
                    hintText: getTranslated(context, UserSearchPageKeys.userSearch),
                    iconData: CustomIconData.magnifyingGlass,
                    onChanged: (p0) async {
                      await onSearchTextChanged(p0);
                    },
                  ),
                ),
                Expanded(
                  child: textEditingController.text.isEmpty
                      ? const SizedBox()
                      : _isLoading
                          ? const SizedBox()
                          : searchListUsers.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconComponent(
                                      iconData: CustomIconData.userSlash,
                                      color: primaryColor,
                                      size: UIHelper.getDeviceWidth(context) / 6,
                                    ),
                                    const SizedBox(height: 10),
                                    TextComponent(
                                      text: getTranslated(context, UserSearchPageKeys.userNotFound),
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    )
                                  ],
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(10),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: searchListUsers.length,
                                  itemBuilder: (context, index) {
                                    return UserRowWidget(
                                      loggedUserModel: loggedUser!,
                                      userModel: searchListUsers[index],
                                      onTap: () {
                                        Navigator.pushNamed(context, chatPageRoute);
                                        ref.watch(targetUserProvider.notifier).state = searchListUsers[index];
                                      },
                                    );
                                  },
                                ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  onSearchTextChanged(String text) async {
    text = text.trim().toLowerCase();
    searchListUsers.clear();
    if (text.isEmpty) {
      searchListUsers.clear();
      setState(() {
        _isLoading = false;
      });
    } else {
      searchListUsers = await searchUsers(text);
    }
  }

  Future<List<UserModel>> searchUsers(String searchText) async {
    setState(() {
      _isLoading = true;
    });
    List<UserModel> userList = [];
    final users = await FirebaseFirestore.instance
        .collection('profiles')
        .where('userName', isGreaterThanOrEqualTo: searchText)
        .where('userName', isLessThan: '${searchText}z')
        .get();

    userList = users.docs.map((userMap) => UserModel.fromDocumentSnapshot(userMap)).toList();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    return userList;
  }
}
