//
//  Constant.h
//  SalesManager
//
//  Created by liu xueyan on 7/30/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#ifndef JSLite_Constant_h
#define JSLite_Constant_h

#import "Product.h"
#import "LocalManager.h"
#import "NSString+FontAwesome.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"

#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define STATEBARHEIGHT 64
#define MAINHEIGHT (SCREENHEIGHT - STATEBARHEIGHT)
#define MAINWIDTH SCREENWIDTH

#define TABLEVIEWHEADERHEIGHT 3.f

#define PINGDURATION 15
#define PAGESIZE 20

#define ERR_MSG_DURATION 3.0
#define INFO_MSG_DURATION 2.0
#define SUCCESS_MSG_DURATION 2.0
#define RELOAD_DELAY 1.0

#define GPS_DURATION 120
#define GPS_REDIUS 100

#define AVATAR_SIZE CGSizeMake(300, 300)
#define AVATAR_COMPRESS_QUALITY 0.7

#define LOCALMANAGER [LocalManager sharedInstance]
#define AGENT LOCALMANAGER.agent
#define USER LOCALMANAGER.currentUser
#define MESSAGE [MessageBarManager sharedInstance]
#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

#endif

#define OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define WT_DARK_GRAY [UIColor darkGrayColor]
#define WT_RED RGBA(231,76,60,1)
#define WT_GREEN RGBA(92, 184, 92, 1.0)
#define WT_GRAY [UIColor grayColor]
#define WT_WHITE [UIColor whiteColor]
#define WT_YELLOW [UIColor yellowColor]
#define WT_KHAKI RGBA(245,163,10,1.0)
#define WT_BLUE RGBA(52,152,219,1.0)
#define WT_LIGHT_YELLOW RGBA(255, 255, 240, 1.0)
#define WT_LIGHT_GRAY RGBA(133, 133, 133, 0.8)
#define WT_TOOLBAR_GRAY [UIColor grayColor]
#define WT_BLACK [UIColor blackColor]
#define WT_CLEARCOLOR [UIColor clearColor]

#define FUNC_DASHBOARD 0

#define FUNC_ATTENDANCE 1
#define FUNC_ATTENDANCE_LIST 1001
#define FUNC_ATTENDANCE_DES @"ATTENDANCE"

#define FUNC_PATROL 2
#define FUNC_PATROL_LIST 1002
#define FUNC_PATROL_DES @"PATROL"

#define FUNC_WORKLOG 3
#define FUNC_WORKLOG_LIST 1003
#define FUNC_WORKLOG_DES @"WORKLOG"

#define FUNC_SELL_ORDER 4
#define FUNC_SELL_ORDER_LIST 1004
#define FUNC_SELL_ORDER_DES @"SELL_ORDER"

#define FUNC_SELL_STOCK 5
#define FUNC_SELL_STOCK_LIST 1005
#define FUNC_SELL_STOCK_DES @"SELL_STOCK"

#define FUNC_SELL_REPORT 6
#define FUNC_SELL_REPORT_DES @"SELL_REPORT"

#define FUNC_MESSAGE 1007
#define FUNC_MESSAGE_DES @"CLOUD_NOTICE"

#define FUNC_CHANGE_PASSWORD 8

#define FUNC_SYNC 1009
#define FUNC_SYNC_DES @"SYNC"

#define FUNC_LOGOUT 10
#define FUNC_ABOUT 11
#define FUNC_CHECK_VERSION 12

#define FUNC_FAVORATE 1013
#define FUNC_FAVORATE_DES @"FAV"

#define FUNC_COMPANY_CONTACT 14
#define FUNC_COMPANY_CONTACT_DES @"COMPANY_CONTACT"

#define FUNC_SELL_TODAY 15
#define FUNC_SELL_TODAY_LIST 1015
#define FUNC_SELL_TODAY_DES @"SELL_TODAY"

#define FUNC_COMPETITION 16
#define FUNC_COMPETITION_LIST 1016
#define FUNC_COMPETITION_DES @"COMPETITION"

#define FUNC_CUSTOMER_CONTACT 17
#define FUNC_CUSTOMER_CONTACT_DES @"CUSTOMER_CONTACT"

