library my_prj.globals;

import 'package:location/location.dart';

Map syncObj = {};
bool syncRead = false;
bool langRead = false;
LocationData? currentPositionOfSR;
late DateTime callStartTime;
Map currentPreorderData = {};
Map currentPromotionData = {}; // stores currentPromotional Info
Map currentSaleData = {};
Map currentStockData = {};

//
// String appVersion = '1.0.1';
Map dummyData = {
  "date": "2026-04-21",
  "logged_in": 1,
  "userData": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiQWhtZWQgTGlua29uIiwiaWQiOjE3NjUsInVzZXJUeXBlSWQiOjUzLCJlbWFpbCI6ImxpbmtvbkBnbWFpbC5jb20iLCJzYnVfaWQiOls1NF0sImlhdCI6MTc3Njc3MTkxOCwiZXhwIjoxMDAxNzc2NzY1MDM4fQ.-i_gCKes9RAigwKHRU8KslU7jGLW3FddTZTNk9DyT4A",
    "refreshToken": "0l5fzUPIek0vXibj",
    "date": "2026-04-21",
    "id": 1765,
    "sbu_id": [
      54
    ],
    "user_type_id": 53,
    "user_role_id": 1,
    "name": "Ahmed Linkon",
    "email": "linkon@gmail.com",
    "joining_date": null,
    "end_date": null,
    "user_name": "linkon@gmail.com",
    "contact": "01888999444",
    "status": 1,
    "image": null,
    "created_by": null,
    "updated_by": null,
    "created_at": "2026-04-09T09:31:40.000Z",
    "updated_at": "2026-04-21T04:50:10.000Z",
    "user_type_slug": "AO",
    "dep_ids": [
      166,
      167
    ],
    "depots": [
      {
        "dep_id": 166,
        "type": null,
        "parent_location_id": 0
      },
      {
        "dep_id": 167,
        "type": "depot",
        "parent_location_id": 0
      }
    ],
    "permitted_sbus": {
      "sbu_ids": [
        54
      ],
      "default_sbu": 54,
      "multi_access": 0
    },
    "sbu_info": [
      {
        "id": 54,
        "sbu_name": "Sun"
      }
    ],
    "sections": [],
    "routes": [],
    "password": "apsis@2025",
    "pointId": 167
  },
  "retailers": [
    {
      "id": 150,
      "outlet_name": "Russel Store",
      "outlet_name_bn": "রাসেল স্টোরে",
      "outlet_code": "ord-101132",
      "owner": "Russel",
      "contact": "01552576656",
      "approval_status": "APPROVED",
      "nid": "9898776778",
      "address": "road 8, shop no 12, shenpara parbata.",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/ord-101132/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        49
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 0,
      "sap_code": "ord-101132",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/ord-101132/outlet_cover_image.jpg",
      "lat": 23.7936524,
      "long": 90.4046146,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 111,
          "slug": "Blue"
        }
      },
      "available_surveys": []
    },
    {
      "id": 151,
      "outlet_name": "RS Store",
      "outlet_name_bn": "RS Store",
      "outlet_code": "15",
      "owner": "RS",
      "contact": "+8801612201607",
      "approval_status": "APPROVED",
      "nid": "2200558833",
      "address": "Nikunja-2,Dhaka",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        1
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 46089,
      "sap_code": "15",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/15/outlet_cover_image.jpg",
      "lat": 23.7936804,
      "long": 90.4045817,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 152,
      "outlet_name": "Ahmed Store",
      "outlet_name_bn": "Ahmed Store",
      "outlet_code": "SA-123445",
      "owner": "Sajid",
      "contact": "01535155113",
      "approval_status": "APPROVED",
      "nid": "",
      "address": "204/1,Niketon",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 46073,
      "sap_code": "SA-123445",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/SA-123445/outlet_cover_image.jpg",
      "lat": 23.7936334,
      "long": 90.404596,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 153,
      "outlet_name": "outlet1",
      "outlet_name_bn": "outlet1",
      "outlet_code": "99898",
      "owner": "Mahbub",
      "contact": "01617161514",
      "approval_status": "APPROVED",
      "nid": "0908878776",
      "address": "address1",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        67
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 0,
      "sap_code": "99898",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/99898/outlet_cover_image.jpg",
      "lat": 23.793779,
      "long": 90.404598,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 154,
      "outlet_name": "Nishat Store",
      "outlet_name_bn": "নিশাত স্টোর",
      "outlet_code": "K-1234",
      "owner": "Nishat",
      "contact": "0",
      "approval_status": "APPROVED",
      "nid": "0",
      "address": "Kakoli",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 498,
      "sap_code": "K-1234",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/K-1234/outlet_cover_image.jpg",
      "lat": 23.793714,
      "long": 90.40453,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 155,
      "outlet_name": "Bipu Store",
      "outlet_name_bn": "বিপু স্টোর",
      "outlet_code": "M-1234",
      "owner": "Bipu",
      "contact": "01752506879",
      "approval_status": "APPROVED",
      "nid": "0",
      "address": "Mohakhali",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 499,
      "sap_code": "M-1234",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/M-1234/outlet_cover_image.jpg",
      "lat": 23.793707,
      "long": 90.404526,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1438,
      "outlet_name": "Ymail Store",
      "outlet_name_bn": "Yমেইল স্টোর",
      "outlet_code": "R-228228220126-003",
      "owner": "Hablu",
      "contact": "01725836914",
      "approval_status": "APPROVED",
      "nid": "123456789123456",
      "address": "Banani",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228220126-003",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228220126-003/outlet_cover_image.jpg",
      "lat": 23.7936568,
      "long": 90.4046068,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 50,
          "slug": "Departmental"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1439,
      "outlet_name": "Hotmail Store",
      "outlet_name_bn": "হটমেইল স্টোর",
      "outlet_code": "R-228228220126-004",
      "owner": "গোপার ভাড়",
      "contact": "01741858585",
      "approval_status": "APPROVED",
      "nid": "12345678900",
      "address": "বানানি রোড ৯০০০",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228220126-004",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228220126-004/outlet_cover_image.jpg",
      "lat": 23.7936529,
      "long": 90.4046194,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 48,
          "slug": "Tong"
        },
        "channel_category": {
          "id": 53,
          "slug": "Silver"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1440,
      "outlet_name": "Mushfiq",
      "outlet_name_bn": "abd",
      "outlet_code": "R-228228220126-002",
      "owner": "salehin",
      "contact": "01741423438",
      "approval_status": "APPROVED",
      "nid": "1234567899",
      "address": "abcd",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228220126-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228220126-002/outlet_cover_image.jpg",
      "lat": 23.7936753,
      "long": 90.4045548,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1441,
      "outlet_name": "Mushfiq 1",
      "outlet_name_bn": "nadjd",
      "outlet_code": "R-228228220126-005",
      "owner": "salehin",
      "contact": "01741423438",
      "approval_status": "APPROVED",
      "nid": "121212121",
      "address": "ad",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228220126-005",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228220126-005/outlet_cover_image.jpg",
      "lat": 23.7936687,
      "long": 90.4045721,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 53,
          "slug": "Silver"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1443,
      "outlet_name": "Test For Status",
      "outlet_name_bn": "Test For Status",
      "outlet_code": "R-228228250126-002",
      "owner": "Hasan",
      "contact": "01245783265",
      "approval_status": "PENDING",
      "nid": "8785496325",
      "address": "Banani",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228250126-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228250126-002/outlet_cover_image.jpg",
      "lat": 23.7936625,
      "long": 90.4046194,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 49,
          "slug": "Pharma"
        },
        "channel_category": {
          "id": 53,
          "slug": "Silver"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1444,
      "outlet_name": "Test for cooler image",
      "outlet_name_bn": "mushfiq",
      "outlet_code": "R-228228250126-006",
      "owner": "mushfiq",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1122334455",
      "address": "asdad",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228250126-006",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228250126-006/outlet_cover_image.jpg",
      "lat": 23.7936967,
      "long": 90.4045728,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 53,
          "slug": "Silver"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1445,
      "outlet_name": "cooler image",
      "outlet_name_bn": "adsd",
      "outlet_code": "R-228228250126-007",
      "owner": "cooler",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1122334466",
      "address": "abcd",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228250126-007",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228250126-007/outlet_cover_image.jpg",
      "lat": 23.7936488,
      "long": 90.4045872,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "Yes",
        "cooler": {
          "id": 57,
          "slug": "AFBL"
        },
        "cooler_photo_url": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228250126-007/outlet_cooler_image.jpg",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1447,
      "outlet_name": "Shahabuddin Vai",
      "outlet_name_bn": "Shahabuddin Vai",
      "outlet_code": "R-228228260126-003",
      "owner": "Shahabuddin Vai",
      "contact": "01542542154",
      "approval_status": "PENDING",
      "nid": "1234568459",
      "address": "Banani",
      "price_group": 1,
      "outlet_cover_image": "retailer/R-228228260126-003/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228260126-003",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228260126-003/outlet_cover_image.jpg",
      "lat": 23.7937094,
      "long": 90.4045836,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 49,
          "slug": "Pharma"
        },
        "channel_category": {
          "id": 54,
          "slug": "Bronze"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1448,
      "outlet_name": "ggggggg",
      "outlet_name_bn": "gggggggg",
      "outlet_code": "R-228228280126-005",
      "owner": "gggg-",
      "contact": "01457845789",
      "approval_status": "PENDING",
      "nid": "2154632597",
      "address": "hsjdjd",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228280126-005/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228280126-005",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228280126-005/outlet_cover_image.jpg",
      "lat": 23.7936443,
      "long": 90.4045111,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1449,
      "outlet_name": "Rashed Khan Store",
      "outlet_name_bn": "Rashed Khan Store",
      "outlet_code": "R-228228280126-002",
      "owner": "Rashed Khan",
      "contact": "01852558666",
      "approval_status": "PENDING",
      "nid": "0852365238",
      "address": "Aftabnagar",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228280126-002/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228280126-002/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228280126-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228280126-002/outlet_cover_image.jpg",
      "lat": 23.7936284,
      "long": 90.4045098,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 59,
          "slug": "Pran"
        },
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1450,
      "outlet_name": "RRR",
      "outlet_name_bn": "RRR",
      "outlet_code": "R-228228280126-003",
      "owner": "RRR",
      "contact": "01532665222",
      "approval_status": "PENDING",
      "nid": "0852316523",
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228280126-003/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228280126-003/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228280126-003",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228280126-003/outlet_cover_image.jpg",
      "lat": 23.7936945,
      "long": 90.4044945,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 58,
          "slug": "Pepsi"
        },
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1451,
      "outlet_name": "Cluster test",
      "outlet_name_bn": "bdbdd",
      "outlet_code": "R-228228290126-009",
      "owner": "jdjdjd",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1122334888",
      "address": "gsgshs",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-009/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228290126-009/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 499,
      "sap_code": "R-228228290126-009",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-009/outlet_cover_image.jpg",
      "lat": 23.7936409,
      "long": 90.4046321,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 60,
          "slug": "Coke"
        },
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1452,
      "outlet_name": "Cluster test",
      "outlet_name_bn": "hehe",
      "outlet_code": "R-228228290126-010",
      "owner": "hdbs",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1122334488",
      "address": "hshshs",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-010/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228290126-010/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 500,
      "sap_code": "R-228228290126-010",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-010/outlet_cover_image.jpg",
      "lat": 23.7936546,
      "long": 90.404605,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 60,
          "slug": "Coke"
        },
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1453,
      "outlet_name": "Cluster test 2",
      "outlet_name_bn": "bdbdnx",
      "outlet_code": "R-228228290126-011",
      "owner": "jxjx",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1122334478",
      "address": "vsvsvs",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-011/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228290126-011/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 46063,
      "sap_code": "R-228228290126-011",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-011/outlet_cover_image.jpg",
      "lat": 23.7936878,
      "long": 90.4045443,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 60,
          "slug": "Coke"
        },
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1454,
      "outlet_name": "Cluster test 3",
      "outlet_name_bn": "hdhdnx",
      "outlet_code": "R-228228290126-012",
      "owner": "jdjdjd",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1122335544",
      "address": "vsbsvz",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-012/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228290126-012/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 46065,
      "sap_code": "R-228228290126-012",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-012/outlet_cover_image.jpg",
      "lat": 23.7936503,
      "long": 90.4046224,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 61,
          "slug": "Own"
        },
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1455,
      "outlet_name": "Abcd",
      "outlet_name_bn": "jdjdjd",
      "outlet_code": "R-228228290126-013",
      "owner": "jdjfjd",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1122336699",
      "address": "hdbdbd",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-013/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228290126-013/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 46070,
      "sap_code": "R-228228290126-013",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-013/outlet_cover_image.jpg",
      "lat": 23.7936674,
      "long": 90.4045855,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 59,
          "slug": "Pran"
        },
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1456,
      "outlet_name": "Cl4",
      "outlet_name_bn": "nxjxbx",
      "outlet_code": "R-228228290126-017",
      "owner": "jxjxbx",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1133446677",
      "address": "hzbzbz",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-017/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 46066,
      "sap_code": "R-228228290126-017",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-017/outlet_cover_image.jpg",
      "lat": 23.7936842,
      "long": 90.4045995,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1457,
      "outlet_name": "Cl5",
      "outlet_name_bn": "ghhhj",
      "outlet_code": "R-228228290126-018",
      "owner": "ghhbn",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "2255880033",
      "address": "ggggh",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-018/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 46070,
      "sap_code": "R-228228290126-018",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-018/outlet_cover_image.jpg",
      "lat": 23.7936504,
      "long": 90.4046178,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1458,
      "outlet_name": "Hasan cluster",
      "outlet_name_bn": "vxbxbxb",
      "outlet_code": "R-228228290126-019",
      "owner": "hxhxbx",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1122445577",
      "address": "bzbzbz",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-019/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 46064,
      "sap_code": "R-228228290126-019",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-019/outlet_cover_image.jpg",
      "lat": 23.7936561,
      "long": 90.4046003,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1459,
      "outlet_name": "Final cluster",
      "outlet_name_bn": "hzhx",
      "outlet_code": "R-228228290126-020",
      "owner": "hxhxh",
      "contact": "01741423438",
      "approval_status": "REJECTED",
      "nid": "1155773399",
      "address": "hzbzbz",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-020/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 498,
      "sap_code": "R-228228290126-020",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-020/outlet_cover_image.jpg",
      "lat": 23.7936961,
      "long": 90.4045576,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1460,
      "outlet_name": "aaaaa",
      "outlet_name_bn": "vdbsgs",
      "outlet_code": "R-228228290126-021",
      "owner": "hshdhd",
      "contact": "01741423438",
      "approval_status": "APPROVED",
      "nid": "1115577993",
      "address": "vsbsbs",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-021/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 46066,
      "sap_code": "R-228228290126-021",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-021/outlet_cover_image.jpg",
      "lat": 23.7936473,
      "long": 90.4046063,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 49,
          "slug": "Pharma"
        },
        "channel_category": {
          "id": 53,
          "slug": "Silver"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1461,
      "outlet_name": "Samir Store",
      "outlet_name_bn": "Samir Store",
      "outlet_code": "R-228228020226-002",
      "owner": "Samir",
      "contact": "01853665232",
      "approval_status": "PENDING",
      "nid": "8855558658",
      "address": "Aftabnagar",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228020226-002/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228020226-002/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 46063,
      "sap_code": "R-228228020226-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228020226-002/outlet_cover_image.jpg",
      "lat": 23.7938464,
      "long": 90.404586,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 58,
          "slug": "Pepsi"
        },
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1462,
      "outlet_name": "Samir Store",
      "outlet_name_bn": "Samir Store",
      "outlet_code": "R-228228020226-003",
      "owner": "Samir",
      "contact": "01553669555",
      "approval_status": "APPROVED",
      "nid": "8562365235",
      "address": "Aftabnagar",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228020226-003/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228020226-003/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 499,
      "sap_code": "R-228228020226-003",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228020226-003/outlet_cover_image.jpg",
      "lat": 23.7936237,
      "long": 90.4046236,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 59,
          "slug": "Pran"
        },
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1464,
      "outlet_name": "Jamil Store",
      "outlet_name_bn": "Jamil Store",
      "outlet_code": "R-228228020226-004",
      "owner": "Jamil",
      "contact": "01523552666",
      "approval_status": "PENDING",
      "nid": "8562356523",
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228020226-004/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228020226-004/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 499,
      "sap_code": "R-228228020226-004",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228020226-004/outlet_cover_image.jpg",
      "lat": 23.7939196,
      "long": 90.4046952,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 58,
          "slug": "Pepsi"
        },
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1465,
      "outlet_name": "Dolphin Store",
      "outlet_name_bn": "Dolphin Store",
      "outlet_code": "R-228228030226-002",
      "owner": "Dolphin",
      "contact": "01883995666",
      "approval_status": "PENDING",
      "nid": "0853265868",
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228030226-002/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228030226-002/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 498,
      "sap_code": "R-228228030226-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228030226-002/outlet_cover_image.jpg",
      "lat": 23.7936111,
      "long": 90.4045778,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 58,
          "slug": "Pepsi"
        },
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1466,
      "outlet_name": "sbsbbe",
      "outlet_name_bn": "bebene",
      "outlet_code": "R-228228030226-002",
      "owner": "hshdjd",
      "contact": "01739757575",
      "approval_status": "PENDING",
      "nid": "2525859680",
      "address": "gffg",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228030226-002/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 499,
      "sap_code": "R-228228030226-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228030226-002/outlet_cover_image.jpg",
      "lat": 23.7936587,
      "long": 90.4045928,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1467,
      "outlet_name": "sbbdbd",
      "outlet_name_bn": "hdheje",
      "outlet_code": "R-228228030226-003",
      "owner": "sbdhdj",
      "contact": "01658080909",
      "approval_status": "PENDING",
      "nid": "5464567893",
      "address": "gshshjs",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228030226-003/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 500,
      "sap_code": "R-228228030226-003",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228030226-003/outlet_cover_image.jpg",
      "lat": 23.7936827,
      "long": 90.4046185,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 48,
          "slug": "Tong"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1470,
      "outlet_name": "James",
      "outlet_name_bn": "James",
      "outlet_code": "R-228228050226-003",
      "owner": "James",
      "contact": "01523665888",
      "approval_status": "PENDING",
      "nid": "8523156523",
      "address": "Ulla Para",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228050226-003/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228050226-003/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 500,
      "sap_code": "R-228228050226-003",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228050226-003/outlet_cover_image.jpg",
      "lat": 23.7940266,
      "long": 90.4050935,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 58,
          "slug": "Pepsi"
        },
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1472,
      "outlet_name": "ggggggg",
      "outlet_name_bn": "ggggggg",
      "outlet_code": "R-228228050226-004",
      "owner": "ggggggg",
      "contact": "01787879898",
      "approval_status": "PENDING",
      "nid": "12457812568923567",
      "address": "hshhdudud",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228050226-004/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228050226-004/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 46063,
      "sap_code": "R-228228050226-004",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228050226-004/outlet_cover_image.jpg",
      "lat": 23.7936413,
      "long": 90.4045458,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 60,
          "slug": "Coke"
        },
        "business_type": {
          "id": 50,
          "slug": "Departmental"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1473,
      "outlet_name": "zzzzzzzzzzzzzzz",
      "outlet_name_bn": "zzzzzzzzzzzzzzz",
      "outlet_code": "R-228228050226-005",
      "owner": "zzzzzzzzzzzzzz",
      "contact": "01758889966",
      "approval_status": "PENDING",
      "nid": "1235426985",
      "address": "vshs",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228050226-005/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 499,
      "sap_code": "R-228228050226-005",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228050226-005/outlet_cover_image.jpg",
      "lat": 23.7935994,
      "long": 90.4045652,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 48,
          "slug": "Tong"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1474,
      "outlet_name": "xxxxxxxxxxx",
      "outlet_name_bn": "xxxxxxxxxxx",
      "outlet_code": "R-228228050226-006",
      "owner": "xxxxxxxxxx",
      "contact": "01888588588",
      "approval_status": "PENDING",
      "nid": "0088559966",
      "address": "hsjd",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228050226-006/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 499,
      "sap_code": "R-228228050226-006",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228050226-006/outlet_cover_image.jpg",
      "lat": 23.7936196,
      "long": 90.4045794,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 48,
          "slug": "Tong"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1475,
      "outlet_name": "Jabbar",
      "outlet_name_bn": "Jabbar",
      "outlet_code": "R-228228050226-007",
      "owner": "Jabbar",
      "contact": "01558326523",
      "approval_status": "APPROVED",
      "nid": "8523145236",
      "address": "Abbas",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228050226-007/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228050226-007/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 46064,
      "sap_code": "R-228228050226-007",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228050226-007/outlet_cover_image.jpg",
      "lat": 23.7935785,
      "long": 90.4046437,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 58,
          "slug": "Pepsi"
        },
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1476,
      "outlet_name": "Ranju Store",
      "outlet_name_bn": "Ranju Store",
      "outlet_code": "OLM-8190525-003",
      "owner": "Ranju",
      "contact": "01914444123",
      "approval_status": "APPROVED",
      "nid": "19238192038291",
      "address": "Banani, Dhaka",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 0,
      "sap_code": "OLM-8190525-003",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/OLM-8190525-003/outlet_cover_image.jpg",
      "lat": 23.83473,
      "long": 90.416331,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 54,
          "slug": "Bronze"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1478,
      "outlet_name": "Rabbi Store",
      "outlet_name_bn": "Rabbi Store",
      "outlet_code": "1234",
      "owner": "Rabbi",
      "contact": "01786554555",
      "approval_status": "APPROVED",
      "nid": "1209876898",
      "address": "Aftabnagar",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 0,
      "sap_code": "1234",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/1234/outlet_cover_image.jpg",
      "lat": 22.3396,
      "long": 91.8292,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 49,
          "slug": "Pharma"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1481,
      "outlet_name": "Jabir Store",
      "outlet_name_bn": "Jabir Store",
      "outlet_code": "R-228228080226-002",
      "owner": "Jabir",
      "contact": "01567886555",
      "approval_status": "APPROVED",
      "nid": "2987656783",
      "address": "Abtabnagar",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228080226-002/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228080226-002/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 498,
      "sap_code": "R-228228080226-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228080226-002/outlet_cover_image.jpg",
      "lat": 22.8269288,
      "long": 91.5223027,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 58,
          "slug": "Pepsi"
        },
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1483,
      "outlet_name": "Rabbi Store",
      "outlet_name_bn": "Rabbi Store",
      "outlet_code": "12343",
      "owner": "Rabbi",
      "contact": "01786554555",
      "approval_status": "APPROVED",
      "nid": "1209876898",
      "address": "Aftabnagar",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 0,
      "sap_code": "12343",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/12343/outlet_cover_image.jpg",
      "lat": 23.793659,
      "long": 90.404649,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1484,
      "outlet_name": "Rabbi Store",
      "outlet_name_bn": "Rabbi Store",
      "outlet_code": "12344",
      "owner": "Rabbi",
      "contact": "01786554555",
      "approval_status": "APPROVED",
      "nid": "1209876898",
      "address": "Aftabnagar, Dhaka, Bangladesh",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 0,
      "sap_code": "12344",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/12344/outlet_cover_image.jpg",
      "lat": 23.793661,
      "long": 90.404647,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1485,
      "outlet_name": "Momtaz Store",
      "outlet_name_bn": "Momtaz Store",
      "outlet_code": "123433",
      "owner": "Momtaz",
      "contact": "01786554555",
      "approval_status": "APPROVED",
      "nid": "1209876898",
      "address": "Momtaz Store",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 0,
      "sap_code": "123433",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/123433/outlet_cover_image.jpg",
      "lat": 23.793659,
      "long": 90.404654,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 53,
          "slug": "Silver"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1486,
      "outlet_name": "Momtaz Store",
      "outlet_name_bn": "Momtaz Store",
      "outlet_code": "1234332",
      "owner": "Momtaz",
      "contact": "01786554555",
      "approval_status": "APPROVED",
      "nid": "1209876898",
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 0,
      "sap_code": "1234332",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/1234332/outlet_cover_image.jpg",
      "lat": 23.793663,
      "long": 90.404651,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 53,
          "slug": "Silver"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1488,
      "outlet_name": "abcd",
      "outlet_name_bn": "abcd",
      "outlet_code": "R-228228160226-002",
      "owner": "abcd",
      "contact": "01741423438",
      "approval_status": "APPROVED",
      "nid": "",
      "address": "abcd",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228160226-002/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 500,
      "sap_code": "R-228228160226-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228160226-002/outlet_cover_image.jpg",
      "lat": 23.7936692,
      "long": 90.4045662,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1490,
      "outlet_name": "Rahim Store",
      "outlet_name_bn": "Rahim Store",
      "outlet_code": "Rahim67",
      "owner": "Rahim",
      "contact": "01786554555",
      "approval_status": "APPROVED",
      "nid": null,
      "address": "Banani",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 202,
      "cluster_id": 0,
      "sap_code": "Rahim67",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/Rahim67/outlet_cover_image.jpg",
      "lat": 23.793664,
      "long": 90.404651,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1492,
      "outlet_name": "Samir Store",
      "outlet_name_bn": "Samir Store",
      "outlet_code": "R-228228010326-002",
      "owner": "Samir",
      "contact": "01511111111",
      "approval_status": "APPROVED",
      "nid": "1652365482",
      "address": "Bashandhura",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228010326-002/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 378,
      "cluster_id": 498,
      "sap_code": "R-228228010326-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228010326-002/outlet_cover_image.jpg",
      "lat": 23.7939943,
      "long": 90.4046935,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1493,
      "outlet_name": "Rabbi Store",
      "outlet_name_bn": "Rabbi Store",
      "outlet_code": "R-228228010326-003",
      "owner": "Rabbi",
      "contact": "01511111111",
      "approval_status": "PENDING",
      "nid": "1325652356",
      "address": "Bashundhora",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228010326-003/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 378,
      "cluster_id": 498,
      "sap_code": "R-228228010326-003",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228010326-003/outlet_cover_image.jpg",
      "lat": 23.7937179,
      "long": 90.4046215,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1494,
      "outlet_name": "gggggg",
      "outlet_name_bn": "gggg",
      "outlet_code": "R-228228010326-008",
      "owner": "ggggg",
      "contact": "01478252536",
      "approval_status": "PENDING",
      "nid": "1212454578",
      "address": "vvv",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228010326-008/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 378,
      "cluster_id": 46063,
      "sap_code": "R-228228010326-008",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228010326-008/outlet_cover_image.jpg",
      "lat": 23.7937411,
      "long": 90.4045357,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 48,
          "slug": "Tong"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1495,
      "outlet_name": "Abc",
      "outlet_name_bn": "Abc",
      "outlet_code": "R-228228020326-004",
      "owner": "Abcb",
      "contact": "01556552666",
      "approval_status": "PENDING",
      "nid": "5235626523",
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228020326-004/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 378,
      "cluster_id": 498,
      "sap_code": "R-228228020326-004",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228020326-004/outlet_cover_image.jpg",
      "lat": 23.7939921,
      "long": 90.4050633,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1502,
      "outlet_name": "Sufia",
      "outlet_name_bn": "Sufia",
      "outlet_code": "R-228228090326-002",
      "owner": "Sufia",
      "contact": "01762335888",
      "approval_status": "APPROVED",
      "nid": "1523658213",
      "address": "Banani",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228090326-002/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 498,
      "sap_code": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228090326-002/outlet_cover_image.jpg",
      "lat": 23.79366,
      "long": 90.4046925,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1503,
      "outlet_name": "Momtaz Store",
      "outlet_name_bn": "Momtaz Store",
      "outlet_code": "mom123",
      "owner": "Momtaz",
      "contact": "01786554557",
      "approval_status": "APPROVED",
      "nid": null,
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 222,
      "cluster_id": 0,
      "sap_code": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/mom123/outlet_cover_image.jpg",
      "lat": 23.793663,
      "long": 90.40463,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1505,
      "outlet_name": "ehhe",
      "outlet_name_bn": "ehhe",
      "outlet_code": "R-228228100326-009",
      "owner": "eheh",
      "contact": "01745858586",
      "approval_status": "PENDING",
      "nid": "2145783695",
      "address": "vsjdj",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228100326-009/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 499,
      "sap_code": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228100326-009/outlet_cover_image.jpg",
      "lat": 23.7937078,
      "long": 90.40457,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 48,
          "slug": "Tong"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1506,
      "outlet_name": "bdbdbd",
      "outlet_name_bn": "bebrbr",
      "outlet_code": "R-228228100326-010",
      "owner": "hshdhd",
      "contact": "01755885566",
      "approval_status": "REJECTED",
      "nid": "8787454569",
      "address": "shhshd",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228100326-010/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 500,
      "sap_code": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228100326-010/outlet_cover_image.jpg",
      "lat": 23.7937496,
      "long": 90.4045298,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1508,
      "outlet_name": "Asraf Store",
      "outlet_name_bn": "Asraf Store",
      "outlet_code": "R-228228110326-002",
      "owner": "Asraf",
      "contact": "01885213526",
      "approval_status": "APPROVED",
      "nid": "1235642536",
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228110326-002/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 293752,
      "sap_code": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228110326-002/outlet_cover_image.jpg",
      "lat": 23.7938971,
      "long": 90.4046451,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1437,
      "outlet_name": "Khan store Banani",
      "outlet_name_bn": "Khan store Banani",
      "outlet_code": "R-228228220126-002",
      "owner": "khan",
      "contact": "01885885666",
      "approval_status": "APPROVED",
      "nid": "1958358",
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228220126-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228220126-002/outlet_cover_image.jpg",
      "lat": 23.7939054,
      "long": 90.4046311,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1436,
      "outlet_name": "Gmail store",
      "outlet_name_bn": "জিমেইল ষ্টোর",
      "outlet_code": "R-228228210126-002",
      "owner": "Alal",
      "contact": "01789456123",
      "approval_status": "APPROVED",
      "nid": "123456789978654",
      "address": "Dhaka, Banani",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": null,
      "sap_code": "R-228228210126-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228210126-002/outlet_cover_image.jpg",
      "lat": 23.7937144,
      "long": 90.4045622,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 53,
          "slug": "Silver"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1488,
      "outlet_name": "abcd",
      "outlet_name_bn": "abcd",
      "outlet_code": "R-228228160226-002",
      "owner": "abcd",
      "contact": "01741423438",
      "approval_status": "APPROVED",
      "nid": "",
      "address": "abcd",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228160226-002/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 500,
      "sap_code": "R-228228160226-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228160226-002/outlet_cover_image.jpg",
      "lat": 23.7936692,
      "long": 90.4045662,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1473,
      "outlet_name": "zzzzzzzzzzzzzzz",
      "outlet_name_bn": "zzzzzzzzzzzzzzz",
      "outlet_code": "R-228228050226-005",
      "owner": "zzzzzzzzzzzzzz",
      "contact": "01758889966",
      "approval_status": "PENDING",
      "nid": "1235426985",
      "address": "vshs",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228050226-005/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 499,
      "sap_code": "R-228228050226-005",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228050226-005/outlet_cover_image.jpg",
      "lat": 23.7935994,
      "long": 90.4045652,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 48,
          "slug": "Tong"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1474,
      "outlet_name": "xxxxxxxxxxx",
      "outlet_name_bn": "xxxxxxxxxxx",
      "outlet_code": "R-228228050226-006",
      "owner": "xxxxxxxxxx",
      "contact": "01888588588",
      "approval_status": "PENDING",
      "nid": "0088559966",
      "address": "hsjd",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228050226-006/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 499,
      "sap_code": "R-228228050226-006",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228050226-006/outlet_cover_image.jpg",
      "lat": 23.7936196,
      "long": 90.4045794,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 48,
          "slug": "Tong"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1456,
      "outlet_name": "Cl4",
      "outlet_name_bn": "nxjxbx",
      "outlet_code": "R-228228290126-017",
      "owner": "jxjxbx",
      "contact": "01741423438",
      "approval_status": "PENDING",
      "nid": "1133446677",
      "address": "hzbzbz",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228290126-017/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 46066,
      "sap_code": "R-228228290126-017",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228290126-017/outlet_cover_image.jpg",
      "lat": 23.7936842,
      "long": 90.4045995,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 47,
          "slug": "Grocery"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 154,
      "outlet_name": "Nishat Store",
      "outlet_name_bn": "নিশাত স্টোর",
      "outlet_code": "K-1234",
      "owner": "Nishat",
      "contact": "0",
      "approval_status": "APPROVED",
      "nid": "0",
      "address": "Kakoli",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 498,
      "sap_code": "K-1234",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/K-1234/outlet_cover_image.jpg",
      "lat": 23.793714,
      "long": 90.40453,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1493,
      "outlet_name": "Rabbi Store",
      "outlet_name_bn": "Rabbi Store",
      "outlet_code": "R-228228010326-003",
      "owner": "Rabbi",
      "contact": "01511111111",
      "approval_status": "PENDING",
      "nid": "1325652356",
      "address": "Bashundhora",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228010326-003/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 498,
      "sap_code": "R-228228010326-003",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228010326-003/outlet_cover_image.jpg",
      "lat": 23.7937179,
      "long": 90.4046215,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1492,
      "outlet_name": "Samir Store",
      "outlet_name_bn": "Samir Store",
      "outlet_code": "R-228228010326-002",
      "owner": "Samir",
      "contact": "01511111111",
      "approval_status": "APPROVED",
      "nid": "1652365482",
      "address": "Bashandhura",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228010326-002/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 498,
      "sap_code": "R-228228010326-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228010326-002/outlet_cover_image.jpg",
      "lat": 23.7939943,
      "long": 90.4046935,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 46,
          "slug": "Supershop"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1465,
      "outlet_name": "Dolphin Store",
      "outlet_name_bn": "Dolphin Store",
      "outlet_code": "R-228228030226-002",
      "owner": "Dolphin",
      "contact": "01883995666",
      "approval_status": "PENDING",
      "nid": "0853265868",
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228030226-002/outlet_cover_image.jpg",
      "outlet_cooler_image": "olympic/retailer/R-228228030226-002/outlet_cooler_image.jpg",
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 498,
      "sap_code": "R-228228030226-002",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228030226-002/outlet_cover_image.jpg",
      "lat": 23.7936111,
      "long": 90.4045778,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "cooler": {
          "id": 58,
          "slug": "Pepsi"
        },
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1495,
      "outlet_name": "Abc",
      "outlet_name_bn": "Abc",
      "outlet_code": "R-228228020326-004",
      "owner": "Abcb",
      "contact": "01556552666",
      "approval_status": "PENDING",
      "nid": "5235626523",
      "address": "Badda",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228020326-004/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 498,
      "sap_code": "R-228228020326-004",
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228020326-004/outlet_cover_image.jpg",
      "lat": 23.7939921,
      "long": 90.4050633,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1511,
      "outlet_name": "Rabbi Store",
      "outlet_name_bn": "রাব্বি স্টোর",
      "outlet_code": "R-228228140326-002",
      "owner": "Rabbi",
      "contact": "01765778777",
      "approval_status": "APPROVED",
      "nid": "1976578675",
      "address": "Dhaka",
      "price_group": 1,
      "outlet_cover_image": "olympic/retailer/R-228228140326-002/outlet_cover_image.jpg",
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 213,
      "cluster_id": 498,
      "sap_code": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/R-228228140326-002/outlet_cover_image.jpg",
      "lat": 23.7666139,
      "long": 90.4270397,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_surveys": []
    },
    {
      "id": 1513,
      "outlet_name": "AP",
      "outlet_name_bn": "AP",
      "outlet_code": "AP09",
      "owner": "Apon",
      "contact": "01786554333",
      "approval_status": "APPROVED",
      "nid": null,
      "address": "Banani",
      "price_group": 1,
      "outlet_cover_image": null,
      "outlet_cooler_image": null,
      "sbu_id": [
        54
      ],
      "dep_id": 167,
      "section_id": 204,
      "cluster_id": 0,
      "sap_code": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "https://olympic-dev.wingssfa.net/app-api/static-file/retailer/AP09/outlet_cover_image.jpg",
      "lat": 23.793645,
      "long": 90.404641,
      "allowable_distance": 100,
      "reasoning_check": 1,
      "available_onboarding_info": {
        "cooler_status": "No",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 52,
          "slug": "Gold"
        }
      },
      "available_surveys": []
    }
  ],
  "transport_types": [],
  "notifications": [],
  "resignation_notice_days": 30,
  "dashboard_button": {
    "stock": 0,
    "pre_order_button": 0,
    "delivery": 0,
    "memo": 0,
    "attendance": 1,
    "summary": 0,
    "asset": 0,
    "route_change": 0,
    "sync": 1,
    "leave_management": 0,
    "outlet": 1,
    "tsm": 0,
    "sales_entry": 0,
    "ro": 0,
    "approval_asset": 0,
    "maintenance": 0,
    "bill": 0,
    "digital_learning": 1,
    "pjp_plan": 0,
    "allowance": 0,
    "web_panel": 0,
    "resignation": 0,
    "taDa": 1,
    "catalogue": 0,
    "stock_verification": 1,
    "audit": 1,
    "market": 0
  },
  "retailer_selection_config": {
    "tab_mode": true,
    "show_all_routes": false
  },
  "modules": {
    "54": {
      "id": 54,
      "name": "Sun",
      "slug": "Sun",
      "dashboard_infos": {
        "visited": 1,
        "strike_rate": 1,
        "issue": 1,
        "stock": 1,
        "preorder_visited": 1,
        "preorder_strike_rate": 1,
        "preorder_issue_qty": 1,
        "preorder_issue_amount": 1
      },
      "units": {
        "17": {
          "id": 17,
          "name": "Pcs",
          "slug": "Pcs",
          "is_primary": 0,
          "increase_id": 17
        },
        "120": {
          "id": 120,
          "name": "Case",
          "slug": "Case",
          "is_primary": 0,
          "increase_id": 120
        },
        "168": {
          "id": 168,
          "name": "Carton",
          "slug": "Carton",
          "is_primary": 0,
          "increase_id": 168
        },
        "169": {
          "id": 169,
          "name": "Bag",
          "slug": "Bag",
          "is_primary": 0,
          "increase_id": 169
        },
        "219": {
          "id": 219,
          "name": "Meter",
          "slug": "Meter",
          "is_primary": 0,
          "increase_id": 219
        }
      },
      "product_category": {
        "9": {
          "id": 9,
          "name": "Brand",
          "slug": "Brand",
          "parent_id": 0,
          "is_sku": 0
        },
        "10": {
          "id": 10,
          "name": "SKU",
          "slug": "SKU",
          "parent_id": 9,
          "is_sku": 1
        }
      }
    }
  },
  "app_version_info": {
    "app_version": "1.0.0",
    "version_mandatory": 1
  },
  "survey_details": {},
  "ta_da_config": {
    "vehicle_list": [
      {
        "id": 194,
        "parent": 193,
        "slug": "Bus"
      },
      {
        "id": 195,
        "parent": 193,
        "slug": "Train"
      },
      {
        "id": 196,
        "parent": 193,
        "slug": "Boat"
      },
      {
        "id": 197,
        "parent": 193,
        "slug": "Rickshaw"
      },
      {
        "id": 198,
        "parent": 193,
        "slug": "CNG"
      },
      {
        "id": 199,
        "parent": 193,
        "slug": "Other Transport"
      }
    ],
    "other_cost_type_list": [
      {
        "id": 201,
        "parent": 200,
        "slug": "Breakfast"
      },
      {
        "id": 202,
        "parent": 200,
        "slug": "Lunch"
      },
      {
        "id": 203,
        "parent": 200,
        "slug": "Dinner"
      },
      {
        "id": 204,
        "parent": 200,
        "slug": "DA"
      },
      {
        "id": 205,
        "parent": 200,
        "slug": "Others"
      }
    ]
  },
  "tada_expense_configs": {
    "166": {
      "197": {
        "type": "HQ",
        "amount": 700
      }
    },
    "167": {
      "204": {
        "type": "HQ",
        "amount": 700
      },
      "213": {
        "type": "EX-HQ",
        "amount": 300
      },
      "214": {
        "type": "Outstation(OS)",
        "amount": 300
      },
      "220": {
        "type": "Outstation(OS)",
        "amount": 300
      },
      "221": {
        "type": "Outstation(OS)",
        "amount": 300
      },
      "222": {
        "type": "Outstation(OS)",
        "amount": 300
      },
      "377": {
        "type": "Outstation(OS)",
        "amount": 300
      },
      "378": {
        "type": "Outstation(OS)",
        "amount": 300
      },
      "379": {
        "type": "Outstation(OS)",
        "amount": 300
      },
      "380": {
        "type": "Outstation(OS)",
        "amount": 300
      },
      "382": {
        "type": "Outstation(OS)",
        "amount": 300
      },
      "388": {
        "type": "Outstation(OS)",
        "amount": 300
      }
    }
  },
  "locations": {
    "zone": {
      "13": {
        "id": 13,
        "name": "Zone-D",
        "parent_id": 0
      }
    },
    "region": {
      "90": {
        "id": 90,
        "name": "Khulna",
        "parent_id": 13
      }
    },
    "area": {
      "420": {
        "id": 420,
        "name": "Satkhira",
        "parent_id": 90
      }
    },
    "point": {
      "166": {
        "id": 166,
        "name": "SATKHIRA",
        "parent_id": 420,
        "location_type": 19,
        "type": "EX-HQ",
        "available_surveys": []
      },
      "167": {
        "id": 167,
        "name": "KOLAROA",
        "parent_id": 420,
        "location_type": 19,
        "type": "HQ",
        "available_surveys": []
      }
    }
  },
  "sale_submit_config": {
    "resetEnabled": true,
    "reasons": [
      {
        "id": 1,
        "slug": "Wrong SKU Selected"
      },
      {
        "id": 2,
        "slug": "Wrong SKU Amount"
      },
      {
        "id": 3,
        "slug": "Promotion Issue"
      }
    ]
  },
  "max_service_count": 2,
  "last_service_points": [],
  "attendance_configuration": {
    "mandatory_attendance": 1,
    "check_in": 1
  },
  "sr-tracking": [
    {
      "sbu_id": "[54]",
      "date": "2026-04-21",
      "pin_date_time": "2026-04-21 17:48:22.911744",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937011",
      "longitude": "90.4046117",
      "accuracy": 22.0310001373291,
      "altitude": 30.5,
      "altitudeAccuracy": "",
      "heading": 0.0,
      "speed": 0.0,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-21",
      "pin_date_time": "2026-04-21 17:52:09.477180",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7936929",
      "longitude": "90.4046868",
      "accuracy": 14.831999778747559,
      "altitude": 30.5,
      "altitudeAccuracy": "",
      "heading": 94.21311950683594,
      "speed": 0.985514760017395,
      "internet_speed": "",
      "connection_type": ""
    }
  ]
};
