import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/utils/ui/app_buttons.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GetHelpScreen extends StatefulWidget {
  const GetHelpScreen({super.key});

  @override
  State<GetHelpScreen> createState() => _GetHelpScreenState();
}

class _GetHelpScreenState extends State<GetHelpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black.withAlpha(200),
            size: 20,
          ),
        ),
        title: Text(
          "Get Help",
          style: appTextStyle(
            context,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black.withAlpha(220),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),

            // Header illustration
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.goldBrandColor.withAlpha(20),
                    AppColors.goldBrandColor.withAlpha(10),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.goldBrandColor.withAlpha(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.goldBrandColor.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      color: AppColors.goldBrandColor,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "How can we help you?",
                    style: appTextStyle(
                      context,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withAlpha(220),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    "Send us a message and we'll get back to you within 24 hours",
                    textAlign: TextAlign.center,
                    style: appTextStyle(
                      context,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Contact Form
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black.withAlpha(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    Text(
                      "Full Name",
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withAlpha(180),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(context, "Enter your name"),
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        color: AppColors.blackColor,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Subject
                    Text(
                      "Subject",
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withAlpha(180),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _subjectController,
                      decoration: _inputDecoration(context, "Enter subject"),
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        color: AppColors.blackColor,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Subject is required";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Message
                    Text(
                      "Message",
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withAlpha(180),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 5,
                      decoration: _inputDecoration(
                        context,
                        "Describe your issue or question...",
                      ),
                      style: appTextStyle(
                        context,
                        fontSize: 11.sp,
                        color: AppColors.blackColor,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Message is required";
                        }
                        if (value.trim().length < 10) {
                          return "Message must be at least 10 characters";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 2.5.h),

                    AppButton(
                      backgroundColor: AppColors.goldBrandColor,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Send message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Message sent successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Send Message",
                        style: appTextStyle(
                          context,
                          fontSize: 12.2.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: appTextStyle(
        context,
        fontSize: 10.8.sp,
        color: AppColors.grayBrandColor.withAlpha(102),
      ),
      filled: true,
      fillColor: AppColors.whiteColor.withAlpha(13),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.grayBrandColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.grayBrandColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.grayBrandColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red),
      ),
      errorStyle: appTextStyle(context, fontSize: 9.5.sp, color: Colors.red),
    );
  }
}
