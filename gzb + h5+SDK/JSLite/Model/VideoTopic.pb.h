// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "Generic.pb.h"
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
@class Location;
@class Location_Builder;
@class PageUser;
@class PageUser_Builder;
@class PageVideoTopic;
@class PageVideoTopic_Builder;
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


@interface VideoTopicRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface VideoTopic : PBGeneratedMessage {
@private
  BOOL hasId_:1;
  BOOL hasReplyCount_:1;
  BOOL hasComment_:1;
  BOOL hasCreateDate_:1;
  BOOL hasUploadDate_:1;
  BOOL hasTitle_:1;
  BOOL hasUser_:1;
  BOOL hasLocation_:1;
  BOOL hasUploadLocation_:1;
  BOOL hasCategory_:1;
  int32_t id;
  int32_t replyCount;
  NSString* comment;
  NSString* createDate;
  NSString* uploadDate;
  NSString* title;
  User* user;
  Location* location;
  Location* uploadLocation;
  VideoCategory* category;
  PBAppendableArray * videoPixelsArray;
  PBAppendableArray * videoDurationsArray;
  PBAppendableArray * videoSizesArray;
  PBAppendableArray * videoPathsArray;
  PBAppendableArray * filePathsArray;
  PBAppendableArray * videoTopicRepliesArray;
  PBAppendableArray * videoDurationCategoriesArray;
  PBAppendableArray * videosArray;
  PBAppendableArray * filesArray;
}
- (BOOL) hasId;
- (BOOL) hasUser;
- (BOOL) hasComment;
- (BOOL) hasLocation;
- (BOOL) hasCreateDate;
- (BOOL) hasUploadDate;
- (BOOL) hasCategory;
- (BOOL) hasReplyCount;
- (BOOL) hasTitle;
- (BOOL) hasUploadLocation;
@property (readonly) int32_t id;
@property (readonly, retain) User* user;
@property (readonly, retain) NSString* comment;
@property (readonly, retain) Location* location;
@property (readonly, retain) NSString* createDate;
@property (readonly, retain) NSString* uploadDate;
@property (readonly, retain) PBArray * files;
@property (readonly, retain) PBArray * filePaths;
@property (readonly, retain) PBArray * videos;
@property (readonly, retain) PBArray * videoPaths;
@property (readonly, retain) VideoCategory* category;
@property (readonly, retain) PBArray * videoTopicReplies;
@property (readonly) int32_t replyCount;
@property (readonly, retain) NSString* title;
@property (readonly, retain) Location* uploadLocation;
@property (readonly, retain) PBArray * videoSizes;
@property (readonly, retain) PBArray * videoDurations;
@property (readonly, retain) PBArray * videoPixels;
@property (readonly, retain) PBArray * videoDurationCategories;
- (NSData*)filesAtIndex:(NSUInteger)index;
- (NSString*)filePathsAtIndex:(NSUInteger)index;
- (NSData*)videosAtIndex:(NSUInteger)index;
- (NSString*)videoPathsAtIndex:(NSUInteger)index;
- (VideoTopicReply*)videoTopicRepliesAtIndex:(NSUInteger)index;
- (NSString*)videoSizesAtIndex:(NSUInteger)index;
- (NSString*)videoDurationsAtIndex:(NSUInteger)index;
- (NSString*)videoPixelsAtIndex:(NSUInteger)index;
- (VideoDurationCategory*)videoDurationCategoriesAtIndex:(NSUInteger)index;

