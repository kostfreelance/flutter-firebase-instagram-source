import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_firebase_instagram/src/presentation/app_colors.dart';
import 'app_button.dart';

class SearchBar extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final Function() onChanged; 

  const SearchBar({
    Key? key,
    required this.placeholder,
    required this.controller,
    required this.onChanged
  }) : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  Timer? _searchBarDebounceTimer;
  bool _showClear = false;

  void _onSearchBarChanged(String searchTerm) {
    setState(() {
      _showClear = searchTerm.isNotEmpty;
    });
    if (_searchBarDebounceTimer?.isActive ?? false) {
      _searchBarDebounceTimer?.cancel();
    }
    _searchBarDebounceTimer = Timer(
      const Duration(milliseconds: 1000),
      () => widget.onChanged()
    );
  }

  void _clearPressed() {
    widget.controller.clear();
    _onSearchBarChanged('');
  }

  @override
  void dispose() {
    _searchBarDebounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      padding: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.lightGrey
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: AppColors.grey,
            size: 20.r
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: CupertinoTextField(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.black
                ),
                placeholder: widget.placeholder,
                placeholderStyle: TextStyle(
                  fontFamily: 'Lato-Regular',
                  fontSize: 16.sp,
                  color: AppColors.grey
                ),
                decoration: const BoxDecoration(color: Colors.transparent),
                padding: EdgeInsets.zero,
                controller: widget.controller,
                onChanged: _onSearchBarChanged
              )
            )
          ),
          _showClear ?
            AppButton(
              height: 32.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              borderRadius: BorderRadius.circular(10.r),
              onPressed: _clearPressed,
              child: Icon(
                Icons.cancel,
                color: AppColors.grey,
                size: 20.r
              )
            ) :
            Container()
        ]
      )
    );
  }
}