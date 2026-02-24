import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wings_olympic_sr/constants/dashboard_btn_names.dart';

import '../../../constants/constant_variables.dart';
import '../../../main.dart';
import '../../../models/journey_change_route_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/buttons/submit_button_group.dart';
import '../../../reusable_widgets/input_fields/dropdowns.dart';
import '../../../reusable_widgets/input_fields/input_text_fields.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../reusable_widgets/scaffold_widgets/appbar.dart';
import '../controller/change_route_controller.dart';

class ChangeRouteUI extends ConsumerStatefulWidget {
  const ChangeRouteUI({Key? key}) : super(key: key);
  static const routeName = "/change_route_ui";
  @override
  ConsumerState<ChangeRouteUI> createState() => _ChangeRouteUIState();
}

class _ChangeRouteUIState extends ConsumerState<ChangeRouteUI> {
  final _appBarTitle = DashboardBtnNames.changeRoute;
  late TextEditingController reasonController;
  late ChangeRouteController changeController;
  @override
  void initState() {
    super.initState();
    changeController = ChangeRouteController(context: context, ref: ref);
    reasonController = TextEditingController();
  }
  @override
  void dispose() {
    super.dispose();
    reasonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: _appBarTitle,
          titleImage: "route_change.png",
          onLeadingIconPressed: () {
            Navigator.pop(context);
          },
        heroTagTitle: _appBarTitle,
        heroTagImg: DashboardBtnNames.getImageHeroTag(_appBarTitle),
      ),
      body: ListView(
        children: [
          SizedBox(height: 2.h,),
          heading("Pick a Date"),

          InkWell(
            onTap: ()async{
              DateTime prevPickedDate = ref.read(selectedDateChangeRouteProvider);
              DateTime? pickedDate = await showDatePicker(context: context, initialDate: prevPickedDate, firstDate: DateTime.now(), lastDate: DateTime(3000));
              if(pickedDate != null){
                ref.read(selectedDateChangeRouteProvider.notifier).state = pickedDate;
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(appBarRadius)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(
                      builder: (context,ref,_) {
                        DateTime datetime = ref.watch(selectedDateChangeRouteProvider);
                        return LangText(
                          uiDateFormat.format(datetime),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 9.sp
                          ),
                        );
                      }
                    ),
                    Icon(Icons.calendar_month_outlined, color: lightMediumGrey,)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h,),
          heading("Select Route"),
          Consumer( //
            builder: (context,ref,_) {
              AsyncValue<List<JourneyChangeRouteModel>> asyncRouteList = ref.watch(getALlRouteListProvider);

              return asyncRouteList.when(
                  data: (routeList){
                    return Consumer(
                      builder: (context,ref,_) {
                        JourneyChangeRouteModel? selected = ref.watch(selectedRouteProvider);
                        String lang = ref.watch(languageProvider);
                        String hint = "Select a route";
                        if(lang != "en"){
                          hint = "রুট নির্বাচন করুন";
                        }
                        return CustomSingleDropdown<JourneyChangeRouteModel>(
                          value: selected,
                          items: routeList.map<DropdownMenuItem<JourneyChangeRouteModel>>((e) => DropdownMenuItem(value: e, child: Text(e.slug))).toList(),
                          onChanged: (value){
                            ref.read(selectedRouteProvider.notifier).state = value;
                          },
                          hintText: hint,
                        );
                      }
                    );
                  },
                  error: (e,s)=> Container(),
                  loading: ()=> Container()
              );

            }
          ),
          SizedBox(height: 2.h,),
          heading("Reason"),
          Consumer(
            builder: (context,ref,_) {
              String lang = ref.watch(languageProvider);
              String hint = "Reason";
              if(lang != "en"){
                hint = "কারণ লিখুন";
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                child: InputTextFields(
                    textEditingController: reasonController,
                    hintText: hint,
                    inputType: TextInputType.text,
                  maxLine: 5,
                ),
              );
            }
          ),
          SizedBox(height: 5.h,),
          SubmitButtonGroup(
            twoButtons: true,
            onButton1Pressed: (){
              changeController.submitChangeRequest(reasonController.text.trim());
            },
            onButton2Pressed: (){
              navigatorKey.currentState?.pop();
            },
          )
        ],
      ),
    );
  }

  Widget heading(String label){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: LangText(
        label,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.sp
        ),
      ),
    );
  }
}
