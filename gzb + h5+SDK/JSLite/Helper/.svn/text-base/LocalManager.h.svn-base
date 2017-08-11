#import <Foundation/Foundation.h>
#import "Model.h"
#import "FMDatabase.h"

#define KEY_YES @"1"
#define KEY_NO @"0"

#define KEY_SYNC_TIME @"SyncTime"
#define KEY_SYNC_CUSTOMER_TIME @"SyncCustomerTime"
#define KEY_SYNC_STATUS @"SyncStatus"
#define KEY_SYNC_CUSTOMER_STATUS @"SyncCustomerStatus"
#define KEY_SYNC_CUSTOMER_PAGE @"SyncCustomerPage"
#define KEY_SYNC_CUSTOMER_TOTAL_SIZE @"SyncCustomerTotalSize"
#define KEY_SYNC_CUSTOMER_CURRENT_SIZE @"SyncCustomerCurrentSize"
#define KEY_SYNC_CUSTOMER_PAGE_SIZE @"SyncCustomerPageSize"
#define KEY_COUNT_CUSTOMER_CATEGORY @"CountCustomerCategory"
#define KEY_COUNT_PATROL_CATEGORY @"CountPatrolCategory"
#define KEY_COUNT_PRODUCT @"CountProduct"
#define KEY_COUNT_COMPETITION_PRODUCT @"CountCompetitionProduct"
#define KEY_COUNT_PRODUCT_SUPPLY @"CountProductSupply"
#define KEY_COUNT_USER @"CountUser"
#define KEY_COUNT_USER_CONTACT @"CountUserContact"
#define KEY_COUNT_CURRENT_CUSTOMER @"CountCurrentCustomer"
#define KEY_COUNT_CUSTOMER @"CountCustomer"
#define KEY_COUNT_INSPECTION @"CountInspection"
#define KEY_COUNT_VIDEOCATETORY @"CountVideoCategory"
#define KEY_COUNT_VIDEO_DURATION @"CountVideoDuration"

#define KEY_COUNT_DEPARTMENT @"CountDepartment"
#define KEY_COUNT_GIF_PRODUCT @"CountGifProduct"
#define KEY_COUNT_APPLY_CATEGORY @"CoutApplyCategory"
#define KEY_COUNT_GIF_PRODUCT_CATEGORY @"CountProductCategory"
#define KEY_COUNT_ATTENDANCE_CATEGORY @"CountAttenDanceCategory"

#define KEY_CHECKIN_DATE @"CheckInDate"
#define KEY_CHECKOUT_DATE @"CheckOutDate"
#define KEY_UPDATE_FUNCKEY @"Update_%d"
#define KEY_APP_TITLE @"AppTitle"
#define KEY_MESSAGE @"MessageSetting"

#define KEY_CUSTOMERTAG_MAX_COUNT @"KEY_CUSTOMERTAG_MAX_COUNT"
#define KEY_CUSTOMERTAG_COUNT @"KEY_CUSTOMERTAG_COUNT"
#define KEY_PRODUCT_SPEC_MAX_COUNT @"KEY_PRODUCT_SPEC_MAX_COUNT"
#define KEY_PRODUCT_SPEC_COUNT @"KEY_PRODUCT_SPEC_COUNT"
#define KEY_LOCATION_INTERVAL  @"KEY_LOCATION_INTERVAL"

#define KEY_APP_VERSION @"APP_VERSION"


@class RequestAgent;
@interface LocalManager : NSObject
{
    NSString* dbPath;
}

+ (LocalManager*) sharedInstance;

- (BOOL) saveFunctions:(PBArray*) functions;
- (NSMutableArray*) getFunctions;
- (BOOL) favFunctions:(PBArray*) functions;
- (BOOL) favFunction:(NSString*) funcName;
- (NSMutableArray*) getFavFunctions;
- (BOOL) hasFunction:(NSString*) functionName;
- (NSString*) getFunctionNameWithDes:(NSString *) funcDes;
- (BOOL) deleteFunctionWithDes:(NSString *) funcDes;

- (BOOL) saveCustomerCategories:(PBArray*) customerCategories;
- (NSMutableArray*) getCustomerCategories;
//假休模块
- (BOOL) saveHolidayCategories:(PBArray*) holidayCategoies;
- (NSMutableArray*) getHolidayCategories;

- (BOOL) savePatrolCategories:(PBArray*) patrolCategories;
- (BOOL) favPatrolCategory:(PatrolCategory*) pc Fav:(int)fav;
- (NSMutableArray*) getPatrolCategories;
- (NSMutableArray*) getFavPatrolCategories;

