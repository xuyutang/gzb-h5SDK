// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "User.pb.h"

@class AppSetting;
@class AppSetting_Builder;
@class Company;
@class Company_Builder;
@class Department;
@class Department_Builder;
@class Device;
@class Device_Builder;
@class Function;
@class Function_Builder;
@class HolidayApply;
@class HolidayApply_Builder;
@class HolidayAudit;
@class HolidayAudit_Builder;
@class HolidayCategory;
@class HolidayCategory_Builder;
@class Location;
@class Location_Builder;
@class PageUser;
@class PageUser_Builder;
@class Pagination;
@class Pagination_Builder;
@class Permission;
@class Permission_Builder;
@class Position;
@class Position_Builder;
@class SystemSetting;
@class SystemSetting_Builder;
@class User;
@class UserParams;
@class UserParams_Builder;
@class User_Builder;
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


@interface HolidayRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface HolidayCategory : PBGeneratedMessage {
@private
    BOOL hasId_:1;
    BOOL hasName_:1;
    BOOL hasComment_:1;
    int32_t id;
    NSString* name;
    NSString* comment;
}
- (BOOL) hasId;
- (BOOL) hasName;
- (BOOL) hasComment;
@property (readonly) int32_t id;
@property (readonly, retain) NSString* name;
@property (readonly, retain) NSString* comment;

