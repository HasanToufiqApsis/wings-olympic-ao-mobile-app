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
  "date": "2026-04-19",
  "logged_in": 1,
  "userData": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiQWhtZWQgTGlua29uIiwiaWQiOjE3NjUsInVzZXJUeXBlSWQiOjY1LCJlbWFpbCI6ImxpbmtvbkBnbWFpbC5jb20iLCJzYnVfaWQiOls1NF0sImlhdCI6MTc3NjU4Nzg2MywiZXhwIjoxMDAxNzc2NTgwOTgzfQ.MljwHRXNmrbuOfE8a6ryn0bYmU9H0jQZ4O2jdC87Cck",
    "refreshToken": "CX73qo3C42oFcWBL",
    "date": "2026-04-19",
    "id": 1765,
    "sbu_id": [
      54
    ],
    "user_type_id": 65,
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
    "updated_at": "2026-04-09T09:33:56.000Z",
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
      "available_surveys": [
        599
      ]
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
  "survey_details": {
    "survey_info": [
      {
        "id": 599,
        "name": "April Survey",
        "dep_id": 167,
        "mandatory": 0
      }
    ],
    "questions": {
      "599": [
        {
          "survey_id": 599,
          "question_id": 1003,
          "question_type": "yes_no",
          "has_dependency": 1,
          "question_name": "Abc",
          "required": 0,
          "options": [
            {
              "answer_id": 525,
              "answer_name": "Yes",
              "question_id": 1003,
              "dependency_question_id": null,
              "survey_id": 580,
              "parent_id": 525
            },
            {
              "answer_id": 526,
              "answer_name": "No",
              "question_id": 1003,
              "dependency_question_id": null,
              "survey_id": 580,
              "parent_id": 526
            }
          ],
          "dependent_questions": {}
        }
      ]
    }
  },
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
        "slug": "Hotel"
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
        "amount": 650
      }
    },
    "167": {
      "204": {
        "type": "HQ",
        "amount": 800
      },
      "213": {
        "type": "EX-HQ",
        "amount": 700
      },
      "214": {
        "type": "EX-HQ",
        "amount": 650
      },
      "220": {
        "type": "EX-HQ",
        "amount": 300
      },
      "221": {
        "type": "OUTSTATION",
        "amount": 500
      },
      "222": {
        "type": "OUTSTATION",
        "amount": 800
      },
      "223": {
        "type": "OUTSTATION",
        "amount": 300
      },
      "377": {
        "type": "OUTSTATION",
        "amount": 500
      },
      "378": {
        "type": "OUTSTATION",
        "amount": 300
      },
      "379": {
        "type": "OUTSTATION",
        "amount": 300
      },
      "380": {
        "type": "OUTSTATION",
        "amount": 500
      },
      "382": {
        "type": "OUTSTATION",
        "amount": 800
      },
      "388": {
        "type": "OUTSTATION",
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
        "available_surveys": []
      },
      "167": {
        "id": 167,
        "name": "KOLAROA",
        "parent_id": 420,
        "location_type": 19,
        "available_surveys": [
          599
        ]
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
  "survey-data": {
    "1440": {
      "599": {
        "1003": {
          "questionType": "select",
          "answer_id": 525,
          "answer": "Yes"
        }
      }
    }
  },
  "taDa-survey-events": [
    {
      "survey_type": "outlet",
      "survey_id": 599,
      "retailer_id": 1440,
      "point_id": 167,
      "dep_id": 167,
      "section_id": 213,
      "sales_date": "2026-04-19",
      "created_at": "2026-04-19T14:38:06.071676"
    }
  ],
  "checkout-data": {
    "1440": [
      {
        "ff_id": 1765,
        "sbu_id": "[54]",
        "dep_id": null,
        "section_id": null,
        "outlet_id": 1440,
        "outlet_code": "R-228228220126-002",
        "date": "2026-04-19",
        "checkout_datetime": "2026-04-19 14:38:07.988744"
      }
    ]
  },
  "sr-tracking": [
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:38:56.010934",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7938097",
      "longitude": "90.4044768",
      "accuracy": 34.400001525878906,
      "altitude": 29.5,
      "altitudeAccuracy": "",
      "heading": 273.8368225097656,
      "speed": 0.9432469606399536,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:40:50.066339",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937626",
      "longitude": "90.4045414",
      "accuracy": 19.812000274658203,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 218.24612426757812,
      "speed": 0.4173867702484131,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:41:57.483178",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937587",
      "longitude": "90.4045613",
      "accuracy": 15.442999839782715,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 65.80790710449219,
      "speed": 0.15951423346996307,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:43:53.675066",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937747",
      "longitude": "90.4045711",
      "accuracy": 15.996000289916992,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 20.415328979492188,
      "speed": 0.5251979827880859,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:45:00.765875",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937667",
      "longitude": "90.4045203",
      "accuracy": 31.225000381469727,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 224.4224090576172,
      "speed": 0.6315683722496033,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:46:56.737384",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.793763",
      "longitude": "90.404572",
      "accuracy": 18.00200080871582,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 130.48263549804688,
      "speed": 0.6469206809997559,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:48:03.869503",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937771",
      "longitude": "90.404482",
      "accuracy": 25.006999969482422,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 291.708984375,
      "speed": 0.5740599036216736,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:49:59.792497",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937554",
      "longitude": "90.4045244",
      "accuracy": 25.065000534057617,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 0.0,
      "speed": 0.04018164053559303,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:51:06.770583",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937623",
      "longitude": "90.4045462",
      "accuracy": 13.855999946594238,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 182.0541229248047,
      "speed": 0.2672993540763855,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:53:02.833518",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937804",
      "longitude": "90.4044725",
      "accuracy": 30.023000717163086,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 123.69442749023438,
      "speed": 0.4204852879047394,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:54:10.110125",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937645",
      "longitude": "90.4045771",
      "accuracy": 13.779999732971191,
      "altitude": 29.0,
      "altitudeAccuracy": "",
      "heading": 89.19033813476562,
      "speed": 0.842764675617218,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:56:06.064483",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.793758",
      "longitude": "90.4045312",
      "accuracy": 12.899999618530273,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 229.3285675048828,
      "speed": 0.5233741998672485,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:57:13.229264",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937756",
      "longitude": "90.4045015",
      "accuracy": 14.829999923706055,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 120.84637451171875,
      "speed": 1.2439618110656738,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 14:59:08.997876",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937887",
      "longitude": "90.4044306",
      "accuracy": 32.73699951171875,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 296.7905578613281,
      "speed": 1.8192962408065796,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:00:15.796812",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7938029",
      "longitude": "90.4044551",
      "accuracy": 27.64900016784668,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 318.8730773925781,
      "speed": 0.2406924068927765,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:02:11.883028",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937319",
      "longitude": "90.4045487",
      "accuracy": 17.94099998474121,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 208.06845092773438,
      "speed": 0.398750901222229,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:03:18.897890",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937798",
      "longitude": "90.4044379",
      "accuracy": 30.059999465942383,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 300.3021545410156,
      "speed": 3.0835840702056885,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:05:15.057628",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937555",
      "longitude": "90.4045394",
      "accuracy": 17.35300064086914,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 82.69734191894531,
      "speed": 0.21372801065444946,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:06:22.323216",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937465",
      "longitude": "90.4045554",
      "accuracy": 12.602999687194824,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 124.69124603271484,
      "speed": 0.4434601664543152,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:08:18.721500",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937901",
      "longitude": "90.4044736",
      "accuracy": 35.141998291015625,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 301.23248291015625,
      "speed": 1.2828409671783447,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:09:26.335449",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937286",
      "longitude": "90.4045878",
      "accuracy": 42.5,
      "altitude": 24.600000381469727,
      "altitudeAccuracy": "",
      "heading": 138.72503662109375,
      "speed": 1.0197111368179321,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:11:22.600696",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937506",
      "longitude": "90.4045461",
      "accuracy": 24.329999923706055,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 0.0,
      "speed": 0.07463232427835464,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:12:30.108917",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937321",
      "longitude": "90.4045698",
      "accuracy": 15.8100004196167,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 110.16438293457031,
      "speed": 2.338780403137207,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:14:26.440754",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937276",
      "longitude": "90.4045821",
      "accuracy": 12.13599967956543,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 128.98109436035156,
      "speed": 0.2890559434890747,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:15:34.013414",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937363",
      "longitude": "90.4045629",
      "accuracy": 20.858999252319336,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 145.4242706298828,
      "speed": 0.5385462641716003,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:17:30.306874",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937682",
      "longitude": "90.4045562",
      "accuracy": 15.89900016784668,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 118.45274353027344,
      "speed": 1.2129426002502441,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:18:37.924806",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937361",
      "longitude": "90.4045676",
      "accuracy": 20.12700080871582,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 133.70689392089844,
      "speed": 0.34310635924339294,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:20:34.535091",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937558",
      "longitude": "90.4045315",
      "accuracy": 22.187000274658203,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 2.907447099685669,
      "speed": 0.2362721711397171,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:21:42.063775",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937568",
      "longitude": "90.4045372",
      "accuracy": 17.757999420166016,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 302.59881591796875,
      "speed": 0.5364304780960083,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:23:38.524767",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937518",
      "longitude": "90.4045335",
      "accuracy": 28.98699951171875,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 133.1545867919922,
      "speed": 0.27916601300239563,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:24:45.997394",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937793",
      "longitude": "90.4045336",
      "accuracy": 12.21500015258789,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 3.880509376525879,
      "speed": 0.6473612785339355,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:26:42.097929",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937389",
      "longitude": "90.4045598",
      "accuracy": 26.697999954223633,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 119.04127502441406,
      "speed": 0.41916948556900024,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:27:49.287507",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937804",
      "longitude": "90.4044485",
      "accuracy": 32.14099884033203,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 290.6420593261719,
      "speed": 1.5735995769500732,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:29:45.618020",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937587",
      "longitude": "90.4045269",
      "accuracy": 29.976999282836914,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 293.3172302246094,
      "speed": 0.6716263294219971,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:30:52.834902",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937808",
      "longitude": "90.4044764",
      "accuracy": 32.034000396728516,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 305.78387451171875,
      "speed": 1.5912580490112305,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:32:49.164922",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937712",
      "longitude": "90.4045498",
      "accuracy": 17.231000900268555,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 122.01617431640625,
      "speed": 1.333457350730896,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:33:56.264096",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937945",
      "longitude": "90.4045204",
      "accuracy": 18.211999893188477,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 323.7137145996094,
      "speed": 0.8307191133499146,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:35:52.371309",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937808",
      "longitude": "90.4045025",
      "accuracy": 17.801000595092773,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 306.1676025390625,
      "speed": 1.2571641206741333,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:36:59.699749",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.793718",
      "longitude": "90.4045497",
      "accuracy": 26.92300033569336,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 158.64781188964844,
      "speed": 1.5376111268997192,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:38:55.829079",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.79374",
      "longitude": "90.4045613",
      "accuracy": 20.39299964904785,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 310.39190673828125,
      "speed": 0.39579981565475464,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:40:03.137970",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937756",
      "longitude": "90.4045367",
      "accuracy": 19.121000289916992,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 347.2776184082031,
      "speed": 0.20071427524089813,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:41:59.443427",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.793781",
      "longitude": "90.4045283",
      "accuracy": 15.333999633789062,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 323.4021911621094,
      "speed": 1.229228138923645,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:43:06.984236",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937412",
      "longitude": "90.4045568",
      "accuracy": 12.743000030517578,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 267.88958740234375,
      "speed": 0.2193380445241928,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:45:03.492987",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937619",
      "longitude": "90.4045676",
      "accuracy": 19.13599967956543,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 355.0057678222656,
      "speed": 1.1547250747680664,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:46:10.794549",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937423",
      "longitude": "90.4045661",
      "accuracy": 18.902999877929688,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 139.84393310546875,
      "speed": 0.28340837359428406,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:48:07.406297",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937789",
      "longitude": "90.4045473",
      "accuracy": 15.362000465393066,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 334.5329284667969,
      "speed": 1.3420085906982422,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:49:14.814476",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937765",
      "longitude": "90.4045397",
      "accuracy": 16.665000915527344,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 344.58172607421875,
      "speed": 0.42588940262794495,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:51:11.104238",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937347",
      "longitude": "90.4045646",
      "accuracy": 12.310999870300293,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 145.34457397460938,
      "speed": 0.922319769859314,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:52:18.286567",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937697",
      "longitude": "90.4045457",
      "accuracy": 16.76099967956543,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 143.73614501953125,
      "speed": 0.5725743770599365,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:54:14.225253",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937774",
      "longitude": "90.4044792",
      "accuracy": 26.09600067138672,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 303.9300231933594,
      "speed": 1.1412841081619263,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:55:21.697112",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937419",
      "longitude": "90.4045844",
      "accuracy": 15.234999656677246,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 128.59933471679688,
      "speed": 0.24525101482868195,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:57:17.739251",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937822",
      "longitude": "90.4045511",
      "accuracy": 12.95199966430664,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 337.46392822265625,
      "speed": 1.2416679859161377,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 15:58:25.288087",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937264",
      "longitude": "90.4045693",
      "accuracy": 13.642999649047852,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 93.54219818115234,
      "speed": 0.3529861867427826,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:00:21.858735",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937308",
      "longitude": "90.404556",
      "accuracy": 13.762999534606934,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 338.4409484863281,
      "speed": 0.6689454317092896,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:01:29.493896",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937402",
      "longitude": "90.4045579",
      "accuracy": 13.116000175476074,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 153.874267578125,
      "speed": 0.23371665179729462,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:38:19.742511",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937029",
      "longitude": "90.4046125",
      "accuracy": 100.0,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 0.0,
      "speed": 0.0,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:41:22.738727",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.793762",
      "longitude": "90.4045356",
      "accuracy": 27.361000061035156,
      "altitude": 28.600000381469727,
      "altitudeAccuracy": "",
      "heading": 297.5794372558594,
      "speed": 0.29418712854385376,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:44:25.883642",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937602",
      "longitude": "90.4045787",
      "accuracy": 18.615999221801758,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 121.40380859375,
      "speed": 0.3132609724998474,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:47:28.577515",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937866",
      "longitude": "90.4045168",
      "accuracy": 14.52400016784668,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 130.44569396972656,
      "speed": 0.6094775199890137,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:50:31.840015",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7938044",
      "longitude": "90.4044545",
      "accuracy": 17.09000015258789,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 278.8493347167969,
      "speed": 0.5861616134643555,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:53:35.380804",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937977",
      "longitude": "90.4045056",
      "accuracy": 16.445999145507812,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 67.68529510498047,
      "speed": 0.4008368253707886,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:56:38.732602",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937747",
      "longitude": "90.4045363",
      "accuracy": 15.340999603271484,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 123.12374877929688,
      "speed": 0.8679903745651245,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 16:59:42.031132",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7938098",
      "longitude": "90.4044982",
      "accuracy": 15.039999961853027,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 321.5453186035156,
      "speed": 2.036003589630127,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:02:45.449808",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937664",
      "longitude": "90.4045271",
      "accuracy": 23.176000595092773,
      "altitude": 29.100000381469727,
      "altitudeAccuracy": "",
      "heading": 210.2021026611328,
      "speed": 0.4601050913333893,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:05:49.553262",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937311",
      "longitude": "90.4045699",
      "accuracy": 20.398000717163086,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 294.8773498535156,
      "speed": 0.8090713620185852,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:08:53.467140",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.793808",
      "longitude": "90.404453",
      "accuracy": 19.47100067138672,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 287.15191650390625,
      "speed": 1.3285802602767944,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:11:57.477964",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937652",
      "longitude": "90.4045704",
      "accuracy": 16.349000930786133,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 21.599349975585938,
      "speed": 0.30587708950042725,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:22:30.203691",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937421",
      "longitude": "90.4045789",
      "accuracy": 100.0,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 0.0,
      "speed": 0.0,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:25:34.610789",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937821",
      "longitude": "90.4045439",
      "accuracy": 14.501999855041504,
      "altitude": 29.0,
      "altitudeAccuracy": "",
      "heading": 291.6941833496094,
      "speed": 0.5819262862205505,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:31:01.611477",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937492",
      "longitude": "90.4045504",
      "accuracy": 12.199000358581543,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 353.690185546875,
      "speed": 0.7888555526733398,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:34:02.238155",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937248",
      "longitude": "90.4045519",
      "accuracy": 28.731000900268555,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 172.16244506835938,
      "speed": 0.4372892677783966,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:37:06.631750",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937394",
      "longitude": "90.4045415",
      "accuracy": 29.43199920654297,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 288.6180419921875,
      "speed": 0.4957827925682068,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:40:10.333831",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937215",
      "longitude": "90.4045544",
      "accuracy": 19.200000762939453,
      "altitude": 28.5,
      "altitudeAccuracy": "",
      "heading": 190.17059326171875,
      "speed": 0.4182320237159729,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:43:12.690375",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937991",
      "longitude": "90.4044947",
      "accuracy": 17.819000244140625,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 276.3432312011719,
      "speed": 0.5715140104293823,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:46:16.074395",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937683",
      "longitude": "90.404546",
      "accuracy": 19.531999588012695,
      "altitude": 29.600000381469727,
      "altitudeAccuracy": "",
      "heading": 145.44894409179688,
      "speed": 0.4685799777507782,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:49:19.795500",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7938234",
      "longitude": "90.4044212",
      "accuracy": 18.277000427246094,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 298.7890625,
      "speed": 2.12319278717041,
      "internet_speed": "",
      "connection_type": ""
    },
    {
      "sbu_id": "[54]",
      "date": "2026-04-19",
      "pin_date_time": "2026-04-19 17:52:21.483401",
      "ff_id": 1765,
      "dep_id": null,
      "section_id": null,
      "latitude": "23.7937575",
      "longitude": "90.4045431",
      "accuracy": 17.481000900268555,
      "altitude": 29.400001525878906,
      "altitudeAccuracy": "",
      "heading": 135.97396850585938,
      "speed": 1.5727273225784302,
      "internet_speed": "",
      "connection_type": ""
    }
  ],
  "taDa-data": {
    "remarks": "ggggh",
    "submitted": false,
    "sales_date": "2026-04-19",
    "da_info": {
      "survey_type": "outlet",
      "point_id": 167,
      "section_id": 213,
      "allowance_type": "EX-HQ",
      "amount": 700.0,
      "sales_date": "2026-04-19"
    },
    "ta_rows": [
      {
        "identity": "1776587889987954",
        "vehicle_id": 198,
        "vehicle_slug": "CNG",
        "from": "Banani",
        "to": "Mirpur",
        "km": "9",
        "amount": "320",
        "remarks": ""
      }
    ]
  },
  "attendance_configuration": {
    "mandatory_attendance": 1,
    "check_in": 0
  }
};