#define FUNC_RESEARSH 18
#define FUNC_RESEARSH_LIST 1018
#define FUNC_RESEARSH_DES @"MARKET_RESEARCH"

#define FUNC_TASK 19
#define FUNC_TASK_LIST 1019
#define FUNC_TASK_DES @"TASK"

#define FUNC_SPACE 1020
#define FUNC_SPACE_DES @"CLOUD_SPACE"

#define FUNC_BIZOPP 21
#define FUNC_BIZOPP_LIST 1021
#define FUNC_BIZOPP_DES @"BUSINESS_OPPORTUNITY"

#define FUNC_APPROVE 22
#define FUNC_APPROVE_LIST 1022
#define FUNC_APPROVE_DES @"APPROVE"

#define FUNC_GIFT 23
#define FUNC_GIFT_LIST 1023
#define FUNC_GIFT_DES @"GIFT"


#define FUNC_CUSTOMER_SERVICE 24
#define FUNC_CONTACTS 25

#define FUNC_INSPECTION 26
#define FUNC_INSPECTION_LIST 1026
#define FUNC_INSPECTION_DES @"INSPECTION"

#define FUNC_PATROL_TASK 27
#define FUNC_PATROL_TASK_DES @"TASK_PATROL"

#define FUNC_PAPER_POST 28
#define FUNK_PAPER_POST_LIST 1027
#define FUNC_PAPER_POST_DES @"PAPER_POST"

#define FUNC_HOLIDAY 29
#define FUNC_HOLIDAY_DES @"HOLIDAY"

#define FUNC_CUSTOMER_LIST 1028
#define FUNC_NEARBY_LIST 1029
#define FUNC_TRACK_LIST 1030
#define FUNC_EDIT 1031

#define FUNC_SELL_DELIVERY 1032
#define FUNC_SELL_DELIVERY_DES @"SELL_DELIVERY"

#define FUNC_SELL_REWARD 1033
#define FUNC_SELL_REWARD_DES @"SELL_REWARD"

#define FUNC_LOGIN 1034
#define FUNC_ANNOUNCE 1035
#define FUNC_MESSAGE_LIST 1036
#define FUNC_ANNOUNCE_LIST 1037
#define FUNC_SETTING 1038
#define FUNC_CUSTOMER_DETAIL 1039
#define FUNC_OTHER_USER_DETAIL 1040
#define FUNC_GIFT_PURCHASE_LIST 1041
#define FUNC_GIFT_PURCHASE_LIST_DES @"GIFT_PURCHASE_LIST"
#define FUNC_GIFT_DELIVERY_LIST 1042
#define FUNC_GIFT_DELIVERY_LIST_DES @"GIFT_DELIVERY_LIST"
#define FUNC_GIFT_DISTRIBUTE_LIST 1043
#define FUNC_GIFT_DISTRIBUTE_LIST_DES @"GIFT_DISTRIBUTE_LIST"
#define FUNC_GIFT_STOCK_LIST 1044
#define FUNC_GIFT_STOCK_LIST_DES @"GIFT_STOCK_LIST"
#define FUNC_ALARM 1045
#define FUNC_ALARM_DES @"ALARMA"

#define FUNC_VIDEO 1046
#define FUNC_VIDEO_LIST 1047
#define FUNC_VIDEO_DES @"VIDEO"
#define FUNC_VIDEO_TASK_LIST 1048
#define FUNC_VIDEO_TASK_DES @"VIDEO_TASK_LIST"

#define FUNC_COMMON_PHRASES 1049

//寻访报告功能
#define PATROL_FUNC_PICTURE @"PICTURE"
#define PATROL_FUNC_VIDEO   @"VIDEO"
#define FUNC_PATROL_VIDEO 1050

//合并的通讯录
#define FUNC_CONTACT 1051

//订单产品
#define FUNC_NEW_ORDER_REPORT 1052
#define FUNC_NEW_ORDER_NORMAL 1053
#define FUNC_NEW_ORDER_COMFIRM 1054
#define FUNC_NEW_ORDER_SUCESS 1055
#define FUNC_NEW_ORDER_PRINT 1056
#define FUNC_NEW_ORDER_LIST 1057
//QChat
#define FUNC_QCHAT_DESC   @"QCHAT"
#define FUNC_QCHAT 1058

