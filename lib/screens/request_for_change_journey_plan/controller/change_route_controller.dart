import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/enum.dart';
import '../../../main.dart';
import '../../../models/journey_change_route_model.dart';
import '../../../models/returned_data_model.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/custom_dialog.dart';
import '../../../services/change_route_service.dart';

class ChangeRouteController {
  BuildContext context;
  WidgetRef ref;
  late Alerts alerts;
  ChangeRouteController({required this.context, required this.ref}):alerts = Alerts(context: context);
  ChangeRouteService changeRouteService = ChangeRouteService();
  void submitChangeRequest(String reason)async {
    DateTime selectedDate = ref.read(selectedDateChangeRouteProvider);
    JourneyChangeRouteModel? selectedRoute = ref.read(selectedRouteProvider);
    if(reason.isEmpty){
      alerts.customDialog(type: AlertType.error, description: "Please provide a reason");
      return;
    }
    if(selectedRoute == null){
      alerts.customDialog(type: AlertType.error, description: "Please select a route");
      return;
    }
    alerts.floatingLoading();
    ReturnedDataModel checkIfExistRouteInSelectedForJourneyChangeReturnedData = await changeRouteService.checkIfExistingRouteIsSelectedForJourneyChange(selectedDate, selectedRoute);
    navigatorKey.currentState?.pop();
    if(checkIfExistRouteInSelectedForJourneyChangeReturnedData.status == ReturnedStatus.error){
      alerts.customDialog(type: AlertType.error, description: checkIfExistRouteInSelectedForJourneyChangeReturnedData.errorMessage);
    }
    else if(checkIfExistRouteInSelectedForJourneyChangeReturnedData.status == ReturnedStatus.warning){
      alerts.customDialog(
          type: AlertType.warning,
          description: checkIfExistRouteInSelectedForJourneyChangeReturnedData.errorMessage,
          twoButtons: true,
          button1: "Yes",
          onTap1: ()async{
            navigatorKey.currentState?.pop();
            await submitChangeRouteRequestToAPI(selectedDate, selectedRoute, reason);
          },
        button2:"No",
        onTap2: (){
            navigatorKey.currentState?.pop();
        }
      );
    }
    else {
      await submitChangeRouteRequestToAPI(selectedDate, selectedRoute, reason);
    }
  }

  submitChangeRouteRequestToAPI(DateTime selectedDate, JourneyChangeRouteModel selectedRoute, String reason) async{
    alerts.floatingLoading();
    ReturnedDataModel returnedDataModel = await changeRouteService.submitJourneyChangeRequest(selectedDate, selectedRoute, reason);
    navigatorKey.currentState?.pop();
    if(returnedDataModel.status == ReturnedStatus.success){

      alerts.customDialog(type: AlertType.success, description: "Route has been changed!",onTap1: (){
        ref.refresh(checkIfChangeRouteRequestedProvider);

        navigatorKey.currentState?.pop();
        navigatorKey.currentState?.pop();
      });
    }
    else {

      alerts.customDialog(type: AlertType.warning, description: returnedDataModel.errorMessage,onTap1: (){
        ref.refresh(checkIfChangeRouteRequestedProvider);
        navigatorKey.currentState?.pop();
        navigatorKey.currentState?.pop();
      });
    }
  }

}