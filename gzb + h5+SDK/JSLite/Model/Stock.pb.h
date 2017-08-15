// Generated by the protocol buffer compiler.  DO NOT EDIT!
#import "ProtocolBuffers.h"

#import "Generic.pb.h"
#import "User.pb.h"
#import "Product.pb.h"
#import "Customer.pb.h"

@class AppSetting;
@class AppSetting_Builder;
@class Company;
@class Company_Builder;
@class Contact;
@class Contact_Builder;
@class Customer;
@class CustomerCategory;
@class CustomerCategory_Builder;
@class CustomerParams;
@class CustomerParams_Builder;
@class Customer_Builder;
@class Department;
@class Department_Builder;
@class Device;
@class Device_Builder;
@class Function;
@class Function_Builder;
@class Location;
@class Location_Builder;
@class PageCustomer;
@class PageCustomer_Builder;
@class PageStock;
@class PageStock_Builder;
@class PageUser;
@class PageUser_Builder;
@class Pagination;
@class Pagination_Builder;
@class Permission;
@class Permission_Builder;
@class Position;
@class Position_Builder;
@class Product;
@class ProductCategory;
@class ProductCategory_Builder;
@class Product_Builder;
@class Stock;
@class StockParams;
@class StockParams_Builder;
@class Stock_Builder;
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


@interface StockRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface Stock : PBGeneratedMessage {
@private
  BOOL hasId_:1;
  BOOL hasCreateDate_:1;
  BOOL hasComment_:1;
  BOOL hasUser_:1;
  BOOL hasCustomer_:1;
  BOOL hasLocation_:1;
  int32_t id;
  NSString* createDate;
  NSString* comment;
  User* user;
  Customer* customer;
  Location* location;
  PBAppendableArray * productsArray;
}
- (BOOL) hasUser;
- (BOOL) hasId;
- (BOOL) hasCustomer;
- (BOOL) hasLocation;
- (BOOL) hasCreateDate;
- (BOOL) hasComment;
@property (readonly, retain) User* user;
@property (readonly) int32_t id;
@property (readonly, retain) Customer* customer;
@property (readonly, retain) Location* location;
@property (readonly, retain) NSString* createDate;
@property (readonly, retain) PBArray * products;
@property (readonly, retain) NSString* comment;
- (Product*)productsAtIndex:(NSUInteger)index;

+ (Stock*) defaultInstance;
- (Stock*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Stock_Builder*) builder;
+ (Stock_Builder*) builder;
+ (Stock_Builder*) builderWithPrototype:(Stock*) prototype;
- (Stock_Builder*) toBuilder;