+ (HolidayCategory*) defaultInstance;
- (HolidayCategory*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (HolidayCategory_Builder*) builder;
+ (HolidayCategory_Builder*) builder;
+ (HolidayCategory_Builder*) builderWithPrototype:(HolidayCategory*) prototype;
- (HolidayCategory_Builder*) toBuilder;

+ (HolidayCategory*) parseFromData:(NSData*) data;
+ (HolidayCategory*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (HolidayCategory*) parseFromInputStream:(NSInputStream*) input;
+ (HolidayCategory*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (HolidayCategory*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (HolidayCategory*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface HolidayCategory_Builder : PBGeneratedMessage_Builder {
@private
    HolidayCategory* result;
}

- (HolidayCategory*) defaultInstance;

- (HolidayCategory_Builder*) clear;
- (HolidayCategory_Builder*) clone;

- (HolidayCategory*) build;
- (HolidayCategory*) buildPartial;

- (HolidayCategory_Builder*) mergeFrom:(HolidayCategory*) other;
- (HolidayCategory_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (HolidayCategory_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (int32_t) id;
- (HolidayCategory_Builder*) setId:(int32_t) value;
- (HolidayCategory_Builder*) clearId;

- (BOOL) hasName;
- (NSString*) name;
- (HolidayCategory_Builder*) setName:(NSString*) value;
- (HolidayCategory_Builder*) clearName;

- (BOOL) hasComment;
- (NSString*) comment;
- (HolidayCategory_Builder*) setComment:(NSString*) value;
- (HolidayCategory_Builder*) clearComment;
@end

@interface HolidayApply : PBGeneratedMessage {
@private
    BOOL hasId_:1;
    BOOL hasStartTime_:1;
    BOOL hasEndTime_:1;
    BOOL hasReason_:1;
    BOOL hasDeviceId_:1;
    BOOL hasUser_:1;
    BOOL hasHolidayCateory_:1;
    int32_t id;
    NSString* startTime;
    NSString* endTime;
    NSString* reason;
    NSString* deviceId;
    User* user;
    HolidayCategory* holidayCateory;
    PBAppendableArray * usersArray;
}
- (BOOL) hasId;
- (BOOL) hasUser;
- (BOOL) hasHolidayCateory;
- (BOOL) hasStartTime;
- (BOOL) hasEndTime;
- (BOOL) hasReason;
- (BOOL) hasDeviceId;
@property (readonly) int32_t id;
@property (readonly, retain) User* user;
@property (readonly, retain) HolidayCategory* holidayCateory;
@property (readonly, retain) NSString* startTime;
@property (readonly, retain) NSString* endTime;
@property (readonly, retain) NSString* reason;
@property (readonly, retain) NSString* deviceId;
@property (readonly, retain) PBArray * users;
- (User*)usersAtIndex:(NSUInteger)index;

+ (HolidayApply*) defaultInstance;
- (HolidayApply*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (HolidayApply_Builder*) builder;
+ (HolidayApply_Builder*) builder;
+ (HolidayApply_Builder*) builderWithPrototype:(HolidayApply*) prototype;
- (HolidayApply_Builder*) toBuilder;

+ (HolidayApply*) parseFromData:(NSData*) data;
+ (HolidayApply*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (HolidayApply*) parseFromInputStream:(NSInputStream*) input;
+ (HolidayApply*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (HolidayApply*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (HolidayApply*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface HolidayApply_Builder : PBGeneratedMessage_Builder {
@private
    HolidayApply* result;
}

- (HolidayApply*) defaultInstance;

- (HolidayApply_Builder*) clear;
- (HolidayApply_Builder*) clone;

- (HolidayApply*) build;
- (HolidayApply*) buildPartial;

- (HolidayApply_Builder*) mergeFrom:(HolidayApply*) other;
- (HolidayApply_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (HolidayApply_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (int32_t) id;
- (HolidayApply_Builder*) setId:(int32_t) value;
- (HolidayApply_Builder*) clearId;

- (BOOL) hasUser;
- (User*) user;
- (HolidayApply_Builder*) setUser:(User*) value;
- (HolidayApply_Builder*) setUserBuilder:(User_Builder*) builderForValue;
- (HolidayApply_Builder*) mergeUser:(User*) value;
- (HolidayApply_Builder*) clearUser;

- (BOOL) hasHolidayCateory;
- (HolidayCategory*) holidayCateory;
- (HolidayApply_Builder*) setHolidayCateory:(HolidayCategory*) value;
- (HolidayApply_Builder*) setHolidayCateoryBuilder:(HolidayCategory_Builder*) builderForValue;
- (HolidayApply_Builder*) mergeHolidayCateory:(HolidayCategory*) value;
- (HolidayApply_Builder*) clearHolidayCateory;

- (BOOL) hasStartTime;
- (NSString*) startTime;
- (HolidayApply_Builder*) setStartTime:(NSString*) value;
- (HolidayApply_Builder*) clearStartTime;

- (BOOL) hasEndTime;
- (NSString*) endTime;
- (HolidayApply_Builder*) setEndTime:(NSString*) value;
- (HolidayApply_Builder*) clearEndTime;

- (BOOL) hasReason;
- (NSString*) reason;
- (HolidayApply_Builder*) setReason:(NSString*) value;
- (HolidayApply_Builder*) clearReason;

- (BOOL) hasDeviceId;
- (NSString*) deviceId;
- (HolidayApply_Builder*) setDeviceId:(NSString*) value;
- (HolidayApply_Builder*) clearDeviceId;

- (PBAppendableArray *)users;
- (User*)usersAtIndex:(NSUInteger)index;
- (HolidayApply_Builder *)addUsers:(User*)value;
- (HolidayApply_Builder *)setUsersArray:(NSArray *)array;
- (HolidayApply_Builder *)setUsersValues:(const User* *)values count:(NSUInteger)count;
- (HolidayApply_Builder *)clearUsers;
@end

@interface HolidayAudit : PBGeneratedMessage {
@private
    BOOL hasType_:1;
    BOOL hasReason_:1;
    BOOL hasHolidayApply_:1;
    NSString* type;
    NSString* reason;
    HolidayApply* holidayApply;
}
- (BOOL) hasHolidayApply;
- (BOOL) hasType;
- (BOOL) hasReason;
@property (readonly, retain) HolidayApply* holidayApply;
@property (readonly, retain) NSString* type;
@property (readonly, retain) NSString* reason;

+ (HolidayAudit*) defaultInstance;
- (HolidayAudit*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (HolidayAudit_Builder*) builder;
+ (HolidayAudit_Builder*) builder;
+ (HolidayAudit_Builder*) builderWithPrototype:(HolidayAudit*) prototype;
- (HolidayAudit_Builder*) toBuilder;

+ (HolidayAudit*) parseFromData:(NSData*) data;
+ (HolidayAudit*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (HolidayAudit*) parseFromInputStream:(NSInputStream*) input;
+ (HolidayAudit*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (HolidayAudit*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (HolidayAudit*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface HolidayAudit_Builder : PBGeneratedMessage_Builder {
@private
    HolidayAudit* result;
}

- (HolidayAudit*) defaultInstance;

- (HolidayAudit_Builder*) clear;
- (HolidayAudit_Builder*) clone;

- (HolidayAudit*) build;
- (HolidayAudit*) buildPartial;

- (HolidayAudit_Builder*) mergeFrom:(HolidayAudit*) other;
- (HolidayAudit_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (HolidayAudit_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasHolidayApply;
- (HolidayApply*) holidayApply;
- (HolidayAudit_Builder*) setHolidayApply:(HolidayApply*) value;
- (HolidayAudit_Builder*) setHolidayApplyBuilder:(HolidayApply_Builder*) builderForValue;
- (HolidayAudit_Builder*) mergeHolidayApply:(HolidayApply*) value;
- (HolidayAudit_Builder*) clearHolidayApply;

- (BOOL) hasType;
- (NSString*) type;
- (HolidayAudit_Builder*) setType:(NSString*) value;
- (HolidayAudit_Builder*) clearType;

- (BOOL) hasReason;
- (NSString*) reason;
- (HolidayAudit_Builder*) setReason:(NSString*) value;
- (HolidayAudit_Builder*) clearReason;
@end

