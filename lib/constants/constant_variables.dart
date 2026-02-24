import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

//================= COLORS  ===================
const primary = Color(0xFFcc0000);
const primaryGrey = Color(0xFFEBE8E8);
const scaffoldBGColor = Color(0xFFFDFBFB);
const primaryBlue = Color(0xFFcc0000);
const secondaryBlue = Color(0xFFE3F2FD);
const secondaryBlue2 = Color(0xFFDAF3FB);
const red3 = Color(0xFFDC143C);
const primaryBlack = Color(0xFF444444);
const pureGrey = Colors.grey;
const secondaryGrey = Color(0xFF6F6F6F);
const primaryRed = Color(0xFFEF4065);
Color green = const Color(0xFFAFCA0B);
Color preorderColor = const Color(0xFFAFCA0B);
Color spotSalesColor = const Color(0xFF0BC4CA);
Color yellow = const Color(0xFFFF9728);
Color pullOutButton = const Color(0xFFFF9028);
Color darkGreen = const Color(0xFF50AF47);
Color darkGrey = const Color(0xFF2C2C2C);
Color lightMediumGrey = const Color(0xFFBABABA);
Color lightMediumGrey2 = const Color(0xFFE8E8E8);
Color grey = const Color(0xFF505050);
const orange = Color(0xFFEE7B20);
const tealBlue = Color(0xFF047481);

Color greenOlive = const Color(0xFF1E6752);
Color purple = const Color(0xFFE72582);
Color redDeep = const Color(0xFF820406);
Color auroraGreen = const Color(0xFF298373);
Color yellowSun = const Color(0xFFFCB217);
Color greenPaste = const Color(0xFF4CAE9F);
const lightBlue = const Color(0xFFE1EFFE);
const dashboaedItemColor = Color(0xFFF3F4F6);

const notificationAvatarBackgroundColor = Color(0xff334155);
const notificationAvatarTextColor = Color(0xff94A3B8);
const notificationActiveColor = Color(0xff2E70E8);
const appBarColor2 = Color(0xFF941000);
const appBarColor3 = Color(0xFF660000);

Color grey500 = const Color(0xFF6B7280);
Color black900 = const Color(0xFF111928);
Color grey50 = const Color(0xFFF9FAFB);
Color grey300 = const Color(0xFFD1D5DB);
Color blue = const Color(0xFF00B1EB);

Map<int, List<Color>> moduleColor = {
  1: [primaryBlue, primary],
  2: [secondaryGrey, darkGreen],
  3: [primaryBlue, primary],
  4: [secondaryGrey, darkGreen],
  5: [primaryBlue, primary],
  6: [secondaryGrey, darkGreen],
};

//=============================================

//======================== FONTS ===================
double largeFontSize = 20.sp;
double bigMediumFontSize = 16.sp;
double mediumFontSize = 13.sp;
double normalFontSize = 11.sp;
double standardFontSize = 10.sp;
double smallFontSize = 9.sp;
double smallerFontSize = 8.sp;

//==================================================

//====================attendance====================
final attendanceMap = {
  checkedInAddressKey: '',
  checkedOutAddressKey: '',
};

const checkedInAddressKey = 'checked_in_address';
const checkedOutAddressKey = 'checked_out_address';
//===================================================

//===================== Constant Date Format ============
DateFormat apiDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
DateFormat apiDateFormat = DateFormat("yyyy-MM-dd");
DateFormat maintenanceDateFormat = DateFormat("dd MMM yyyy");
DateFormat uiDateTimeFormat = DateFormat.yMMMMd('en_US').add_jm();
DateFormat uiDateFormat = DateFormat.yMMMMd('en_US');
DateFormat uiTimeFormat = DateFormat.jm();
DateFormat dateFormat = DateFormat("yyyy-MM-dd");
String todayDate = dateFormat.format(DateTime.now());
DateFormat requisitionDateTimeFormat = DateFormat("yyyy-MM-dd");
//======================================================

//======================== Border Radius ====================
double verificationRadius = 10;
double appBarRadius = 10.sp;
//===========================================================

// ========================= image folder name ==========================
const fireflyFolder = "outlet";

// ===================== camera list ==============================
List<CameraDescription> cameras = [];

//====================== Constant string ==========================
const String internetConnectionErrorMessage = "No Internet";

//===================== Font Family ===============================
String banglaFont = 'kalpurush';
String englishFont = 'Roboto';

//====================== APP VERSION ==============================
String appVersionDeviceLog = "";

// scheduled notification global variables
double sttTotalAchievements = 0.0;
double geoFencingTotalAchievements = 0.0;
double strikeRate = 0.0;
double geoFencing = 0.0;

// const expandedHeight = 260.00;
const expandedHeight = 290.00;

const primaryGradient = LinearGradient(
  begin: Alignment(-0.9, -1),
  end: Alignment(0.9, 1),
  colors: [
    primary,
    appBarColor2,
    appBarColor3,
  ],
);