- (BOOL) saveMessages:(PBArray*) messages;
- (BOOL) saveMessage:(SessionMessage*) wtm;
- (NSMutableArray*) getMessages;
- (int) getMessagesCount:(int) userId;
- (int) getUnReadMessageCountWithUser:(int) userId;
- (NSMutableArray*) getUnReadMessagesWithUser:(int) userId;
- (NSMutableArray*) getUsersByMessage;
- (User*) getUserByMessage:(int)messageId;
- (NSMutableArray*) getMessages:(int) pageSize UserId:(int) userId;
- (SysMessage*) getLastestMessage:(int) userId;
- (BOOL) readMessage:(int)type SourceId:(NSString*) sourceId;
- (BOOL) readMessage:(int) userId;
- (BOOL) deleteMessage:(int) userId;
    
- (BOOL) saveAnnounces:(PBArray*) announces;
- (BOOL) saveAnnounce:(SessionMessage*) wtm;
- (BOOL) saveAnnounce2:(Announce*) a;
- (NSMutableArray*) getAnnounces;
//发通知者信息
-(BOOL)saveAnnounceSender:(User*)sender;
-(NSMutableArray*)getAnnouncesenders;
-(BOOL)updateAnnounceSender:(User*)sender;

//我发出的通知
-(BOOL)saveMyAnnounce:(Announce*)an;
-(NSMutableArray*)getMyAnnounce;

- (int) getAnnouncesCount;
- (int) getUnReadAnnouncesCount;
- (NSMutableArray*) getAnnounces:(int) pageSize;
- (Announce*) getLastestAnnounce;
- (Announce*) getLastestUnReadAnnounce;
- (NSMutableArray*) getAllUnreceivedAnnounces;
- (BOOL) setReadedAnnounceStatus:(Announce *)announce;
- (BOOL) setReceivedAnnouncesStatus:(PBArray *)announces;
- (BOOL) deleteAnnounce:(Announce *)announce;
- (BOOL) deleteAnnounce;
//下属
- (BOOL) saveUsers:(PBArray*) users;
- (NSMutableArray*) getUsers;
//通讯录
- (BOOL) saveAllUsers:(PBArray*) users;
- (NSMutableArray*) getAllUsers;
//用户登录ID
- (BOOL) saveLatestUserId:(NSString *)userId;
- (NSString *)getLatestUserId;

- (NSMutableArray*) getProducts;
- (NSMutableArray*) getProductSupplies:(int) customerId;
- (NSMutableArray*) getProducts:(int) customerId PruductName:(NSString*) name Index:(int) index;
- (NSMutableArray*) getProducts:(NSString*) name Index:(int) index;
- (int) getProductTotal:(int) customerId PruductName:(NSString*) name;
- (int) getProductTotal:(NSString*) name;
- (NSMutableArray*) getFavProducts;
- (BOOL) favProduct:(Product*) p Fav:(int)fav;

-(BOOL) hasFavCustomer:(Customer *) c;
- (BOOL) saveCustomers:(PBArray*) customers;
- (BOOL) saveCustomer:(Customer*) customer;
- (BOOL) saveCustomersWithSync:(PBArray*) customers;
- (BOOL) clearCustomerWithSync;
- (NSMutableArray*) getCustomers;
- (NSMutableArray*) getCustomers2:(int) categoryId;
- (NSMutableArray*) getCustomers:(int) categoryId;
- (NSMutableArray*) getCustomers:(int) categoryId UserId:(int) userId;
- (BOOL) favCustomer:(Customer*) customer Fav:(int)fav;
- (NSMutableArray*) getFavCustomers;
- (NSMutableArray*) getFavCustomersWithName:(NSString *) name;
- (NSMutableArray*) getCustomerContacts:(int) customerId;
- (Contact*) getContactWithCustomer:(Customer*) c;

- (BOOL) saveProducts:(PBArray*) products;
- (BOOL) saveCompetitionProducts:(PBArray*) competitionProducts;
- (NSMutableArray*) getCompetitionProducts;
- (NSMutableArray*) getCompetitionProducts:(NSString*) name Index:(int) index;
- (int) getCompetitionProductTotal:(NSString*) name;