+ (VideoTopic*) defaultInstance;
- (VideoTopic*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (VideoTopic_Builder*) builder;
+ (VideoTopic_Builder*) builder;
+ (VideoTopic_Builder*) builderWithPrototype:(VideoTopic*) prototype;
- (VideoTopic_Builder*) toBuilder;

+ (VideoTopic*) parseFromData:(NSData*) data;
+ (VideoTopic*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoTopic*) parseFromInputStream:(NSInputStream*) input;
+ (VideoTopic*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoTopic*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (VideoTopic*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface VideoTopic_Builder : PBGeneratedMessage_Builder {
@private
  VideoTopic* result;
}

- (VideoTopic*) defaultInstance;

- (VideoTopic_Builder*) clear;
- (VideoTopic_Builder*) clone;

- (VideoTopic*) build;
- (VideoTopic*) buildPartial;

- (VideoTopic_Builder*) mergeFrom:(VideoTopic*) other;
- (VideoTopic_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (VideoTopic_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (int32_t) id;
- (VideoTopic_Builder*) setId:(int32_t) value;
- (VideoTopic_Builder*) clearId;

- (BOOL) hasUser;
- (User*) user;
- (VideoTopic_Builder*) setUser:(User*) value;
- (VideoTopic_Builder*) setUserBuilder:(User_Builder*) builderForValue;
- (VideoTopic_Builder*) mergeUser:(User*) value;
- (VideoTopic_Builder*) clearUser;

- (BOOL) hasComment;
- (NSString*) comment;
- (VideoTopic_Builder*) setComment:(NSString*) value;
- (VideoTopic_Builder*) clearComment;

- (BOOL) hasLocation;
- (Location*) location;
- (VideoTopic_Builder*) setLocation:(Location*) value;
- (VideoTopic_Builder*) setLocationBuilder:(Location_Builder*) builderForValue;
- (VideoTopic_Builder*) mergeLocation:(Location*) value;
- (VideoTopic_Builder*) clearLocation;

- (BOOL) hasCreateDate;
- (NSString*) createDate;
- (VideoTopic_Builder*) setCreateDate:(NSString*) value;
- (VideoTopic_Builder*) clearCreateDate;

- (BOOL) hasUploadDate;
- (NSString*) uploadDate;
- (VideoTopic_Builder*) setUploadDate:(NSString*) value;
- (VideoTopic_Builder*) clearUploadDate;

- (PBAppendableArray *)files;
- (NSData*)filesAtIndex:(NSUInteger)index;
- (VideoTopic_Builder *)addFiles:(NSData*)value;
- (VideoTopic_Builder *)setFilesArray:(NSArray *)array;
- (VideoTopic_Builder *)setFilesValues:(const NSData* *)values count:(NSUInteger)count;
- (VideoTopic_Builder *)clearFiles;

- (PBAppendableArray *)filePaths;
- (NSString*)filePathsAtIndex:(NSUInteger)index;
- (VideoTopic_Builder *)addFilePaths:(NSString*)value;
- (VideoTopic_Builder *)setFilePathsArray:(NSArray *)array;
- (VideoTopic_Builder *)setFilePathsValues:(const NSString* *)values count:(NSUInteger)count;
- (VideoTopic_Builder *)clearFilePaths;

- (PBAppendableArray *)videos;
- (NSData*)videosAtIndex:(NSUInteger)index;
- (VideoTopic_Builder *)addVideos:(NSData*)value;
- (VideoTopic_Builder *)setVideosArray:(NSArray *)array;
- (VideoTopic_Builder *)setVideosValues:(const NSData* *)values count:(NSUInteger)count;
- (VideoTopic_Builder *)clearVideos;

- (PBAppendableArray *)videoPaths;
- (NSString*)videoPathsAtIndex:(NSUInteger)index;
- (VideoTopic_Builder *)addVideoPaths:(NSString*)value;
- (VideoTopic_Builder *)setVideoPathsArray:(NSArray *)array;
- (VideoTopic_Builder *)setVideoPathsValues:(const NSString* *)values count:(NSUInteger)count;
- (VideoTopic_Builder *)clearVideoPaths;

- (BOOL) hasCategory;
- (VideoCategory*) category;
- (VideoTopic_Builder*) setCategory:(VideoCategory*) value;
- (VideoTopic_Builder*) setCategoryBuilder:(VideoCategory_Builder*) builderForValue;
- (VideoTopic_Builder*) mergeCategory:(VideoCategory*) value;
- (VideoTopic_Builder*) clearCategory;

- (PBAppendableArray *)videoTopicReplies;
- (VideoTopicReply*)videoTopicRepliesAtIndex:(NSUInteger)index;
- (VideoTopic_Builder *)addVideoTopicReplies:(VideoTopicReply*)value;
- (VideoTopic_Builder *)setVideoTopicRepliesArray:(NSArray *)array;
- (VideoTopic_Builder *)setVideoTopicRepliesValues:(const VideoTopicReply* *)values count:(NSUInteger)count;
- (VideoTopic_Builder *)clearVideoTopicReplies;

- (BOOL) hasReplyCount;
- (int32_t) replyCount;
- (VideoTopic_Builder*) setReplyCount:(int32_t) value;
- (VideoTopic_Builder*) clearReplyCount;

- (BOOL) hasTitle;
- (NSString*) title;
- (VideoTopic_Builder*) setTitle:(NSString*) value;
- (VideoTopic_Builder*) clearTitle;

- (BOOL) hasUploadLocation;
- (Location*) uploadLocation;
- (VideoTopic_Builder*) setUploadLocation:(Location*) value;
- (VideoTopic_Builder*) setUploadLocationBuilder:(Location_Builder*) builderForValue;
- (VideoTopic_Builder*) mergeUploadLocation:(Location*) value;
- (VideoTopic_Builder*) clearUploadLocation;

- (PBAppendableArray *)videoSizes;
- (NSString*)videoSizesAtIndex:(NSUInteger)index;
- (VideoTopic_Builder *)addVideoSizes:(NSString*)value;
- (VideoTopic_Builder *)setVideoSizesArray:(NSArray *)array;
- (VideoTopic_Builder *)setVideoSizesValues:(const NSString* *)values count:(NSUInteger)count;
- (VideoTopic_Builder *)clearVideoSizes;

- (PBAppendableArray *)videoDurations;
- (NSString*)videoDurationsAtIndex:(NSUInteger)index;
- (VideoTopic_Builder *)addVideoDurations:(NSString*)value;
- (VideoTopic_Builder *)setVideoDurationsArray:(NSArray *)array;
- (VideoTopic_Builder *)setVideoDurationsValues:(const NSString* *)values count:(NSUInteger)count;
- (VideoTopic_Builder *)clearVideoDurations;

- (PBAppendableArray *)videoPixels;
- (NSString*)videoPixelsAtIndex:(NSUInteger)index;
- (VideoTopic_Builder *)addVideoPixels:(NSString*)value;
- (VideoTopic_Builder *)setVideoPixelsArray:(NSArray *)array;
- (VideoTopic_Builder *)setVideoPixelsValues:(const NSString* *)values count:(NSUInteger)count;
- (VideoTopic_Builder *)clearVideoPixels;

- (PBAppendableArray *)videoDurationCategories;
- (VideoDurationCategory*)videoDurationCategoriesAtIndex:(NSUInteger)index;
- (VideoTopic_Builder *)addVideoDurationCategories:(VideoDurationCategory*)value;
- (VideoTopic_Builder *)setVideoDurationCategoriesArray:(NSArray *)array;
- (VideoTopic_Builder *)setVideoDurationCategoriesValues:(const VideoDurationCategory* *)values count:(NSUInteger)count;
- (VideoTopic_Builder *)clearVideoDurationCategories;
@end

@interface VideoTopicReply : PBGeneratedMessage {
@private
  BOOL hasId_:1;
  BOOL hasVideoTopicId_:1;
  BOOL hasContent_:1;
  BOOL hasCreateDate_:1;
  BOOL hasSender_:1;
  int32_t id;
  int32_t videoTopicId;
  NSString* content;
  NSString* createDate;
  User* sender;
  PBAppendableArray * filePathArray;
  PBAppendableArray * receiversArray;
  PBAppendableArray * filesArray;
}
- (BOOL) hasId;
- (BOOL) hasVideoTopicId;
- (BOOL) hasSender;
- (BOOL) hasContent;
- (BOOL) hasCreateDate;
@property (readonly) int32_t id;
@property (readonly) int32_t videoTopicId;
@property (readonly, retain) User* sender;
@property (readonly, retain) PBArray * receivers;
@property (readonly, retain) NSString* content;
@property (readonly, retain) NSString* createDate;
@property (readonly, retain) PBArray * files;
@property (readonly, retain) PBArray * filePath;
- (User*)receiversAtIndex:(NSUInteger)index;
- (NSData*)filesAtIndex:(NSUInteger)index;
- (NSString*)filePathAtIndex:(NSUInteger)index;

+ (VideoTopicReply*) defaultInstance;
- (VideoTopicReply*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (VideoTopicReply_Builder*) builder;
+ (VideoTopicReply_Builder*) builder;
+ (VideoTopicReply_Builder*) builderWithPrototype:(VideoTopicReply*) prototype;
- (VideoTopicReply_Builder*) toBuilder;

+ (VideoTopicReply*) parseFromData:(NSData*) data;
+ (VideoTopicReply*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoTopicReply*) parseFromInputStream:(NSInputStream*) input;
+ (VideoTopicReply*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoTopicReply*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (VideoTopicReply*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface VideoTopicReply_Builder : PBGeneratedMessage_Builder {
@private
  VideoTopicReply* result;
}

- (VideoTopicReply*) defaultInstance;

- (VideoTopicReply_Builder*) clear;
- (VideoTopicReply_Builder*) clone;

- (VideoTopicReply*) build;
- (VideoTopicReply*) buildPartial;

- (VideoTopicReply_Builder*) mergeFrom:(VideoTopicReply*) other;
- (VideoTopicReply_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (VideoTopicReply_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (int32_t) id;
- (VideoTopicReply_Builder*) setId:(int32_t) value;
- (VideoTopicReply_Builder*) clearId;

- (BOOL) hasVideoTopicId;
- (int32_t) videoTopicId;
- (VideoTopicReply_Builder*) setVideoTopicId:(int32_t) value;
- (VideoTopicReply_Builder*) clearVideoTopicId;

- (BOOL) hasSender;
- (User*) sender;
- (VideoTopicReply_Builder*) setSender:(User*) value;
- (VideoTopicReply_Builder*) setSenderBuilder:(User_Builder*) builderForValue;
- (VideoTopicReply_Builder*) mergeSender:(User*) value;
- (VideoTopicReply_Builder*) clearSender;

- (PBAppendableArray *)receivers;
- (User*)receiversAtIndex:(NSUInteger)index;
- (VideoTopicReply_Builder *)addReceivers:(User*)value;
- (VideoTopicReply_Builder *)setReceiversArray:(NSArray *)array;
- (VideoTopicReply_Builder *)setReceiversValues:(const User* *)values count:(NSUInteger)count;
- (VideoTopicReply_Builder *)clearReceivers;

- (BOOL) hasContent;
- (NSString*) content;
- (VideoTopicReply_Builder*) setContent:(NSString*) value;
- (VideoTopicReply_Builder*) clearContent;

- (BOOL) hasCreateDate;
- (NSString*) createDate;
- (VideoTopicReply_Builder*) setCreateDate:(NSString*) value;
- (VideoTopicReply_Builder*) clearCreateDate;

- (PBAppendableArray *)files;
- (NSData*)filesAtIndex:(NSUInteger)index;
- (VideoTopicReply_Builder *)addFiles:(NSData*)value;
- (VideoTopicReply_Builder *)setFilesArray:(NSArray *)array;
- (VideoTopicReply_Builder *)setFilesValues:(const NSData* *)values count:(NSUInteger)count;
- (VideoTopicReply_Builder *)clearFiles;

- (PBAppendableArray *)filePath;
- (NSString*)filePathAtIndex:(NSUInteger)index;
- (VideoTopicReply_Builder *)addFilePath:(NSString*)value;
- (VideoTopicReply_Builder *)setFilePathArray:(NSArray *)array;
- (VideoTopicReply_Builder *)setFilePathValues:(const NSString* *)values count:(NSUInteger)count;
- (VideoTopicReply_Builder *)clearFilePath;
@end

@interface PageVideoTopic : PBGeneratedMessage {
@private
  BOOL hasPage_:1;
  Pagination* page;
  PBAppendableArray * videoTopicsArray;
}
- (BOOL) hasPage;
@property (readonly, retain) Pagination* page;
@property (readonly, retain) PBArray * videoTopics;
- (VideoTopic*)videoTopicsAtIndex:(NSUInteger)index;

+ (PageVideoTopic*) defaultInstance;
- (PageVideoTopic*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (PageVideoTopic_Builder*) builder;
+ (PageVideoTopic_Builder*) builder;
+ (PageVideoTopic_Builder*) builderWithPrototype:(PageVideoTopic*) prototype;
- (PageVideoTopic_Builder*) toBuilder;

+ (PageVideoTopic*) parseFromData:(NSData*) data;
+ (PageVideoTopic*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PageVideoTopic*) parseFromInputStream:(NSInputStream*) input;
+ (PageVideoTopic*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PageVideoTopic*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (PageVideoTopic*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface PageVideoTopic_Builder : PBGeneratedMessage_Builder {
@private
  PageVideoTopic* result;
}

- (PageVideoTopic*) defaultInstance;

- (PageVideoTopic_Builder*) clear;
- (PageVideoTopic_Builder*) clone;

- (PageVideoTopic*) build;
- (PageVideoTopic*) buildPartial;

- (PageVideoTopic_Builder*) mergeFrom:(PageVideoTopic*) other;
- (PageVideoTopic_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PageVideoTopic_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasPage;
- (Pagination*) page;
- (PageVideoTopic_Builder*) setPage:(Pagination*) value;
- (PageVideoTopic_Builder*) setPageBuilder:(Pagination_Builder*) builderForValue;
- (PageVideoTopic_Builder*) mergePage:(Pagination*) value;
- (PageVideoTopic_Builder*) clearPage;

- (PBAppendableArray *)videoTopics;
- (VideoTopic*)videoTopicsAtIndex:(NSUInteger)index;
- (PageVideoTopic_Builder *)addVideoTopics:(VideoTopic*)value;
- (PageVideoTopic_Builder *)setVideoTopicsArray:(NSArray *)array;
- (PageVideoTopic_Builder *)setVideoTopicsValues:(const VideoTopic* *)values count:(NSUInteger)count;
- (PageVideoTopic_Builder *)clearVideoTopics;
@end

@interface VideoTopicParams : PBGeneratedMessage {
@private
  BOOL hasPage_:1;
  BOOL hasStartDate_:1;
  BOOL hasEndDate_:1;
  BOOL hasSource_:1;
  BOOL hasCategory_:1;
  int32_t page;
  NSString* startDate;
  NSString* endDate;
  NSString* source;
  VideoCategory* category;
  PBAppendableArray * paramUsersArray;
  PBAppendableArray * departmentsArray;
}
- (BOOL) hasCategory;
- (BOOL) hasPage;
- (BOOL) hasStartDate;
- (BOOL) hasEndDate;
- (BOOL) hasSource;
@property (readonly, retain) VideoCategory* category;
@property (readonly) int32_t page;
@property (readonly, retain) PBArray * paramUsers;
@property (readonly, retain) NSString* startDate;
@property (readonly, retain) NSString* endDate;
@property (readonly, retain) NSString* source;
@property (readonly, retain) PBArray * departments;
- (User*)paramUsersAtIndex:(NSUInteger)index;
- (Department*)departmentsAtIndex:(NSUInteger)index;

+ (VideoTopicParams*) defaultInstance;
- (VideoTopicParams*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (VideoTopicParams_Builder*) builder;
+ (VideoTopicParams_Builder*) builder;
+ (VideoTopicParams_Builder*) builderWithPrototype:(VideoTopicParams*) prototype;
- (VideoTopicParams_Builder*) toBuilder;

+ (VideoTopicParams*) parseFromData:(NSData*) data;
+ (VideoTopicParams*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoTopicParams*) parseFromInputStream:(NSInputStream*) input;
+ (VideoTopicParams*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoTopicParams*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (VideoTopicParams*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface VideoTopicParams_Builder : PBGeneratedMessage_Builder {
@private
  VideoTopicParams* result;
}

- (VideoTopicParams*) defaultInstance;

- (VideoTopicParams_Builder*) clear;
- (VideoTopicParams_Builder*) clone;

- (VideoTopicParams*) build;
- (VideoTopicParams*) buildPartial;

- (VideoTopicParams_Builder*) mergeFrom:(VideoTopicParams*) other;
- (VideoTopicParams_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (VideoTopicParams_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCategory;
- (VideoCategory*) category;
- (VideoTopicParams_Builder*) setCategory:(VideoCategory*) value;
- (VideoTopicParams_Builder*) setCategoryBuilder:(VideoCategory_Builder*) builderForValue;
- (VideoTopicParams_Builder*) mergeCategory:(VideoCategory*) value;
- (VideoTopicParams_Builder*) clearCategory;

- (BOOL) hasPage;
- (int32_t) page;
- (VideoTopicParams_Builder*) setPage:(int32_t) value;
- (VideoTopicParams_Builder*) clearPage;

- (PBAppendableArray *)paramUsers;
- (User*)paramUsersAtIndex:(NSUInteger)index;
- (VideoTopicParams_Builder *)addParamUsers:(User*)value;
- (VideoTopicParams_Builder *)setParamUsersArray:(NSArray *)array;
- (VideoTopicParams_Builder *)setParamUsersValues:(const User* *)values count:(NSUInteger)count;
- (VideoTopicParams_Builder *)clearParamUsers;

- (BOOL) hasStartDate;
- (NSString*) startDate;
- (VideoTopicParams_Builder*) setStartDate:(NSString*) value;
- (VideoTopicParams_Builder*) clearStartDate;

- (BOOL) hasEndDate;
- (NSString*) endDate;
- (VideoTopicParams_Builder*) setEndDate:(NSString*) value;
- (VideoTopicParams_Builder*) clearEndDate;

- (BOOL) hasSource;
- (NSString*) source;
- (VideoTopicParams_Builder*) setSource:(NSString*) value;
- (VideoTopicParams_Builder*) clearSource;

- (PBAppendableArray *)departments;
- (Department*)departmentsAtIndex:(NSUInteger)index;
- (VideoTopicParams_Builder *)addDepartments:(Department*)value;
- (VideoTopicParams_Builder *)setDepartmentsArray:(NSArray *)array;
- (VideoTopicParams_Builder *)setDepartmentsValues:(const Department* *)values count:(NSUInteger)count;
- (VideoTopicParams_Builder *)clearDepartments;
@end

@interface VideoCategory : PBGeneratedMessage {
@private
  BOOL hasId_:1;
  BOOL hasName_:1;
  int32_t id;
  NSString* name;
}
- (BOOL) hasId;
- (BOOL) hasName;
@property (readonly) int32_t id;
@property (readonly, retain) NSString* name;

+ (VideoCategory*) defaultInstance;
- (VideoCategory*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (VideoCategory_Builder*) builder;
+ (VideoCategory_Builder*) builder;
+ (VideoCategory_Builder*) builderWithPrototype:(VideoCategory*) prototype;
- (VideoCategory_Builder*) toBuilder;

+ (VideoCategory*) parseFromData:(NSData*) data;
+ (VideoCategory*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoCategory*) parseFromInputStream:(NSInputStream*) input;
+ (VideoCategory*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoCategory*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (VideoCategory*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface VideoCategory_Builder : PBGeneratedMessage_Builder {
@private
  VideoCategory* result;
}

- (VideoCategory*) defaultInstance;

- (VideoCategory_Builder*) clear;
- (VideoCategory_Builder*) clone;

- (VideoCategory*) build;
- (VideoCategory*) buildPartial;

- (VideoCategory_Builder*) mergeFrom:(VideoCategory*) other;
- (VideoCategory_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (VideoCategory_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (int32_t) id;
- (VideoCategory_Builder*) setId:(int32_t) value;
- (VideoCategory_Builder*) clearId;

- (BOOL) hasName;
- (NSString*) name;
- (VideoCategory_Builder*) setName:(NSString*) value;
- (VideoCategory_Builder*) clearName;
@end

@interface VideoDurationCategory : PBGeneratedMessage {
@private
  BOOL hasId_:1;
  BOOL hasDurationValue_:1;
  int32_t id;
  NSString* durationValue;
}
- (BOOL) hasId;
- (BOOL) hasDurationValue;
@property (readonly) int32_t id;
@property (readonly, retain) NSString* durationValue;

+ (VideoDurationCategory*) defaultInstance;
- (VideoDurationCategory*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (VideoDurationCategory_Builder*) builder;
+ (VideoDurationCategory_Builder*) builder;
+ (VideoDurationCategory_Builder*) builderWithPrototype:(VideoDurationCategory*) prototype;
- (VideoDurationCategory_Builder*) toBuilder;

+ (VideoDurationCategory*) parseFromData:(NSData*) data;
+ (VideoDurationCategory*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoDurationCategory*) parseFromInputStream:(NSInputStream*) input;
+ (VideoDurationCategory*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (VideoDurationCategory*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (VideoDurationCategory*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface VideoDurationCategory_Builder : PBGeneratedMessage_Builder {
@private
  VideoDurationCategory* result;
}

- (VideoDurationCategory*) defaultInstance;

- (VideoDurationCategory_Builder*) clear;
- (VideoDurationCategory_Builder*) clone;

- (VideoDurationCategory*) build;
- (VideoDurationCategory*) buildPartial;

- (VideoDurationCategory_Builder*) mergeFrom:(VideoDurationCategory*) other;
- (VideoDurationCategory_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (VideoDurationCategory_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (int32_t) id;
- (VideoDurationCategory_Builder*) setId:(int32_t) value;
- (VideoDurationCategory_Builder*) clearId;

- (BOOL) hasDurationValue;
- (NSString*) durationValue;
- (VideoDurationCategory_Builder*) setDurationValue:(NSString*) value;
- (VideoDurationCategory_Builder*) clearDurationValue;
@end