#define FUNC_PAPER_POST_LIST 1059
#define FUNC_PAPER_TEMPLATE_LIST 1060
#define FUNC_PAPER_POST_DETAIL    1061

//考勤管理  签到考勤／打卡考勤
#define FUNC_ATTENDANCE_ATTENDANCE_LIST 1062
#define FUNC_ATTENDANCE_ATTENDANCET_LIST_DES @"ATTENDANCE_ATTENDANCET_LIST"
#define FUNC_ATTENDANCE_CHECK_IN_LIST 1063
#define FUNC_ATTENDANCE_CHECK_IN_LIST_DES @"ATTENDANCE_CHECK_IN_LIST"

#define READED @"Y"
#define UNREADED @"N"

#define REQUEST_END_NOTIFICATION @"request_end_notification"
#define MESSAGE_NOTIFICATION @"message_notification"
#define ANNOUNCE_NOTIFICATION @"announce_notification"
#define SYNC_NOTIFICATION @"sync_notification"
#define SYNC_NOTIFICATION_MENU @"sync_notification_menu"
#define CUSTOMER_NOTIFICATION @"customer_notification"
#define SYNC_VIDEO_MEDIA @"sync_video_media"
#define SYNC_PAPER_TEMPLE @"sync_paper_temple"
#define SYNC_PAPER_DEFAULT @"sync_paper_default"

#define COMMON_PHRASES_COUNT 10
#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define REQUEST_TIME_OUT 30.f

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/*
 @"1千米", @"3千米", @"5千米", @"10千米"
 */
#define DISTANCE_1KM    1000
#define DISTANCE_3KM    3000
#define DISTANCE_5KM    5000
#define DISTANCE_10KM   10000

#define S_ERROR_SERVER @"数据处理失败。"

typedef enum VIEW_TYPE{
    VIEW_TYPE_REPORT = 0,
    VIEW_TYPE_LIST,
    VIEW_TYPE_DETAIL,
    VIEW_TYPE_STR
}VIEW_TYPE;

typedef enum TASK_TYPE{
    
    SINGLE_TASK = 0,
    REPEAT_TASK
    
}TASK_TYPE;

typedef enum TASK_STATUS{
    
    TASK_STATUS_ALL = -1,
    TASK_STATUS_NOT_FINISH,
    TASK_STATUS_FINISH
}TASK_STATUS;


typedef enum REQUEST_STATUS{
    
    DONE = 0,
    NETWROK_NOT_AVAILABLE,
    WEBSOCKET_NOT_OPEN,
    RECONNECT_WEBSOCKET,
    NETWORK_BUSSY
    
}REQUEST_STATUS;

typedef enum OPERATION_STATUS{

    CREATE = 0,
    UPDATE,
    DELETE,
    DELETE_ALL
}OPERATION_STATUS;

typedef enum SYS_MESSAGE_TYPE_ID {
    MESSAGE_CARGO_REQ = 1,
    MESSAGE_INVENTORY = 2,
    MESSAGE_TODAY_SALE_REQ = 3,
    MESSAGE_COMPETITION_SALE_REQ = 4,
    MESSAGE_VIVID_REPORT = 5,
    MESSAGE_DAILY_REPORT = 6,
    MESSAGE_DAILY_APPROVAL = 7,
    MESSAGE_MARKET_REPORT = 8,
    MESSAGE_BUSINESS_REPORT = 9,
    MESSAGE_BUSINESS_APPROVAL = 10,
    MESSAGE_GIFT_PURCHASE = 11,
    MESSAGE_GIFT_DELIVERY = 12,
    MESSAGE_GIFT_DISTRIBUTE = 13,
    MESSAGE_GIFT_STOCK = 14,
    MESSAGE_APPLY_ITEM = 15,
    MESSAGE_APPLY_ITEM_APPROVAL = 16,
    MESSAGE_VIVID_REPORT_APPROVAL = 17,
    MESSAGE_ATTENDANCE_APPROVAL = 18,
    MESSAGE_INSPECTION_DETAIL = 19,
    MESSAGE_INSPECTION_APPROVAL = 20,
    MESSAGE_MARKET_APPROVAL = 21,
    MESSAGE_TASK_PATROL_FINISH = 22,
    MESSAGE_TASK_PATROL_APPROVAL = 23,
    MESSAGE_TASK_PATROL_ADD=24,
    MESSAGE_VIDEO_ADD=25,
    MESSAGE_VIDEO_REPLY=26,
    MESSAGE_PAPER_DETAIL=27,
    MESSAGE_HOLIDAY_APPROVAL_USER = 28,
    MESSAGE_HOLIDAY_APPLY = 29,
    MESSAGE_CHENK_IN_ATTENDANCE = 30,
    MESSAGE_APPLY_ITEM_AUDIT = 31,
    MESSAGE_UNKNOW=0
}SYS_MESSAGE_TYPE_ID;