- (NSMutableArray*) getWorkLogs:(int) limit;
- (BOOL) saveWorkLog:(WorkLog*) workLog;
- (BOOL) saveAttendanceCategories:(PBArray*) attendanceCategoies;
- (NSMutableArray*) getAttendanceCategories;
- (BOOL) saveLoginUser:(User*) user;
- (BOOL) saveCompany:(Company*) company;
- (BOOL) updateCompanyWithAvatar:(NSData* )image;
- (NSString*) getCompanyAvatar;
- (User*) getLoginUser;
- (BOOL) cleanLoginUser;
- (NSString*) isUserExpire:(User*)user;
- (BOOL) validateUserExpire:(User*)user;
- (BOOL) setUserExpire:(User*)user ExceptionMessage:(ExceptionMessage*)exceptionMessage;
//清除上一个登录用户的部分数据（功能、通知、消息）
- (BOOL) cleanLatestUserData;
- (Location*) getLocation;
- (BOOL) saveLocation:(Location*) location;

- (BOOL) saveLocationSetting:(int) value;
- (int) getLocationSetting;

- (BOOL) saveDeviceId;
- (NSString*) getDeviceId;
- (void) saveDeviceIdToKeychain:(NSString*) deviceId;

- (BOOL) saveModel;
- (NSString *)getModel;

/*
 *功能更新检测
 */
-(BOOL) setFuncSync:(int) funcID;

-(BOOL) isFuncSync:(int) funcID;

/**
 *KVO 存储 & 获取
 */
-(BOOL) saveKvo:(NSString *) value key:(NSString *) key;
- (NSString*) getKvoByKey:(NSString *) key;
/*
 * 保存Apple返回的消息Device Token
 */
- (BOOL) saveDeviceToken:(NSString *)deviceToken;
- (NSString *)getDeviceToken;

- (BOOL) saveValueToUserDefaults:(NSString*) key Value:(NSString*) value;
- (NSString*) getValueFromUserDefaults:(NSString*) key;

- (BOOL) saveMessageSetting:(int) value;
- (int) getMessageSetting;

- (NSString*) getCheckInDate;

- (NSString*) saveImage:(NSData*) image;
- (void) clearImages;
- (void) clearImagesWithFiles:(NSMutableArray*) files;

/*
 * 获取省、市、区
 */
- (NSMutableArray*) getProvinces;
- (NSMutableArray*) getCities:(NSString*) provinceName;
- (NSMutableArray*) getAreas:(NSString*) cityName;

- (NSString*) getProvince:(NSString*) postId;
- (NSString*) getCity:(NSString*) postId;
- (NSString*) getArea:(NSString*) postId;

- (NSString*) getProvincePostIdWithName:(NSString*) name;
- (NSString*) getCityPostIdWithName:(NSString*) name;
- (NSString*) getAreaPostIdWithName:(NSString*) name;

/*
 * 审批类型
 */
- (BOOL) saveApplyCategories:(PBArray*) categories;
- (NSMutableArray*) getApplyCategories;

/*
 * 赠品类型
 */
- (BOOL) saveGiftProductCategories:(PBArray*) categories;
- (NSMutableArray*) getGiftProductCategories;

/*
 * 赠品
 */
- (BOOL) saveGiftProducts:(PBArray*) products;
- (NSMutableArray*) getGiftProductsWithGiftName:(NSString*) name CategoryId:(int) categoryId Index:(int) index;

/*
 * 部门
 */
- (BOOL) saveDepartments:(PBArray*) depts;
- (NSMutableArray*) getDepartments;

/*
 * 巡检类型
 */
- (BOOL) saveInspectionCategories:(PBArray*) categories;
- (NSMutableArray*) getInspectionCategories;

/*
 * 巡检状态
 */
- (BOOL) saveInspectionStatus:(PBArray*) status;
- (NSMutableArray*) getInspectionStatus;
-(NSMutableArray *) getInspectionStatusWithModelId:(int) modelid;
-(NSMutableArray *) getInspectionDefaultStatusWithModelId:(int) modelid;
/*
 * 巡检大类
 */
- (BOOL) saveInspectionTypes:(PBArray*) types;
- (NSMutableArray*) getInspectionTypes;
/*
 * 巡检型号
 */
- (BOOL) saveInspectionModels:(PBArray*) models;

/*
 * 巡检对象
 */