+ (Stock*) parseFromData:(NSData*) data;
+ (Stock*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Stock*) parseFromInputStream:(NSInputStream*) input;
+ (Stock*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Stock*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Stock*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Stock_Builder : PBGeneratedMessage_Builder {
@private
  Stock* result;
}

- (Stock*) defaultInstance;

- (Stock_Builder*) clear;
- (Stock_Builder*) clone;

- (Stock*) build;
- (Stock*) buildPartial;

- (Stock_Builder*) mergeFrom:(Stock*) other;
- (Stock_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Stock_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasUser;
- (User*) user;
- (Stock_Builder*) setUser:(User*) value;
- (Stock_Builder*) setUserBuilder:(User_Builder*) builderForValue;
- (Stock_Builder*) mergeUser:(User*) value;
- (Stock_Builder*) clearUser;

- (BOOL) hasId;
- (int32_t) id;
- (Stock_Builder*) setId:(int32_t) value;
- (Stock_Builder*) clearId;

- (BOOL) hasCustomer;
- (Customer*) customer;
- (Stock_Builder*) setCustomer:(Customer*) value;
- (Stock_Builder*) setCustomerBuilder:(Customer_Builder*) builderForValue;
- (Stock_Builder*) mergeCustomer:(Customer*) value;
- (Stock_Builder*) clearCustomer;

- (BOOL) hasLocation;
- (Location*) location;
- (Stock_Builder*) setLocation:(Location*) value;
- (Stock_Builder*) setLocationBuilder:(Location_Builder*) builderForValue;
- (Stock_Builder*) mergeLocation:(Location*) value;
- (Stock_Builder*) clearLocation;

- (BOOL) hasCreateDate;
- (NSString*) createDate;
- (Stock_Builder*) setCreateDate:(NSString*) value;
- (Stock_Builder*) clearCreateDate;

- (PBAppendableArray *)products;
- (Product*)productsAtIndex:(NSUInteger)index;
- (Stock_Builder *)addProducts:(Product*)value;
- (Stock_Builder *)setProductsArray:(NSArray *)array;
- (Stock_Builder *)setProductsValues:(const Product* *)values count:(NSUInteger)count;
- (Stock_Builder *)clearProducts;

- (BOOL) hasComment;
- (NSString*) comment;
- (Stock_Builder*) setComment:(NSString*) value;
- (Stock_Builder*) clearComment;
@end

@interface PageStock : PBGeneratedMessage {
@private
  BOOL hasPage_:1;
  Pagination* page;
  PBAppendableArray * stocksArray;
}
- (BOOL) hasPage;
@property (readonly, retain) Pagination* page;
@property (readonly, retain) PBArray * stocks;
- (Stock*)stocksAtIndex:(NSUInteger)index;

+ (PageStock*) defaultInstance;
- (PageStock*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (PageStock_Builder*) builder;
+ (PageStock_Builder*) builder;
+ (PageStock_Builder*) builderWithPrototype:(PageStock*) prototype;
- (PageStock_Builder*) toBuilder;

+ (PageStock*) parseFromData:(NSData*) data;
+ (PageStock*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PageStock*) parseFromInputStream:(NSInputStream*) input;
+ (PageStock*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PageStock*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (PageStock*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface PageStock_Builder : PBGeneratedMessage_Builder {
@private
  PageStock* result;
}

- (PageStock*) defaultInstance;

- (PageStock_Builder*) clear;
- (PageStock_Builder*) clone;

- (PageStock*) build;
- (PageStock*) buildPartial;

- (PageStock_Builder*) mergeFrom:(PageStock*) other;
- (PageStock_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PageStock_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasPage;
- (Pagination*) page;
- (PageStock_Builder*) setPage:(Pagination*) value;
- (PageStock_Builder*) setPageBuilder:(Pagination_Builder*) builderForValue;
- (PageStock_Builder*) mergePage:(Pagination*) value;
- (PageStock_Builder*) clearPage;

- (PBAppendableArray *)stocks;
- (Stock*)stocksAtIndex:(NSUInteger)index;
- (PageStock_Builder *)addStocks:(Stock*)value;
- (PageStock_Builder *)setStocksArray:(NSArray *)array;
- (PageStock_Builder *)setStocksValues:(const Stock* *)values count:(NSUInteger)count;
- (PageStock_Builder *)clearStocks;
@end

@interface StockParams : PBGeneratedMessage {
@private
  BOOL hasPage_:1;
  BOOL hasStartDate_:1;
  BOOL hasEndDate_:1;
  int32_t page;
  NSString* startDate;
  NSString* endDate;
  PBAppendableArray * usersArray;
  PBAppendableArray * customerCategoryArray;
  PBAppendableArray * customersArray;
  PBAppendableArray * departmentsArray;
  PBAppendableArray * companiesArray;
}
- (BOOL) hasPage;
- (BOOL) hasStartDate;
- (BOOL) hasEndDate;
@property (readonly) int32_t page;
@property (readonly, retain) PBArray * users;
@property (readonly, retain) PBArray * customerCategory;
@property (readonly, retain) PBArray * customers;
@property (readonly, retain) PBArray * departments;
@property (readonly, retain) PBArray * companies;
@property (readonly, retain) NSString* startDate;
@property (readonly, retain) NSString* endDate;
- (User*)usersAtIndex:(NSUInteger)index;
- (CustomerCategory*)customerCategoryAtIndex:(NSUInteger)index;
- (Customer*)customersAtIndex:(NSUInteger)index;
- (Department*)departmentsAtIndex:(NSUInteger)index;
- (Company*)companiesAtIndex:(NSUInteger)index;

+ (StockParams*) defaultInstance;
- (StockParams*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (StockParams_Builder*) builder;
+ (StockParams_Builder*) builder;
+ (StockParams_Builder*) builderWithPrototype:(StockParams*) prototype;
- (StockParams_Builder*) toBuilder;

+ (StockParams*) parseFromData:(NSData*) data;
+ (StockParams*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StockParams*) parseFromInputStream:(NSInputStream*) input;
+ (StockParams*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StockParams*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (StockParams*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StockParams_Builder : PBGeneratedMessage_Builder {
@private
  StockParams* result;
}

- (StockParams*) defaultInstance;

- (StockParams_Builder*) clear;
- (StockParams_Builder*) clone;

- (StockParams*) build;
- (StockParams*) buildPartial;

- (StockParams_Builder*) mergeFrom:(StockParams*) other;
- (StockParams_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (StockParams_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasPage;
- (int32_t) page;
- (StockParams_Builder*) setPage:(int32_t) value;
- (StockParams_Builder*) clearPage;

- (PBAppendableArray *)users;
- (User*)usersAtIndex:(NSUInteger)index;
- (StockParams_Builder *)addUsers:(User*)value;
- (StockParams_Builder *)setUsersArray:(NSArray *)array;
- (StockParams_Builder *)setUsersValues:(const User* *)values count:(NSUInteger)count;
- (StockParams_Builder *)clearUsers;

- (PBAppendableArray *)customerCategory;
- (CustomerCategory*)customerCategoryAtIndex:(NSUInteger)index;
- (StockParams_Builder *)addCustomerCategory:(CustomerCategory*)value;
- (StockParams_Builder *)setCustomerCategoryArray:(NSArray *)array;
- (StockParams_Builder *)setCustomerCategoryValues:(const CustomerCategory* *)values count:(NSUInteger)count;
- (StockParams_Builder *)clearCustomerCategory;

- (PBAppendableArray *)customers;
- (Customer*)customersAtIndex:(NSUInteger)index;
- (StockParams_Builder *)addCustomers:(Customer*)value;
- (StockParams_Builder *)setCustomersArray:(NSArray *)array;
- (StockParams_Builder *)setCustomersValues:(const Customer* *)values count:(NSUInteger)count;
- (StockParams_Builder *)clearCustomers;

- (PBAppendableArray *)departments;
- (Department*)departmentsAtIndex:(NSUInteger)index;
- (StockParams_Builder *)addDepartments:(Department*)value;
- (StockParams_Builder *)setDepartmentsArray:(NSArray *)array;
- (StockParams_Builder *)setDepartmentsValues:(const Department* *)values count:(NSUInteger)count;
- (StockParams_Builder *)clearDepartments;

- (PBAppendableArray *)companies;
- (Company*)companiesAtIndex:(NSUInteger)index;
- (StockParams_Builder *)addCompanies:(Company*)value;
- (StockParams_Builder *)setCompaniesArray:(NSArray *)array;
- (StockParams_Builder *)setCompaniesValues:(const Company* *)values count:(NSUInteger)count;
- (StockParams_Builder *)clearCompanies;

- (BOOL) hasStartDate;
- (NSString*) startDate;
- (StockParams_Builder*) setStartDate:(NSString*) value;
- (StockParams_Builder*) clearStartDate;

- (BOOL) hasEndDate;
- (NSString*) endDate;
- (StockParams_Builder*) setEndDate:(NSString*) value;
- (StockParams_Builder*) clearEndDate;
@end