const NSArray *___ActionTypes;
#define actionTypeGet (___ActionTypes == nil ? ___ActionTypes = [[NSArray alloc] initWithObjects: \
@"LOGIN", \
@"LOGOUT", \
@"LOCATION_SAVE", \
@"CHANGE_PWD", \
@"PATROL_SAVE", \
@"PATROL_LIST", \
@"PATROL_GET", \
@"PATROL_REPLY", \
@"WORKLOG_LIST", \
@"WORKLOG_SAVE", \
@"WORKLOG_GET", \
@"WORKLOG_REPLY", \
@"ATTENDANCE_SAVE", \
@"ATTENDANCE_CATEGORY_LIST", \
@"ATTENDANCE_LIST", \
@"ATTENDANCE_GET", \
@"ATTENDANCE_REPLY", \
@"MARKETRESEARCH_SAVE", \
@"MARKETRESEARCH_LIST", \
@"MARKETRESEARCH_GET", \
@"MARKETRESEARCH_REPLY", \
@"BUSINESSOPPORTUNITY_SAVE", \
@"BUSINESSOPPORTUNITY_LIST", \
@"BUSINESSOPPORTUNITY_GET", \
@"BUSINESSOPPORTUNITY_REPLY", \
@"APPLY_ITEM_SAVE", \
@"APPLY_ITEM_LIST", \
@"APPLY_ITEM_GET", \
@"APPLY_ITEM_REPLY", \
@"INSPECTION_REPORT_SAVE", \
@"INSPECTION_REPORT_LIST", \
@"INSPECTION_REPORT_GET", \
@"INSPECTION_REPORT_REPLY", \
@"ORDERGOODS_SAVE", \
@"ORDERGOODS_LIST", \
@"STOCK_SAVE", \
@"STOCK_LIST", \
@"SALEGOODS_SAVE", \
@"SALEGOODS_LIST", \
@"COMPETITIONGOODS_SAVE", \
@"COMPETITIONGOODS_LIST", \
@"GIFT_PURCHASE_SAVE", \
@"GIFT_PURCHASE_LIST", \
@"GIFT_PURCHASE_GET", \
@"GIFT_DELIVERY_SAVE", \
@"GIFT_DELIVERY_LIST", \
@"GIFT_DELIVERY_GET", \
@"GIFT_DISTRIBUTE_SAVE", \
@"GIFT_DISTRIBUTE_LIST", \
@"GIFT_DISTRIBUTE_GET", \
@"GIFT_STOCK_SAVE", \
@"GIFT_STOCK_LIST", \
@"GIFT_STOCK_GET", \
@"TASK_PATROL_GET", \
@"TASK_PATROL_LIST", \
@"TASK_PATROL_DETAIL_SAVE", \
@"TASK_PATROL_REPLY", \
@"MY_TASK_PATROL_LIST", \
@"MY_TASK_PATROL_GET", \
@"MESSAGE_LIST", \
@"ANNOUNCE_LIST", \
@"ANNOUNCE_ACK", \
@"MESSAGE_ACK", \
@"COMPANYSPACE_CATEGORY_LIST", \
@"COMPANYSPACE_LIST", \
@"FAV_SAVE", \
@"SYNC_BASE_DATA", \
@"SYNC_CUSTOMER_LIST", \
@"CUSTOMER_LIST", \
@"USER_LIST", \
@"USER_INFO_GET", \
@"CUSTOMER_INFO_GET", \
@"COUNT_DATA_GET", \
@"USER_INFO_UPDATE", \
@"CUSTOMER_SAVE",\
@"USER_LOG_SAVE",\
@"PUSH_MSG",\
@"COMPANY_CONTACT_LIST",\
@"PATROL_REPLY_LIST", \
@"WORKLOG_REPLY_LIST",\
@"TASK_PATROL_REPLY_LIST",\
@"APPLY_ITEM_REPLY_LIST",\
@"VIDEO_TOPIC_SAVE",\
@"VIDEO_TOPIC_LIST",\
@"VIDEO_TOPIC_GET",\
@"VIDEO_TOPIC_REPLY",\
@"VIDEO_TOPIC_REPLY_LIST",\
@"FAV_LANG_SAVE",\
@"FAV_LANG_LIST",\
@"FAV_LANG_DELETE",\
@"FAV_LANG_UPDATE",\
@"PRINT_ORDER",\
@"CUSTOMER_FAV_LIST",\
@"CUSTOMER_FAV_SAVE",\
@"CUSTOMER_FAV_DELETE",\
@"QCHAT_USERGROUP_LIST",\
@"QCHAT_USERGROUP_SAVE",\
@"QCHAT_USERGROUP_DELETE",\
@"QCHAT_USERGROUP_UPDATE",\
@"QCHAT_USER_LIST",\
@"PAPER_POST_SAVE",\
@"PAPER_POST_LIST",\
@"PAPER_POST_GET",\
@"PAPER_TEMPLATE_LIST",\
@"HOLIDAY_APPLY_SAVE",\
@"IS_EXIST_HOLIDAY_CATEGORY_FLOW",\
@"CHECKIN_SHIFT_GET",\
@"CHECKIN_TRACK_SAVE",\
@"CHECKIN_TRACK_LIST",\
@"CHECKIN_TRACK_GET",\
@"CHECKIN_TRACK_REPLY",\
@"CHECKIN_TRACK_REPLY_LIST",\
@"CHECKIN_WIFI_SAVE",\
@"CHECKIN_WIFI_LIST",\
@"CHECKIN_TRACK_DATE",\
@"CHECKIN_TRACK_REMARK",\
@"ANNOUNCEMENT_SAVE",\
@"HOLIDAY_APPLY_APPROVE",\
@"APPLY_ITEM_AUDIT_LIST",\
@"APPLY_ITEM_APPROVE",\
@"APPLY_CATEGORY_USERS",nil] : ___ActionTypes)
#define NS_ACTIONTYPE(type) ([actionTypeGet objectAtIndex:type])
#define INT_ACTIONTYPE(string) ([actionTypeGet indexOfObject:string])