- (BOOL) saveInspectionTargets:(PBArray*) inspections;
- (NSMutableArray*) getInspectionTargetsWithName:(NSString*) name Index:(int) index;
- (NSMutableArray*) getInspectionTargetsWithName:(NSString*) name;
- (NSMutableArray*) getInspectionTargetsWithChildPage:(int) index parentId:(int)parentId;
- (NSMutableArray*) getInspectionTargetsWithParentId:(int)parentId;
- (int) getInspectionTargetsTotalCountWithParentId:(int)parentId;

//- (BOOL)saveSplashImage;
/*
 * 检查更新
 */
- (void) checkVersion;

/*
 * 本地数据缓存
 */
- (BOOL) saveCache:(int) funcId Content:(NSData*) content;
- (NSMutableArray*) getCacheWithFuncId:(int) funcId Index:(int) index;
- (BOOL) deleteCache:(int) funcId Content:(NSData*) content;
- (int) getCacheCount;
-(int) getCacheCountWithFuncId:(int) funcId;

/*
 * 视频类型
 */
- (BOOL) saveVideoCategories:(PBArray*) categories;
- (NSMutableArray*) getVideoCategories;

/*
 * 视频长度类型
 */
- (BOOL) saveVideoDurationCategories:(PBArray*) categories;
- (NSMutableArray*) getVideoDurationCategories;
- (BOOL) favVideoDurationCategory:(int) categoryId;
- (VideoDurationCategory*) getFavVideoDurationCategory;

/*
 * 视频长度类型
 */
- (BOOL) savePatrolVideoDurationCategories:(PBArray*) categories;
- (NSMutableArray*) getPatrolVideoDurationCategories;
- (BOOL) favPatrolVideoDurationCategory:(int) categoryId;
- (PatrolVideoDurationCategory*) getFavPatrolVideoDurationCategory;

/*
 * 巡访媒体类型
 */
- (BOOL) savePatrolMediaCategories:(PBArray*) categories;
- (NSMutableArray*) getPatrolMediaCategories;

/*
 * 常用语
 */
- (BOOL) saveFavoriteLangs:(PBArray*) langs SortIds:(NSArray*) sortIds;
- (NSMutableArray*) getFavoriteLangs;
- (BOOL) saveFavoriteLang:(FavoriteLang*) lang Status:(int) status;

/*
 * 客户标签
 */
- (BOOL) saveCustomerTags:(PBArray*) tags;
- (NSMutableArray*) getCustomerTags;
- (CustomerTag*) getCustomerTagWithId:(int) tagId;
- (CustomerTag *) getCustomerTagWithTagValueId:(int) valueId;
- (NSMutableArray*) getCustomerTagValuesWithTagId:(int)tagId;
- (NSMutableArray*) getCustomerTagValuesWithPartentId:(int)parentId;

/*
 * 产品类型，规格
 */
- (BOOL) saveProductCategories:(PBArray*) categories;
- (NSMutableArray*) getProductCategories;
- (BOOL) saveProductSpecifications:(PBArray*) specs;
- (NSMutableArray*) getProductSpecifications;
- (NSMutableArray*) getProductSpecificationsWithSpecId:(int)specId;

/*
 * 自定义模板
 */
- (BOOL) savePaperTemplates:(PBArray*) templates;
- (NSMutableArray*) getPaperTemplates;
- (BOOL) favPaperTemplate:(NSString*) templateId;
- (PaperTemplate*) getFavPaperTempate;
/*
 * 考勤类型 ATTENDANCE/CHECK_IN
 */
-(BOOL)saveAttendanceTypes:(PBArray*)attendancetypes;
-(NSMutableArray*)getAttendanceTypes;

/*
 * Channels GPS/WIFI
 */
-(BOOL)saveCheckInChannels:(PBArray*)checkInChannels;
-(NSMutableArray*)getCheckInChannels;

/*
 * 班次信息表
 * 打卡记录表
 * 工作日表
 */
-(BOOL)saveChenkInShift:(CheckInShift*)checkInshift;
-(CheckInShift*)getCheckInshift;
//假期
-(BOOL)saveHolidays:(PBArray*)holidays;
-(NSMutableArray*)getHolidays;

//打卡记录
-(BOOL)saveShiftGroup:(PBArray*)track;
-(NSMutableArray*)getShiftGroup;

//权限 id name  value
-(BOOL)saveUserPermission:(User*)user;
-(NSMutableArray*)getUserPermisson;

@property (strong, nonatomic) Location *myLocation;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) AppSetting* appSetting;
@property (strong, nonatomic) RequestAgent *agent;

@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong) NSManagedObjectModel *managedObjectModel;
@property (strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong) NSURL *storeURL;

@end 
