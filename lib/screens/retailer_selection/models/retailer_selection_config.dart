class RetailerSelectionConfig {
  bool? tabMode;
  bool? showAllRoutes;
  bool? showNavButtons;

  RetailerSelectionConfig({
    required this.showAllRoutes,
    required this.tabMode,
    required this.showNavButtons,
  });

  RetailerSelectionConfig.fromJson(Map<String, dynamic> json) {
    tabMode = json['tab_mode'];
    showAllRoutes = json['show_all_routes'];
    showNavButtons = json['show_nav_buttons'];
  }
}