const NSArray *___ActionCodes;
#define actionCodeGet (___ActionCodes == nil ? ___ActionCodes = [[NSArray alloc] initWithObjects: \
@"DONE", \
@"ERROR_TIMEOUT", \
@"ERROR_SERVER", \
@"ERROR_INVALID_ACTION", \
@"ERROR_ACCOUNT_EXCEPTION", \
@"ERROR_APP_EXCEPTION", \
@"ERROR_CAMERA_CATEGORY_INVALID" ,nil] : ___ActionCodes)
#define INT_ACTIONCODE(string) ([actionCodeGet indexOfObject:string])
#define NS_ACTIONCODE(type) ([actionCodeGet objectAtIndex:type])

const NSArray *___MessageTypes;
#define messageTypesGet (___MessageTypes == nil ? ___MessageTypes = [[NSArray alloc] initWithObjects: \
@"SERVICE", \
@"ANNOUNCE", \
@"SYNCDATA", \
@"EXCEPTION", nil] : ___MessageTypes)
#define INT_MESSAGETYPE(string) ([messageTypesGet indexOfObject:string])
#define NS_MESSAGETYPE(type) ([messageTypesGet objectAtIndex:type])

const NSArray *___UserLogTypes;
#define userlogTypesGet (___UserLogTypes == nil ? ___UserLogTypes = [[NSArray alloc] initWithObjects: \
@"LOGIN", \
@"LOGOUT", nil] : ___UserLogTypes)
#define INT_USERLOGTYPE(string) ([userlogTypesGet indexOfObject:string])
#define NS_USERLOGTYPE(type) ([userlogTypesGet objectAtIndex:type])

const NSArray *___Sort;
#define sortsGet (___Sort == nil ? ___Sort = [[NSArray alloc] initWithObjects: \
@"ASC", \
@"DES", nil] : ___Sort)
#define INT_SORT(string) ([sortsGet indexOfObject:string])
#define NS_SORT(type) ([sortsGet objectAtIndex:type])

