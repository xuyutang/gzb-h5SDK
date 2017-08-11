// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "Generic.pb.h"
#import "User.pb.h"
#import "Apply.pb.h"
#import "Customer.pb.h"
#import "Patrol.pb.h"
#import "Attendance.pb.h"
#import "Product.pb.h"
#import "Gift.pb.h"
#import "InspectionReport.pb.h"
#import "VideoTopic.pb.h"
#import "CompetitionGoods.pb.h"
#import "PaperTemplate.pb.h"
#import "Holiday.pb.h"
#import "CheckIn.pb.h"

@class AppSetting;
@class AppSetting_Builder;
@class ApplyCategory;
@class ApplyCategory_Builder;
@class ApplyItem;
@class ApplyItemParams;
@class ApplyItemParams_Builder;
@class ApplyItemReply;
@class ApplyItemReply_Builder;
@class ApplyItem_Builder;
@class Attendance;
@class AttendanceCategory;
@class AttendanceCategory_Builder;
@class AttendanceParams;
@class AttendanceParams_Builder;
@class AttendanceReply;
@class AttendanceReply_Builder;
@class AttendanceType;
@class AttendanceType_Builder;
@class Attendance_Builder;
@class CheckInChannel;
@class CheckInChannel_Builder;
@class CheckInShift;
@class CheckInShiftGroup;
@class CheckInShiftGroup_Builder;
@class CheckInShift_Builder;
@class CheckInTrack;
@class CheckInTrackParams;
@class CheckInTrackParams_Builder;
@class CheckInTrackReply;
@class CheckInTrackReply_Builder;
@class CheckInTrack_Builder;
@class CheckInWifi;
@class CheckInWifi_Builder;
@class Company;
@class Company_Builder;
@class CompetitionGoods;
@class CompetitionGoodsParams;
@class CompetitionGoodsParams_Builder;
@class CompetitionGoods_Builder;
@class CompetitionProduct;
@class CompetitionProductCategory;
@class CompetitionProductCategory_Builder;
@class CompetitionProduct_Builder;
@class Contact;
@class Contact_Builder;
@class Customer;
@class CustomerCategory;
@class CustomerCategory_Builder;
@class CustomerParams;
@class CustomerParams_Builder;
@class CustomerTag;
@class CustomerTagValue;
@class CustomerTagValue_Builder;
@class CustomerTag_Builder;
@class Customer_Builder;
@class Department;
@class Department_Builder;
@class Device;
@class Device_Builder;
@class FavData;
@class FavData_Builder;
@class Function;
@class Function_Builder;
@class GiftDelivery;
@class GiftDeliveryParams;
@class GiftDeliveryParams_Builder;
@class GiftDelivery_Builder;
@class GiftDistribute;
@class GiftDistributeParams;
@class GiftDistributeParams_Builder;
@class GiftDistribute_Builder;
@class GiftProduct;
@class GiftProductArea;
@class GiftProductArea_Builder;
@class GiftProductCategory;
@class GiftProductCategory_Builder;
@class GiftProductModel;
@class GiftProductModel_Builder;
@class GiftProduct_Builder;
@class GiftPurchase;
@class GiftPurchaseParams;
@class GiftPurchaseParams_Builder;
@class GiftPurchase_Builder;
@class GiftStock;
@class GiftStockParams;
@class GiftStockParams_Builder;
@class GiftStock_Builder;
@class HolidayApply;
@class HolidayApply_Builder;
@class HolidayCategory;
@class HolidayCategory_Builder;
@class InspectionModel;
@class InspectionModel_Builder;
@class InspectionReport;
@class InspectionReportCategory;
@class InspectionReportCategory_Builder;
@class InspectionReportParams;
@class InspectionReportParams_Builder;
@class InspectionReportReply;
@class InspectionReportReply_Builder;
@class InspectionReport_Builder;
@class InspectionStatus;
@class InspectionStatus_Builder;
@class InspectionTarget;
@class InspectionTarget_Builder;
@class InspectionType;
@class InspectionType_Builder;
@class Location;
@class Location_Builder;
@class PageApplyItem;
@class PageApplyItem_Builder;
@class PageAttendance;
@class PageAttendance_Builder;
@class PageCheckInTrack;
@class PageCheckInTrack_Builder;
@class PageCompetitionGoods;
@class PageCompetitionGoods_Builder;
@class PageCustomer;
@class PageCustomer_Builder;
@class PageGiftDelivery;
@class PageGiftDelivery_Builder;
@class PageGiftDistribute;
@class PageGiftDistribute_Builder;
@class PageGiftPurchase;
@class PageGiftPurchase_Builder;
@class PageGiftStock;
@class PageGiftStock_Builder;
@class PageInspectionReport;
@class PageInspectionReport_Builder;
@class PagePatrol;
@class PagePatrol_Builder;
@class PageUser;
@class PageUser_Builder;
@class PageVideoTopic;
@class PageVideoTopic_Builder;
@class Pagination;
@class Pagination_Builder;
@class PaperTemplate;
@class PaperTemplate_Builder;
@class Patrol;
@class PatrolCategory;
@class PatrolCategory_Builder;
@class PatrolMediaCategory;
@class PatrolMediaCategory_Builder;
@class PatrolParams;
@class PatrolParams_Builder;
@class PatrolReply;
@class PatrolReply_Builder;
@class PatrolVideoDurationCategory;
@class PatrolVideoDurationCategory_Builder;
@class Patrol_Builder;
@class Permission;
@class Permission_Builder;
@class Position;
@class Position_Builder;
@class Product;
@class ProductCategory;
@class ProductCategory_Builder;
@class ProductParams;
@class ProductParams_Builder;
@class ProductSpecification;
@class ProductSpecificationValue;
@class ProductSpecificationValue_Builder;
@class ProductSpecification_Builder;
@class Product_Builder;
@class SyncData;
@class SyncDataParams;
@class SyncDataParams_Builder;
@class SyncData_Builder;
@class SystemSetting;
@class SystemSetting_Builder;
@class User;
@class UserParams;
@class UserParams_Builder;
@class User_Builder;
@class VideoCategory;
@class VideoCategory_Builder;
@class VideoDurationCategory;
@class VideoDurationCategory_Builder;
@class VideoTopic;
@class VideoTopicParams;
@class VideoTopicParams_Builder;
@class VideoTopicReply;
@class VideoTopicReply_Builder;
@class VideoTopic_Builder;
#ifndef __has_feature
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif // __has_feature

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif


