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
  "date": "2026-02-15",
  "logged_in": 1,
  "userData": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjI4LCJ1c2VyVHlwZUlkIjo0MSwiZW1haWwiOiJhYnUuc2FsZWhAZ21haWwuY29tIiwic2J1X2lkIjoiWzU0XSIsImlhdCI6MTc3MTEyOTI3NywiZXhwIjoxMDAxNzcxMTIyMzk3fQ.dZ4FRerjfEs2QtY0G_7BYxqQtwxXDNKztX1WiPrnbWc",
    "refreshToken": "JgQKUCyedILBJCNs",
    "ff_id": 228,
    "sbu_id": "[54]",
    "dep_id": 167,
    "email": "abu.saleh@gmail.com",
    "contact_no": "01584163560",
    "nid": "1234567890123",
    "birth_certificate_no": "12345678901234567",
    "employee_id": "asr-2319249",
    "referrer_id": null,
    "employment_status": "on_notice",
    "is_permanent": 0,
    "visiting_frequency": "2",
    "user_type": 41,
    "status": 1,
    "username": "01584163560",
    "password": "123",
    "fullname": "Abu Saleh",
    "sr_route": "Kakoli (Kakoli_Route)",
    "distribution_house_id": 420,
    "distribution_house_name": "Satkhira",
    "wpf": 0,
    "point_name": "KOLAROA",
    "point_contact_no": "8801716169154",
    "company_name": "Agami Limited",
    "section_id": 202
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/ord-101132/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/15/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "nid": "1234567895",
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/SA-123445/outlet_cover_image.jpg",
      "lat": 23.7936343,
      "long": 90.4045739,
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
      "available_surveys": [
        533,
        534,
        537
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/99898/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/K-1234/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 9,
          "discount_val": 2,
          "cap_val": null
        },
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
      "available_surveys": [
        533,
        534,
        537
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/M-1234/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
      "available_surveys": [
        533,
        534,
        537
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228210126-002/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228220126-002/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228220126-003/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228220126-004/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228220126-002/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228220126-005/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228250126-002/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228250126-006/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228250126-007/outlet_cover_image.jpg",
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
        "cooler_photo_url": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228250126-007/outlet_cooler_image.jpg",
        "business_type": {
          "id": 45,
          "slug": "Wholesale"
        },
        "channel_category": {
          "id": 51,
          "slug": "Platinum"
        }
      },
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228260126-003/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228280126-005/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228280126-002/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": null,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228280126-003/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": 499,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-009/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": 500,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-010/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": 46063,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-011/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": 46065,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-012/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": 46070,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-013/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-017/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-018/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-019/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-020/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228290126-021/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228020226-002/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228020226-003/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228020226-004/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228030226-002/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228030226-002/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228030226-003/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228050226-003/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228050226-004/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228050226-005/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228050226-006/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
      "available_surveys": []
    },
    {
      "id": 1475,
      "outlet_name": "Jabbar",
      "outlet_name_bn": "Jabbar",
      "outlet_code": "R-228228050226-007",
      "owner": "Jabbar",
      "contact": "01558326523",
      "approval_status": "PENDING",
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228050226-007/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/OLM-8190525-003/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/1234/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
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
      "section_id": 202,
      "cluster_id": 498,
      "qc_price_group": 3,
      "outlet_cover_photo": "http://192.168.20.16:2080/app-api/static-file/retailer/R-228228080226-002/outlet_cover_image.jpg",
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
      "available_promotions": [
        {
          "id": 65,
          "discount_val": 5,
          "cap_val": null
        },
        {
          "id": 66,
          "discount_val": 4,
          "cap_val": null
        }
      ],
      "available_try_before_you_buy": [],
      "available_qps_promotions": [],
      "available_surveys": []
    }
  ],
  "clusters": [
    {
      "id": 498,
      "cluster_type_id": 160,
      "dep_id": 167,
      "slug": "Dolphin Goli"
    },
    {
      "id": 499,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Lake Circus"
    },
    {
      "id": 500,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Boshir Uddin Road"
    },
    {
      "id": 46063,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "M More"
    },
    {
      "id": 46064,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Sonali Biri"
    },
    {
      "id": 46065,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mouchak More"
    },
    {
      "id": 46066,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Shatbaria More"
    },
    {
      "id": 46067,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Char Rastar More"
    },
    {
      "id": 46068,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Poshu Haat"
    },
    {
      "id": 46069,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Dhorompur"
    },
    {
      "id": 46070,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Dhorompur Bazar"
    },
    {
      "id": 46072,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Joggesshor Bazar"
    },
    {
      "id": 46073,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bottola"
    },
    {
      "id": 46074,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Karigorpara"
    },
    {
      "id": 46075,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Porankhali"
    },
    {
      "id": 46076,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Station bazar"
    },
    {
      "id": 46077,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "C bazar"
    },
    {
      "id": 46079,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Sono Bazar Mor"
    },
    {
      "id": 46081,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Pouro market"
    },
    {
      "id": 46082,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Dak bangla"
    },
    {
      "id": 46084,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mosjid Mor"
    },
    {
      "id": 46085,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Godaun mor"
    },
    {
      "id": 46086,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Hall bazar"
    },
    {
      "id": 46087,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bahadurpur"
    },
    {
      "id": 46088,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Kuchiamura"
    },
    {
      "id": 46089,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Notun Haat"
    },
    {
      "id": 46090,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Sentar More"
    },
    {
      "id": 46091,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Golap Nogar"
    },
    {
      "id": 46092,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kilik More"
    },
    {
      "id": 46093,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "H More"
    },
    {
      "id": 46095,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Jatri Sawni"
    },
    {
      "id": 46096,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Oill pamp"
    },
    {
      "id": 46098,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Coach stand"
    },
    {
      "id": 46099,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Pourosova Mor"
    },
    {
      "id": 46100,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Tempu Stand"
    },
    {
      "id": 46106,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kachari Para"
    },
    {
      "id": 46108,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "South Rail Gate"
    },
    {
      "id": 46109,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "4 Raster More"
    },
    {
      "id": 46110,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Chand Gram"
    },
    {
      "id": 46111,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Chondipur"
    },
    {
      "id": 46112,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kharara"
    },
    {
      "id": 46115,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Ferot Mor"
    },
    {
      "id": 46117,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Rubel More"
    },
    {
      "id": 46118,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Loridiar"
    },
    {
      "id": 46119,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Fozipur"
    },
    {
      "id": 46121,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Boria"
    },
    {
      "id": 46122,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "MohisaKhola"
    },
    {
      "id": 46123,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Shatgacha"
    },
    {
      "id": 46124,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Foizullapur"
    },
    {
      "id": 46125,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Raita Bottola"
    },
    {
      "id": 46126,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Raita Pathor ghat"
    },
    {
      "id": 46127,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Raita S Bazar"
    },
    {
      "id": 46128,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Raita Station"
    },
    {
      "id": 46129,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Arkandi"
    },
    {
      "id": 46131,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Farukpur Relgate"
    },
    {
      "id": 46132,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Shamur More"
    },
    {
      "id": 46133,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Soner More"
    },
    {
      "id": 46134,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Rjur More"
    },
    {
      "id": 46136,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Moslempur"
    },
    {
      "id": 46137,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Moslempur Balirmath"
    },
    {
      "id": 46140,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Pamp House"
    },
    {
      "id": 46142,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Vanggapul"
    },
    {
      "id": 46143,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Kamalpur"
    },
    {
      "id": 46144,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Vita"
    },
    {
      "id": 46146,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Nohir More"
    },
    {
      "id": 46147,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mirzapur"
    },
    {
      "id": 46148,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Dontuya"
    },
    {
      "id": 46151,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Jaker Bari"
    },
    {
      "id": 46152,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Kaji Hata"
    },
    {
      "id": 46153,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Moniadora"
    },
    {
      "id": 46154,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Nasir Nagar"
    },
    {
      "id": 46155,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Uttar Varotipur"
    },
    {
      "id": 46156,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Khemirdia"
    },
    {
      "id": 46157,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Somiti More"
    },
    {
      "id": 46158,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Musarafpur"
    },
    {
      "id": 46159,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Jogossar"
    },
    {
      "id": 46160,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Fokirabad"
    },
    {
      "id": 46161,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mazar"
    },
    {
      "id": 46163,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Sorupeghope"
    },
    {
      "id": 46166,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Hosen Pur"
    },
    {
      "id": 46172,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bamonpara"
    },
    {
      "id": 46176,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bittepara"
    },
    {
      "id": 46177,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Shatbari Mathpara"
    },
    {
      "id": 46178,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Shatbari Dokkhinpara"
    },
    {
      "id": 46180,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Muslimpara"
    },
    {
      "id": 46184,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Munshi Para"
    },
    {
      "id": 46186,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "3 No. Bridge"
    },
    {
      "id": 46188,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Munshi Oahedpur"
    },
    {
      "id": 46191,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Shatbari Gorosthan Para"
    },
    {
      "id": 46192,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Baggari Pul"
    },
    {
      "id": 46194,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Islampur Gate"
    },
    {
      "id": 46195,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bangal Para"
    },
    {
      "id": 46196,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Dhaka Chor"
    },
    {
      "id": 46198,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Somotir Mor"
    },
    {
      "id": 46199,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Chor Damukdia"
    },
    {
      "id": 46200,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Damukdia"
    },
    {
      "id": 46201,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Satbaria Club"
    },
    {
      "id": 46202,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Sat Bari"
    },
    {
      "id": 46203,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Uttor Vobanipur EID Gah"
    },
    {
      "id": 46204,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Dhorompur Purbopara"
    },
    {
      "id": 61144,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Fire Service More"
    },
    {
      "id": 94291,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "11 Mile"
    },
    {
      "id": 94292,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "10 Mile"
    },
    {
      "id": 94293,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "12 Mile"
    },
    {
      "id": 94570,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "C Bazar"
    },
    {
      "id": 94572,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Moddho Bazar"
    },
    {
      "id": 94573,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "JSD office"
    },
    {
      "id": 94574,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "S More"
    },
    {
      "id": 94575,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Bangir More"
    },
    {
      "id": 94576,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Centre More"
    },
    {
      "id": 94577,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Balurghat"
    },
    {
      "id": 94578,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Dhaka Coach Stand"
    },
    {
      "id": 94579,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Platform"
    },
    {
      "id": 94580,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Makkro Streen"
    },
    {
      "id": 94581,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Mazar Road"
    },
    {
      "id": 94582,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Choytonna More"
    },
    {
      "id": 94583,
      "cluster_type_id": 160,
      "dep_id": 167,
      "slug": "Bus Stand"
    },
    {
      "id": 94584,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "C More"
    },
    {
      "id": 94585,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Lozen More"
    },
    {
      "id": 94587,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "6 No. Bridge"
    },
    {
      "id": 94592,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Farukpur"
    },
    {
      "id": 94594,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Sonar More"
    },
    {
      "id": 94596,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Dolua Bazar"
    },
    {
      "id": 94598,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Daskin Vobanipur"
    },
    {
      "id": 94599,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Golap Nagor Mazar"
    },
    {
      "id": 94604,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Moslempur Pump"
    },
    {
      "id": 122095,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bhera Pan Bazar"
    },
    {
      "id": 122096,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bhera Katherpul"
    },
    {
      "id": 122097,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bherakudalipara"
    },
    {
      "id": 122098,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bhera Bittepara"
    },
    {
      "id": 122099,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bhechoitonno More"
    },
    {
      "id": 122100,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Juniadaha"
    },
    {
      "id": 139526,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Indra More"
    },
    {
      "id": 139528,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Gurer Para"
    },
    {
      "id": 139531,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Nowda Boholbari"
    },
    {
      "id": 139533,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Doctor More"
    },
    {
      "id": 139535,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kazipur Moddo Para"
    },
    {
      "id": 139536,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kazipur Britti Para"
    },
    {
      "id": 139540,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Lolua"
    },
    {
      "id": 139542,
      "cluster_type_id": 160,
      "dep_id": 167,
      "slug": "Fakirpara"
    },
    {
      "id": 139544,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kastom"
    },
    {
      "id": 139545,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Joypur"
    },
    {
      "id": 139827,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "7 Baria"
    },
    {
      "id": 139828,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Farakpur Rail Gate"
    },
    {
      "id": 139829,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kazihata"
    },
    {
      "id": 139832,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mos Pamp House"
    },
    {
      "id": 197936,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "M Mor (Bhera)"
    },
    {
      "id": 197937,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Joggesshor Bridge"
    },
    {
      "id": 197938,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Thanar Mor (Bhera)"
    },
    {
      "id": 197939,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Jasod Office Mor"
    },
    {
      "id": 197940,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Chashi Club"
    },
    {
      "id": 197941,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "1 No Bridge"
    },
    {
      "id": 197942,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Katherpul"
    },
    {
      "id": 197943,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kudalipara"
    },
    {
      "id": 197944,
      "cluster_type_id": 160,
      "dep_id": 167,
      "slug": "Bheramara Bus Stand"
    },
    {
      "id": 197945,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Baradi Bazar"
    },
    {
      "id": 197946,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Upozila More (Bhera)"
    },
    {
      "id": 197947,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Allahr Dorga High S"
    },
    {
      "id": 197948,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Ektarpur"
    },
    {
      "id": 197949,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "12 Mile Bus Stand"
    },
    {
      "id": 198014,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "4 No Bridge"
    },
    {
      "id": 200835,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kather Pul"
    },
    {
      "id": 200836,
      "cluster_type_id": 160,
      "dep_id": 167,
      "slug": "Ronopia"
    },
    {
      "id": 200838,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kudalia Para"
    },
    {
      "id": 210248,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Satbaria"
    },
    {
      "id": 210249,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Char Raster More"
    },
    {
      "id": 210250,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Poshu Hat"
    },
    {
      "id": 210251,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Jogossor"
    },
    {
      "id": 210252,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Jogossor Bridge"
    },
    {
      "id": 210253,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Poran Khali"
    },
    {
      "id": 210254,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Manik Para"
    },
    {
      "id": 210255,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Godown More"
    },
    {
      "id": 210257,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Notun Hat"
    },
    {
      "id": 210258,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Golapnagor"
    },
    {
      "id": 210259,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Jattri Souney"
    },
    {
      "id": 210260,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Choitnno More"
    },
    {
      "id": 210261,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kather Pole"
    },
    {
      "id": 210262,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mazar More"
    },
    {
      "id": 210263,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kodalia Para"
    },
    {
      "id": 210264,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "C Gate"
    },
    {
      "id": 210265,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Dokkin Rail Gate"
    },
    {
      "id": 210266,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "4No. Bridge"
    },
    {
      "id": 210267,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Baradi"
    },
    {
      "id": 210268,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Firot More"
    },
    {
      "id": 210269,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Robelar More"
    },
    {
      "id": 210270,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mijan More"
    },
    {
      "id": 210271,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Boria Bazar"
    },
    {
      "id": 210272,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Gasia Doulotpur"
    },
    {
      "id": 210273,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Raita"
    },
    {
      "id": 210274,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Horipur"
    },
    {
      "id": 210275,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Upazila More"
    },
    {
      "id": 210276,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Farakpur Railgate"
    },
    {
      "id": 210277,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Samur More"
    },
    {
      "id": 210278,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Nolua Bazar"
    },
    {
      "id": 210279,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mirzapur Bazar"
    },
    {
      "id": 210280,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Nahir More"
    },
    {
      "id": 210281,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Juniadoha"
    },
    {
      "id": 210282,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Ronopia Bazar"
    },
    {
      "id": 210283,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mohisadora"
    },
    {
      "id": 210284,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Nasir Nagor"
    },
    {
      "id": 210285,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Professor Para"
    },
    {
      "id": 210286,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Khemirdiar"
    },
    {
      "id": 210287,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Moulahabaspur"
    },
    {
      "id": 210288,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Somitirmore"
    },
    {
      "id": 210289,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Vanga Pul"
    },
    {
      "id": 210290,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Senur Gate"
    },
    {
      "id": 210291,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Khat Mill"
    },
    {
      "id": 210292,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Baka Pul"
    },
    {
      "id": 210293,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Gm Gate"
    },
    {
      "id": 210294,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Taltola"
    },
    {
      "id": 210295,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Jipani Pul"
    },
    {
      "id": 210296,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Shatbari"
    },
    {
      "id": 231230,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Patoaronde"
    },
    {
      "id": 280784,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "T \u0026 T Road"
    },
    {
      "id": 280785,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Chermen Mor"
    },
    {
      "id": 280786,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Collage Mor"
    },
    {
      "id": 280787,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Golap Nogar Bazar"
    },
    {
      "id": 280788,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Eyaeya Park"
    },
    {
      "id": 280789,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Bamonpara Chermen Mor"
    },
    {
      "id": 280790,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Allhera Mor"
    },
    {
      "id": 282607,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "M P Bazar"
    },
    {
      "id": 282608,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Moshjid Goli"
    },
    {
      "id": 282609,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Golap Nogor Bazar"
    },
    {
      "id": 282610,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "School Bazar"
    },
    {
      "id": 282611,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Mazarroad"
    },
    {
      "id": 282612,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Golap Bazar"
    },
    {
      "id": 282613,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kuchiamura Bazar"
    },
    {
      "id": 282614,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Colloge More"
    },
    {
      "id": 282615,
      "cluster_type_id": 157,
      "dep_id": 167,
      "slug": "Kuchiamura Posuhut"
    },
    {
      "id": 282616,
      "cluster_type_id": 160,
      "dep_id": 167,
      "slug": "Khacha Bazar"
    },
    {
      "id": 282617,
      "cluster_type_id": 160,
      "dep_id": 167,
      "slug": "Rail Bazar"
    },
    {
      "id": 282618,
      "cluster_type_id": 178,
      "dep_id": 167,
      "slug": "Kuchiamora Posuhut"
    }
  ],
  "transport_types": [
    {
      "id": 349,
      "sbu_id": "0",
      "parent": 348,
      "type": 0,
      "display_label": "Van",
      "slug": "Van",
      "status": 1,
      "sort": "1.00",
      "created_by": null,
      "updated_by": null,
      "created_at": "2025-12-04T10:48:35.000Z",
      "updated_at": "2025-12-04T10:48:46.000Z"
    },
    {
      "id": 350,
      "sbu_id": "0",
      "parent": 348,
      "type": 0,
      "display_label": "Bike",
      "slug": "Bike",
      "status": 1,
      "sort": "2.00",
      "created_by": null,
      "updated_by": null,
      "created_at": "2025-12-04T10:48:45.000Z",
      "updated_at": "2026-01-21T04:59:29.000Z"
    }
  ],
  "fare_charts": [
    {
      "id": 2,
      "dep_id": 171,
      "route_id": 40,
      "section_id": 202,
      "cluster_id_from": 499,
      "cluster_id_to": 500,
      "distance_in_km": 15,
      "transport_category_id": 349,
      "fare_in_amount": 20,
      "category_slug": "Van"
    },
    {
      "id": 3,
      "dep_id": 171,
      "route_id": 40,
      "section_id": 202,
      "cluster_id_from": 500,
      "cluster_id_to": 501,
      "distance_in_km": 12,
      "transport_category_id": 349,
      "fare_in_amount": 25,
      "category_slug": "Van"
    },
    {
      "id": 4,
      "dep_id": 171,
      "route_id": 40,
      "section_id": 202,
      "cluster_id_from": 500,
      "cluster_id_to": 46063,
      "distance_in_km": 5,
      "transport_category_id": 349,
      "fare_in_amount": 10,
      "category_slug": "Van"
    },
    {
      "id": 5,
      "dep_id": 171,
      "route_id": 40,
      "section_id": 202,
      "cluster_id_from": 46063,
      "cluster_id_to": 46064,
      "distance_in_km": 20,
      "transport_category_id": 349,
      "fare_in_amount": 40,
      "category_slug": "Van"
    },
    {
      "id": 6,
      "dep_id": 171,
      "route_id": 40,
      "section_id": 202,
      "cluster_id_from": 46064,
      "cluster_id_to": 46065,
      "distance_in_km": 20,
      "transport_category_id": 349,
      "fare_in_amount": 40,
      "category_slug": "Van"
    },
    {
      "id": 7,
      "dep_id": 171,
      "route_id": 40,
      "section_id": 202,
      "cluster_id_from": 46065,
      "cluster_id_to": 46066,
      "distance_in_km": 20,
      "transport_category_id": 349,
      "fare_in_amount": 40,
      "category_slug": "Van"
    },
    {
      "id": 8,
      "dep_id": 171,
      "route_id": 40,
      "section_id": 202,
      "cluster_id_from": 46067,
      "cluster_id_to": 46068,
      "distance_in_km": 20,
      "transport_category_id": 349,
      "fare_in_amount": 40,
      "category_slug": "Van"
    },
    {
      "id": 9,
      "dep_id": 171,
      "route_id": 40,
      "section_id": 202,
      "cluster_id_from": 46068,
      "cluster_id_to": 46069,
      "distance_in_km": 20,
      "transport_category_id": 349,
      "fare_in_amount": 40,
      "category_slug": "Van"
    },
    {
      "id": 200,
      "dep_id": 171,
      "route_id": 40,
      "section_id": 202,
      "cluster_id_from": 498,
      "cluster_id_to": 499,
      "distance_in_km": 15,
      "transport_category_id": 349,
      "fare_in_amount": 20,
      "category_slug": "Van"
    },
    {
      "id": 245,
      "dep_id": 167,
      "route_id": 34,
      "section_id": 202,
      "cluster_id_from": 498,
      "cluster_id_to": 499,
      "distance_in_km": 1,
      "transport_category_id": 349,
      "fare_in_amount": 111,
      "category_slug": "Van"
    }
  ],
  "notifications": [],
  "resignation_notice_days": 30,
  "product_classification_types": [
    {
      "id": 13,
      "name": "MANDATORY"
    },
    {
      "id": 14,
      "name": "FOCUSED"
    },
    {
      "id": 15,
      "name": "OTHERS"
    },
    {
      "id": 47,
      "name": "Classification_Type_1"
    }
  ],
  "outlet_onboarding_configurations": {
    "available_onboarding_buttons": {
      "new_outlet": 1,
      "inactive_outlet": 0,
      "modify_outlet": 1
    },
    "business_types": [
      {
        "id": 45,
        "slug": "Wholesale"
      },
      {
        "id": 46,
        "slug": "Supershop"
      },
      {
        "id": 47,
        "slug": "Grocery"
      },
      {
        "id": 48,
        "slug": "Tong"
      },
      {
        "id": 49,
        "slug": "Pharma"
      },
      {
        "id": 50,
        "slug": "Departmental"
      },
      {
        "id": 107,
        "slug": "HORECA"
      },
      {
        "id": 108,
        "slug": "Confectionary"
      },
      {
        "id": 110,
        "slug": "Community Center"
      }
    ],
    "channel_categories": [
      {
        "id": 51,
        "slug": "Platinum"
      },
      {
        "id": 52,
        "slug": "Gold"
      },
      {
        "id": 53,
        "slug": "Silver"
      },
      {
        "id": 54,
        "slug": "Bronze"
      },
      {
        "id": 111,
        "slug": "Blue"
      }
    ],
    "coolers": [
      {
        "id": 57,
        "slug": "AFBL"
      },
      {
        "id": 58,
        "slug": "Pepsi"
      },
      {
        "id": 59,
        "slug": "Pran"
      },
      {
        "id": 60,
        "slug": "Coke"
      },
      {
        "id": 61,
        "slug": "Own"
      },
      {
        "id": 62,
        "slug": "Others"
      }
    ]
  },
  "dashboard_button": {
    "pre_order_button": 1,
    "delivery": 1,
    "memo": 1,
    "attendance": 1,
    "summary": 1,
    "asset": 1,
    "route_change": 1,
    "sync": 1,
    "leave_management": 1,
    "outlet": 1,
    "tsm": 0,
    "sales_entry": 1,
    "ro": 0,
    "approval_asset": 0,
    "maintenance": 0,
    "bill": 0,
    "digital_learning": 1,
    "pjp_plan": 0,
    "allowance": 1,
    "promotion": 1,
    "web_panel": 0,
    "stock": 1,
    "spot_sale": 1,
    "resignation": 1,
    "taDa": 1
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
  "cats": {
    "54": {
      "9": {
        "38": {
          "id": 38,
          "name": "Biscuits",
          "short_name": "Biscuits",
          "parent_id": 0
        }
      },
      "10": {
        "81": {
          "id": 81,
          "name": "Energy Plus",
          "short_name": "Energy",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 17,
          "uom_type_default": 120,
          "file_url": "olympic/81.png",
          "pack_size_value": 1,
          "pack_size_cases": 4,
          "sort": 1,
          "created_at": "2025-12-25T12:26:52.000Z",
          "uom_parent_id": 4,
          "filter_type": "Classification_Type_1",
          "unit_config": {
            "4": 1,
            "17": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "82": {
          "id": 82,
          "name": "Lemon Cream",
          "short_name": "Lemon",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 17,
          "uom_type_default": 120,
          "file_url": "olympic/82.png",
          "pack_size_value": 1,
          "pack_size_cases": 6,
          "sort": 1,
          "created_at": "2025-06-18T12:42:58.000Z",
          "uom_parent_id": 4,
          "filter_type": "OTHERS",
          "unit_config": {
            "4": 1,
            "17": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "83": {
          "id": 83,
          "name": "Nutty",
          "short_name": "Nutty",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 219,
          "uom_type_default": 120,
          "file_url": "olympic/83.png",
          "pack_size_value": 1,
          "pack_size_cases": 16,
          "sort": 1,
          "created_at": "2025-06-19T09:46:56.000Z",
          "uom_parent_id": 4,
          "filter_type": "Classification_Type_1",
          "unit_config": {
            "4": 1,
            "219": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "84": {
          "id": 84,
          "name": "First Choice",
          "short_name": "Choice",
          "parent_id": 38,
          "sales_enable": 0,
          "type": 10,
          "uom_type": 17,
          "uom_type_default": 120,
          "file_url": "olympic/84.png",
          "pack_size_value": 1,
          "pack_size_cases": 6,
          "sort": 1,
          "created_at": "2025-06-19T10:22:09.000Z",
          "uom_parent_id": 4,
          "filter_type": "OTHERS",
          "unit_config": {
            "4": 1,
            "17": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "92": {
          "id": 92,
          "name": "Saltes",
          "short_name": "Salt",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 17,
          "uom_type_default": 120,
          "file_url": "",
          "pack_size_value": 1,
          "pack_size_cases": 1,
          "sort": 1,
          "created_at": "2025-06-25T07:05:01.000Z",
          "uom_parent_id": 4,
          "filter_type": "FOCUSED",
          "unit_config": {
            "4": 1,
            "17": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "93": {
          "id": 93,
          "name": "Digestive",
          "short_name": "Digestive",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 17,
          "uom_type_default": 120,
          "file_url": "",
          "pack_size_value": 1,
          "pack_size_cases": 4,
          "sort": 1,
          "created_at": "2025-06-29T11:59:03.000Z",
          "uom_parent_id": 4,
          "filter_type": "FOCUSED",
          "unit_config": {
            "4": 1,
            "17": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "94": {
          "id": 94,
          "name": "Pineapple Cream",
          "short_name": "Pineapple",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 17,
          "uom_type_default": 120,
          "file_url": "",
          "pack_size_value": 1,
          "pack_size_cases": 6,
          "sort": 1,
          "created_at": "2025-06-30T06:37:38.000Z",
          "uom_parent_id": 4,
          "filter_type": "FOCUSED",
          "unit_config": {
            "4": 1,
            "17": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "112": {
          "id": 112,
          "name": "Tip",
          "short_name": "Tip",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 166,
          "uom_type_default": 120,
          "file_url": "",
          "pack_size_value": null,
          "pack_size_cases": 6,
          "sort": 1,
          "created_at": null,
          "uom_parent_id": 2,
          "filter_type": "Classification_Type_1",
          "unit_config": {
            "2": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "113": {
          "id": 113,
          "name": "Tim Tim",
          "short_name": "TT_01",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 11,
          "uom_type_default": 120,
          "file_url": "",
          "pack_size_value": null,
          "pack_size_cases": 6,
          "sort": 2,
          "created_at": null,
          "uom_parent_id": 2,
          "filter_type": "FOCUSED",
          "unit_config": {
            "2": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "114": {
          "id": 114,
          "name": "Oreno",
          "short_name": "OR_01",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 166,
          "uom_type_default": 120,
          "file_url": "olympic/114.png",
          "pack_size_value": null,
          "pack_size_cases": 6,
          "sort": 1,
          "created_at": null,
          "uom_parent_id": 2,
          "filter_type": "Classification_Type_1",
          "unit_config": {
            "2": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        },
        "115": {
          "id": 115,
          "name": "Amoxicillin 20mg Capsule",
          "short_name": "SKU0022",
          "parent_id": 38,
          "sales_enable": 1,
          "type": 10,
          "uom_type": 11,
          "uom_type_default": 11,
          "file_url": "",
          "pack_size_value": null,
          "pack_size_cases": 6,
          "sort": 2,
          "created_at": null,
          "uom_parent_id": 2,
          "filter_type": "FOCUSED",
          "unit_config": {
            "2": 1
          },
          "parents": {
            "9": 38
          },
          "isSKUNew": false
        }
      }
    }
  },
  "stock": {
    "Sun": {
      "81": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 81,
        "sales_enable": 1
      },
      "82": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 82,
        "sales_enable": 1
      },
      "83": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 83,
        "sales_enable": 1
      },
      "84": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 84,
        "sales_enable": 0
      },
      "92": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 92,
        "sales_enable": 1
      },
      "93": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 93,
        "sales_enable": 1
      },
      "94": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 94,
        "sales_enable": 1
      },
      "112": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 112,
        "sales_enable": 1
      },
      "113": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 113,
        "sales_enable": 1
      },
      "114": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 114,
        "sales_enable": 1
      },
      "115": {
        "lifting_stock": 0,
        "current_stock": 0,
        "sbu_id": "54",
        "id": 115,
        "sales_enable": 1
      }
    }
  },
  "price_group": {
    "1": {
      "81": {
        "id": 81,
        "base_price": "18.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "82": {
        "id": 82,
        "base_price": "15.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "83": {
        "id": 83,
        "base_price": "15.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "84": {
        "id": 84,
        "base_price": "20.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "92": {
        "id": 92,
        "base_price": "50.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "93": {
        "id": 93,
        "base_price": "30.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "94": {
        "id": 94,
        "base_price": "15.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "112": {
        "id": 112,
        "base_price": "12.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "113": {
        "id": 113,
        "base_price": "12.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "114": {
        "id": 114,
        "base_price": "12.00000",
        "price_group_id": 1,
        "sbu_id": 54
      },
      "115": {
        "id": 115,
        "base_price": "18.00000",
        "price_group_id": 1,
        "sbu_id": 54
      }
    },
    "2": {
      "81": {
        "id": 81,
        "base_price": "20.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "82": {
        "id": 82,
        "base_price": "15.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "83": {
        "id": 83,
        "base_price": "15.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "84": {
        "id": 84,
        "base_price": "20.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "92": {
        "id": 92,
        "base_price": "50.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "93": {
        "id": 93,
        "base_price": "30.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "94": {
        "id": 94,
        "base_price": "15.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "112": {
        "id": 112,
        "base_price": "11.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "113": {
        "id": 113,
        "base_price": "11.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "114": {
        "id": 114,
        "base_price": "11.00000",
        "price_group_id": 2,
        "sbu_id": 54
      },
      "115": {
        "id": 115,
        "base_price": "19.99000",
        "price_group_id": 2,
        "sbu_id": 54
      }
    },
    "3": {
      "81": {
        "id": 81,
        "base_price": "16.00000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "82": {
        "id": 82,
        "base_price": "13.00000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "83": {
        "id": 83,
        "base_price": "14.00000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "84": {
        "id": 84,
        "base_price": "18.50000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "92": {
        "id": 92,
        "base_price": "47.00000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "93": {
        "id": 93,
        "base_price": "29.00000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "94": {
        "id": 94,
        "base_price": "14.50000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "112": {
        "id": 112,
        "base_price": "10.00000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "113": {
        "id": 113,
        "base_price": "10.00000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "114": {
        "id": 114,
        "base_price": "10.00000",
        "price_group_id": 3,
        "sbu_id": 54
      },
      "115": {
        "id": 115,
        "base_price": "15.00000",
        "price_group_id": 3,
        "sbu_id": 54
      }
    }
  },
  "qc_info": {
    "54": [
      {
        "id": 97,
        "sbu_id": 54,
        "name": "Manufacturing Fault",
        "types": []
      },
      {
        "id": 108,
        "sbu_id": 54,
        "name": "Test QC Fault",
        "types": [
          {
            "id": 109,
            "parent": 108,
            "name": "Test Child QC Fault",
            "quantity": 0
          }
        ]
      }
    ]
  },
  "wom_configurations": {},
  "tutorial": [],
  "av_configurations": {},
  "preorder_configurations": {},
  "app_version_info": {
    "app_version": "1.0.0",
    "version_mandatory": 1
  },
  "app_version_configurations": {},
  "survey_details": {
    "survey_info": [
      {
        "id": 533,
        "name": "Report Testing Survey",
        "outlet_id": 152,
        "mandatory": 0
      },
      {
        "id": 534,
        "name": "My Survey 101",
        "outlet_id": 152,
        "mandatory": 0
      },
      {
        "id": 537,
        "name": "Test Survey 102",
        "outlet_id": 152,
        "mandatory": 0
      }
    ],
    "questions": {
      "533": [
        {
          "survey_id": 533,
          "question_id": 937,
          "question_type": "yes_no",
          "has_dependency": 1,
          "question_name": "Are you interest to play Q/A game?",
          "required": 0,
          "options": [
            {
              "answer_id": 525,
              "answer_name": "Yes",
              "question_id": 937,
              "dependency_question_id": 938,
              "survey_id": 533,
              "parent_id": 525
            },
            {
              "answer_id": 526,
              "answer_name": "No",
              "question_id": 937,
              "dependency_question_id": null,
              "survey_id": 533,
              "parent_id": 526
            }
          ],
          "dependent_questions": {
            "525": [
              {
                "survey_id": 533,
                "question_id": 938,
                "question_type": "yes_no",
                "has_dependency": 1,
                "question_name": "Start the game!!",
                "required": 0,
                "parent_id": 525,
                "options": [
                  {
                    "answer_id": 525,
                    "answer_name": "Yes",
                    "question_id": 938,
                    "dependency_question_id": 939,
                    "survey_id": 533,
                    "parent_id": 525
                  },
                  {
                    "answer_id": 526,
                    "answer_name": "No",
                    "question_id": 938,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 526
                  }
                ],
                "dependent_questions": {
                  "525": [
                    {
                      "survey_id": 533,
                      "question_id": 939,
                      "question_type": "multiselect",
                      "has_dependency": 1,
                      "question_name": "What is the capital of Japan?",
                      "required": 0,
                      "parent_id": 525,
                      "options": [
                        {
                          "answer_id": 508,
                          "answer_name": "Seoul",
                          "question_id": 939,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 508
                        },
                        {
                          "answer_id": 509,
                          "answer_name": "Tokyo",
                          "question_id": 939,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 509
                        },
                        {
                          "answer_id": 510,
                          "answer_name": "Bangkok",
                          "question_id": 939,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 510
                        },
                        {
                          "answer_id": 511,
                          "answer_name": "Beijing",
                          "question_id": 939,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 511
                        }
                      ],
                      "dependent_questions": {}
                    },
                    {
                      "survey_id": 533,
                      "question_id": 940,
                      "question_type": "multiselect",
                      "has_dependency": 1,
                      "question_name": "If you could have one superpower, what would it be?",
                      "required": 0,
                      "parent_id": 525,
                      "options": [
                        {
                          "answer_id": 512,
                          "answer_name": "Invisibility",
                          "question_id": 940,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 512
                        },
                        {
                          "answer_id": 513,
                          "answer_name": "Flying",
                          "question_id": 940,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 513
                        },
                        {
                          "answer_id": 514,
                          "answer_name": "Time travel",
                          "question_id": 940,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 514
                        },
                        {
                          "answer_id": 515,
                          "answer_name": "Reading minds",
                          "question_id": 940,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 515
                        }
                      ],
                      "dependent_questions": {}
                    },
                    {
                      "survey_id": 533,
                      "question_id": 941,
                      "question_type": "multiselect",
                      "has_dependency": 1,
                      "question_name": "Which of these words best describes your mindset today?",
                      "required": 0,
                      "parent_id": 525,
                      "options": [
                        {
                          "answer_id": 516,
                          "answer_name": "Curious",
                          "question_id": 941,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 516
                        },
                        {
                          "answer_id": 517,
                          "answer_name": "Calm",
                          "question_id": 941,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 517
                        },
                        {
                          "answer_id": 518,
                          "answer_name": "Energetic",
                          "question_id": 941,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 518
                        },
                        {
                          "answer_id": 519,
                          "answer_name": "Confused",
                          "question_id": 941,
                          "dependency_question_id": null,
                          "survey_id": 533,
                          "parent_id": 519
                        }
                      ],
                      "dependent_questions": {}
                    }
                  ]
                }
              }
            ]
          }
        },
        {
          "survey_id": 533,
          "question_id": 942,
          "question_type": "number",
          "has_dependency": 0,
          "question_name": "You see a locked door with a keypad. A note says ‘2, 4, 8, 16, ?’. What number comes next?",
          "required": 0,
          "options": [],
          "dependent_questions": {}
        },
        {
          "survey_id": 533,
          "question_id": 943,
          "question_type": "select",
          "has_dependency": 1,
          "question_name": "What is your favorite hobby or thing to do in your free time?",
          "required": 0,
          "options": [
            {
              "answer_id": 520,
              "answer_name": "music, drawing, writing, etc.",
              "question_id": 943,
              "dependency_question_id": 944,
              "survey_id": 533,
              "parent_id": 520
            },
            {
              "answer_id": 529,
              "answer_name": "watching movies, sleeping, etc.",
              "question_id": 943,
              "dependency_question_id": 946,
              "survey_id": 533,
              "parent_id": 529
            }
          ],
          "dependent_questions": {
            "520": [
              {
                "survey_id": 533,
                "question_id": 944,
                "question_type": "multiselect",
                "has_dependency": 1,
                "question_name": "How often do you practice or engage in this hobby?",
                "required": 0,
                "parent_id": 520,
                "options": [
                  {
                    "answer_id": 521,
                    "answer_name": "Every day",
                    "question_id": 944,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 521
                  },
                  {
                    "answer_id": 522,
                    "answer_name": "A few times a week",
                    "question_id": 944,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 522
                  },
                  {
                    "answer_id": 523,
                    "answer_name": "Occasionally",
                    "question_id": 944,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 523
                  },
                  {
                    "answer_id": 524,
                    "answer_name": "Rarely",
                    "question_id": 944,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 524
                  }
                ],
                "dependent_questions": {}
              },
              {
                "survey_id": 533,
                "question_id": 945,
                "question_type": "multiselect",
                "has_dependency": 1,
                "question_name": "Would you like to turn this hobby into a profession someday?",
                "required": 0,
                "parent_id": 520,
                "options": [
                  {
                    "answer_id": 525,
                    "answer_name": "Yes",
                    "question_id": 945,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 525
                  },
                  {
                    "answer_id": 526,
                    "answer_name": "No",
                    "question_id": 945,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 526
                  },
                  {
                    "answer_id": 527,
                    "answer_name": "Maybe",
                    "question_id": 945,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 527
                  },
                  {
                    "answer_id": 528,
                    "answer_name": "Already have",
                    "question_id": 945,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 528
                  }
                ],
                "dependent_questions": {}
              }
            ],
            "529": [
              {
                "survey_id": 533,
                "question_id": 946,
                "question_type": "multiselect",
                "has_dependency": 1,
                "question_name": "What kind of content do you enjoy most?",
                "required": 0,
                "parent_id": 529,
                "options": [
                  {
                    "answer_id": 530,
                    "answer_name": "Action \u0026 Adventure",
                    "question_id": 946,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 530
                  },
                  {
                    "answer_id": 531,
                    "answer_name": "Comedy \u0026 Lighthearted",
                    "question_id": 946,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 531
                  },
                  {
                    "answer_id": 532,
                    "answer_name": "Emotional \u0026 Romantic",
                    "question_id": 946,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 532
                  },
                  {
                    "answer_id": 533,
                    "answer_name": "Thriller \u0026 Mystery",
                    "question_id": 946,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 533
                  }
                ],
                "dependent_questions": {}
              },
              {
                "survey_id": 533,
                "question_id": 947,
                "question_type": "multiselect",
                "has_dependency": 1,
                "question_name": "Do you prefer enjoying this alone or with others?",
                "required": 0,
                "parent_id": 529,
                "options": [
                  {
                    "answer_id": 534,
                    "answer_name": "Alone",
                    "question_id": 947,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 534
                  },
                  {
                    "answer_id": 535,
                    "answer_name": "With family",
                    "question_id": 947,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 535
                  },
                  {
                    "answer_id": 536,
                    "answer_name": "With friends",
                    "question_id": 947,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 536
                  },
                  {
                    "answer_id": 537,
                    "answer_name": "Depends on the mood",
                    "question_id": 947,
                    "dependency_question_id": null,
                    "survey_id": 533,
                    "parent_id": 537
                  }
                ],
                "dependent_questions": {}
              }
            ]
          }
        },
        {
          "survey_id": 533,
          "question_id": 948,
          "question_type": "image",
          "has_dependency": 0,
          "question_name": "Capture a selfie of your reaction with this survey.",
          "required": 0,
          "options": [],
          "dependent_questions": {}
        },
        {
          "survey_id": 533,
          "question_id": 949,
          "question_type": "text",
          "has_dependency": 0,
          "question_name": "How do you feel after playing this game?",
          "required": 0,
          "options": [],
          "dependent_questions": {}
        }
      ],
      "534": [
        {
          "survey_id": 534,
          "question_id": 950,
          "question_type": "yes_no",
          "has_dependency": 1,
          "question_name": "Do you have interest in gaming?",
          "required": 1,
          "options": [
            {
              "answer_id": 525,
              "answer_name": "Yes",
              "question_id": 950,
              "dependency_question_id": 951,
              "survey_id": 534,
              "parent_id": 525
            },
            {
              "answer_id": 526,
              "answer_name": "No",
              "question_id": 950,
              "dependency_question_id": 956,
              "survey_id": 534,
              "parent_id": 526
            }
          ],
          "dependent_questions": {
            "525": [
              {
                "survey_id": 534,
                "question_id": 951,
                "question_type": "yes_no",
                "has_dependency": 1,
                "question_name": "Do you play PC games?",
                "required": 1,
                "parent_id": 525,
                "options": [
                  {
                    "answer_id": 525,
                    "answer_name": "Yes",
                    "question_id": 951,
                    "dependency_question_id": 952,
                    "survey_id": 534,
                    "parent_id": 525
                  },
                  {
                    "answer_id": 526,
                    "answer_name": "No",
                    "question_id": 951,
                    "dependency_question_id": 955,
                    "survey_id": 534,
                    "parent_id": 526
                  }
                ],
                "dependent_questions": {
                  "525": [
                    {
                      "survey_id": 534,
                      "question_id": 952,
                      "question_type": "select",
                      "has_dependency": 1,
                      "question_name": "What kind of games?",
                      "required": 1,
                      "parent_id": 525,
                      "options": [
                        {
                          "answer_id": 538,
                          "answer_name": "XBox",
                          "question_id": 952,
                          "dependency_question_id": 953,
                          "survey_id": 534,
                          "parent_id": 538
                        },
                        {
                          "answer_id": 539,
                          "answer_name": "PS5",
                          "question_id": 952,
                          "dependency_question_id": 953,
                          "survey_id": 534,
                          "parent_id": 539
                        }
                      ],
                      "dependent_questions": {
                        "538": [
                          {
                            "survey_id": 534,
                            "question_id": 953,
                            "question_type": "number",
                            "has_dependency": 0,
                            "question_name": "how many games?",
                            "required": 1,
                            "parent_id": 538,
                            "options": []
                          },
                          {
                            "survey_id": 534,
                            "question_id": 953,
                            "question_type": "number",
                            "has_dependency": 0,
                            "question_name": "how many games?",
                            "required": 1,
                            "parent_id": 538,
                            "options": []
                          },
                          {
                            "survey_id": 534,
                            "question_id": 954,
                            "question_type": "number",
                            "has_dependency": 0,
                            "question_name": "How many hours?",
                            "required": 1,
                            "parent_id": 538,
                            "options": []
                          },
                          {
                            "survey_id": 534,
                            "question_id": 954,
                            "question_type": "number",
                            "has_dependency": 0,
                            "question_name": "How many hours?",
                            "required": 1,
                            "parent_id": 538,
                            "options": []
                          }
                        ]
                      }
                    }
                  ],
                  "526": [
                    {
                      "survey_id": 534,
                      "question_id": 955,
                      "question_type": "text",
                      "has_dependency": 0,
                      "question_name": "What do you do then?",
                      "required": 1,
                      "parent_id": 526,
                      "options": []
                    }
                  ]
                }
              }
            ],
            "526": [
              {
                "survey_id": 534,
                "question_id": 956,
                "question_type": "text",
                "has_dependency": 0,
                "question_name": "what kind of interest do you have?",
                "required": 1,
                "parent_id": 526,
                "options": []
              }
            ]
          }
        }
      ],
      "537": [
        {
          "survey_id": 537,
          "question_id": 957,
          "question_type": "yes_no",
          "has_dependency": 1,
          "question_name": "Do like ciggereter",
          "required": 1,
          "options": [
            {
              "answer_id": 525,
              "answer_name": "Yes",
              "question_id": 957,
              "dependency_question_id": 958,
              "survey_id": 537,
              "parent_id": 525
            },
            {
              "answer_id": 526,
              "answer_name": "No",
              "question_id": 957,
              "dependency_question_id": 959,
              "survey_id": 537,
              "parent_id": 526
            }
          ],
          "dependent_questions": {
            "525": [
              {
                "survey_id": 537,
                "question_id": 958,
                "question_type": "number",
                "has_dependency": 0,
                "question_name": "how many a day?",
                "required": 1,
                "parent_id": 525,
                "options": []
              }
            ],
            "526": [
              {
                "survey_id": 537,
                "question_id": 959,
                "question_type": "text",
                "has_dependency": 0,
                "question_name": "What do u eat then?",
                "required": 1,
                "parent_id": 526,
                "options": []
              }
            ]
          }
        }
      ]
    }
  },
  "promotions": {
    "1": {
      "id": 1,
      "sbu_id": 1,
      "label": "Buy 1 case, Get 2 Pcs Free",
      "payable_type": "Product Discount",
      "discount_type": "Normal",
      "cap_value": null,
      "discount_amount": 2,
      "is_dependency": 0,
      "total_applicable_quantity": 24,
      "discount_product_type": "case",
      "slab_group_id": null,
      "is_fractional": 0,
      "number_of_memos": null,
      "target_amount": null,
      "target_on": "Value",
      "skus": [
        {
          "sku_id": 81,
          "applied_unit": 24
        },
        {
          "sku_id": 82,
          "applied_unit": 24
        },
        {
          "sku_id": 83,
          "applied_unit": 24
        },
        {
          "sku_id": 84,
          "applied_unit": 24
        },
        {
          "sku_id": 92,
          "applied_unit": 24
        },
        {
          "sku_id": 99,
          "applied_unit": 24
        }
      ],
      "discount_on": [
        {
          "sku_id": 81,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 82,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 83,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 84,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 92,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 99,
          "discount_val": 2,
          "applied_unit": 0
        }
      ],
      "rules": [
        {
          "sku_id": 81,
          "case": 1
        },
        {
          "sku_id": 82,
          "case": 1
        },
        {
          "sku_id": 83,
          "case": 1
        },
        {
          "sku_id": 84,
          "case": 1
        },
        {
          "sku_id": 92,
          "case": 1
        },
        {
          "sku_id": 99,
          "case": 1
        }
      ],
      "growth_percentage": null
    },
    "5": {
      "id": 5,
      "sbu_id": 1,
      "label": "title",
      "payable_type": "Absolute Cash",
      "discount_type": "Normal",
      "cap_value": 1,
      "discount_amount": 1,
      "is_dependency": 0,
      "total_applicable_quantity": 48,
      "discount_product_type": "case",
      "slab_group_id": null,
      "is_fractional": 0,
      "number_of_memos": null,
      "target_amount": null,
      "target_on": "Value",
      "skus": [
        {
          "sku_id": 81,
          "applied_unit": 48
        },
        {
          "sku_id": 82,
          "applied_unit": 48
        },
        {
          "sku_id": 83,
          "applied_unit": 48
        },
        {
          "sku_id": 84,
          "applied_unit": 48
        },
        {
          "sku_id": 92,
          "applied_unit": 48
        },
        {
          "sku_id": 99,
          "applied_unit": 48
        }
      ],
      "discount_on": [
        {
          "sku_id": 81,
          "discount_val": 1,
          "applied_unit": 0
        },
        {
          "sku_id": 82,
          "discount_val": 1,
          "applied_unit": 0
        },
        {
          "sku_id": 83,
          "discount_val": 1,
          "applied_unit": 0
        },
        {
          "sku_id": 84,
          "discount_val": 1,
          "applied_unit": 0
        },
        {
          "sku_id": 92,
          "discount_val": 1,
          "applied_unit": 0
        },
        {
          "sku_id": 99,
          "discount_val": 1,
          "applied_unit": 0
        }
      ],
      "rules": [],
      "growth_percentage": null
    },
    "9": {
      "id": 9,
      "sbu_id": 2,
      "label": "buy 2 case \u002711\u0027 Get 2 pcs Free ",
      "payable_type": "Percentage of Value",
      "discount_type": "Normal",
      "cap_value": 4,
      "discount_amount": 2,
      "is_dependency": 0,
      "total_applicable_quantity": 48,
      "discount_product_type": "case",
      "slab_group_id": null,
      "is_fractional": 0,
      "number_of_memos": null,
      "target_amount": null,
      "target_on": "Value",
      "skus": [
        {
          "sku_id": 81,
          "applied_unit": 48
        },
        {
          "sku_id": 82,
          "applied_unit": 48
        },
        {
          "sku_id": 83,
          "applied_unit": 48
        },
        {
          "sku_id": 84,
          "applied_unit": 48
        },
        {
          "sku_id": 92,
          "applied_unit": 48
        },
        {
          "sku_id": 99,
          "applied_unit": 48
        }
      ],
      "discount_on": [
        {
          "sku_id": 81,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 82,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 83,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 84,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 92,
          "discount_val": 2,
          "applied_unit": 0
        },
        {
          "sku_id": 99,
          "discount_val": 2,
          "applied_unit": 0
        }
      ],
      "rules": [
        {
          "sku_id": 81,
          "case": 1
        },
        {
          "sku_id": 82,
          "case": 1
        },
        {
          "sku_id": 83,
          "case": 1
        },
        {
          "sku_id": 84,
          "case": 1
        },
        {
          "sku_id": 92,
          "case": 1
        },
        {
          "sku_id": 99,
          "case": 1
        }
      ],
      "growth_percentage": null
    },
    "65": {
      "id": 65,
      "sbu_id": 54,
      "label": "Buy 4 pcs get 5 taka discount",
      "payable_type": "Absolute Cash",
      "discount_type": "Normal",
      "cap_value": 30,
      "discount_amount": 5,
      "is_dependency": 0,
      "total_applicable_quantity": 4,
      "discount_product_type": "case",
      "slab_group_id": null,
      "is_fractional": 0,
      "number_of_memos": null,
      "target_amount": null,
      "target_on": "Value",
      "skus": [
        {
          "sku_id": 81,
          "applied_unit": 4
        }
      ],
      "discount_on": [
        {
          "sku_id": 81,
          "discount_val": 5,
          "applied_unit": 0
        }
      ],
      "rules": [],
      "growth_percentage": null
    },
    "66": {
      "id": 66,
      "sbu_id": 54,
      "label": "Buy 4 pcs get 1 pcs free",
      "payable_type": "Product Discount",
      "discount_type": "Normal",
      "cap_value": 1,
      "discount_amount": 4,
      "is_dependency": 0,
      "total_applicable_quantity": 6,
      "discount_product_type": "case",
      "slab_group_id": null,
      "is_fractional": 0,
      "number_of_memos": null,
      "target_amount": null,
      "target_on": "Value",
      "skus": [
        {
          "sku_id": 82,
          "applied_unit": 6
        }
      ],
      "discount_on": [
        {
          "sku_id": 82,
          "discount_val": 4,
          "applied_unit": 0
        }
      ],
      "rules": [],
      "growth_percentage": null
    }
  },
  "gifts": {},
  "delivery_configurations": {
    "delivery_enabled": 1,
    "zero_sale_enabled": 1,
    "retailers": [],
    "existing_preorders": {}
  },
  "target_configurations": {
    "target_enabled_sbus": [
      54
    ],
    "sbu_wise_available_targets": {
      "54": [
        "STT"
      ]
    },
    "targets": {
      "54": {
        "STT": {
          "10": {
            "81": 1050,
            "82": 1000,
            "83": 1000,
            "84": 1000,
            "85": 1300,
            "86": 1000
          }
        }
      }
    },
    "sr_archivement": {
      "STT": {
        "54": {
          "10": {
            "81": 472,
            "82": 44,
            "83": 80,
            "84": 0,
            "85": 0,
            "86": 0
          }
        }
      }
    }
  },
  "journey_plan_configurations": {
    "enabled": 1,
    "routes": [
      {
        "id": 202,
        "slug": "Kakoli_Route",
        "section_code": "167-34-222",
        "section_config_id": 252,
        "route_id": 34
      }
    ],
    "day_wise": {
      "Fri": 202,
      "Mon": 202,
      "Sat": 202,
      "Sun": 202,
      "Thu": 202,
      "Tue": 202,
      "Wed": 202
    }
  },
  "asset_type": [
    {
      "id": 141,
      "slug": "Light Box"
    }
  ],
  "cooler_type": [
    {
      "id": 136,
      "slug": "Beverage"
    },
    {
      "id": 137,
      "slug": "Dairy"
    }
  ],
  "light_box_type": [
    {
      "id": 142,
      "slug": "Lubber"
    },
    {
      "id": 143,
      "slug": "ACP Board"
    },
    {
      "id": 144,
      "slug": "Profile Light Box"
    }
  ],
  "bill_category": [
    "Product",
    "Cash"
  ],
  "outlet_unsold_no_button_info": [
    {
      "id": 1,
      "slug": "Outlet Close"
    },
    {
      "id": 2,
      "slug": "Available stock"
    },
    {
      "id": 3,
      "slug": "Insufficient fund"
    }
  ],
  "cooler_size": [
    {
      "id": 139,
      "slug": "260L"
    },
    {
      "id": 140,
      "slug": "440L"
    }
  ],
  "rtc_config": {
    "is_enabled": false,
    "rag_score_data": {},
    "videos": [],
    "survey_details": {}
  },
  "allocated_posm": {},
  "pull_out_reasons": [
    "Reason 1",
    "Reason 2",
    "Others"
  ],
  "coupons": [],
  "posm_types": [
    {
      "posm_type_id": 147,
      "posm_type": "Poster"
    },
    {
      "posm_type_id": 148,
      "posm_type": "Sticker"
    },
    {
      "posm_type_id": 149,
      "posm_type": "Dangler"
    },
    {
      "posm_type_id": 150,
      "posm_type": "Festoon"
    },
    {
      "posm_type_id": 151,
      "posm_type": "Bunting"
    },
    {
      "posm_type_id": 152,
      "posm_type": "Shelf Talker"
    },
    {
      "posm_type_id": 153,
      "posm_type": "Wobbler"
    },
    {
      "posm_type_id": 154,
      "posm_type": "Neck Header"
    },
    {
      "posm_type_id": 155,
      "posm_type": "Cut Out"
    },
    {
      "posm_type_id": 156,
      "posm_type": "X-Banner"
    },
    {
      "posm_type_id": 157,
      "posm_type": "Enrollment Book"
    },
    {
      "posm_type_id": 158,
      "posm_type": "Leaflet"
    },
    {
      "posm_type_id": 159,
      "posm_type": "Tread Letter"
    }
  ],
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
  "sales_configurations": {
    "sale_ui_v2_enable": 1,
    "dashboard_button_sequence": {
      "sale": 1,
      "media": 2,
      "outlet_stock_count": 3,
      "survey": 4,
      "promotion": 5,
      "delivery": 6,
      "stock_check_image": 7,
      "check_out": 8,
      "spot_sale": 1.1
    },
    "sales_dashboard_buttons": {
      "sale": 1,
      "media": 1,
      "outlet_stock_count": 1,
      "survey": 1,
      "promotion": 1,
      "delivery": 1,
      "check_out": 1,
      "spot_sale": 1,
      "stock_check_image": 0
    }
  },
  "max_order_limit_config": {
    "81": {
      "available_stock": 500032,
      "in_transit_stock": 24,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565063.28
    },
    "82": {
      "available_stock": 500010,
      "in_transit_stock": 0,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565011.3
    },
    "83": {
      "available_stock": 500032,
      "in_transit_stock": 0,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565036.16
    },
    "84": {
      "available_stock": 500000,
      "in_transit_stock": 0,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565000
    },
    "92": {
      "available_stock": 500002,
      "in_transit_stock": 0,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565002.26
    },
    "93": {
      "available_stock": 500006,
      "in_transit_stock": 2,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565009.04
    },
    "94": {
      "available_stock": 500009,
      "in_transit_stock": 3,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565013.56
    },
    "112": {
      "available_stock": 500000,
      "in_transit_stock": 0,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565000
    },
    "113": {
      "available_stock": 500000,
      "in_transit_stock": 0,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565000
    },
    "114": {
      "available_stock": 500000,
      "in_transit_stock": 0,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565000
    },
    "115": {
      "available_stock": 500000,
      "in_transit_stock": 0,
      "allocated_stock_percentage": 13,
      "max_order_limit": 565000
    }
  },
  "stock_check_image_retake": 1,
  "tada_expense_configs": [
    {
      "id": 28,
      "sbu_id": "[54]",
      "user_type_id": 41,
      "category_id": 204,
      "amount": "600.00",
      "status": 1,
      "category_type": 200,
      "category_slug": "Hotel",
      "category_display_label": "Hotel",
      "user_type": "SO",
      "user_pre_type": "SO",
      "user_is_management": 0,
      "slug": null
    },
    {
      "id": 30,
      "sbu_id": "[54]",
      "user_type_id": 41,
      "category_id": 204,
      "amount": "2000.00",
      "status": 1,
      "category_type": 200,
      "category_slug": "Hotel",
      "category_display_label": "Hotel",
      "user_type": "SO",
      "user_pre_type": "SO",
      "user_is_management": 0,
      "slug": null
    },
    {
      "id": 31,
      "sbu_id": "[54]",
      "user_type_id": 41,
      "category_id": 201,
      "amount": "100.00",
      "status": 1,
      "category_type": 200,
      "category_slug": "Breakfast",
      "category_display_label": "Breakfast",
      "user_type": "SO",
      "user_pre_type": "SO",
      "user_is_management": 0,
      "slug": null
    },
    {
      "id": 32,
      "sbu_id": "[54]",
      "user_type_id": 41,
      "category_id": 201,
      "amount": "100.00",
      "status": 1,
      "category_type": 200,
      "category_slug": "Breakfast",
      "category_display_label": "Breakfast",
      "user_type": "SO",
      "user_pre_type": "SO",
      "user_is_management": 0,
      "slug": null
    },
    {
      "id": 35,
      "sbu_id": "[54]",
      "user_type_id": 41,
      "category_id": 205,
      "amount": "0.00",
      "status": 1,
      "category_type": 0,
      "category_slug": "Others",
      "category_display_label": "Others",
      "user_type": "SO",
      "user_pre_type": "SO",
      "user_is_management": 0,
      "slug": null
    }
  ],
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
  "sku_unit_config": {
    "81": [
      {
        "pack_type": "Box",
        "pack_size": 12,
        "uom_type": "Pcs"
      },
      {
        "pack_type": "Cartoon",
        "pack_size": 6,
        "uom_type": "Pcs"
      },
      {
        "pack_type": "Piece",
        "pack_size": 1,
        "uom_type": "Pcs"
      }
    ],
    "82": [
      {
        "pack_type": "Cartoon",
        "pack_size": 12,
        "uom_type": "Pcs"
      },
      {
        "pack_type": "Piece",
        "pack_size": 1,
        "uom_type": "Pcs"
      }
    ],
    "83": [
      {
        "pack_type": "Cartoon",
        "pack_size": 12,
        "uom_type": "Pcs"
      },
      {
        "pack_type": "Piece",
        "pack_size": 1,
        "uom_type": "Pcs"
      }
    ],
    "84": [
      {
        "pack_type": "Digital Goods",
        "pack_size": 1,
        "uom_type": "Pcs"
      }
    ],
    "92": [
      {
        "pack_type": "Piece",
        "pack_size": 1,
        "uom_type": "Pcs"
      }
    ],
    "93": [
      {
        "pack_type": "Cartoon",
        "pack_size": 1,
        "uom_type": "Pcs"
      }
    ],
    "94": [
      {
        "pack_type": "Digital Goods",
        "pack_size": 1,
        "uom_type": "Pcs"
      }
    ],
    "112": [
      {
        "pack_type": "Cartoon",
        "pack_size": null,
        "uom_type": "Bag"
      }
    ],
    "113": [
      {
        "pack_type": "Cartoon",
        "pack_size": null,
        "uom_type": "CAN"
      }
    ],
    "114": [
      {
        "pack_type": "Cartoon",
        "pack_size": null,
        "uom_type": "Bag"
      }
    ],
    "115": [
      {
        "pack_type": "SKU",
        "pack_size": null,
        "uom_type": "CAN"
      }
    ]
  },
  "sr-achievement": {
    "STT": {
      "54": {
        "10": {
          "81": 472,
          "82": 44,
          "83": 80,
          "84": 0,
          "85": 0,
          "86": 0
        }
      }
    }
  },
  "finalAssets": {
    "SKU": {
      "id": 1,
      "slug": "SKU",
      "version": "1.0.16",
      "assets": [
        "/app-api/static-file/download/olympic/81.png",
        "/app-api/static-file/download/olympic/82.png",
        "/app-api/static-file/download/olympic/83.png",
        "/app-api/static-file/download/olympic/84.png",
        "/app-api/static-file/download/85.undefined",
        "/app-api/static-file/download/86.undefined",
        "/app-api/static-file/download/92.undefined",
        "/app-api/static-file/download/93.undefined",
        "/app-api/static-file/download/94.undefined",
        "/app-api/static-file/download/96.undefined",
        "/app-api/static-file/download/97.undefined",
        "/app-api/static-file/download/98.undefined",
        "/app-api/static-file/download/99.undefined",
        "/app-api/static-file/download/100.undefined",
        "/app-api/static-file/download/101.undefined",
        "/app-api/static-file/download/110.undefined",
        "/app-api/static-file/download/111.undefined",
        "/app-api/static-file/download/112.undefined",
        "/app-api/static-file/download/113.undefined",
        "/app-api/static-file/download/olympic/114.png",
        "/app-api/static-file/download/115.undefined",
        "/app-api/static-file/download/117.undefined",
        "/app-api/static-file/download/118.undefined",
        "/app-api/static-file/download/119.undefined",
        "/app-api/static-file/download/120.undefined",
        "/app-api/static-file/download/121.undefined",
        "/app-api/static-file/download/olympic/122.png"
      ]
    },
    "ICONS": {
      "id": 3,
      "slug": "ICONS",
      "version": "1.0.16",
      "assets": [
        "/app-api/static-file/download/app_logos/attendance.png",
        "/app-api/static-file/download/app_logos/route_change.png",
        "/app-api/static-file/download/app_logos/pjp_plan.png",
        "/app-api/static-file/download/app_logos/web_panel.png",
        "/app-api/static-file/download/app_logos/bangla.png",
        "/app-api/static-file/download/app_logos/delivery.png",
        "/app-api/static-file/download/app_logos/english.png",
        "/app-api/static-file/download/app_logos/logout.png",
        "/app-api/static-file/download/app_logos/new_outlet.png",
        "/app-api/static-file/download/app_logos/promotion.png",
        "/app-api/static-file/download/app_logos/sales.png",
        "/app-api/static-file/download/app_logos/stock.png",
        "/app-api/static-file/download/app_logos/survey.png",
        "/app-api/static-file/download/app_logos/attendance.png",
        "/app-api/static-file/download/app_logos/route_change.png",
        "/app-api/static-file/download/app_logos/pjp_plan.png",
        "/app-api/static-file/download/app_logos/web_panel.png",
        "/app-api/static-file/download/app_logos/bangla.png",
        "/app-api/static-file/download/app_logos/delivery.png",
        "/app-api/static-file/download/app_logos/english.png",
        "/app-api/static-file/download/app_logos/logout.png",
        "/app-api/static-file/download/app_logos/new_outlet.png",
        "/app-api/static-file/download/app_logos/promotion.png",
        "/app-api/static-file/download/app_logos/sales.png",
        "/app-api/static-file/download/app_logos/stock.png",
        "/app-api/static-file/download/app_logos/survey.png",
        "/app-api/static-file/download/assets/93.png",
        "/app-api/static-file/download/assets/94.png",
        "/app-api/static-file/download/assets/test_updated.png",
        "/app-api/static-file/download/assets/test_updated.png",
        "/app-api/static-file/download/assets/117.png",
        "/app-api/static-file/download/assets/undefined.png",
        "/app-api/static-file/download/olympic/81.png",
        "/app-api/static-file/download/olympic/82.png",
        "/app-api/static-file/download/olympic/122.png",
        "/app-api/static-file/download/olympic/114.png",
        "/app-api/static-file/download/olympic/83.png",
        "/app-api/static-file/download/olympic/84.png"
      ]
    }
  },
  "welcomed": true
};