const NSArray *___SyncTargets;
#define syncTargetsGet (___SyncTargets == nil ? ___SyncTargets = [[NSArray alloc] initWithObjects: \
@"USER", \
@"POSITION", \
@"DEPARTMENT", \
@"COMPANY", \
@"PRODUCT_CATEGORY", \
@"PRODUCT", \
@"COMPETITION_PRODUCT", \
@"GIFT_PRODUCT_CATEGORY", \
@"GIFT_PRODUCT", \
@"CUSTOMER_CATEGORY", \
@"CUSTOMER", \
@"SYSTEM_SETTING", \
@"FUNCTION", \
@"INSPECTION_TYPE", \
@"INSPECTION_MODEL", \
@"INSPECTION_STATUS", \
@"INSPECTION_TARGET", \
@"INSPECTION_REPORT_CATEGORY", \
@"ATTENDANCE_CATEGORY", \
@"APPLY_CATEGORY", \
@"APP_SETTING", \
@"PATROL_CATEGORY", \
@"VIDEO_CATEGORY",\
@"VIDEO_DURATION_CATEGORY",\
@"CAMERA_CATEGORY",\
@"PRODUCT_SPEC",\
@"CUSTOMER_TAG", nil] : ___SyncTargets)
#define INT_SYNCTARGET(string) ([syncTargetsGet indexOfObject:string])
#define NS_SYNCTARGET(type) ([syncTargetsGet objectAtIndex:type])


#define ICON_HOME                           FAHome
#define ICON_COMPANY_SPACE                  FAFolderO
#define ICON_ATTENDANCE                     FAPencil
#define ICON_PATROL                         FACamera
#define ICON_TASK_PATROL                    FATasks
#define ICON_INPECTION                      FARetweet
#define ICON_WORKLOG                        FABook
#define ICON_MARKET_RESEARCH                FAEye
#define ICON_BUSSINESS_OPPORTUNITY          FAlifeRing
#define ICON_COMPETITION                    FAGavel
#define ICON_SELL_TODAY                     FACalendar
#define ICON_SELL_ORDER                     FAListAlt
#define ICON_SELL_STOCK                     FAcube
#define ICON_APPROVE                        FASortAmountAsc
#define ICON_GIFT                           FAGift
#define ICON_CONTACT                        FAPhone
#define ICON_MESSAGE                        FAEnvelope
#define ICON_FAV                            FAStar
#define ICON_CHANGE_PWD                     FAKey
#define ICON_DATA_SYNC                      FADownload
#define ICON_LOGOUT                         FAHandOLeft
#define ICON_CUSTOMER_SERVICE               FAHeadphones
#define ICON_CHECK_VERSION                  FAArrowCircleOUp
#define ICON_COPYRIGHT                      FACog
#define ICON_PROFILE                        FAUser
#define ICON_MESSAGE2                       FAEnvelopeO
#define ICON_GO                             FAChevronCircleRight
#define ICON_CLOUD_UPLOAD                   FACloudUpload
#define ICON_LOCATION_ARROW                 FALocationArrow
#define ICON_TAB_CATEGORY                   FAAlignJustify
#define ICON_TAB_DISTANCE                   FAMapMarker
#define ICON_MAP_MARK                       FAMapMarker
#define ICON_TAB_CITY                       FAGlobe
#define ICON_LOCATION_MARKER                FAMapMarker
#define ICON_CUSTOMER                       FAUsers
#define ICON_PHONE                          FAPhone
#define ICON_EDIT                           FAPlus
#define ICON_TAB_NAME                       FAListAlt
#define ICON_CUSTOMER_CONTACT               FAMobile
#define ICON_ALARM                          FABell
#define ICON_CENTER                         FACircleO
#define ICON_VIDEO                          FAVideoCamera
#define ICON_LIST                           FASearch
#define ICON_SAVE                           FASave
#define ICON_PLAY                           FAPlayCircle
#define ICON_CHECK_CIRCLE                   FACheckCircle
#define ICON_SEARCH                         FASearch
#define ICON_CIRCLE_THIN                    FAcircleThin
#define ICON_CIRCLE_NOTHIN                  FAcircleONotch
#define ICON_PLUS                           FAPlus
#define ICON_CONFIG                         FACog
#define ICON_BACK                           FAAngleLeft
#define ICON_NAVLIST                        FABars
#define ICON_MYLOC                          FARepeat
#define ICON_REFRESH                        FARefresh
#define ICON_FILTER                         FAFilter
#define ICON_ARROW                          FAArrowsV
#define ICON_SHOPPING                       FAShoppingCart
#define ICON_BLUETOOTH                      FABluetooth
#define ICON_LEFT                           FALongArrowLeft
#define ICON_TYPELIST                       FAAlignJustify
#define ICON_DOWNLOAD                       FACloudDownload