@interface SyncDataRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface FavData : PBGeneratedMessage {
@private
    PBAppendableArray * patrolCategoriesArray;
    PBAppendableArray * productsArray;
    PBAppendableArray * customersArray;
}
@property (readonly, retain) PBArray * patrolCategories;
@property (readonly, retain) PBArray * products;
@property (readonly, retain) PBArray * customers;
- (PatrolCategory*)patrolCategoriesAtIndex:(NSUInteger)index;
- (Product*)productsAtIndex:(NSUInteger)index;
- (Customer*)customersAtIndex:(NSUInteger)index;

+ (FavData*) defaultInstance;
- (FavData*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (FavData_Builder*) builder;
+ (FavData_Builder*) builder;
+ (FavData_Builder*) builderWithPrototype:(FavData*) prototype;
- (FavData_Builder*) toBuilder;

+ (FavData*) parseFromData:(NSData*) data;
+ (FavData*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (FavData*) parseFromInputStream:(NSInputStream*) input;
+ (FavData*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (FavData*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (FavData*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface FavData_Builder : PBGeneratedMessage_Builder {
@private
    FavData* result;
}

- (FavData*) defaultInstance;

- (FavData_Builder*) clear;
- (FavData_Builder*) clone;

- (FavData*) build;
- (FavData*) buildPartial;

- (FavData_Builder*) mergeFrom:(FavData*) other;
- (FavData_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (FavData_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (PBAppendableArray *)patrolCategories;
- (PatrolCategory*)patrolCategoriesAtIndex:(NSUInteger)index;
- (FavData_Builder *)addPatrolCategories:(PatrolCategory*)value;
- (FavData_Builder *)setPatrolCategoriesArray:(NSArray *)array;
- (FavData_Builder *)setPatrolCategoriesValues:(const PatrolCategory* *)values count:(NSUInteger)count;
- (FavData_Builder *)clearPatrolCategories;

- (PBAppendableArray *)products;
- (Product*)productsAtIndex:(NSUInteger)index;
- (FavData_Builder *)addProducts:(Product*)value;
- (FavData_Builder *)setProductsArray:(NSArray *)array;
- (FavData_Builder *)setProductsValues:(const Product* *)values count:(NSUInteger)count;
- (FavData_Builder *)clearProducts;

- (PBAppendableArray *)customers;
- (Customer*)customersAtIndex:(NSUInteger)index;
- (FavData_Builder *)addCustomers:(Customer*)value;
- (FavData_Builder *)setCustomersArray:(NSArray *)array;
- (FavData_Builder *)setCustomersValues:(const Customer* *)values count:(NSUInteger)count;
- (FavData_Builder *)clearCustomers;
@end

@interface SyncData : PBGeneratedMessage {
@private
    BOOL hasCameraCategory_:1;
    BOOL hasCheckInShift_:1;
    BOOL hasSessionUser_:1;
    BOOL hasCompany_:1;
    BOOL hasAppSetting_:1;
    BOOL hasPageCustomer_:1;
    BOOL hasSystemSetting_:1;
    NSString* cameraCategory;
    CheckInShift* checkInShift;
    User* sessionUser;
    Company* company;
    AppSetting* appSetting;
    PageCustomer* pageCustomer;
    SystemSetting* systemSetting;
    PBAppendableArray * usersArray;
    PBAppendableArray * checkInChannelsArray;
    PBAppendableArray * attendanceTypesArray;
    PBAppendableArray * holidayCategoriesArray;
    PBAppendableArray * paperTemplatesArray;
    PBAppendableArray * productCategoriesArray;
    PBAppendableArray * customerTagsArray;
    PBAppendableArray * productSpecificationsArray;
    PBAppendableArray * functionsArray;
    PBAppendableArray * patrolVideoDurationCategoriesArray;
    PBAppendableArray * patrolMediaCategoriesArray;
    PBAppendableArray * videoDurationCategoriesArray;
    PBAppendableArray * videoCategoriesArray;
    PBAppendableArray * patrolCategoriesArray;
    PBAppendableArray * positionArray;
    PBAppendableArray * customerCategoriesArray;
    PBAppendableArray * competitionProductsArray;
    PBAppendableArray * productsArray;
    PBAppendableArray * inspectionReportCategoriesArray;
    PBAppendableArray * inspectionTargetsArray;
    PBAppendableArray * inspectionStatusesArray;
    PBAppendableArray * inspectionModelsArray;
    PBAppendableArray * inspectionTypesArray;
    PBAppendableArray * attendanceCategoriesArray;
    PBAppendableArray * giftProductCategoriesArray;
    PBAppendableArray * departmentsArray;
    PBAppendableArray * giftProductsArray;
    PBAppendableArray * applyCategoriesArray;
}
- (BOOL) hasSystemSetting;
- (BOOL) hasPageCustomer;
- (BOOL) hasAppSetting;
- (BOOL) hasCompany;
- (BOOL) hasSessionUser;
- (BOOL) hasCameraCategory;
- (BOOL) hasCheckInShift;
@property (readonly, retain) PBArray * users;
@property (readonly, retain) PBArray * functions;
@property (readonly, retain) PBArray * patrolCategories;
@property (readonly, retain) PBArray * customerCategories;
@property (readonly, retain) PBArray * competitionProducts;
@property (readonly, retain) PBArray * products;
@property (readonly, retain) PBArray * attendanceCategories;
@property (readonly, retain) PBArray * applyCategories;
@property (readonly, retain) PBArray * giftProducts;
@property (readonly, retain) PBArray * departments;
@property (readonly, retain) PBArray * giftProductCategories;
@property (readonly, retain) SystemSetting* systemSetting;
@property (readonly, retain) PBArray * inspectionTypes;
@property (readonly, retain) PBArray * inspectionModels;
@property (readonly, retain) PBArray * inspectionStatuses;
@property (readonly, retain) PBArray * inspectionTargets;
@property (readonly, retain) PBArray * inspectionReportCategories;
@property (readonly, retain) PageCustomer* pageCustomer;
@property (readonly, retain) AppSetting* appSetting;
@property (readonly, retain) Company* company;
@property (readonly, retain) PBArray * position;
@property (readonly, retain) User* sessionUser;
@property (readonly, retain) PBArray * videoCategories;
@property (readonly, retain) PBArray * videoDurationCategories;
@property (readonly, retain) PBArray * patrolMediaCategories;
@property (readonly, retain) PBArray * patrolVideoDurationCategories;
@property (readonly, retain) NSString* cameraCategory;
@property (readonly, retain) PBArray * productSpecifications;
@property (readonly, retain) PBArray * customerTags;
@property (readonly, retain) PBArray * productCategories;
@property (readonly, retain) PBArray * paperTemplates;
@property (readonly, retain) PBArray * holidayCategories;
@property (readonly, retain) PBArray * attendanceTypes;
@property (readonly, retain) PBArray * checkInChannels;
@property (readonly, retain) CheckInShift* checkInShift;
- (User*)usersAtIndex:(NSUInteger)index;
- (Function*)functionsAtIndex:(NSUInteger)index;
- (PatrolCategory*)patrolCategoriesAtIndex:(NSUInteger)index;
- (CustomerCategory*)customerCategoriesAtIndex:(NSUInteger)index;
- (CompetitionProduct*)competitionProductsAtIndex:(NSUInteger)index;
- (Product*)productsAtIndex:(NSUInteger)index;
- (AttendanceCategory*)attendanceCategoriesAtIndex:(NSUInteger)index;
- (ApplyCategory*)applyCategoriesAtIndex:(NSUInteger)index;
- (GiftProduct*)giftProductsAtIndex:(NSUInteger)index;
- (Department*)departmentsAtIndex:(NSUInteger)index;
- (GiftProductCategory*)giftProductCategoriesAtIndex:(NSUInteger)index;
- (InspectionType*)inspectionTypesAtIndex:(NSUInteger)index;
- (InspectionModel*)inspectionModelsAtIndex:(NSUInteger)index;
- (InspectionStatus*)inspectionStatusesAtIndex:(NSUInteger)index;
- (InspectionTarget*)inspectionTargetsAtIndex:(NSUInteger)index;
- (InspectionReportCategory*)inspectionReportCategoriesAtIndex:(NSUInteger)index;
- (Position*)positionAtIndex:(NSUInteger)index;
- (VideoCategory*)videoCategoriesAtIndex:(NSUInteger)index;
- (VideoDurationCategory*)videoDurationCategoriesAtIndex:(NSUInteger)index;
- (PatrolMediaCategory*)patrolMediaCategoriesAtIndex:(NSUInteger)index;
- (PatrolVideoDurationCategory*)patrolVideoDurationCategoriesAtIndex:(NSUInteger)index;
- (ProductSpecification*)productSpecificationsAtIndex:(NSUInteger)index;
- (CustomerTag*)customerTagsAtIndex:(NSUInteger)index;
- (ProductCategory*)productCategoriesAtIndex:(NSUInteger)index;
- (PaperTemplate*)paperTemplatesAtIndex:(NSUInteger)index;
- (HolidayCategory*)holidayCategoriesAtIndex:(NSUInteger)index;
- (AttendanceType*)attendanceTypesAtIndex:(NSUInteger)index;
- (CheckInChannel*)checkInChannelsAtIndex:(NSUInteger)index;

+ (SyncData*) defaultInstance;
- (SyncData*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SyncData_Builder*) builder;
+ (SyncData_Builder*) builder;
+ (SyncData_Builder*) builderWithPrototype:(SyncData*) prototype;
- (SyncData_Builder*) toBuilder;

+ (SyncData*) parseFromData:(NSData*) data;
+ (SyncData*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SyncData*) parseFromInputStream:(NSInputStream*) input;
+ (SyncData*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SyncData*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SyncData*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SyncData_Builder : PBGeneratedMessage_Builder {
@private
    SyncData* result;
}

- (SyncData*) defaultInstance;

- (SyncData_Builder*) clear;
- (SyncData_Builder*) clone;

- (SyncData*) build;
- (SyncData*) buildPartial;

- (SyncData_Builder*) mergeFrom:(SyncData*) other;
- (SyncData_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SyncData_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (PBAppendableArray *)users;
- (User*)usersAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addUsers:(User*)value;
- (SyncData_Builder *)setUsersArray:(NSArray *)array;
- (SyncData_Builder *)setUsersValues:(const User* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearUsers;

- (PBAppendableArray *)functions;
- (Function*)functionsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addFunctions:(Function*)value;
- (SyncData_Builder *)setFunctionsArray:(NSArray *)array;
- (SyncData_Builder *)setFunctionsValues:(const Function* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearFunctions;

- (PBAppendableArray *)patrolCategories;
- (PatrolCategory*)patrolCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addPatrolCategories:(PatrolCategory*)value;
- (SyncData_Builder *)setPatrolCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setPatrolCategoriesValues:(const PatrolCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearPatrolCategories;

- (PBAppendableArray *)customerCategories;
- (CustomerCategory*)customerCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addCustomerCategories:(CustomerCategory*)value;
- (SyncData_Builder *)setCustomerCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setCustomerCategoriesValues:(const CustomerCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearCustomerCategories;

- (PBAppendableArray *)competitionProducts;
- (CompetitionProduct*)competitionProductsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addCompetitionProducts:(CompetitionProduct*)value;
- (SyncData_Builder *)setCompetitionProductsArray:(NSArray *)array;
- (SyncData_Builder *)setCompetitionProductsValues:(const CompetitionProduct* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearCompetitionProducts;

- (PBAppendableArray *)products;
- (Product*)productsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addProducts:(Product*)value;
- (SyncData_Builder *)setProductsArray:(NSArray *)array;
- (SyncData_Builder *)setProductsValues:(const Product* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearProducts;

- (PBAppendableArray *)attendanceCategories;
- (AttendanceCategory*)attendanceCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addAttendanceCategories:(AttendanceCategory*)value;
- (SyncData_Builder *)setAttendanceCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setAttendanceCategoriesValues:(const AttendanceCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearAttendanceCategories;

- (PBAppendableArray *)applyCategories;
- (ApplyCategory*)applyCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addApplyCategories:(ApplyCategory*)value;
- (SyncData_Builder *)setApplyCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setApplyCategoriesValues:(const ApplyCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearApplyCategories;

- (PBAppendableArray *)giftProducts;
- (GiftProduct*)giftProductsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addGiftProducts:(GiftProduct*)value;
- (SyncData_Builder *)setGiftProductsArray:(NSArray *)array;
- (SyncData_Builder *)setGiftProductsValues:(const GiftProduct* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearGiftProducts;

- (PBAppendableArray *)departments;
- (Department*)departmentsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addDepartments:(Department*)value;
- (SyncData_Builder *)setDepartmentsArray:(NSArray *)array;
- (SyncData_Builder *)setDepartmentsValues:(const Department* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearDepartments;

- (PBAppendableArray *)giftProductCategories;
- (GiftProductCategory*)giftProductCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addGiftProductCategories:(GiftProductCategory*)value;
- (SyncData_Builder *)setGiftProductCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setGiftProductCategoriesValues:(const GiftProductCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearGiftProductCategories;

- (BOOL) hasSystemSetting;
- (SystemSetting*) systemSetting;
- (SyncData_Builder*) setSystemSetting:(SystemSetting*) value;
- (SyncData_Builder*) setSystemSettingBuilder:(SystemSetting_Builder*) builderForValue;
- (SyncData_Builder*) mergeSystemSetting:(SystemSetting*) value;
- (SyncData_Builder*) clearSystemSetting;

- (PBAppendableArray *)inspectionTypes;
- (InspectionType*)inspectionTypesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addInspectionTypes:(InspectionType*)value;
- (SyncData_Builder *)setInspectionTypesArray:(NSArray *)array;
- (SyncData_Builder *)setInspectionTypesValues:(const InspectionType* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearInspectionTypes;

- (PBAppendableArray *)inspectionModels;
- (InspectionModel*)inspectionModelsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addInspectionModels:(InspectionModel*)value;
- (SyncData_Builder *)setInspectionModelsArray:(NSArray *)array;
- (SyncData_Builder *)setInspectionModelsValues:(const InspectionModel* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearInspectionModels;

- (PBAppendableArray *)inspectionStatuses;
- (InspectionStatus*)inspectionStatusesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addInspectionStatuses:(InspectionStatus*)value;
- (SyncData_Builder *)setInspectionStatusesArray:(NSArray *)array;
- (SyncData_Builder *)setInspectionStatusesValues:(const InspectionStatus* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearInspectionStatuses;

- (PBAppendableArray *)inspectionTargets;
- (InspectionTarget*)inspectionTargetsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addInspectionTargets:(InspectionTarget*)value;
- (SyncData_Builder *)setInspectionTargetsArray:(NSArray *)array;
- (SyncData_Builder *)setInspectionTargetsValues:(const InspectionTarget* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearInspectionTargets;

- (PBAppendableArray *)inspectionReportCategories;
- (InspectionReportCategory*)inspectionReportCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addInspectionReportCategories:(InspectionReportCategory*)value;
- (SyncData_Builder *)setInspectionReportCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setInspectionReportCategoriesValues:(const InspectionReportCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearInspectionReportCategories;

- (BOOL) hasPageCustomer;
- (PageCustomer*) pageCustomer;
- (SyncData_Builder*) setPageCustomer:(PageCustomer*) value;
- (SyncData_Builder*) setPageCustomerBuilder:(PageCustomer_Builder*) builderForValue;
- (SyncData_Builder*) mergePageCustomer:(PageCustomer*) value;
- (SyncData_Builder*) clearPageCustomer;

- (BOOL) hasAppSetting;
- (AppSetting*) appSetting;
- (SyncData_Builder*) setAppSetting:(AppSetting*) value;
- (SyncData_Builder*) setAppSettingBuilder:(AppSetting_Builder*) builderForValue;
- (SyncData_Builder*) mergeAppSetting:(AppSetting*) value;
- (SyncData_Builder*) clearAppSetting;

- (BOOL) hasCompany;
- (Company*) company;
- (SyncData_Builder*) setCompany:(Company*) value;
- (SyncData_Builder*) setCompanyBuilder:(Company_Builder*) builderForValue;
- (SyncData_Builder*) mergeCompany:(Company*) value;
- (SyncData_Builder*) clearCompany;

- (PBAppendableArray *)position;
- (Position*)positionAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addPosition:(Position*)value;
- (SyncData_Builder *)setPositionArray:(NSArray *)array;
- (SyncData_Builder *)setPositionValues:(const Position* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearPosition;

- (BOOL) hasSessionUser;
- (User*) sessionUser;
- (SyncData_Builder*) setSessionUser:(User*) value;
- (SyncData_Builder*) setSessionUserBuilder:(User_Builder*) builderForValue;
- (SyncData_Builder*) mergeSessionUser:(User*) value;
- (SyncData_Builder*) clearSessionUser;

- (PBAppendableArray *)videoCategories;
- (VideoCategory*)videoCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addVideoCategories:(VideoCategory*)value;
- (SyncData_Builder *)setVideoCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setVideoCategoriesValues:(const VideoCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearVideoCategories;

- (PBAppendableArray *)videoDurationCategories;
- (VideoDurationCategory*)videoDurationCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addVideoDurationCategories:(VideoDurationCategory*)value;
- (SyncData_Builder *)setVideoDurationCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setVideoDurationCategoriesValues:(const VideoDurationCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearVideoDurationCategories;

- (PBAppendableArray *)patrolMediaCategories;
- (PatrolMediaCategory*)patrolMediaCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addPatrolMediaCategories:(PatrolMediaCategory*)value;
- (SyncData_Builder *)setPatrolMediaCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setPatrolMediaCategoriesValues:(const PatrolMediaCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearPatrolMediaCategories;

- (PBAppendableArray *)patrolVideoDurationCategories;
- (PatrolVideoDurationCategory*)patrolVideoDurationCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addPatrolVideoDurationCategories:(PatrolVideoDurationCategory*)value;
- (SyncData_Builder *)setPatrolVideoDurationCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setPatrolVideoDurationCategoriesValues:(const PatrolVideoDurationCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearPatrolVideoDurationCategories;

- (BOOL) hasCameraCategory;
- (NSString*) cameraCategory;
- (SyncData_Builder*) setCameraCategory:(NSString*) value;
- (SyncData_Builder*) clearCameraCategory;

- (PBAppendableArray *)productSpecifications;
- (ProductSpecification*)productSpecificationsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addProductSpecifications:(ProductSpecification*)value;
- (SyncData_Builder *)setProductSpecificationsArray:(NSArray *)array;
- (SyncData_Builder *)setProductSpecificationsValues:(const ProductSpecification* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearProductSpecifications;

- (PBAppendableArray *)customerTags;
- (CustomerTag*)customerTagsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addCustomerTags:(CustomerTag*)value;
- (SyncData_Builder *)setCustomerTagsArray:(NSArray *)array;
- (SyncData_Builder *)setCustomerTagsValues:(const CustomerTag* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearCustomerTags;

- (PBAppendableArray *)productCategories;
- (ProductCategory*)productCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addProductCategories:(ProductCategory*)value;
- (SyncData_Builder *)setProductCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setProductCategoriesValues:(const ProductCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearProductCategories;

- (PBAppendableArray *)paperTemplates;
- (PaperTemplate*)paperTemplatesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addPaperTemplates:(PaperTemplate*)value;
- (SyncData_Builder *)setPaperTemplatesArray:(NSArray *)array;
- (SyncData_Builder *)setPaperTemplatesValues:(const PaperTemplate* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearPaperTemplates;

- (PBAppendableArray *)holidayCategories;
- (HolidayCategory*)holidayCategoriesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addHolidayCategories:(HolidayCategory*)value;
- (SyncData_Builder *)setHolidayCategoriesArray:(NSArray *)array;
- (SyncData_Builder *)setHolidayCategoriesValues:(const HolidayCategory* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearHolidayCategories;

- (PBAppendableArray *)attendanceTypes;
- (AttendanceType*)attendanceTypesAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addAttendanceTypes:(AttendanceType*)value;
- (SyncData_Builder *)setAttendanceTypesArray:(NSArray *)array;
- (SyncData_Builder *)setAttendanceTypesValues:(const AttendanceType* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearAttendanceTypes;

- (PBAppendableArray *)checkInChannels;
- (CheckInChannel*)checkInChannelsAtIndex:(NSUInteger)index;
- (SyncData_Builder *)addCheckInChannels:(CheckInChannel*)value;
- (SyncData_Builder *)setCheckInChannelsArray:(NSArray *)array;
- (SyncData_Builder *)setCheckInChannelsValues:(const CheckInChannel* *)values count:(NSUInteger)count;
- (SyncData_Builder *)clearCheckInChannels;

- (BOOL) hasCheckInShift;
- (CheckInShift*) checkInShift;
- (SyncData_Builder*) setCheckInShift:(CheckInShift*) value;
- (SyncData_Builder*) setCheckInShiftBuilder:(CheckInShift_Builder*) builderForValue;
- (SyncData_Builder*) mergeCheckInShift:(CheckInShift*) value;
- (SyncData_Builder*) clearCheckInShift;
@end

@interface SyncDataParams : PBGeneratedMessage {
@private
    BOOL hasSyncType_:1;
    BOOL hasSyncTarget_:1;
    BOOL hasDataSourceId_:1;
    NSString* syncType;
    NSString* syncTarget;
    NSString* dataSourceId;
}
- (BOOL) hasSyncType;
- (BOOL) hasSyncTarget;
- (BOOL) hasDataSourceId;
@property (readonly, retain) NSString* syncType;
@property (readonly, retain) NSString* syncTarget;
@property (readonly, retain) NSString* dataSourceId;

+ (SyncDataParams*) defaultInstance;
- (SyncDataParams*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SyncDataParams_Builder*) builder;
+ (SyncDataParams_Builder*) builder;
+ (SyncDataParams_Builder*) builderWithPrototype:(SyncDataParams*) prototype;
- (SyncDataParams_Builder*) toBuilder;

+ (SyncDataParams*) parseFromData:(NSData*) data;
+ (SyncDataParams*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SyncDataParams*) parseFromInputStream:(NSInputStream*) input;
+ (SyncDataParams*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SyncDataParams*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SyncDataParams*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SyncDataParams_Builder : PBGeneratedMessage_Builder {
@private
    SyncDataParams* result;
}

- (SyncDataParams*) defaultInstance;

- (SyncDataParams_Builder*) clear;
- (SyncDataParams_Builder*) clone;

- (SyncDataParams*) build;
- (SyncDataParams*) buildPartial;

- (SyncDataParams_Builder*) mergeFrom:(SyncDataParams*) other;
- (SyncDataParams_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SyncDataParams_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasSyncType;
- (NSString*) syncType;
- (SyncDataParams_Builder*) setSyncType:(NSString*) value;
- (SyncDataParams_Builder*) clearSyncType;

- (BOOL) hasSyncTarget;
- (NSString*) syncTarget;
- (SyncDataParams_Builder*) setSyncTarget:(NSString*) value;
- (SyncDataParams_Builder*) clearSyncTarget;

- (BOOL) hasDataSourceId;
- (NSString*) dataSourceId;
- (SyncDataParams_Builder*) setDataSourceId:(NSString*) value;
- (SyncDataParams_Builder*) clearDataSourceId;
@end