#define USER_PERMISSION_VIEW                @"查看用户"
#define USER_PERMISSION_VIEW_VAL            @"user:view"
#define USER_PERMISSION_ANNOUNCE_ADD   @"company:announcementAdd"
/*
 #define MODEL_ATTENDANCE_CATEGORY_VERSION           1
 #define MODEL_FUNCTION_VERSION                      1
 #define MODEL_CUSTOMER_CATEGORY_VERSION             1
 #define MODEL_PATROL_CATEGORY_VERSION               1
 #define MODEL_PATROL_VERSION                        1
 #define MODEL_MESSAGE_VERSION                       1
 #define MODEL_ANNOUNCE_VERSION                      1
 #define MODEL_USER_VERSION                          1
 #define MODEL_DEPARTMENT_VERSION                    1
 #define MODEL_PRODUCT_VERSION                       1
 #define MODEL_COMPETITION_PRODUCT_VERSION           1
 #define MODEL_CUSTOMER_VERSION                      1
 #define MODEL_CUSTOMER_CONTACT_VERSION              1
 #define MODEL_LOCATION_VERSION                      1
 #define MODEL_WORKLOG_VERSION                       1
 #define MODEL_COMPANY_VERSION                       1
 #define MODEL_APPLY_CATEGORY_VERSION                1
 #define MODEL_GIFT_PRODUCT_VERSION                  1
 #define MODEL_GIFT_PRODUCT_CATEGORY_VERSION         1
 #define MODEL_GIFT_PRODUCT_MODEL_VERSION            1
 #define MODEL_GIFT_PRODUCT_AREA_VERSION             1
 #define MODEL_INSPECTION_REPORT_CATEGORY_VERSION    1
 #define MODEL_INSPECTION_TYPE_VERSION               1
 #define MODEL_INSPECTION_MODEL_VERSION              1
 #define MODEL_INSPECTION_STATUS_VERSION             1
 #define MODEL_INSPECTION_TARGET_VERSION             1
 */
#define DEVICE_TYPE @"IOS"


//DB Version 11 增加考勤类型表
//DB Version 12 增加申请类型、赠品、部门
//DB Version 13 增加巡检
//DB Version 23 LoginUser增加过期内容
//DB Version 24 增加客户标签，产品类型，产品标签
#define DATABASE_VERSION 26

#define APP_KEY     @"EFCEF44D-F8D9-4F43-BEED-0CF8F691A278"
#define APP_SECRET  @"[WT]3B57CD15-F259-492E-BCA0-F2E0A276E701"
#define IV_KEY      [[NSString stringWithFormat:@"%@%@%@",APP_KEY,APP_SECRET,@"cc.juicyshare.mm"].md5 substringToIndex:16]
#define SERVICE_URL @"http://www.juicyshare.cc"
#define SERVICE_TEL @"tel://4008940551"

#ifdef TELECOM
#define KEYCHAIN_GROUP  @"9MZ9ZQG82C.cc.juicyshare.salesmanager"
#define BAIDU_KEY       @"C4x8WpwMdFnQGX1jkzSE3P9yyGNkGxsW"
//#define BAIDU_KEY       @"ZPOWPYE3aW9mbLxmpqDuvvC1"
#define BUGLY_KEY       @"900017950"
#elif defined S
#define KEYCHAIN_GROUP  @"9MZ9ZQG82C.cc.juicyshare.salesmanager.xswq"
#define BAIDU_KEY       @"EyaRCkdbf4uz9aTbzQwB0dUP"
#define BUGLY_KEY       @"900017950"
#endif
