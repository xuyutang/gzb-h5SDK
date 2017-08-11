#import "LocalManager.h"
#import "NSDate+Util.h"
#import <CommonCrypto/CommonDigest.h> 
#import <Security/SecItem.h>
#import "SSKeychain.h"
#import "GlobalConstant.h"
#import "NSString+Helpers.h"
#import "UIDevice+Util.h"
#import "RequestAgent.h"
#import "City.h"
#import "NSBundle+JSLite.h"
#import "GlobalConstant.h"
#import <CoreData/CoreData.h>
#import "Alarm+Extensions.h"
#import "Repetition+Extensions.h"
#import "NSString+Util.h"
#import "UIImage+Category.h"
#import "UpdateVersion.h"
#import "DataInputStream.h"
#import "DataOutputStream.h"

@implementation LocalManager

static NSString* CREATE_TABLE_LOGIN_USER = @"create table if not exists login_user (id integer primary key,username text,password text,realname text,email text,departmentName varchar(20),positionName varchar(20),departmentId integer,expire integer default 0,expire_content varchar(200),avatars varchar(200),position_id integer,position_name varchar(50));";
static NSString* CREATE_TABLE_USER = @"create table if not exists user (id integer primary key,username text,password text,realname text,email text,departmentName varchar(20),positionName varchar(20),pinyin text,departmentId integer);";
static NSString* CREATE_TABLE_USER_HASH = @"create table if not exists sync_hash (hashcode text primary key,type text);";
static NSString* CREATE_TABLE_DAILY_REPORT = @"create table if not exists daily_report (id integer primary key,user_id integer,user_name text,user_realname text,today text,plan text,special text,create_date datetime);";
static NSString* CREATE_TABLE_PATROL_CATEGORY = @"create table if not exists patrol_category (id integer primary key,name text,favorites integer default 0  );";
static NSString* CREATE_TABLE_CUSTOMER_CATEGORY = @"create table if not exists customer_category (id integer primary key,name text );";
static NSString* CREATE_TABLE_CUSTOMER = @"create table if not exists customer (id integer primary key,category_id integer,user_id integer,name text,address text,contact varchar(50),phone varchar(50),longitude double,latitude double,pinyin text,favorites integer default 0 );";
static NSString* CREATE_TABLE_COMPANY = @"create table if not exists company (id varchar(50) primary key,name text,desc text,idea varchar(200),avtar varchar(200),avtarFile BLOB);";

static NSString* CREATE_TABLE_MESSAGE = @"create table if not exists message (id integer primary key,content text,readed char(1),status char(1), create_date datetime,type integer,sourceId varchar(100), userId integer,realName varchar(50),avtar varchar(500),userName varchar(100),deleted integer default 0);";
/* update dbscript with version 6*/
static NSString* CREATE_TABLE_ANNOUNCE = @"create table if not exists announce (id integer primary key,subject text,readed char(1),status char(1), create_date datetime,deleted integer default 0,userid integer realName varchar(100),avtar varchar(500));";

static NSString* CREATE_TABLE_PRODUCT_SUPPLY = @"create table if not exists product_supply (id integer,customer_id integer,name varchar(100),unit varchar(50),price varchar(100));";
static NSString* CREATE_TABLE_FUNCTION = @"create table if not exists function (id integer,name varchar(50),value varchar(50),fav integer default 0);";
static NSString* CREATE_TABLE_VERSION = @"create table if not exists version (dbversion varchar(50));";
/* Update dbscript with version 5*/
static NSString* CREATE_TABLE_CUSTOMER_USER = @"create table if not exists customer_user (id integer,uid integer);";
/* Update dbscript with version 3*/
static NSString* ADD_PRICE_TABLE_PRODUCT_SUPPLY = @"alter table product_supply ADD price varchar(100);";

/* Update dbscript with version 4*/
static NSString* CREATE_TABLE_CONTACTS_USER = @"create table if not exists all_user (id integer primary key,username text,password text,realname text,email text,departmentName varchar(20),departmentId integer,positionName varchar(20),pinyin text);";
static NSString*  ADD_FAVORITES_TABLE_CUSTOMER = @"alter table customer ADD favorites integer default 0";
static NSString*  ADD_FAVORITES_PATROL_CATEGORY = @"alter table patrol_category ADD favorites integer default 0";

/* update dbscript with version 5*/
static NSString* CREATE_TABLE_COMPETITION_PRODUCT = @"create table if not exists competition_product (id integer,customer_id integer,name varchar(100),unit varchar(50),price varchar(100));";

/* update dbscript with version 7*/
static NSString* CREATE_TABLE_PRODUCT = @"create table if not exists product (id integer primary key,name varchar(100),unit varchar(50),price varchar(100),favorites integer default 0 );";

/* update dbscript with version 8*/
static NSString* CREATE_TABLE_DEVICE = @"create table if not exists device (id integer primary key,name varchar(100),default_value varchar(200));";

/* update dbscript with version 10*/
static NSString* ADD_STATUS_TABLE_ANNOUNCE = @"alter table announce ADD status char(1);";
static NSString* ADD_STATUS_TABLE_MESSAGE = @"alter table message ADD status char(1);";
/* update dbscript with version 11*/
static NSString* CREATE_TABLE_ATTENDANCE_CATEGORY = @"create table if not exists attendance_category (id integer,name varchar(100));";
/* update dbscript with version 12*/
static NSString* CREATE_TABLE_APPLY_CATEGORY = @"create table if not exists apply_category (id integer,name varchar(200));";
static NSString* CREATE_TABLE_APPLY_USER = @"create table if not exists apply_user (id integer primary key,username text,password text,realname text,email text,departmentName varchar(20),positionName varchar(20),pinyin text,departmentId integer);";
static NSString* CREATE_TABLE_APPLY_CATEGORY_R_USER = @"create table if not exists apply_category_r_user (categoryId integer,userId integer);";
static NSString* CREATE_TABLE_GIFT_PRODUCT_CATEGORY = @"create table if not exists gift_product_category (id integer,name varchar(200),unit varchar(200));";
static NSString* CREATE_TABLE_GIFT_PRODUCT_AREA = @"create table if not exists gift_product_area (id integer,provinceId varchar(200),cityId varchar(200),countyId varchar(200),provinceName varchar(200),cityName varchar(200),countyName varchar(200));";
static NSString* CREATE_TABLE_GIFT_PRODUCT_MODEL = @"create table if not exists gift_product_model (id integer,productId integer,name varchar(200),num double,price double,createDate varchar(100));";
static NSString* CREATE_TABLE_GIFT_PRODUCT = @"create table if not exists gift_product (id integer,categoryId integer,name varchar(200),code varchar(200),prior varchar(200),specification varchar(200),priority varchar(200),description varchar(2000),level varchar(200),place varchar(200),createDate varchar(100));";
static NSString* CREATE_TABLE_GIFT_MODEL_R_AREA = @"create table if not exists gift_model_r_area(modelId integer,areaId integer); ";
static NSString* CREATE_TABLE_DEPARTMENT = @"create table if not exists department (id integer,name varchar(200),parentId integer,sortId integer);";
/* update dbscript with version 13*/
static NSString* CREATE_TABLE_INSPECTION_TYPE = @"create table if not exists inspection_type (id integer,name varchar(200));";
static NSString* CREATE_TABLE_INSPECTION_MODEL = @"create table if not exists inspection_model (id integer,name varchar(200));";
static NSString* CREATE_TABLE_INSPECTION_STATUS = @"create table if not exists inspection_status (id integer,name varchar(200),isDefault integer);";
static NSString* CREATE_TABLE_INSPECTION_TARGET = @"create table if not exists inspection_target (id integer,name varchar(200),serialNumber varchar(200),inspectionType integer,inspectionModel integer,parentId integer,createDate varchar(100));";
static NSString* CREATE_TABLE_INSPECTION_CATEGORY = @"create table if not exists inspection_category (id integer,name varchar(200));";
static NSString* ADD_FAVORITES_PRODUCT = @"alter table product ADD favorites integer default 0";
/* update dbscript with version 14*/
static NSString* ADD_DEPARTMENT_ID_TABLE_LOGIN_USER = @"alter table login_user ADD departmentId integer default 0";
static NSString* ADD_DEPARTMENT_ID_TABLE_USER = @"alter table user ADD departmentId integer default 0";
static NSString* CREATE_TABLE_CUSTOMER_CONTACT = @"create table if not exists customer_contact (id integer,name varchar(200),phone varchar(200));";
static NSString* ADD_DEPARTMENT_ID_TABLE_APPLY_USER = @"alter table apply_user ADD departmentId integer default 0";
static NSString* ADD_FAV_TABLE_FUNCTION = @"alter table function ADD fav integer default 1";
static NSString* ADD_USER_TABLE_MESSAGE = @"alter table message ADD userId integer,ADD realName varchar(50),ADD avtar varchar(500), ADD userName varchar(100), ADD type integer, ADD sourceId varchar(100)";
static NSString* ADD_DEPTID_TABLE_ALLUSER = @"alter table all_user add departmentId integer";
static NSString* ADD_AVTAR_TABLE_COMPANY = @"alter table company ADD idea varchar(200),ADD avtar varchar(200)";
static NSString* ADD_DELETE_TABLE_MESSAGE = @"alter table message ADD deleted integer default 0";
static NSString* ADD_DELETE_TABLE_ANNOUNCE = @"alter table announce ADD deleted integer default 0";
static NSString* ADD_AVATAR_FILE_TABLE_COMPANY = @"alter table company add avtarFile BLOB;";
/* update dbscript with version 15*/
static NSString* CREATE_TABLE_CACHE = @"create table if not exists cache (id integer primary key autoincrement,functionId integer,objectId varchar(200),content blob);";
static NSString* CREATE_TABLE_VIDEO_CATEGORY = @"create table if not exists video_category (id integer primary key,name varchar(500),favorites integer default 0);";
static NSString* CREATE_TABLE_VIDEO_DURATION_CATEGORY = @"create table if not exists video_duration_category (id integer primary key,name varchar(500),favorites integer default 0);";
static NSString* CREATE_TABLE_FAV_LANG = @"create table if not exists favorite_lang (id integer primary key,content  varchar(2000),favorites integer default 0);";

static NSString* CREATE_TABLE_PATROL_VIDEO_DURATION_CATEGORY = @"create table if not exists patrol_video_duration_category (id integer primary key,name varchar(500),favorites integer default 0);";
static NSString* CREATE_TABLE_PATROL_MEDIA_CATEGORY = @"create table if not exists patrol_media_category (id integer primary key,name varchar(100),value varchar(200));";
static NSString* ADD_EXPIRE_TABLE_LOGIN_USER = @"alter table login_user ADD expire integer default 0, ADD expire_content varchar(200);";

static NSString* CREATE_CUSTOMER_TAG = @"create table if not exists customer_tag (id integer primary key,tag_name varchar(500));";
static NSString* CREATE_CUSTOMER_TAG_VALUES = @"create table if not exists customer_tag_values (id integer primary key,tag_id integer,tag_value varchar(200),parent_id integer,tag_path varchar(2000));";
static NSString* CREATE_PRODUCT_CATEGORY = @"create table if not exists product_category (id integer primary key,name  varchar(200),parent_id integer,cat_path varchar(2000));";
static NSString* CREATE_PRODUCT_SPECIFICATION = @"create table if not exists product_specification (id integer primary key,spec_name varchar(200));";
static NSString* CREATE_PRODUCT_SPECIFICATION_VALUES = @"create table if not exists product_specification_values (id integer primary key,spec_id integer,spec_value varchar(200));";
static NSString* CREATE_CUSTOMER_TAG_ASSOCIATION = @"create table if not exists customer_tag_association (customer_id integer,tag_id integer,tag_value_id);";
static NSString* CREATE_PRODUCT_SPEC_ASSOCIATION = @"create table if not exists product_spec_association (prod_id integer,spec_id integer,spec_value_id);";
static NSString *CREATE_INSPECTION_MODEL_STATUS = @"create table if not exists inspection_model_status (id integer,name varchar(200), modelid integer,isDefault integer default 0);";
static NSString *CREATE_PAPER_TEMPLATE = @"create table if not exists paper_template (id text,name text, userId integer,fieldCount integer,fieldContent text,totalRecords integer,isDefault integer default 0);";

static NSString* CREATE_TABLE_HOLIDAY_CATEGORY = @"create table if not exists holiday_category (id integer primary key,name text );";

static NSString* CREATE_TABLE_ATTENDANCE_TYPE = @"create table if not exists attendance_type (value text );";

static NSString* CREATE_TABLE_CHECKIN_CHANNEL = @"create table if not exists checkin_channel (channelValue text );";

static NSString* CREATE_TABLE_CHECKIN_SHIFT = @"create table if not exists checkin_shift (id integer primary key,name text,checkInCount integer,isDaySpan char(1),versionNo varchar(100),workingTime varchar(2000),weekDay varchar(500), humanizedSet varchar(500),syncTime varchar(200), checkInAhead integer,date varchar(200));";

static NSString* CREATE_TABLE_CHECKIN_HOLIDAY = @"create table if not exists checkin_holiday (value text );";

static NSString* CREATE_TABLE_CHECKIN_SHIFT_GROUP = @"create table if not exists checkin_shiftgroup (id varchar(100),name varchar(50),date varchar(50),checkInStatus integer,checkInType integer,checkInTime varchar(200),checkInAbnormal integer)";
static NSString *CREATE_TABLE_USER_PERMISSION = @"create table if not exists user_permission(name varchar(50),value text)";

static NSString *CREATE_TABLE_ANNOUNCE_SENDER = @"create table if not exists announce_sender(id integer,userName varchar(100),realName varchar(100),avtar varchar(500))";

static NSString *CREATE_TABLE_MY_ANNOUNCE =  @"create table if not exists my_announce (id integer ,subject text,readed char(1),status char(1), create_date datetime,realName varchar(100),avtar varchar(500));";
static NSString *ALTER_TABLE_ANNOUNCE_ADD_REALNAME = @"alter table announce ADD realName varchar(100)";
static NSString *ALTER_TABLE_ANNDOUNCE_ADD_AVTAR= @"alter table announce ADD avtar varchar(500)";
static NSString *ALTER_TABLE_ANNDOUNCE_ADD_USERID= @"alter table announce ADD userid integer";


+(LocalManager*)sharedInstance
{

    static LocalManager* sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[LocalManager alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    NSLog(@"%@",[NSString UUID]);
    NSString* doc = PATH_OF_DOCUMENT;
    NSString* path = [doc stringByAppendingPathComponent:@"WTDB_V4.sqlite"];
    
    //首次创建数据文件时 清空已缓存的 NSUserDefaults
    NSFileManager *mgr = [[NSFileManager alloc] init];
    if (![mgr fileExistsAtPath:path]) {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    }
    
    _agent = [[RequestAgent alloc] init];
    dbPath = [[NSString alloc] initWithString:path];
    
    if (self.managedObjectContext == nil) {
        [self setupManagedObjectContext];
    }
    
    [self _initTable];
    
    self = [super init];
    
    
    return self;
}

- (void)_initTable {
    [self _createTable:CREATE_TABLE_LOGIN_USER];
    [self _createTable:CREATE_TABLE_USER];
    [self _createTable:CREATE_TABLE_USER_HASH];
    [self _createTable:CREATE_TABLE_DAILY_REPORT];
    [self _createTable:CREATE_TABLE_PATROL_CATEGORY];
    [self _createTable:CREATE_TABLE_CUSTOMER];
    [self _createTable:CREATE_TABLE_CUSTOMER_CATEGORY];
    [self _createTable:CREATE_TABLE_COMPANY];
    [self _createTable:CREATE_TABLE_MESSAGE];
    [self _createTable:CREATE_TABLE_PRODUCT_SUPPLY];
    [self _createTable:CREATE_TABLE_FUNCTION];
    [self _createTable:CREATE_TABLE_VERSION];
    [self _createTable:CREATE_TABLE_CONTACTS_USER];
    [self _createTable:CREATE_TABLE_CUSTOMER_USER];
    [self _createTable:CREATE_TABLE_COMPETITION_PRODUCT];
    [self _createTable:CREATE_TABLE_ANNOUNCE];
    [self _createTable:CREATE_TABLE_PRODUCT];
    [self _createTable:CREATE_TABLE_DEVICE];
    [self _createTable:CREATE_TABLE_APPLY_CATEGORY];
    [self _createTable:CREATE_TABLE_APPLY_USER];
    [self _createTable:CREATE_TABLE_APPLY_CATEGORY_R_USER];
    [self _createTable:CREATE_TABLE_GIFT_PRODUCT_CATEGORY];
    [self _createTable:CREATE_TABLE_GIFT_PRODUCT_AREA];
    [self _createTable:CREATE_TABLE_GIFT_PRODUCT_MODEL];
    [self _createTable:CREATE_TABLE_GIFT_PRODUCT];
    [self _createTable:CREATE_TABLE_GIFT_MODEL_R_AREA];
    [self _createTable:CREATE_TABLE_DEPARTMENT];
    [self _createTable:CREATE_TABLE_ATTENDANCE_CATEGORY];
    [self _createTable:CREATE_TABLE_INSPECTION_TYPE];
    [self _createTable:CREATE_TABLE_INSPECTION_MODEL];
    [self _createTable:CREATE_TABLE_INSPECTION_STATUS];
    [self _createTable:CREATE_TABLE_INSPECTION_TARGET];
    [self _createTable:CREATE_TABLE_INSPECTION_CATEGORY];
    [self _createTable:CREATE_TABLE_CUSTOMER_CONTACT];
    [self _createTable:CREATE_TABLE_CACHE];
    [self _createTable:CREATE_TABLE_VIDEO_CATEGORY];
    [self _createTable:CREATE_TABLE_VIDEO_DURATION_CATEGORY];
    [self _createTable:CREATE_TABLE_FAV_LANG];
    [self _createTable:CREATE_TABLE_PATROL_VIDEO_DURATION_CATEGORY];
    [self _createTable:CREATE_TABLE_PATROL_MEDIA_CATEGORY];
    [self _createTable:CREATE_CUSTOMER_TAG];
    [self _createTable:CREATE_CUSTOMER_TAG_VALUES];
    [self _createTable:CREATE_PRODUCT_CATEGORY];
    [self _createTable:CREATE_PRODUCT_SPECIFICATION];
    [self _createTable:CREATE_PRODUCT_SPECIFICATION_VALUES];
    [self _createTable:CREATE_CUSTOMER_TAG_ASSOCIATION];
    [self _createTable:CREATE_PRODUCT_SPEC_ASSOCIATION];
    [self _createTable:CREATE_INSPECTION_MODEL_STATUS];
    [self _createTable:CREATE_PAPER_TEMPLATE];
    [self _createTable:CREATE_TABLE_HOLIDAY_CATEGORY];
    [self _createTable:CREATE_TABLE_ATTENDANCE_TYPE];
    [self _createTable:CREATE_TABLE_CHECKIN_CHANNEL];
    [self _createTable:CREATE_TABLE_CHECKIN_SHIFT];
    [self _createTable:CREATE_TABLE_CHECKIN_HOLIDAY];
    [self _createTable:CREATE_TABLE_CHECKIN_SHIFT_GROUP];
    [self _createTable:CREATE_TABLE_USER_PERMISSION];
    [self _createTable:CREATE_TABLE_ANNOUNCE_SENDER];
    [self _createTable:CREATE_TABLE_MY_ANNOUNCE];
    if ([self _DbVersion] <= DATABASE_VERSION) {
        [self _createTable:ADD_FAVORITES_PRODUCT];
        [self _createTable:ADD_STATUS_TABLE_ANNOUNCE];
        [self _createTable:ADD_STATUS_TABLE_MESSAGE];
        [self _createTable:ADD_FAVORITES_TABLE_CUSTOMER];
        [self _createTable:ADD_FAVORITES_PATROL_CATEGORY];
        [self _createTable:ADD_PRICE_TABLE_PRODUCT_SUPPLY];
        [self _createTable:ADD_DEPARTMENT_ID_TABLE_LOGIN_USER];
        [self _createTable:ADD_DEPARTMENT_ID_TABLE_USER];
        [self _createTable:ADD_DEPARTMENT_ID_TABLE_APPLY_USER];
        [self _createTable:ADD_FAV_TABLE_FUNCTION];
        [self _createTable:ADD_USER_TABLE_MESSAGE];
        [self _createTable:ADD_DEPTID_TABLE_ALLUSER];
        [self _createTable:ADD_AVTAR_TABLE_COMPANY];
        [self _createTable:ADD_DELETE_TABLE_MESSAGE];
        [self _createTable:ADD_DELETE_TABLE_ANNOUNCE];
        [self _createTable:ADD_AVATAR_FILE_TABLE_COMPANY];
        [self _createTable:ADD_EXPIRE_TABLE_LOGIN_USER];
        [self _createTable:ALTER_TABLE_ANNOUNCE_ADD_REALNAME];
        [self _createTable:ALTER_TABLE_ANNDOUNCE_ADD_AVTAR];
        [self _createTable:ALTER_TABLE_ANNDOUNCE_ADD_USERID];
        
        [self _saveDbVersion];
    }
    
    
}

- (void)_createTable:(NSString *)sql
{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        BOOL res = [db executeUpdate:sql];
        if (!res)
        {
            //NSLog(@"error when creating db table");
        }
        else
        {
            NSLog(@"sucesse to creating db table");
        }

        [db close];
        
    }
    else
    {
        NSLog(@"error when open db");
        
    }
}

- (int) _DbVersion
{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        int dbversion = 0.0;
        
        FMResultSet * rs = [db executeQuery:@"select dbversion from version order by dbversion desc;"];
        if ([rs next])
        {
            dbversion = [[rs stringForColumn:@"dbversion"] intValue];
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"insert into version(dbversion) values('%d');",DATABASE_VERSION];
            [rs close];
            [db executeUpdate:sql];
            [db close];
        }
        [rs close];
        [db close];
        return dbversion;
    }
    return DATABASE_VERSION;
}

- (int) _saveDbVersion{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSString* sql = [NSString stringWithFormat:@"insert into version(dbversion) values('%d');",DATABASE_VERSION];
        [db executeUpdate:sql];
        [db close];
    }
    return DATABASE_VERSION;
}


- (BOOL) saveAttendanceCategories:(PBArray*) attendanceCategoies{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        @try {
            [db executeUpdate:@"delete from attendance_category;"];
            
            for (AttendanceCategory* f in attendanceCategoies)
            {
                [db executeUpdate:[NSString stringWithFormat:@"insert into attendance_category (id,name) values (%d,'%@');",f.id,f.name]];
            }
            [db commit];
        }
        @catch (NSException *exception) {
            [db rollback];
        }
        @finally {
            [db close];
        }
        return YES;
    }
    
    return NO;
}

- (NSMutableArray*) getAttendanceCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from attendance_category";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            AttendanceCategory_Builder* v1 = [AttendanceCategory builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            AttendanceCategory* f = [v1 build];
            [result addObject:f];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query attendance category.");
        
    }
    return nil;
}

- (BOOL) saveFunctions:(PBArray*) functions
{
    NSMutableArray* curFuns = [self getFunctions];
    NSMutableArray* favFuns = [self getFavFunctions];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        PBAppendableArray* funs = [[PBAppendableArray alloc] init];
        [funs appendArray:functions];
        
        /*
        Function_Builder* fbm = [Function builder];
        FunctionV1_Builder* fbmv1 = [FunctionV1 builder];
        [fbmv1 setId:FUNC_MESSAGE];
        [fbmv1 setValue:FUNC_MESSAGE_DES];
        [fbmv1 setName:NSLocalizedString(@"menu_function_message", "")];
        [fbm setVersion:fbmv1.version];
        [fbm setV1:[fbmv1 build]];
        
        BOOL hasMessage = FALSE;
        for (Function* f in functions) {
            if (f.id == FUNC_MESSAGE){
                hasMessage = TRUE;
                break;
            }
        }
        if (!hasMessage) {
            [funs addObject:[fbm build]];
        }*/
        
        
        Function_Builder* fbfv1 = [Function builder];
        [fbfv1 setId:FUNC_FAVORATE];
        [fbfv1 setValue:FUNC_FAVORATE_DES];
        [fbfv1 setName:NSLocalizedString(@"my_favorate", "")];

        
        BOOL hasFav = FALSE;
        for (Function* f in functions) {
            if (f.id == FUNC_FAVORATE){
                hasFav = TRUE;
                break;
            }
        }
        if (!hasFav) {
            [funs addObject:[fbfv1 build]];
        }
        
        Function_Builder* fbdv1 = [Function builder];
        [fbdv1 setId:FUNC_SYNC];
        [fbdv1 setValue:FUNC_SYNC_DES];
        [fbdv1 setName:NSLocalizedString(@"menu_function_datasync", "")];

        BOOL hasSync = FALSE;
        for (Function* f in functions) {
            if (f.id == FUNC_SYNC){
                hasSync = TRUE;
                break;
            }
        }
        if (!hasSync) {
            [funs addObject:[fbdv1 build]];
        }
        
        /*
        Function_Builder* fbc = [Function builder];
        FunctionV1_Builder* fbdc1 = [FunctionV1 builder];
        [fbdc1 setId:FUNC_SPACE];
        [fbdc1 setValue:FUNC_SPACE_DES];
        [fbdc1 setName:NSLocalizedString(@"space_msg_info", "")];
        [fbc setVersion:fbdc1.version];
        [fbc setV1:[fbdc1 build]];
        
        BOOL hasSpace = FALSE;
        for (Function* f in functions) {
            if (f.id == FUNC_SPACE){
                hasSpace = TRUE;
                break;
            }
        }
        if (!hasSpace) {
            [funs addObject:[fbc build]];
        }*/
        
        /*
        Function_Builder* fba = [Function builder];
        FunctionV1_Builder* fbav1 = [FunctionV1 builder];
        [fbav1 setId:FUNC_ALARM];
        [fbav1 setValue:FUNC_ALARM_DES];
        [fbav1 setName:NSLocalizedString(@"menu_function_alarm", "")];
        [fba setVersion:fbav1.version];
        [fba setV1:[fbav1 build]];
        [funs addObject:[fba build]];*/
        
        [db executeUpdate:@"delete from function;"];
        
        for (Function* f in funs)
        {
            if ([f.value isEqualToString:FUNC_SELL_DELIVERY_DES] || [f.value isEqualToString:FUNC_SELL_REWARD_DES]|| [f.value isEqualToString:FUNC_QCHAT_DESC]) {
                continue;
            }
            BOOL hasFun = NO;
            for (Function* cf in curFuns) {
                if (cf.id == f.id) {
                    [db executeUpdate:[NSString stringWithFormat:@"insert into function (id,name,value,fav) values (%d,'%@','%@',1);",f.id,f.name,f.value]];
                    hasFun = TRUE;
                    break;
                }
            }
            if (!hasFun) {
                [db executeUpdate:[NSString stringWithFormat:@"insert into function (id,name,value,fav) values (%d,'%@','%@',1);",f.id,f.name,f.value]];
            }
            
            BOOL hasFav = NO;
            for (Function* ff in favFuns) {
                if (ff.id == f.id) {
                    [db executeUpdate:[NSString stringWithFormat:@"update function set fav = 1 where id =%d",f.id]];
                    hasFav = YES;
                    break;
                }
            }
            if (!hasFav) {
                [db executeUpdate:[NSString stringWithFormat:@"update function set fav = 0 where id =%d",f.id]];
            }
            if (favFuns.count == 0) {
                [db executeUpdate:[NSString stringWithFormat:@"update function set fav = 1 where id =%d",f.id]];
            }
        }
        
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (BOOL) favFunctions:(PBArray*) functions{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"update function set fav = 0"];
        for (Function* f in functions)
        {
            [db executeUpdate:[NSString stringWithFormat:@"update function set fav = 1 where id =%d",f.id]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (BOOL) favFunction:(NSString*) funcName{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:[NSString stringWithFormat:@"update function set fav = 1 where value ='%@'",funcName]];
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}


- (NSMutableArray *) getFavFunctions
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from function where fav = 1 order by fav desc";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Function_Builder* v1 = [Function builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setValue: [rs stringForColumn:@"value"]];
            
            Function* f = [v1 build];
            if ([f.value isEqualToString:FUNC_SELL_DELIVERY_DES] || [f.value isEqualToString:FUNC_SELL_REWARD_DES] || [f.value isEqualToString:FUNC_FAVORATE_DES]  || [f.value isEqualToString:FUNC_SYNC_DES]) {
                continue;
            }
            [result addObject:f];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query function.");
        
    }
    return nil;
}

- (NSMutableArray *) getFunctions
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from function";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Function_Builder* v1 = [Function builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setValue: [rs stringForColumn:@"value"]];
            
            Function* f = [v1 build];
            if ([f.value isEqualToString:FUNC_SELL_DELIVERY_DES] || [f.value isEqualToString:FUNC_SELL_REWARD_DES] || [f.value isEqualToString:FUNC_FAVORATE_DES]  || [f.value isEqualToString:FUNC_SYNC_DES]) {
                continue;
            }
            [result addObject:f];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query function.");
        
    }
    return nil;
}

- (NSString*) getFunctionNameWithDes:(NSString *) funcDes
{
    NSString *funcName = @"";
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"select * from function where value = '%@'",funcDes];
        FMResultSet * rs = [db executeQuery:sql];
        if ([rs next])
        {
            funcName = [rs stringForColumn:@"name"];
        }
        [rs close];
        [db close];
        return funcName;
    }
    else
    {
        NSLog(@"error when query function.");
        
    }
    return funcName;
}

- (BOOL) deleteFunctionWithDes:(NSString *) funcDes{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from function where value = '%@'",funcDes];
        [db executeUpdate:sql];
        [db close];
        return YES;
    }else{
        NSLog(@"error when query function.");
    }
    return NO;
}

- (BOOL) hasFunction:(NSString*) functionName{
    BOOL ret = FALSE;
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"select * from function where value='%@'",functionName];
        FMResultSet * rs = [db executeQuery:sql];
        ret = [rs next];
        
        [rs close];
        [db close];
        
    }
    else
    {
        NSLog(@"error when query function.");
        
    }
    return ret;
}

- (BOOL) saveCustomerCategories:(PBArray*) customerCategories
{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from customer_category;"];
        
        for (CustomerCategory* cc in customerCategories)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into customer_category (id,name) values (%d,'%@');",cc.id,cc.name]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (NSMutableArray*) getCustomerCategories
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from customer_category";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            CustomerCategory_Builder* v1 = [CustomerCategory builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            
            CustomerCategory* cc = [v1 build];
            [result addObject:cc];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query customer category.");
        
    }
    return nil;
}

- (NSMutableArray*) getFavPatrolCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from patrol_category where favorites = 1;";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            PatrolCategory_Builder* v1 = [PatrolCategory builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            
            PatrolCategory* pc = [v1 build];
            [result addObject:pc];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query patrol category.");
        
    }
    return result;
}
- (BOOL) savePatrolCategories:(PBArray*) patrolCategories{
    NSMutableArray* favPatrolCategories = nil;//[self getFavPatrolCategories];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        
        [db executeUpdate:@"delete from patrol_category;"];
        
        for (PatrolCategory* pc in patrolCategories){
            if (favPatrolCategories.count > 0){
                int fav = 0;
                for (int i = 0;i < favPatrolCategories.count;i++){
                    PatrolCategory* favPatrolCategory = (PatrolCategory*)[favPatrolCategories objectAtIndex:i];
                    if (pc.id == favPatrolCategory.id){
                        fav = 1;
                    }
                }
                NSString* sql = [NSString stringWithFormat:@"insert into patrol_category (id,name,favorites) values (%d,'%@',%d);",pc.id,pc.name,fav];
                [db executeUpdate:sql];
            }else{
                int fav = [pc isFav] ? 1 : 0;
                
                NSString* sql = [NSString stringWithFormat:@"insert into patrol_category (id,name,favorites) values (%d,'%@',%d);",pc.id,pc.name,fav];
                [db executeUpdate:sql];

            }
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (BOOL) favPatrolCategory:(PatrolCategory*) pc Fav:(int)fav{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"update patrol_category set favorites = %d where id=%d;",fav,pc.id];
        [db executeUpdate:sql];
        [db close];
        return YES;
        
    }
    else
    {
        NSLog(@"error when fav patrol category.");
        
    }
    return NO;
}
- (NSMutableArray*) getPatrolCategories
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from patrol_category order by favorites desc;";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            PatrolCategory_Builder* v1 = [PatrolCategory builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            
            PatrolCategory* pc = [v1 build];
            [result addObject:pc];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query patrol category.");
        
    }
    return nil;
}

- (BOOL) saveMessages:(PBArray*) messages
{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        //[db executeUpdate:@"delete from message;"];
        
        for (SysMessage* message in messages)
        {
            NSString* sql = @"";
            sql = [NSString stringWithFormat:@"insert into message (id,content,create_date,readed,status,user) values (%d,'%@','%@','%@','%@');",message.id,message.content,message.createDate,@"N",@"N"];
            [db executeUpdate:sql];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (BOOL) saveMessage:(SessionMessage*) wtm{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    SysMessage* m = [SysMessage parseFromData:wtm.body.content];
    if ([db open])
    {
        [db beginTransaction];
        NSString* avtar = @"";
        if (wtm.header.sender.avatars.count > 0){
            avtar = [wtm.header.sender.avatars objectAtIndex:0];
        }
        NSString* sql = @"";
            sql = [NSString stringWithFormat:@"insert into message (id,content,create_date,readed,status,userId,realName,avtar,userName,type,sourceId) values (%d,'%@','%@','%@','%@','%d','%@','%@','%@',%d,'%@');",m.id,m.content,m.createDate,@"N",@"N",wtm.header.sender.id,wtm.header.sender.realName,avtar,wtm.header.sender.userName,m.type,m.sourceId];
        [db executeUpdate:sql];

        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (int) getUnReadMessageCountWithUser:(int) userId{
    FMDatabase* _db = [FMDatabase databaseWithPath:dbPath];
    int count = 0;
    if ([_db open])
    {
        NSString * sql = [NSString stringWithFormat:@"select count(id) as count from message where userId = %d  and readed = 'N' and deleted = 0 order by create_date desc;",userId];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next])
        {
            count = [rs intForColumn:@"count"];
        }
        [rs close];
        [_db close];
        return count;
        
    }
    else
    {
        NSLog(@"error when query message.");
        
    }
    return count;
}
- (NSMutableArray*) getUnReadMessagesWithUser:(int) userId{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"select * from message where userId = %d and deleted = 0 order by id desc;",userId];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            SysMessage_Builder* v1 = [SysMessage builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setContent: [rs stringForColumn:@"content"]];
            [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
            [v1 setType:[rs intForColumn:@"type"]];
            [v1 setSourceId:[rs stringForColumn:@"sourceId"]];
            SysMessage* m = [v1 build];
            [result addObject:m];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query message.");
        
    }
    return nil;
}
- (NSMutableArray*) getUsersByMessage{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from message where deleted = 0 group by userId order by id desc;";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            User_Builder* ubv1 = [User builder];
            [ubv1 setId: [rs intForColumn:@"userId"]];
            [ubv1 setUserName:[rs stringForColumn:@"userName"]];
            [ubv1 setRealName:[rs stringForColumn:@"realName"]];
            [ubv1 setAvatarsArray:[[ NSArray alloc] initWithObjects:[rs stringForColumn:@"avtar"], nil]];
            
            User* u = [ubv1 build];
            [result addObject:u];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query message.");
        
    }
    return nil;

}

- (User*) getUserByMessage:(int)messageId{
    User* u = nil;
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"select * from message where id = %d;",messageId];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            User_Builder* ubv1 = [User builder];
            [ubv1 setId: [rs intForColumn:@"userId"]];
            [ubv1 setUserName:[rs stringForColumn:@"userName"]];
            [ubv1 setRealName:[rs stringForColumn:@"realName"]];
            [ubv1 setAvatarsArray:[[ NSArray alloc] initWithObjects:[rs stringForColumn:@"avtar"], nil]];
            
            u = [ubv1 build];
        }
        [rs close];
        [db close];
        return u;
        
    }
    else
    {
        NSLog(@"error when query message.");
        
    }
    return nil;
    
}

- (int) getMessagesCount:(int) userId{
    FMDatabase* _db = [FMDatabase databaseWithPath:dbPath];
    int count = 0;
    if ([_db open])
    {
        NSString * sql = @"";
        if (userId != 0) {
            sql = [NSString stringWithFormat:@"select count(id) as count from message where userId = %d order by create_date desc;",userId];
        }else{
            sql = @"select count(id) as count from message order by create_date desc;";
        }
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next])
        {
            count = [rs intForColumn:@"count"];
        }
        [rs close];
        [_db close];
        return count;
        
    }
    else
    {
        NSLog(@"error when query message.");
        
    }
    return count;
}

- (NSMutableArray*) getMessages:(int) pageSize UserId:(int) userId{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* _db = [FMDatabase databaseWithPath:dbPath];
    int currentPage = (pageSize - 1)*PAGESIZE;
    if ([_db open])
    {
        NSString * sql = @"";
        if (userId != 0) {
            sql = [NSString stringWithFormat:@"select * from message where userId = %d order by id desc limit %d,%d",userId,currentPage,PAGESIZE];
        }else{
            sql= [NSString stringWithFormat:@"select * from message order by id desc limit %d,%d",currentPage,PAGESIZE];
        }
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next])
        {
            SysMessage_Builder* v1 = [SysMessage builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setContent: [rs stringForColumn:@"content"]];
            [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
            [v1 setSourceId:[rs stringForColumn:@"sourceId"]];
            [v1 setType:[rs intForColumn:@"type"]];
            [v1 setReadStatus:[rs stringForColumn:@"readed"]];
            
            SysMessage* m = [v1 build];
            [result addObject:m];
        }
        [rs close];
        [_db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query message.");
        
    }
    return nil;
}

- (NSMutableArray*) getMessages
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from message order by create_date desc limit 0,20";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            SysMessage_Builder* v1 = [SysMessage builder];

            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setContent: [rs stringForColumn:@"content"]];
            [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
            [v1 setType:[rs intForColumn:@"type"]];
            [v1 setSourceId:[rs stringForColumn:@"sourceId"]];
            
            SysMessage* m = [v1 build];
            [result addObject:m];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query message.");
        
    }
    return nil;
}

-(SysMessage*) getLastestMessage:(int) userId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"";
        if (userId != 0) {
            sql = [NSString stringWithFormat:@"select * from message where userId = %d and deleted = 0 order by id desc limit 0,1",userId];
        }else{
            sql = @"select * from message order by id desc limit 0,1";
        }
       
        FMResultSet * rs = [db executeQuery:sql];
        
        SysMessage* m = nil;
        SysMessage_Builder* v1 = [SysMessage builder];
        if ([rs next]){
            
            [v1 setId:[rs intForColumn:@"id"]];
            [v1 setContent:[rs stringForColumn:@"content"]];
            [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
            [v1 setType:[rs intForColumn:@"type"]];
            [v1 setSourceId:[rs stringForColumn:@"sourceId"]];

        }else{
            [v1 setId:-1];
        }
        
        m = [v1 build];
        [rs close];
        [db close];
        return m;
    }
    else
    {
        NSLog(@"error when query lastest message.");
    }
    return nil;
    
}

- (BOOL) readMessage:(int)type SourceId:(NSString*) sourceId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];

        NSString * sql = [NSString stringWithFormat:@"update message set readed = 'Y' where type=%d and sourceId = '%@';", type,sourceId];
        [db executeUpdate:sql];

        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (BOOL) deleteMessage:(int) userId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        
        NSString * sql = [NSString stringWithFormat:@"update message set deleted = 1 where userId=%d;", userId];
        [db executeUpdate:sql];
        
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (BOOL) readMessage:(int) userId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        
        NSString * sql = [NSString stringWithFormat:@"update message set readed = 'Y' where userId=%d;", userId];
        [db executeUpdate:sql];
        
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (int) getAnnouncesCount{
    FMDatabase* _db = [FMDatabase databaseWithPath:dbPath];
    int count = 0;
    if ([_db open])
    {
        NSString * sql = @"select count(id) as count from announce order by create_date desc;";
        FMResultSet * rs = [_db executeQuery:sql];
        
        while ([rs next])
        {
            count = [rs intForColumn:@"count"];
        }
        [rs close];
        [_db close];
        return count;
        
    }
    else
    {
        NSLog(@"error when query announce.");
        
    }
    return 0;
}

- (int) getUnReadAnnouncesCount{
    FMDatabase* _db = [FMDatabase databaseWithPath:dbPath];
    int count = 0;
    if ([_db open])
    {
        NSString * sql = @"select count(id) as count from announce where readed = 'N' and deleted = 0 order by create_date desc;";
        FMResultSet * rs = [_db executeQuery:sql];
        
        while ([rs next])
        {
            count = [rs intForColumn:@"count"];
        }
        [rs close];
        [_db close];
        return count;
    }
    else
    {
        NSLog(@"error when query announce.");
        
    }
    return 0;
}

- (NSMutableArray*) getAnnounces:(int) pageSize{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* _db = [FMDatabase databaseWithPath:dbPath];
    int currentPage = (pageSize - 1)*PAGESIZE;
    if ([_db open])
    {
        NSString * sql = [NSString stringWithFormat:@"select * from announce order by id desc limit %d,%d",currentPage,PAGESIZE ];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next])
        {
            Announce_Builder* v1 = [Announce builder];
        
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setSubject: [rs stringForColumn:@"subject"]];
            [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
            [v1 setReadStatus:[rs stringForColumn:@"readed"]];
            
            
            
            User_Builder *u = [User builder];
            [u setId:[rs intForColumn:@"userid"]];
            [u setUserName:@""];
            [u setRealName:[rs stringForColumn:@"realName"]];
            [u setAvatarsArray:[[NSArray alloc] initWithObjects:[rs stringForColumn:@"avtar"], nil]];
            
            User *u1 = [u build];
            
            [v1 setCreator:u1];
            
            Announce* a = [v1 build];
            [result addObject:a];
        }
        [rs close];
        [_db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query announce.");
        
    }
    return nil;
}

- (BOOL) setReceivedAnnouncesStatus:(PBArray *)announces{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        //[db executeUpdate:@"delete from message;"];
        
        for (Announce* announce in announces)
        {
            NSString * sql = [NSString stringWithFormat:@"update announce set status = 'Y' where id=%d;", announce.id];
            [db executeUpdate:sql];
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (BOOL) setReadedAnnounceStatus:(Announce *)announce{

    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];

        NSString * sql = [NSString stringWithFormat:@"update announce set readed = 'Y' where id=%d;", announce.id];
        [db executeUpdate:sql];
        
        [db commit];
        [db close];
        return YES;
    }
    return NO;

}

- (BOOL) deleteAnnounce{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        
        NSString * sql = [NSString stringWithFormat:@"update announce set deleted = 1;"];
        [db executeUpdate:sql];
        
        [db commit];
        [db close];
        return YES;
    }
    return NO;

}

- (BOOL) deleteAnnounce:(Announce *)announce{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        
        NSString * sql = [NSString stringWithFormat:@"delete from announce where id=%d;", announce.id];
        [db executeUpdate:sql];
        
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (NSMutableArray*) getAllUnreceivedAnnounces{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
        if ([db open])
        {
            NSString * sql = @"select * from announce where status = 'N'";
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next])
            {
                Announce_Builder* v1 = [Announce builder];
                [v1 setId: [rs intForColumn:@"id"]];
                [v1 setSubject: [rs stringForColumn:@"subject"]];
                [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
                [v1 setReadStatus:[rs stringForColumn:@"readed"]];
                [v1 setReceiveStatus:[rs stringForColumn:@"status"]];
                
                Announce* a = [v1 build];
                [result addObject:a];
            }
            [rs close];
            [db close];
            return result;
            
        }
        else
        {
            NSLog(@"error when query announce.");
            
        }
    
    return NULL;
}

- (BOOL) saveAnnounces:(PBArray*) announces{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        //[db executeUpdate:@"delete from message;"];
        
        for (Announce* announce in announces)
        {
            NSString* sql = @"";
            sql = [NSString stringWithFormat:@"insert into announce (id,subject,create_date,readed,status) values (%d,'%@','%@','%@','%@');",announce.id,announce.subject,announce.createDate,@"N",@"N"];
            [db executeUpdate:sql];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (BOOL) saveAnnounce:(SessionMessage*) wtm{
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    Announce* a = [Announce parseFromData:wtm.body.content];
    if ([db open])
    {
        [db beginTransaction];
        NSString* avtar = @"";
        if (wtm.header.sender.avatars.count > 0){
            avtar = [wtm.header.sender.avatars objectAtIndex:0];
        }

        
        NSString* sql = @"";
        sql = [NSString stringWithFormat:@"insert into announce (id,subject,create_date,readed,status,realName,avtar) values (%d,'%@','%@','%@','%@','%@','%@');",a.id,a.subject,a.createDate,@"N",@"N",wtm.header.sender.realName,avtar];
        [db executeUpdate:sql];

        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (BOOL) saveAnnounce2:(Announce*) a{
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        NSString* avtar = @"";
        if (a.creator.avatars.count > 0){
            avtar = [a.creator.avatars objectAtIndex:0];
        }
        
        
        NSString* sql = @"";
        sql = [NSString stringWithFormat:@"insert into announce (id,subject,create_date,readed,status,userid,realName,avtar) values (%d,'%@','%@','%@','%@',%d,'%@','%@');",a.id,a.subject,a.createDate,@"N",@"N",a.creator.id,a.creator.realName,avtar];
        [db executeUpdate:sql];
        
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (NSMutableArray*) getAnnounces{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from announce order by id desc limit 0,100";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Announce_Builder* v1 = [Announce builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setSubject: [rs stringForColumn:@"subject"]];
            [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
            
            Announce* a = [v1 build];
            [result addObject:a];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query announce.");
        
    }
    return nil;

}

-(BOOL)saveAnnounceSender:(User*)sender{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        NSString* avtar = @"";
        if (sender.avatars.count > 0){
            avtar = [sender.avatars objectAtIndex:0];
        }
        NSString* sql = @"";
        sql = [NSString stringWithFormat:@"insert into announce_sender(id,userName,realName,avtar) values (%d,'%@','%@','%@');",sender.id,sender.userName,sender.realName,avtar];
        [db executeUpdate:sql];
        [db commit];

        [db close];
        return YES;
    }
    
    return NO;
}

-(BOOL)updateAnnounceSender:(User*)sender;{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        NSString* avtar = @"";
        if (sender.avatars.count > 0){
            avtar = [sender.avatars objectAtIndex:0];
        }
    
        NSString * sql = [NSString stringWithFormat:@"update announce set avtar = '%@' where userid=%d;",avtar,sender.id];
       
        
        [db executeUpdate:sql];
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

-(NSMutableArray*)getAnnouncesenders{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from announce_sender";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            User_Builder *v1 = [User builder];
            [v1 setId:[rs intForColumn:@"id"]];
            [v1 setRealName:[rs stringForColumn:@"realName"]];
            [v1 setUserName:[rs stringForColumn:@"userName"]];
            [v1 setAvatarsArray:[[NSArray alloc] initWithObjects:[rs stringForColumn:@"avtar"], nil]];
            User *u = [v1 build];
            [result addObject:u];
            
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query announce.");
        
    }
    return nil;

}

#pragma mark ----------我发出的通知
-(BOOL)saveMyAnnounce:(Announce*)an {
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
         NSString* avtar = @"";
        if (an.creator.avatars.count > 0){
            avtar = [an.creator.avatars objectAtIndex:0];
        }

        NSString* sql = @"";
        sql = [NSString stringWithFormat:@"insert into my_announce (id,subject,create_date,readed,status,realName,avtar) values (%d,'%@','%@','%@','%@','%@','%@');",an.id,an.subject,an.createDate,@"N",@"N",an.creator.realName,avtar];
        [db executeUpdate:sql];
        
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;

}

-(NSMutableArray*)getMyAnnounce{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from my_announce";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Announce_Builder* v1 = [Announce builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setSubject: [rs stringForColumn:@"subject"]];
            [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
            
            User_Builder *u1 = [User builder];
            [u1 setId:108];
            [u1 setRealName:[rs stringForColumn:@"realName"]];
            [u1 setAvatarsArray:[[NSArray alloc] initWithObjects:[rs stringForColumn:@"avtar"], nil]];
            
            User *u = [u1 build];
            [v1 setCreator:u];
            
            Announce* a = [v1 build];
            [result addObject:a];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query announce.");
        
    }
    return nil;

}

- (Announce*) getLastestAnnounce{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from announce where deleted = 0 order by id desc limit 0,1";
        FMResultSet * rs = [db executeQuery:sql];
        
        Announce* a = nil;
        Announce_Builder* v1 = [Announce builder];
        if ([rs next]){
            [v1 setId:[rs intForColumn:@"id"]];
            [v1 setSubject: [rs stringForColumn:@"subject"]];
            [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
            
            User_Builder *u = [User builder];
            [u setId:-1];
            [u setUserName:@""];
            [u setRealName:[rs stringForColumn:@"realName"]];
            [u setAvatarsArray:[[NSArray alloc] initWithObjects:[rs stringForColumn:@"avtar"], nil]];
            
            User *u1 = [u build];
            
            [v1 setCreator:u1];
        }else{
            return nil;
            [v1 setId:-1];
        }
        
        a = [v1 build];
        [rs close];
        [db close];
        return a;
    }
    else
    {
        NSLog(@"error when query lastest announce.");
    }
    return nil;

}

- (Announce*) getLastestUnReadAnnounce{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from announce where readed = 'N' and deleted = 0 order by id desc limit 0,1";
        FMResultSet * rs = [db executeQuery:sql];
        
        Announce* a = nil;
        Announce_Builder* v1 = [Announce builder];
        if ([rs next]){
            [v1 setId:[rs intForColumn:@"id"]];
            [v1 setSubject: [rs stringForColumn:@"subject"]];
            [v1 setCreateDate:[rs stringForColumn:@"create_date"]];
            
            User_Builder *u = [User builder];
            [u setId:-1];
            [u setUserName:@""];
            [u setRealName:[rs stringForColumn:@"realName"]];
            [u setAvatarsArray:[[NSArray alloc] initWithObjects:[rs stringForColumn:@"avtar"], nil]];
            
            User *u1 = [u build];
            
            [v1 setCreator:u1];
            
        }else{
            [v1 setId:-1];
        }
        a = [v1 build];
        [rs close];
        [db close];
        return a;
    }
    else
    {
        NSLog(@"error when query lastest announce.");
    }
    return nil;
}

- (BOOL) saveUsers:(PBArray*) users
{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from user;"];
        
        for (User* user in users)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into user (id,username,password,realname,email,departmentName,pinyin,departmentId) values (%d,'%@','%@','%@','%@','%@','%@',%d)",user.id,user.userName,user.password,user.realName,user.email,user.department.name,user.spell,user.department.id]];
        }
        [db commit];
        [db close];
        return YES;
    }
  
    return NO;
}

- (NSMutableArray*) getUsers
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from user";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            User_Builder* v1 = [User builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setUserName: [rs stringForColumn:@"username"]];
            [v1 setPassword: [rs stringForColumn:@"password"]];
            [v1 setRealName: [rs stringForColumn:@"realname"]];
            [v1 setEmail: [rs stringForColumn:@"email"]];
            
            Department_Builder* dv1 = [Department builder];
            [dv1 setName:[rs stringForColumn:@"departmentName"]];
            [dv1 setId:[rs intForColumn:@"departmentId"]];
            [v1 setDepartment:[dv1 build]];

            User* u = [v1 build];
            [result addObject:u];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query user.");
        
    }
    return nil;
}

- (NSMutableArray*) getProductSupplies:(int) customerId;
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [ NSString stringWithFormat:@"select id,name,unit,price from product_supply where customer_id=%d",customerId] ;
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Product_Builder* v1 = [Product builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setUnit: [rs stringForColumn:@"unit"]];
            [v1 setPrice: [[rs stringForColumn:@"price"] floatValue]];
            Product* p = [v1 build];
            [result addObject:p];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query product.");
    }
    return nil;
}

- (NSMutableArray*) getProducts:(int) customerId PruductName:(NSString*) name Index:(int) index{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSString* sql = nil;
        int pageIndex = PAGESIZE * index;
        if ([name isEqualToString:@""]){
            sql = [ NSString stringWithFormat:@"select id,name,unit,price from product_supply where customer_id=%d limit %d,%d",customerId,pageIndex,PAGESIZE] ;
        }
        else{
            sql = [ NSString stringWithFormat:@"select id,name,unit,price from product_supply where name like '%%%@%%' and customer_id=%d limit %d,%d",name,customerId,pageIndex,PAGESIZE] ;
        }
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Product_Builder* v1 = [Product builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setUnit: [rs stringForColumn:@"unit"]];
            [v1 setPrice: [[rs stringForColumn:@"price"] floatValue]];
            
            Product* p = [v1 build];
            [result addObject:p];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query product.");
    }
    return nil;
}

- (NSMutableArray*) getProducts:(NSString*) name Index:(int) index{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        int pageIndex = PAGESIZE * index;
        NSString* sql = nil;
        if ([name isEqualToString:@""]){
            sql = [ NSString stringWithFormat:@"select id,name,unit,price from product where favorites=0 limit %d,%d",pageIndex,PAGESIZE] ;
        }
        else{
            sql = [ NSString stringWithFormat:@"select id,name,unit,price from product where favorites=0 and name like '%%%@%%' limit %d,%d",name,pageIndex,PAGESIZE] ;
        }
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Product_Builder* v1 = [Product builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setUnit: [rs stringForColumn:@"unit"]];
            [v1 setPrice: [[rs stringForColumn:@"price"] floatValue]];

            Product* p = [v1 build];
            [result addObject:p];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query product.");
    }
    return nil;
}

- (NSMutableArray*) getProducts{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){

        FMResultSet * rs = [db executeQuery:@"select id,name,unit,price from product where favorites=0"];
        while ([rs next])
        {
            Product_Builder* v1 = [Product builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setUnit: [rs stringForColumn:@"unit"]];
            [v1 setPrice: [[rs stringForColumn:@"price"] floatValue]];
            
            Product* p = [v1 build];
            [result addObject:p];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query product.");
    }
    return nil;
}

- (int) getProductTotal:(int) customerId PruductName:(NSString*) name{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    int total = 0;
    if ([db open]){
        NSString* sql = nil;
        if ([name isEqualToString:@""]){
            sql = [ NSString stringWithFormat:@"select count(id) from product_supply where customer_id=%d",customerId] ;
        }
        else{
            sql = [ NSString stringWithFormat:@"select count(id) from product_supply where name like '%%%@%%' and customer_id=%d",name,customerId] ;
        }
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            total = [rs intForColumnIndex:0];
        }
        
        [rs close];
        [db close];
        return total;
        
    }
    else
    {
        NSLog(@"error when count product.");
    }
    return total;
}

- (int) getProductTotal:(NSString*) name{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    int total = 0;
    if ([db open]){
        NSString* sql = nil;
        if ([name isEqualToString:@""]){
            sql = [ NSString stringWithFormat:@"select count(id) from product"] ;
        }
        else{
            sql = [ NSString stringWithFormat:@"select count(id) from product where name like '%%%@%%'",name] ;
        }
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            total = [rs intForColumnIndex:0];
        }
        
        [rs close];
        [db close];
        return total;
        
    }
    else
    {
        NSLog(@"error when count product.");
    }
    return total;

}

- (NSMutableArray*) getFavProducts{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from product where favorites = 1;";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Product_Builder* v1 = [Product builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setUnit: [rs stringForColumn:@"unit"]];
            [v1 setPrice: [[rs stringForColumn:@"price"] floatValue]];

            Product* p = [v1 build];
            [result addObject:p];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query fav products.");
        
    }
    return result;
}

- (BOOL) favProduct:(Product*) p Fav:(int)fav{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"update product set favorites = %d where id=%d;",fav,p.id];
        [db executeUpdate:sql];
        [db close];
        return YES;
        
    }
    else
    {
        NSLog(@"error when fav product.");
        
    }
    return NO;
}

- (BOOL) saveCompetitionProducts:(PBArray*) competitionProducts{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from competition_product;"];
        
        for (CompetitionProduct* cp in competitionProducts)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into competition_product (id,name,unit,price) values (%d,'%@','%@','%@')",cp.id,cp.name,cp.unit,[NSString stringWithFormat:@"%.2f", cp.price]]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
    
}

- (NSMutableArray*) getCompetitionProducts{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select id,name,unit,price from competition_product" ;
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            CompetitionProduct_Builder* v1 = [CompetitionProduct builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setPrice:[[rs stringForColumn:@"price"] floatValue]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setUnit: [rs stringForColumn:@"unit"]];
            
            CompetitionProduct* cp = [v1 build];
            [result addObject:cp];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query competition product.");
    }
    return nil;

}

- (NSMutableArray*) getCompetitionProducts:(NSString*) name Index:(int) index{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        int pageIndex = PAGESIZE * index;
        NSString* sql = nil;
        if ([name isEqualToString:@""]){
            sql = [ NSString stringWithFormat:@"select id,name,unit,price from competition_product limit %d,%d",pageIndex,PAGESIZE] ;
        }
        else{
            sql = [ NSString stringWithFormat:@"select id,name,unit,price from competition_product where name like '%%%@%%' limit %d,%d",name,pageIndex,PAGESIZE] ;
        }
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            CompetitionProduct_Builder* v1 = [CompetitionProduct builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setPrice:[[rs stringForColumn:@"price"] floatValue]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setUnit: [rs stringForColumn:@"unit"]];

            
            CompetitionProduct* cp = [v1 build];
            [result addObject:cp];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query competition product.");
    }
    return nil;
}

- (int) getCompetitionProductTotal:(NSString*) name{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    int total = 0;
    if ([db open]){
        NSString* sql = nil;
        if ([name isEqualToString:@""]){
            sql = [ NSString stringWithFormat:@"select count(id) from competition_product"] ;
        }
        else{
            sql = [ NSString stringWithFormat:@"select count(id) from competition_product where name like '%%%@%%'",name] ;
        }
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            total = [rs intForColumnIndex:0];
        }
        
        [rs close];
        [db close];
        return total;
        
    }
    else
    {
        NSLog(@"error when count competition product.");
    }
    return total;
}

- (NSMutableArray*) getCustomerContacts:(int) customerId{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        
        FMResultSet * rs = [db executeQuery:[NSString stringWithFormat:@"select id,name,phone from customer_contact where id=%d",customerId]];
        while ([rs next])
        {
            Contact_Builder* v1 = [Contact builder];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setPhoneArray:[[NSArray alloc] initWithObjects:[rs stringForColumn:@"phone"], nil]];
            
            Contact* c = [v1 build];
            [result addObject:c];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query customer contact.");
    }
    return nil;
}


- (NSMutableArray*) getCustomers
{
    NSString* sql = @"select c.id,c.category_id,category.name as categoryname,c.user_id,c.name,c.address,c.contact,c.phone,c.longitude,c.latitude,c.pinyin from customer c left join customer_category category on c.category_id = category.id";
    return [self _getCustomers:sql];
}

- (NSMutableArray*) getCustomers2:(int) categoryId
{
    NSString* sql = [NSString stringWithFormat:@"select c.id,c.category_id,category.name as categoryname,c.user_id,c.name,c.address,c.contact,c.phone,c.longitude,c.latitude,c.pinyin from customer c left join customer_category category on c.category_id = category.id where c.category_id=%d",categoryId];
    return [self _getCustomers:sql];
}

- (NSMutableArray*) getCustomers:(int) categoryId
{
    NSString* sql = [NSString stringWithFormat:@"select c.id,c.category_id,category.name as categoryname,c.user_id,c.name,c.address,c.contact,c.phone,c.longitude,c.latitude,c.pinyin from customer c left join customer_category category on c.category_id = category.id where c.category_id=%d and c.favorites =0",categoryId];
    return [self _getCustomers:sql];
}

- (NSMutableArray*) getCustomers:(int) categoryId UserId:(int) userId{
    NSString* sql = [NSString stringWithFormat:@"select c.id,c.category_id,category.name as categoryname,c.user_id,c.name,c.address,c.contact,c.phone,c.longitude,c.latitude,c.pinyin from customer c left join customer_category category on c.category_id = category.id,customer_user cu where c.id=uc.id and uc.uid=%d and c.category_id=%d",categoryId,userId];
     return [self _getCustomers:sql];
}

- (NSMutableArray*) _getCustomers:(NSString*) sql
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Customer_Builder* v1 = [Customer builder];
            
            CustomerCategory_Builder* ccv1 = [CustomerCategory builder];
            [ccv1 setId: [rs intForColumn:@"category_id"]];
            [ccv1 setName:[rs stringForColumn:@"categoryname"]];
            [v1 setCategory:[ccv1 build]];
        
            Location_Builder* lv1 = [Location builder];
            [lv1 setLongitude: [rs doubleForColumn:@"longitude"]];
            [lv1 setLatitude: [rs doubleForColumn:@"latitude"]];
            [lv1 setAddress:[rs stringForColumn:@"address"]];
            //[v1 setLocation:[lv1 build]];
            
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setSpell: [rs stringForColumn:@"pinyin"]];

            
            Customer* c = [v1 build];
            [result addObject:c];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query product.");
    }
    return result;
}

- (BOOL) favCustomer:(Customer*) customer Fav:(int)fav{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"update customer set favorites = %d where id=%d;", fav,customer.id];
        [db executeUpdate:sql];
        [db close];
        return YES;
    }
    else
    {
        NSLog(@"error when fav customer.");
        
    }
    return NO;
}
- (NSMutableArray*) getFavCustomers{
    NSString* sql = @"select c.id,c.category_id,category.name as categoryname,c.user_id,c.name,c.address,c.contact,c.phone,c.longitude,c.latitude,c.pinyin from customer c left join customer_category category on c.category_id = category.id where c.favorites=1";
    return [self _getCustomers:sql];

}

- (NSMutableArray*) getFavCustomersWithName:(NSString *) name{
    NSString* sql = @"select c.id,c.category_id,category.name as categoryname,c.user_id,c.name,c.address,c.contact,c.phone,c.longitude,c.latitude,c.pinyin from customer c left join customer_category category on c.category_id = category.id where c.favorites=1 and c.name like '%%%@%%'";
    sql = [NSString stringWithFormat:sql,name];
    return [self _getCustomers:sql];
}

-(BOOL) hasFavCustomer:(Customer *) c{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select id from customer where favorites = 1 and id = %d",c.id];
        FMResultSet * rs = [db executeQuery:sql];
        BOOL ist = NO;
        if ([rs next]) {
            ist = YES;
        }
        [rs close];
        [db close];
        return ist;
    }
    else
    {
        NSLog(@"error when query product.");
    }
    return NO;
}

- (Contact*) getContactWithCustomer:(Customer*) c{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    Contact* contact = nil;
    if ([db open])
    {
        NSString* sql = [NSString stringWithFormat:@"select * from customer_contact where id=%d",c.id];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Contact_Builder* cbv1 = [Contact builder];
            [cbv1 setName:[rs stringForColumn:@"name"]];
            NSString* phone = [rs stringForColumn:@"phone"];
            if (phone.length > 0)
                [cbv1 setPhoneArray:[[NSArray alloc] initWithObjects:phone, nil]];
            else
                [cbv1 setPhoneArray:[[NSArray alloc] initWithObjects:@"", nil]];

            contact = [cbv1 build];
        }
        [rs close];
        [db close];
        return contact;
        
    }
    else
    {
        NSLog(@"error when query product.");
    }
    return contact;
}

- (BOOL) saveCustomer:(Customer*) customer{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        [db beginTransaction];
        //保存前删除原有的客户相关资料
        [db executeUpdate:[NSString stringWithFormat:@"delete from product_supply where customer_id=%d",customer.id]];
        [db executeUpdate:[NSString stringWithFormat:@"delete from customer_user where id=%d",customer.id]];
        [db executeUpdate:[NSString stringWithFormat:@"delete from customer where id=%d",customer.id]];
        [db executeUpdate:[NSString stringWithFormat:@"delete from customer_contact where id=%d",customer.id]];
        int nFav = customer.isFav?1:0;
        [db executeUpdate:[NSString stringWithFormat:@"insert into customer (id,category_id,name,address,longitude,latitude,pinyin,favorites) values (%d,%d,'%@','%@','%f','%f','%@',%d)",customer.id,customer.category.id,customer.name,customer.location.address,customer.location.longitude,customer.location.latitude,customer.spell,nFav]];
        
        for (int i = 0;i < customer.users.count;i++){
            User* u = [customer.users objectAtIndex:i];
            [db executeUpdate:[NSString stringWithFormat:@"insert into customer_user(id,uid) values(%d,%d)",customer.id,u.id]];
        }
        
        for (int i = 0;i < customer.products.count; i++){
            Product* p = [customer.products objectAtIndex:i];
            [db executeUpdate:[NSString stringWithFormat:@"insert into product_supply(customer_id,id,name,unit,price) values(%d,%d,'%@','%@','%@')",customer.id,p.id,p.name,p.unit,[NSString stringWithFormat:@"%.2f",p.price]]];
        }
        
        for (int i = 0; i < customer.contacts.count; i++) {
            Contact* c = [customer.contacts objectAtIndex:i];
            NSString* phone = @"";
            if (c.phone.count > 0) {
                phone = [c.phone objectAtIndex:0];
            }
            [db executeUpdate:[NSString stringWithFormat:@"insert into customer_contact(id,name,phone) values(%d,'%@','%@')",customer.id,c.name,phone]];
        }
        
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (BOOL) clearCustomerWithSync{
    FMDatabase* _db = [FMDatabase databaseWithPath:dbPath];
    if ([_db open])
    {
        [_db beginTransaction];
        [_db executeUpdate:@"delete from customer;"];
        [_db executeUpdate:@"delete from product_supply;"];
        [_db commit];
        [_db close];
        
        [self saveValueToUserDefaults:KEY_SYNC_CUSTOMER_CURRENT_SIZE Value:@"0"];
        [self saveValueToUserDefaults:KEY_SYNC_CUSTOMER_PAGE Value:@"1"];
        [self saveValueToUserDefaults:KEY_SYNC_CUSTOMER_STATUS Value:@"0"];
        [self saveValueToUserDefaults:KEY_SYNC_CUSTOMER_TOTAL_SIZE Value:@"0"];
        
        return YES;
    }
    
    return NO;
}

- (BOOL) saveProducts:(PBArray*) products{
    NSMutableArray* favPatrolProducts = nil;//[self getFavProducts];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        
        [db executeUpdate:@"delete from product;"];
        
        for (Product* p in products){
            if (favPatrolProducts.count > 0){
                int fav = 0;
                for (int i = 0;i < favPatrolProducts.count;i++){
                    Product* favProduct = (Product*)[favPatrolProducts objectAtIndex:i];
                    if (p.id == favProduct.id){
                        fav = 1;
                    }
                }
                [db executeUpdate:[NSString stringWithFormat:@"insert into product(id,name,unit,price,favorites) values(%d,'%@','%@','%@',%d)",p.id,p.name,p.unit,[NSString stringWithFormat:@"%.2f",p.price],fav]];
                
            }else{
                int fav = [p isFav] ? 1 : 0;
                
                [db executeUpdate:[NSString stringWithFormat:@"insert into product(id,name,unit,price,favorites) values(%d,'%@','%@','%@',%d)",p.id,p.name,p.unit,[NSString stringWithFormat:@"%.2f",p.price],fav]];
                
            }
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (BOOL) saveCustomers:(PBArray*) customers{
    NSMutableArray* favCustomers = [self getFavCustomers];

    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from customer;"];
        [db executeUpdate:@"delete from product_supply;"];
        [db executeUpdate:@"delete from customer_user;"];
        [db executeUpdate:@"delete from customer_contact;"];
        [db executeUpdate:@"delete from customer_tag_association;"];
        for (Customer* c in customers)
        {
            if (favCustomers.count > 0){
                int fav = 0;
                for (int i = 0;i < favCustomers.count;i++){
                    Customer* favCustomer = (Customer*)[favCustomers objectAtIndex:i];
                    if (c.id == favCustomer.id){
                        fav = 1;
                    }
                }
                
            
                [db executeUpdate:[NSString stringWithFormat:@"insert into customer (id,category_id,name,longitude,latitude,pinyin,favorites) values (%d,%d,'%@','%f','%f','%@',%d)",c.id,c.category.id,c.name,c.location.longitude,c.location.latitude,c.spell,fav]];
            }else{
                int fav = [c isFav] ? 1 : 0;
                [db executeUpdate:[NSString stringWithFormat:@"insert into customer (id,category_id,name,longitude,latitude,pinyin,favorites) values (%d,%d,'%@','%f','%f','%@',%d)",c.id,c.category.id,c.name,c.location.longitude,c.location.latitude,c.spell,fav]];
            }
            for (int i = 0;i < c.users.count;i++){
                User* u = [c.users objectAtIndex:i];
                [db executeUpdate:[NSString stringWithFormat:@"insert into customer_user(id,uid) values(%d,%d)",c.id,u.id]];
            }
            
            for (int i = 0;i < c.products.count; i++){
                Product* p = [c.products objectAtIndex:i];
                [db executeUpdate:[NSString stringWithFormat:@"insert into product_supply(customer_id,id,name,unit,price) values(%d,%d,'%@','%@','%@')",c.id,p.id,p.name,p.unit,[NSString stringWithFormat:@"%.2f",p.price]]];
            }
            
            for (int i = 0; i < c.contacts.count; i++) {
                Contact* cc = [c.contacts objectAtIndex:i];
                NSString* phone = @"";
                if (cc.phone.count > 0) {
                    phone = [cc.phone objectAtIndex:0];
                }
                [db executeUpdate:[NSString stringWithFormat:@"insert into customer_contact(id,name,phone) values(%d,'%@','%@')",c.id,cc.name,phone]];
            }
            //增加客户与客户标签关系
            for (int i = 0; i < c.tags.count; i++) {
                CustomerTag* ct = [c.tags objectAtIndex:i];
                for (int j = 0; j < ct.tagValues.count; j++) {
                    CustomerTagValue* ctv = [ct.tagValues objectAtIndex:j];
                    [db executeUpdate:[NSString stringWithFormat:@"insert into customer_tag_association(customer_id,tag_id,tag_value_id) values(%d,%d,%d)",c.id,ct.id,ctv.id]];
                }
                
            }

        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (BOOL) saveCustomersWithSync:(PBArray*) customers{
    NSMutableArray* favCustomers = [self getFavCustomers];
    FMDatabase* _db = [FMDatabase databaseWithPath:dbPath];
    if ([_db open])
    {
        [_db beginTransaction];
        
        for (Customer* c in customers)
        {
            if (favCustomers.count > 0){
                int fav = 0;
                for (int i = 0;i < favCustomers.count;i++){
                    Customer* favCustomer = (Customer*)[favCustomers objectAtIndex:i];
                    if (c.id == favCustomer.id){
                        fav = 1;
                    }
                }
                
                
                [_db executeUpdate:[NSString stringWithFormat:@"insert into customer (id,category_id,longitude,latitude,pinyin,favorites) values (%d,%d,'%@','%f','%f','%@',%d)",c.id,c.category.id,c.name,c.location.longitude,c.location.latitude,c.spell,fav]];
            }else{
                int fav = [c isFav] ? 1 : 0;
                [_db executeUpdate:[NSString stringWithFormat:@"insert into customer (id,category_id,name,longitude,latitude,pinyin,favorites) values (%d,%d,'%@','%f','%f','%@',%d)",c.id,c.category.id,c.name,c.location.longitude,c.location.latitude,c.spell,fav]];
            }
            /*for (int i = 0;i < c.users.count;i++){
             User* u = [c.users objectAtIndex:i];
             [_db executeUpdate:[NSString stringWithFormat:@"insert into customer_user(id,uid) values(%d,%d)",c.id,u.id]];
             }*/
            
            for (int i = 0;i < c.products.count; i++){
                Product* p = [c.products objectAtIndex:i];
                [_db executeUpdate:[NSString stringWithFormat:@"insert into product_supply(customer_id,id,name,unit,price) values(%d,%d,'%@','%@','%@')",c.id,p.id,p.name,p.unit,[NSString stringWithFormat:@"%.2f",p.price]]];
            }
            
            for (int i = 0; i < c.contacts.count; i++) {
                Contact* cc = [c.contacts objectAtIndex:i];
                NSString* phone = @"";
                if (cc.phone.count > 0) {
                    phone = [cc.phone objectAtIndex:0];
                }
                [_db executeUpdate:[NSString stringWithFormat:@"insert into customer_contact(id,name,phone) values(%d,'%@','%@')",c.id,cc.name,phone]];

            }
            
        }
        [_db commit];
        [_db close];
        return YES;
    }
    
    return NO;
    
}

- (NSMutableArray*) getWorkLogs:(int) limit
{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [ NSString stringWithFormat:@"select * from daily_report order by create_date desc limit 0,%d",limit] ;
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            User_Builder* uv1 = [User builder];
            [uv1 setId:[rs intForColumn:@"user_id"]];
            [uv1 setUserName:[rs stringForColumn:@"user_name"]];
            [uv1 setRealName:[rs stringForColumn:@"user_realname"]];
            
            WorkLog_Builder* v1 = [WorkLog builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setToday: [rs stringForColumn:@"today"]];
            [v1 setPlan: [rs stringForColumn:@"plan"]];
            [v1 setSpecial: [rs stringForColumn:@"special"]];
            [v1 setCreateDate: [rs stringForColumn:@"create_date"]];
            [v1 setUser:[uv1 build]];
            
            WorkLog* w = [v1 build];
            [result addObject:w];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query daily report.");
    }
    return nil;
}

- (BOOL) saveWorkLog:(WorkLog*) workLog
{
    NSString* sql = [NSString stringWithFormat:@"insert into daily_report(id,user_id,user_name,user_realname,today,plan,special,create_date) values('%@','%@','%@','%@','%@','%@','%@','%@')",[NSString stringWithFormat:@"%d",workLog.id],[NSString stringWithFormat:@"%d",workLog.user.id],workLog.user.userName,workLog.user.realName,workLog.today,workLog.plan,workLog.special,workLog.createDate];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        if (![db executeUpdate:sql]){
            [db close];
            return YES;
        }
        else
            NSLog(@"error when insert daily_report.");
    }
    [db close];
    return NO;
}

- (BOOL) saveCompany:(Company*) company{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        [db beginTransaction];
        @try
        {
            if (![db executeUpdate:@"delete from company"])
            {
                NSLog(@"error when delete company.");
            }
            
            NSString* avtar = @"";
            if (company.filePath.count > 0) {
                avtar = [company.filePath objectAtIndex:0];
            }
            NSString* sqlc = [NSString stringWithFormat:@"insert into company(id,name,desc,idea,avtar) values('%@','%@','%@','%@','%@')",company.id,company.name,company.desc,company.idea,avtar];
            
            if (![db executeUpdate:sqlc])
            {
                NSLog(@"error when insert company.");
            }
            [db commit];
            [db close];
        }
        @catch(NSException* e)
        {
            [db rollback];
            [db close];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) updateCompanyWithAvatar:(NSData* )image{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        [db beginTransaction];
        @try
        {
            NSString* sqlc = [NSString stringWithFormat:@"update company set avtarFile = '%@' ",image];
            
            if (![db executeUpdate:sqlc])
            {
                NSLog(@"error when update company avatar.");
            }
            [db commit];
            [db close];
        }
        @catch(NSException* e)
        {
            [db rollback];
            [db close];
            return NO;
        }
    }
    
    return YES;
}

- (NSString*) getCompanyAvatar{
    NSString* result = nil;
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select avtar from company;";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            result = [rs stringForColumn:@"avtar"];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query company avatar.");
    }
    return nil;
}

- (BOOL) saveLoginUser:(User*) user
{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        [db beginTransaction];
        @try
        {
            if (![db executeUpdate:@"delete from login_user"])
            {
                NSLog(@"error when delete login user.");
            }
            if (![db executeUpdate:@"delete from company"])
            {
                NSLog(@"error when delete company.");
            }
            
            NSString* sql = [NSString stringWithFormat:@"insert into login_user(id,username,password,realname,email,departmentName,departmentId,avatars,position_id,position_name) values('%@','%@','%@','%@','%@','%@',%d,'%@',%d,'%@')",[NSString stringWithFormat:@"%d",user.id],user.userName,user.password,user.realName,user.email,user.department.name,user.department.id,[user.avatars objectAtIndex:0],user.position.id,user.position.name];
            
            if (![db executeUpdate:sql])
            {
                NSLog(@"error when insert login user.");
            }
            NSString* avtar = @"";
            if (user.company.filePath.count > 0) {
                avtar = [user.company.filePath objectAtIndex:0];
            }
            NSString* sqlc = [NSString stringWithFormat:@"insert into company(id,name,desc,idea,avtar) values('%@','%@','%@','%@','%@')",user.company.id,user.company.name,user.company.desc,user.company.idea,avtar];
            
            if (![db executeUpdate:sqlc])
            {
                NSLog(@"error when insert company.");
            }
            [db commit];
            [db close];
        }
        @catch(NSException* e)
        {
            [db rollback];
            [db close];
            return NO;
        }
    }
    
    return YES;
}

- (User*) getLoginUser
{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from login_user";
        FMResultSet * rs = [db executeQuery:sql];
        User* u = nil;
        while ([rs next])
        {
            User_Builder* v1 = [User builder];
            
            [v1 setId:[rs intForColumnIndex:0]];
            [v1 setUserName:[rs stringForColumnIndex:1]];
            [v1 setPassword:[rs stringForColumnIndex:2]];
            [v1 setRealName:[rs stringForColumnIndex:3]];
            [v1 setEmail:[rs stringForColumnIndex:4]];
            NSString *avatars = [rs stringForColumn:@"avatars"];
            if (avatars.length > 0) {
                [v1 setAvatarsArray:@[avatars]];
            }
            
            Department_Builder* dv1 = [Department builder];
            [dv1 setName:[rs stringForColumn:@"departmentName"]];
            [dv1 setId:[rs intForColumn:@"departmentId"]];
            [v1 setDepartment:[dv1 build]];
            
            Position_Builder *pv1 = [Position builder];
            [pv1 setId:[rs intForColumn:@"position_id"]];
            [pv1 setName:[rs stringForColumn:@"position_name"]];
            [v1 setPosition:[pv1 build]];
            
            NSString* sqlc = @"select * from company";
            FMResultSet* rsc = [db executeQuery:sqlc];
            
            Company_Builder* cv1 = nil;
            while ([rsc next])
            {
                cv1 = [Company builder];
                [cv1 setId: [rsc stringForColumnIndex:0]];
                [cv1 setName: [rsc stringForColumnIndex:1]];
                [cv1 setDesc:[rsc stringForColumn:@"desc"]];
                [cv1 setIdea:[rsc stringForColumn:@"idea"]];
                [cv1 setFilePathArray:@[[rsc stringForColumn:@"avtar"]]];
                [v1 setCompany:[cv1 build]];
            }
            [rsc close];
            
            u = [v1 build];
        }
        [rs close];
        [db close];
        return u;
    }
    else
    {
        NSLog(@"error when query login user.");
    }
    return nil;
}

- (NSString*) isUserExpire:(User*)user{
    NSString* ret = @"";
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"select * from login_user where expire=1 and id=%d",user.id];
        FMResultSet * rs = [db executeQuery:sql];
        if ([rs next]) {
            ret = [rs stringForColumn:@"expire_content"];
        }
        [rs close];
        [db close];
    }
    return ret;
}

- (BOOL) validateUserExpire:(User*)user{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    BOOL ist = NO;
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"select * from login_user where expire=1 and id=%d",user.id];
        FMResultSet * rs = [db executeQuery:sql];
        if ([rs next]) {
            ist = YES;
        }
        [rs close];
        [db close];
    }
    return ist;
}

- (BOOL) setUserExpire:(User*)user ExceptionMessage:(ExceptionMessage*)exceptionMessage{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        [db beginTransaction];
        @try
        {
            NSString *sql = [NSString stringWithFormat:@"update login_user set expire_content='%@' ,expire=1 where id=%d",exceptionMessage.content,user.id];
            [db executeUpdate:sql];
            [db commit];
            [db close];
        }
        @catch(NSException* e)
        {
            [db rollback];
            [db close];
            return NO;
        }
    }
    return YES;
}



-(BOOL) cleanLatestUserData{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        [db beginTransaction];
        @try
        {
            [db executeUpdate:@"delete from message;"];
            [db executeUpdate:@"delete from function;"];
            [db executeUpdate:@"delete from announce;"];
            [db executeUpdate:@"delete from cache;"];
            [db executeUpdate:@"delete from favorite_lang;"];
            
            [db commit];
            [db close];
        }
        @catch(NSException* e)
        {
            [db rollback];
            [db close];
            return NO;
        }
    }
    return YES;
}

- (BOOL) cleanLoginUser
{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        [db beginTransaction];
        @try
        {
            [db executeUpdate:@"delete from login_user;"];
            [db executeUpdate:@"delete from company;"];
            [db executeUpdate:@"delete from user;"];
            [db executeUpdate:@"delete from customer;"];
            [db executeUpdate:@"delete from product_supply;"];
            [db executeUpdate:@"delete from patrol_category;"];
            [db executeUpdate:@"delete from product;"];
            [db executeUpdate:@"delete from attendance_category;"];
            [db executeUpdate:@"delete from apply_category;"];
            [db executeUpdate:@"delete from apply_user;"];
            [db executeUpdate:@"delete from apply_category_r_user;"];
            [db executeUpdate:@"delete from gift_product_category;"];
            [db executeUpdate:@"delete from gift_product_area;"];
            [db executeUpdate:@"delete from gift_product_model;"];
            [db executeUpdate:@"delete from gift_product;"];
            [db executeUpdate:@"delete from gift_model_r_area;"];
            [db executeUpdate:@"delete from department;"];
            [db executeUpdate:@"delete from inspection_type;"];
            [db executeUpdate:@"delete from inspection_model;"];
            [db executeUpdate:@"delete from inspection_status;"];
            [db executeUpdate:@"delete from inspection_target;"];
            [db executeUpdate:@"delete from inspection_category;"];
            [db executeUpdate:@"delete from competition_product;"];
            [db executeUpdate:@"delete from customer_contact;"];
            [db executeUpdate:@"delete from all_user;"];
            [db executeUpdate:@"delete from video_category;"];
            [db executeUpdate:@"delete from video_duration_category;"];
            [db executeUpdate:@"delete from customer_tag;"];
            [db executeUpdate:@"delete from customer_tag_values;"];
            [db executeUpdate:@"delete from product_category;"];
            [db executeUpdate:@"delete from product_specification;"];
            [db executeUpdate:@"delete from product_specification_values;"];
            [db executeUpdate:@"delete from paper_template;"];
            [db executeUpdate:@"delete from holiday_category;"];
            [db executeUpdate:@"delete from checkin_channel;"];
            [db executeUpdate:@"delete from checkin_shift;"];
            [db executeUpdate:@"delete from checkin_holiday;"];
            [db executeUpdate:@"delete from checkin_shiftgroup;"];
            
            
            //用户登出不删除消息、公告、功能。
            /*[db executeUpdate:@"delete from message;"];
            [db executeUpdate:@"delete from function;"];
            [db executeUpdate:@"delete from announce;"];*/
            [db commit];
            [db close];
        }
        @catch(NSException* e)
        {
            [db rollback];
            [db close];
            return NO;
        }
    }
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    USER = nil;
    
    [Repetition clearRepetitionsWithManagedObjectContext:self.managedObjectContext];
    [Alarm clearAlarmsWithManagedObjectContext:self.managedObjectContext];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}


- (Location*) getLocation
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    Location_Builder* v1 = [Location builder];
    
    [v1 setLatitude:[[userDefaultes stringForKey:@"Latitude"] floatValue]];
    [v1 setLongitude:[[userDefaultes stringForKey:@"Lontitude"] floatValue]];
    [v1 setAddress: [userDefaultes stringForKey:@"Address"]];
    [v1 setProvince: [userDefaultes stringForKey:@"Province"]];
    [v1 setCity: [userDefaultes stringForKey:@"City"]];
    [v1 setDistrict: [userDefaultes stringForKey:@"District"]];
    [v1 setCreateTime: [userDefaultes stringForKey:@"Time"]];
    
    return [v1 build];
}

- (BOOL) saveLocation:(Location*) location
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:[NSString stringWithFormat:@"%f",location.latitude] forKey:@"Latitude"];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",location.longitude] forKey:@"Lontitude"];
    [userDefaults setObject:location.address forKey:@"Address"];
    [userDefaults setObject:location.province forKey:@"Province"];
    [userDefaults setObject:location.city forKey:@"City"];
    [userDefaults setObject:location.district forKey:@"District"];
    [userDefaults setObject:location.createTime forKey:@"Time"];
    
    [userDefaults synchronize];
    
    return YES;
}

- (BOOL) saveDeviceId{
    NSString* deviceId = [self _getDeviceIdFromKeychain];
    if ([deviceId isEqualToString:@""] || deviceId == nil){
        deviceId = [NSString UUID];
        [self _saveDeviceIdToKeychain:deviceId];
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    if ([db open]) {
        sql = [NSString stringWithFormat:@"insert into device (name,default_value) values ('DEVICEID','%@')",deviceId];
        [db executeUpdate:sql];
        [db close];
        return YES;
        
    }
    else
    {
        NSLog(@"error when save DeviceID.");
        
    }
    return YES;
}

- (NSString*) getDeviceId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    NSString* deviceid = nil;
    if ([db open]) {
        sql = @"select default_value from device where name = 'DEVICEID'";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]){
            deviceid = [rs stringForColumnIndex:0];
        }
        [rs close];
        [db close];
    }
    if (deviceid != nil){
        NSString* deviceIdKeychain = [self _getDeviceIdFromKeychain];
        if ([deviceIdKeychain isEqualToString:@""] || deviceIdKeychain == nil){
            [self _saveDeviceIdToKeychain:deviceid];
        }
    }
    return deviceid;
}

- (BOOL) saveModel{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    if ([db open]) {
        sql = [NSString stringWithFormat:@"insert into device (name,default_value) values ('MODEL','%@')",[UIDevice model]];
        [db executeUpdate:sql];
        [db close];
        return YES;
        
    }
    else
    {
        NSLog(@"error when save Model.");
        
    }
    return YES;
}

- (NSString*) getModel{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    NSString* model = nil;
    if ([db open]) {
        sql = @"select default_value from device where name = 'MODEL'";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]){
            model = [rs stringForColumnIndex:0];
        }
        [rs close];
        [db close];
    }
    return model;
}

- (NSString*) getKvoByKey:(NSString *) key{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    NSString* model = nil;
    if ([db open]) {
        sql = [NSString stringWithFormat:@"select default_value from device where name = '%@'",key];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]){
            model = [rs stringForColumnIndex:0];
        }
        [rs close];
        [db close];
    }
    return model;
}

-(BOOL) saveKvo:(NSString *) value key:(NSString *) key{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    if ([db open]) {
        [db beginTransaction];
        @try {
            [db executeUpdate:[NSString stringWithFormat:@"delete from device where name = '%@';",key]];
            sql = [NSString stringWithFormat:@"insert into device (name,default_value) values ('%@','%@')",key,value];
            [db executeUpdate:sql];
            [db commit];
        }
        @catch (NSException *exception) {
            [db rollback];
            return NO;
        }
        @finally{
            [db close];
        }
        return YES;
        
    }
    else
    {
        NSLog(@"error when save Device Token.");
        
    }
    return YES;
}

- (BOOL) saveDeviceToken:(NSString *)deviceToken{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    if ([db open]) {
        [db executeUpdate:@"delete from device where name = 'DEVICETOKEN';"];
        sql = [NSString stringWithFormat:@"insert into device (name,default_value) values ('DEVICETOKEN','%@')",deviceToken];
        [db executeUpdate:sql];
        [db close];
        return YES;
        
    }
    else
    {
        NSLog(@"error when save Device Token.");
        
    }
    return YES;
}



- (NSString *)getDeviceToken{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    NSString* deviceToken = nil;
    if ([db open]) {
        sql = @"select default_value from device where name = 'DEVICETOKEN'";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]){
            deviceToken = [rs stringForColumnIndex:0];
        }
        [rs close];
        [db close];
    }
    return deviceToken;
    
}



- (BOOL) saveLatestUserId:(NSString *)userId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    if ([db open]) {
        [db executeUpdate:@"delete from device where name = 'USERID';"];
        sql = [NSString stringWithFormat:@"insert into device (name,default_value) values ('USERID','%@')",userId];
        [db executeUpdate:sql];
        [db close];
        return YES;
        
    }
    else
    {
        NSLog(@"error when save user id.");
        
    }
    return YES;

}

- (NSString *)getLatestUserId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString * sql = nil;
    NSString* userId = nil;
    if ([db open]) {
        sql = @"select default_value from device where name = 'USERID'";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]){
            userId = [rs stringForColumnIndex:0];
        }
        [rs close];
        [db close];
    }
    return userId;
}

/*
 *功能检测更新
 */
-(BOOL)setFuncSync:(int)funcID{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *funcKey = [self createFuncKey:funcID];
        NSString *sql =[NSString stringWithFormat: @"insert into device (name,default_value) values ('%@','%@')",funcKey,KEY_YES];
        [db executeUpdate:[NSString stringWithFormat:@"delete from device where name = '%@'",funcKey]];
        [db executeUpdate:sql];
        [db close];
        return YES;
    }
    return NO;
}


-(BOOL)isFuncSync:(int)funcId{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from device where name = '%@'",[self createFuncKey:funcId]];
        FMResultSet *res = [db executeQuery:sql];
        if ([res next]) {
            [db close];
            return YES;
        }
        [db close];
    }
    return NO;
}

-(NSString*) createFuncKey:(int) funcID{
    return [NSString stringWithFormat:KEY_UPDATE_FUNCKEY,funcID];
}

- (BOOL) saveLocationSetting:(int) value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSString stringWithFormat:@"%d",value] forKey:@"LocationSetting"];
    [userDefaults synchronize];
    
    return YES;                                                                   
}

- (int) getLocationSetting
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    return (int)[userDefaultes integerForKey:@"LocationSetting"];
}

- (BOOL) saveMessageSetting:(int) value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSString stringWithFormat:@"%d",value] forKey:@"MessageSetting"];
    [userDefaults synchronize];
    
    return YES;
}
- (int) getMessageSetting{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    return (int)[userDefaultes integerForKey:@"MessageSetting"];
}

- (BOOL) saveValueToUserDefaults:(NSString*) key Value:(NSString*) value{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSString stringWithFormat:@"%@",value] forKey:key];
    [userDefaults synchronize];
    
    return YES;
}

- (NSString*) getValueFromUserDefaults:(NSString*) key{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if ([userDefaultes stringForKey:key] == nil){
        return @"";
    }else{
        return [userDefaultes stringForKey:key];
    }
    
}

- (NSString*) getCheckInDate
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    return [userDefaultes stringForKey:@"CheckInDate"];
}

- (BOOL) saveAllUsers:(PBArray*) users{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from all_user;"];
        for (int i = 0 ; i < users.count; ++i) {
            User* user = [User parseFromData:[users objectAtIndex:i]];
            
            NSString* sql = [NSString stringWithFormat:@"insert into all_user (id,username,password,realname,email,departmentName,departmentId,pinyin,positionName) values (%d,'%@','%@','%@','%@','%@',%d,'%@','%@')",user.id,user.userName,user.password,user.realName,user.email,user.department.name,user.department.id,user.spell,user.position.name];
            [db executeUpdate:sql];
        }

        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (NSMutableArray*) getAllUsers{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from all_user";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            User_Builder* v1 = [User builder];
            
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setUserName: [rs stringForColumn:@"username"]];
            [v1 setPassword: [rs stringForColumn:@"password"]];
            [v1 setRealName: [rs stringForColumn:@"realname"]];
            [v1 setEmail: [rs stringForColumn:@"email"]];
            [v1 setSpell:[rs stringForColumn:@"pinyin"]];
            
            Department_Builder* dv1 = [Department builder];
            [dv1 setName:[rs stringForColumn:@"departmentName"]];
            [dv1 setId:[rs intForColumn:@"departmentId"]];
            [v1 setDepartment:[dv1 build]];
            
            Position_Builder* pb = [Position builder];
            [pb setName:[rs stringForColumn:@"positionName"]];
            [pb setId:[rs intForColumn:@"departmentId"]];
            [v1 setPosition:[pb build]];
            
            User* u = [v1 build];
            [result addObject:u];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query all user.");
        
    }
    return nil;
}


- (void) saveDeviceIdToKeychain:(NSString*) deviceId{
    [self _saveDeviceIdToKeychain:deviceId];
}

- (void) _saveDeviceIdToKeychain:(NSString*) deviceId{
    [SSKeychain setPassword:deviceId forService:KEYCHAIN_GROUP account:@"DeviceID"];
}

- (NSString*) _getDeviceIdFromKeychain{
    return [SSKeychain passwordForService:KEYCHAIN_GROUP account:@"DeviceID"];
}

- (NSString*) saveImage:(NSData*) image{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFile = [[NSString alloc] initWithString:[NSString UUID]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageFile]];
    
    [image writeToFile:imagePath atomically:YES];
    
    return imagePath;
}

- (void) clearImages{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    fileList = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for (int i = 0; i<[fileList count]; i++) {
        NSString *fileName = [fileList objectAtIndex:i];
        NSRange range = [fileName rangeOfString:@".jpg"];
        if (range.location != NSNotFound) {
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,fileName] error:nil];
        }
    }
}

- (void) clearImagesWithFiles:(NSMutableArray*) files{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (int i = 0; i < files.count; ++i) {
        [fileManager removeItemAtPath:[files objectAtIndex:i] error:nil];
    }
}

- (void) clearCacheWithFiles:(PBArray*) files{
    return;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (int i = 0; i < files.count; ++i) {
        [fileManager removeItemAtPath:[files objectAtIndex:i] error:nil];
    }
}

- (NSMutableArray*) getProvinces{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    NSString *filePath = [[NSBundle JSLiteResourcesBundle] pathForResource:@"city_ios" ofType:@"db"];

    FMDatabase* db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString* sql = @"select substr(posId,1,5) as id,root from city group by root order by posId";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Province* p = [[Province alloc] init];
            p.id = [rs intForColumn:@"id"];
            p.name = [rs stringForColumn:@"root"];
            
            [result addObject:p];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query province.");
    }
    return result;
}

- (NSString*) getProvince:(NSString*) postId{
    NSString* result = @"";
    NSString *filePath = [[NSBundle JSLiteResourcesBundle] pathForResource:@"city_ios" ofType:@"db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString* sql = [NSString stringWithFormat:@"select substr(posId,1,5) as id,root from city where id = '%@' group by root order by posId",postId];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            result = [rs stringForColumn:@"root"];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query province.");
    }
    return result;
}

- (NSMutableArray*) getCities:(NSString*) provinceName{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    NSString *filePath = [[NSBundle JSLiteResourcesBundle] pathForResource:@"city_ios" ofType:@"db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString* sql = [NSString stringWithFormat:@"select substr(posId,1,5) as id,root,parent,posId from city WHERE root='%@' group by parent order by posId",provinceName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            City* c = [[City alloc] init];
            c.id = [rs intForColumn:@"posId"];
            c.name = [rs stringForColumn:@"parent"];
            c.provinceId = [rs intForColumn:@"id"];
            
            [result addObject:c];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query city.");
    }
    return result;
}

- (NSString*) getCity:(NSString*) postId{
    NSString* result = @"";
    NSString *filePath = [[NSBundle JSLiteResourcesBundle] pathForResource:@"city_ios" ofType:@"db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString* sql = [NSString stringWithFormat:@"select posid,parent from city where posid = '%@' group by root order by posId",postId];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            result = [rs stringForColumn:@"parent"];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query province.");
    }
    return result;
}

- (NSMutableArray*) getAreas:(NSString*) cityName{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    NSString *filePath = [[NSBundle JSLiteResourcesBundle] pathForResource:@"city_ios" ofType:@"db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString* sql = [NSString stringWithFormat:@"select substr(posId,1,5) as id,root,parent,name,posId from city WHERE parent='%@' order by posId",cityName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Area* a = [[Area alloc] init];
            a.id = [rs intForColumn:@"posId"];
            a.name = [rs stringForColumn:@"name"];
            a.provinceId = [rs intForColumn:@"id"];
            
            [result addObject:a];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query city.");
    }
    return result;
}

- (NSString*) getArea:(NSString*) postId{
    NSString* result = @"";
    NSString *filePath = [[NSBundle JSLiteResourcesBundle] pathForResource:@"city_ios" ofType:@"db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString* sql = [NSString stringWithFormat:@"select posid,name from city where posid = '%@' group by root order by posId",postId];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            result = [rs stringForColumn:@"name"];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query province.");
    }
    return result;
}

- (NSString*) getProvincePostIdWithName:(NSString*) name{
    NSString* result = @"10122";
    NSString *filePath = [[NSBundle JSLiteResourcesBundle] pathForResource:@"city_ios" ofType:@"db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString* sql = [NSString stringWithFormat:@"select substr(posId,1,5) as id,root from city where root = '%@' group by root order by posId",name];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            result = [rs stringForColumn:@"id"];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query province.");
    }
    return result;
    
}

- (NSString*) getCityPostIdWithName:(NSString*) name{
    NSString* result = @"";
    NSString *filePath = [[NSBundle JSLiteResourcesBundle] pathForResource:@"city_ios" ofType:@"db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString* sql = [NSString stringWithFormat:@"select posid,parent from city where name = '%@' union select posid,parent from city where parent = '%@' order by posId asc limit 0,1",name,name];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            result = [rs stringForColumn:@"posid"];
        }
        
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query province.");
    }
    return result;
}

- (NSString*) getAreaPostIdWithName:(NSString*) name{
    NSString* result = @"";
    NSString *filePath = [[NSBundle JSLiteResourcesBundle] pathForResource:@"city_ios" ofType:@"db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:filePath];
    if ([db open])
    {
        NSString* sql = [NSString stringWithFormat:@"select name,posid from city where name = '%@' group by parent order by posId",name];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            result = [rs stringForColumn:@"posid"];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query province.");
    }
    return result;
}

- (BOOL) saveApplyCategories:(PBArray*) categories{    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from apply_category;"];
        [db executeUpdate:@"delete from apply_user;"];
        [db executeUpdate:@"delete from apply_category_r_user;"];
        
        for (ApplyCategory* c in categories)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into apply_category (id,name) values (%d,'%@')",c.id,c.name]];
            
            for (int i = 0;i < c.users.count;i++){
                User* u = [c.users objectAtIndex:i];
                [db executeUpdate:[NSString stringWithFormat:@"insert into apply_user (id,username,password,realname,email,departmentName,departmentId,pinyin) values (%d,'%@','%@','%@','%@','%@',%d,'%@')",u.id,u.userName,u.password,u.realName,u.email,u.department.name,u.department.id,u.spell]];
                
                [db executeUpdate:[NSString stringWithFormat:@"insert into apply_category_r_user(categoryId,userId) values(%d,%d)",c.id,u.id]];
            }
        
            
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (NSMutableArray*) getApplyCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        FMResultSet * rs = [db executeQuery:@"select * from apply_category;"];
        while ([rs next])
        {
            FMResultSet * rsUser = [db executeQuery:[NSString stringWithFormat:@"select u.* from apply_user u inner join apply_category_r_user cu on u.id = cu.userId where cu.categoryId=%d;",[rs intForColumn:@"id"]]];
            
            NSMutableArray* users = [[[NSMutableArray alloc] init] autorelease];
            while ([rsUser next]) {
                User_Builder* v1 = [User builder];
                
                [v1 setId: [rsUser intForColumn:@"id"]];
                [v1 setUserName: [rsUser stringForColumn:@"username"]];
                [v1 setPassword: [rsUser stringForColumn:@"password"]];
                [v1 setRealName: [rsUser stringForColumn:@"realname"]];
                [v1 setEmail: [rsUser stringForColumn:@"email"]];
               
                Department_Builder* dv1 = [Department builder];
                [dv1 setName:[rsUser stringForColumn:@"departmentName"]];
                [dv1 setId:[rsUser intForColumn:@"departmentId"]];
                [v1 setDepartment:[dv1 build]];
                User* u = [v1 build];
                
                [users addObject:u];
            }
            [rsUser close];
            
            ApplyCategory_Builder* v1 = [ApplyCategory builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName:[rs stringForColumn:@"name"]];
            [v1 setUsersArray:users];
            
            ApplyCategory* cc = [v1 build];
            [result addObject:cc];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query apply category.");
    }
    return result;
}

- (BOOL) saveGiftProductCategories:(PBArray*) categories{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from gift_product_category;"];
        
        for (GiftProductCategory* cc in categories)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into gift_product_category (id,name,unit) values (%d,'%@','%@');",cc.id,cc.name,cc.unit]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;

}

- (NSMutableArray*) getGiftProductCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from gift_product_category";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            GiftProductCategory_Builder* v1 = [GiftProductCategory builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setUnit: [rs stringForColumn:@"unit"]];

            
            GiftProductCategory* cc = [v1 build];
            [result addObject:cc];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query gift product category.");
        
    }
    return nil;

}

- (BOOL) saveGiftProducts:(PBArray*) products{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from gift_product;"];
        [db executeUpdate:@"delete from gift_product_model;"];
        [db executeUpdate:@"delete from gift_product_area;"];
        [db executeUpdate:@"delete from gift_product_r_model;"];
        [db executeUpdate:@"delete from gift_model_r_area;"];
        
        for (GiftProduct* p in products)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into gift_product (id,categoryId,name,code,prior,specification,priority,description,level,place,createDate) values (%d,%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@')",p.id,p.category.id,p.name,p.code,p.prior,p.specification,p.priority,p.description,p.level,p.place,p.createDate]];
            
            for (int i = 0;i < p.giftProductModels.count;i++){
                GiftProductModel* pm = [p.giftProductModels objectAtIndex:i];
                
                for (int j = 0; j < pm.area.count; j++) {
                    GiftProductArea* pa = [pm.area objectAtIndex:j];
                    [db executeUpdate:[NSString stringWithFormat:@"insert into gift_product_area(id,provinceId,cityId,countyId,provinceName,cityName,countyName) values (%d,'%@','%@','%@','%@','%@','%@')",pa.id,pa.provinceId,pa.cityId,pa.countyId,pa.provinceName,pa.cityName,pa.countyName]];
                    
                    [db executeUpdate:[NSString stringWithFormat:@"insert into gift_model_r_area(modelId,areaId) values(%d,%d)",pm.id,pa.id]];
                }
                [db executeUpdate:[NSString stringWithFormat:@"insert into gift_product_model(id,productId,name,price,createDate) values (%d,%d,'%@','%f','%@')",pm.id,p.id,pm.name,pm.price,pm.createDate]];
            }
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (NSMutableArray*) getGiftProductsWithGiftName:(NSString*) name CategoryId:(int) categoryId Index:(int) index{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        int currentPage = (index - 1)*PAGESIZE;
        NSString* sql = @"";
        
        NSMutableString* sqlCondition = [NSMutableString stringWithCapacity:100];;
        if (![name isEqualToString:@""]){
            [sqlCondition appendString:[NSString stringWithFormat:@" and (p.name like '%%%@%%' or pm.name like'%%%@%%' ) ", name,name]];
        }
        if (categoryId > 0) {
            [sqlCondition appendString:[NSString stringWithFormat:@" and c.id =%d ", categoryId]];
        }
        
        sql = [NSString stringWithFormat:@"select p.*,pm.id as modelId,pm.name as modelName,pm.Price as modelPrice,c.name as categoryName,c.unit as categoryUnit  from gift_product_model pm left join gift_product p on pm.productId = p.id inner join gift_product_category c on p.categoryId = c.id where 1 = 1 %@ limit %d,%d",sqlCondition,currentPage,PAGESIZE];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            GiftProductCategory_Builder* gpcv1 = [GiftProductCategory builder];
            [gpcv1 setId:[rs intForColumn:@"categoryId"]];
            [gpcv1 setName:[rs stringForColumn:@"categoryName"]];
            [gpcv1 setUnit:[rs stringForColumn:@"categoryUnit"]];

            GiftProductCategory* c = [gpcv1 build];
            
            GiftProduct_Builder* gpbV1 = [GiftProduct builder];
            [gpbV1 setId: [rs intForColumn:@"id"]];
            [gpbV1 setName: [rs stringForColumn:@"name"]];
            [gpbV1 setCategory:c];
            [gpbV1 setCode: [rs stringForColumn:@"code"]];
            [gpbV1 setPrior: [rs stringForColumn:@"prior"]];
            [gpbV1 setSpecification: [rs stringForColumn:@"specification"]];
            [gpbV1 setPriority: [rs stringForColumn:@"priority"]];
            [gpbV1 setDescription: [rs stringForColumn:@"description"]];
            [gpbV1 setLevel: [rs stringForColumn:@"level"]];
            [gpbV1 setPlace: [rs stringForColumn:@"place"]];
            [gpbV1 setCreateDate: [rs stringForColumn:@"createDate"]];

            GiftProductModel_Builder* gpmbV1 = [GiftProductModel builder];
            [gpmbV1 setId: [rs intForColumn:@"modelId"]];
            [gpmbV1 setName: [rs stringForColumn:@"modelName"]];
            [gpmbV1 setPrice: [rs doubleForColumn:@"modelPrice"]];
            
            
            FMResultSet * rsArea = [db executeQuery:[NSString stringWithFormat:@"select a.* from gift_product_area a inner join gift_model_r_area pa on a.id = pa.areaId where pa.modelId=%d;",[rs intForColumn:@"modelId"]]];
                
            NSMutableArray* areas = [[[NSMutableArray alloc] init] autorelease];
            while ([rsArea next]) {
                GiftProductArea_Builder* gpaV1 = [GiftProductArea builder];
                [gpaV1 setId:[rsArea intForColumn:@"id"]];
                [gpaV1 setCityId:[rsArea stringForColumn:@"cityId"]];
                [gpaV1 setProvinceId:[rsArea stringForColumn:@"provinceId"]];
                [gpaV1 setCountyId:[rsArea stringForColumn:@"countyId"]];
                [gpaV1 setProvinceName:[rsArea stringForColumn:@"provinceName"]];
                [gpaV1 setCityName:[rsArea stringForColumn:@"cityName"]];
                [gpaV1 setCountyName:[rsArea stringForColumn:@"countyName"]];
                
                GiftProductArea* a = [gpaV1 build];
                    
                [areas addObject:a];
            }
            [rsArea close];
                
            [gpmbV1 setAreaArray:areas];
        
            GiftProduct* gpbv = [gpbV1 build];
            
            [gpmbV1 setGiftProduct:gpbv];
            
            GiftProductModel* gpmbv = [gpmbV1 build];

            [result addObject:gpmbv];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query gif product.");
    }
    return nil;

}

- (BOOL) saveDepartments:(PBArray*) depts{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from department;"];
        
        for (Department* d in depts){
            [db executeUpdate:[NSString stringWithFormat:@"insert into department (id,name,parentId,sortId) values (%d,'%@',%d,%d)",d.id,d.name,d.parentId,d.sortId]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
    
}

- (NSMutableArray*) getDepartments{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from department";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Department_Builder* v1 = [Department builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setParentId: [rs intForColumn:@"parentId"]];
            [v1 setSortId: [rs intForColumn:@"sortId"]];
            
            Department* d = [v1 build];
            [result addObject:d];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query department.");
        
    }
    return nil;
}


- (BOOL) saveInspectionCategories:(PBArray*) categories{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from inspection_category;"];
        
        for (InspectionReportCategory* cc in categories)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into inspection_category (id,name) values (%d,'%@');",cc.id,cc.name]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}
- (NSMutableArray*) getInspectionCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from inspection_category";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            InspectionReportCategory_Builder* v1 = [InspectionReportCategory builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            InspectionReportCategory* cc = [v1 build];
            [result addObject:cc];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query inspection category.");
        
    }
    return nil;
}

- (NSMutableArray*) getInspectionTypes{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from inspection_type";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            InspectionType_Builder* v1 = [InspectionType builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            InspectionType* cc = [v1 build];
            [result addObject:cc];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query inspection type.");
        
    }
    return nil;
}


- (BOOL) saveInspectionTypes:(PBArray*) types;{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from inspection_type;"];
        
        for (InspectionType* cc in types)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into inspection_type (id,name) values (%d,'%@');",cc.id,cc.name]];
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (BOOL) saveInspectionModels:(PBArray*) models{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from inspection_model;"];
        [db executeUpdate:@"delete from inspection_model_status;"];
        
        for (InspectionModel* cc in models)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into inspection_model (id,name) values (%d,'%@');",cc.id,cc.name]];
            for (InspectionStatus *s in cc.inspectionStatus) {
                NSString *sql = [NSString stringWithFormat:@"insert into inspection_model_status (id,name,modelid,isDefault) values (%d,'%@',%d,%d);",s.id,s.name,cc.id,s.isDefault];
                [db executeUpdate:sql];
            }
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}



-(NSMutableArray *) getInspectionStatusWithModelId:(int) modelid
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"select * from inspection_model_status where modelid = %d order by isDefault desc",modelid]];
        while ([res next]) {
            InspectionStatus_Builder *pb = [InspectionStatus builder];
            [pb setId:[res intForColumn:@"id"]];
            [pb setName:[res stringForColumn:@"name"]];
            [pb setIsDefault:[res boolForColumn:@"isDefault"]];
            [result addObject:[pb build]];
        }
        [db close];
        return result;
    }
    return nil;
}

-(NSMutableArray *) getInspectionDefaultStatusWithModelId:(int) modelid
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"select * from inspection_model_status where modelid = %d and isDefault = 1",modelid]];
        while ([res next]) {
            InspectionStatus_Builder *pb = [InspectionStatus builder];
            [pb setId:[res intForColumn:@"id"]];
            [pb setName:[res stringForColumn:@"name"]];
            [pb setIsDefault:[res boolForColumn:@"isDefault"]];
            [result addObject:[pb build]];
        }
        [db close];
        return result;
    }
    return nil;
}

- (BOOL) saveInspectionStatus:(PBArray*) status{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from inspection_status;"];
        
        for (InspectionStatus* cc in status)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into inspection_status (id,name,isDefault) values (%d,'%@',%d);",cc.id,cc.name,cc.isDefault ? 1 : 0]];
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (NSMutableArray*) getInspectionStatus{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from inspection_status order by isDefault desc";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            InspectionStatus_Builder* v1 = [InspectionStatus builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setIsDefault:([rs intForColumn:@"isDefault"] == 1 ) ? TRUE : FALSE];
           
            InspectionStatus* cc = [v1 build];
            [result addObject:cc];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query gift inspection status.");
        
    }
    return nil;
}

- (BOOL) saveInspectionTargets:(PBArray*) inspections{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from inspection_target;"];
        
        for (InspectionTarget* t in inspections)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into inspection_target (id,name,serialNumber ,inspectionType,inspectionModel,parentId,createDate) values (%d,'%@','%@',%d,%d,%d,'%@')",t.id,t.name,t.serialNumber,t.inspectionType.id,t.inspectionModel.id,t.parentId,t.createDate]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}
- (NSMutableArray*) getInspectionTargetsWithName:(NSString*) name Index:(int) index{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        int currentPage = (index - 1)*PAGESIZE;
        NSString* sql = @"";
        
        NSMutableString* sqlCondition = [NSMutableString stringWithCapacity:100];;
        if (![name isEqualToString:@""]){
            [sqlCondition appendString:[NSString stringWithFormat:@" and (t.name like '%%%@%%' or t.serialNumber like '%%%@%%' or im.name like'%%%@%%' or it.name like'%%%@%%' ) ",name,name,name,name]];
        }
        
        sql = [NSString stringWithFormat:@"select t.*,im.id as modelId,im.name as modelName,it.id as typeId,it.name as typeName from inspection_target t left join inspection_type it on t.inspectionType = it.id left join inspection_model im on t.inspectionModel = im.id where 1 = 1 %@ limit %d,%d",sqlCondition,currentPage,PAGESIZE];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            InspectionTarget_Builder* v1 = [InspectionTarget builder];
            [v1 setId:[rs intForColumn:@"Id"]];
            [v1 setName:[rs stringForColumn:@"name"]];
            [v1 setSerialNumber:[rs stringForColumn:@"serialNumber"]];
            [v1 setParentId:[rs intForColumn:@"parentId"]];
            [v1 setCreateDate:[rs stringForColumn:@"createDate"]];
            if ([rs intForColumn:@"inspectionType"] > 0) {
                InspectionType_Builder* itbV1 = [InspectionType builder];
                [itbV1 setId:[rs intForColumn:@"typeId"]];
                [itbV1 setName:[rs stringForColumn:@"typeName"]];

                InspectionType* it = [itbV1 build];
                
                [v1 setInspectionType:it];
            }
            if ([rs intForColumn:@"inspectionModel"] > 0) {
                InspectionModel_Builder* imbV1 = [InspectionModel builder];
                [imbV1 setId:[rs intForColumn:@"modelId"]];
                [imbV1 setName:[rs stringForColumn:@"modelName"]];
                InspectionModel* im = [imbV1 build];
                
                [v1 setInspectionModel:im];
            }
            InspectionTarget* t = [v1 build];
            [result addObject:t];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query inspection target.");
    }
    return nil;

}

- (NSMutableArray*) getInspectionTargetsWithName:(NSString*) name{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSString* sql = @"";
        
        NSMutableString* sqlCondition = [NSMutableString stringWithCapacity:100];;
        if (![name isEqualToString:@""]){
            [sqlCondition appendString:[NSString stringWithFormat:@" and (t.name like '%%%@%%' or t.serialNumber like '%%%@%%' or im.name like'%%%@%%' or it.name like'%%%@%%' ) ",name,name,name,name]];
        }
        
        sql = [NSString stringWithFormat:@"select t.*,im.id as modelId,im.name as modelName,it.id as typeId,it.name as typeName from inspection_target t left join inspection_type it on t.inspectionType = it.id left join inspection_model im on t.inspectionModel = im.id where 1 = 1 %@",sqlCondition];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            InspectionTarget_Builder* v1 = [InspectionTarget builder];
            [v1 setId:[rs intForColumn:@"Id"]];
            [v1 setName:[rs stringForColumn:@"name"]];
            [v1 setSerialNumber:[rs stringForColumn:@"serialNumber"]];
            [v1 setParentId:[rs intForColumn:@"parentId"]];
            [v1 setCreateDate:[rs stringForColumn:@"createDate"]];
            if ([rs intForColumn:@"inspectionType"] > 0) {
                InspectionType_Builder* itbV1 = [InspectionType builder];
                [itbV1 setId:[rs intForColumn:@"typeId"]];
                [itbV1 setName:[rs stringForColumn:@"typeName"]];
                InspectionType* it = [itbV1 build];
                
                [v1 setInspectionType:it];
            }
            if ([rs intForColumn:@"inspectionModel"] > 0) {
                InspectionModel_Builder* imbV1 = [InspectionModel builder];
                [imbV1 setId:[rs intForColumn:@"modelId"]];
                [imbV1 setName:[rs stringForColumn:@"modelName"]];
      
                InspectionModel* im = [imbV1 build];
                
                [v1 setInspectionModel:im];
            }
            InspectionTarget* t = [v1 build];
            [result addObject:t];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query inspection target.");
    }
    return nil;
    
}

- (NSMutableArray*) getInspectionTargetsWithChildPage:(int) index parentId:(int)parentId{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        int currentPage = (index - 1)*PAGESIZE;
        NSString* sql = @"";
        
        NSMutableString* sqlCondition = [NSMutableString stringWithCapacity:100];;
        
        sql = [NSString stringWithFormat:@"select t.*,im.id as modelId,im.name as modelName,it.id as typeId,it.name as typeName from inspection_target t left join inspection_type it on t.inspectionType = it.id left join inspection_model im on t.inspectionModel = im.id where t.parentId = %d limit %d,%d",parentId,currentPage,PAGESIZE];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            InspectionTarget_Builder* v1 = [InspectionTarget builder];
            [v1 setId:[rs intForColumn:@"Id"]];
            [v1 setName:[rs stringForColumn:@"name"]];
            [v1 setSerialNumber:[rs stringForColumn:@"serialNumber"]];
            [v1 setParentId:[rs intForColumn:@"parentId"]];
            [v1 setCreateDate:[rs stringForColumn:@"createDate"]];
            if ([rs intForColumn:@"inspectionType"] > 0) {
                InspectionType_Builder* itbV1 = [InspectionType builder];
                [itbV1 setId:[rs intForColumn:@"typeId"]];
                [itbV1 setName:[rs stringForColumn:@"typeName"]];
                InspectionType* it = [itbV1 build];
                
                [v1 setInspectionType:it];
            }
            if ([rs intForColumn:@"inspectionModel"] > 0) {
                InspectionModel_Builder* imbV1 = [InspectionModel builder];
                [imbV1 setId:[rs intForColumn:@"modelId"]];
                [imbV1 setName:[rs stringForColumn:@"modelName"]];

                InspectionModel* im = [imbV1 build];
                
                [v1 setInspectionModel:im];
            }
            
            InspectionTarget* t = [v1 build];
            [result addObject:t];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query inspection target.");
    }
    return nil;
}

- (NSMutableArray*) getInspectionTargetsWithParentId:(int)parentId{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSString* sql = @"";
        
        NSMutableString* sqlCondition = [NSMutableString stringWithCapacity:100];;
        
        sql = [NSString stringWithFormat:@"select t.*,im.id as modelId,im.name as modelName,it.id as typeId,it.name as typeName from inspection_target t left join inspection_type it on t.inspectionType = it.id left join inspection_model im on t.inspectionModel = im.id where t.parentId = %d",parentId];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            InspectionTarget_Builder* v1 = [InspectionTarget builder];
            [v1 setId:[rs intForColumn:@"Id"]];
            [v1 setName:[rs stringForColumn:@"name"]];
            [v1 setSerialNumber:[rs stringForColumn:@"serialNumber"]];
            [v1 setParentId:[rs intForColumn:@"parentId"]];
            [v1 setCreateDate:[rs stringForColumn:@"createDate"]];
            if ([rs intForColumn:@"inspectionType"] > 0) {
                InspectionType_Builder* itbV1 = [InspectionType builder];
                [itbV1 setId:[rs intForColumn:@"typeId"]];
                [itbV1 setName:[rs stringForColumn:@"typeName"]];
                
                InspectionType* it = [itbV1 build];
                
                [v1 setInspectionType:it];
            }
            if ([rs intForColumn:@"inspectionModel"] > 0) {
                InspectionModel_Builder* imbV1 = [InspectionModel builder];
                [imbV1 setId:[rs intForColumn:@"modelId"]];
                [imbV1 setName:[rs stringForColumn:@"modelName"]];

                InspectionModel* im = [imbV1 build];
                
                [v1 setInspectionModel:im];
            }
            
            InspectionTarget* t = [v1 build];
            [result addObject:t];
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query inspection target.");
    }
    return nil;
}

- (int) getInspectionTargetsTotalCountWithParentId:(int)parentId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    int totalCount = 0;
    if ([db open]){
        NSString* sql = @"";
        sql = [NSString stringWithFormat:@"select count(*) as count from inspection_target where parentid = %d",parentId];
        
        FMResultSet * rs = [db executeQuery:sql];
        if ([rs next]) {
            totalCount = [rs intForColumn:@"count"];
        }
        [rs close];
        [db close];
        return totalCount;
        
    }
    else
    {
        NSLog(@"error when query inspection target.");
    }
    return nil;
}

- (BOOL) saveCache:(int) funcId Content:(NSData*) content{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        //只能插入BLOB字段，其他字段都无法插入数据，故分成了两个SQL语句执行。
        BOOL ret = [db executeUpdate:@"insert into cache(content) values(?);",content];
        NSString* objId = @"";
        switch (funcId) {
            case FUNC_PATROL:{
                Patrol* p = [Patrol parseFromData:content];
                objId = [p.filePath objectAtIndex:0];
            }
                break;
            case FUNC_PATROL_TASK:{
                TaskPatrolDetail* p = [TaskPatrolDetail parseFromData:content];
                objId = [p.patrol.filePath objectAtIndex:0];
            }
                break;
            case FUNC_VIDEO:{
                VideoTopic* p = [VideoTopic parseFromData:content];
                objId = [p.filePaths objectAtIndex:0];
            }
                break;
            default:
                break;
        }
        if (ret) {
            [db commit];
            long i = [db lastInsertRowId];
            NSString* updateSQL = [NSString stringWithFormat:@"update cache set functionId=%d ,objectId='%@' where id=%ld;",funcId,objId,i];
            [db executeUpdate:updateSQL];
        }
        
        [db close];

        return ret;
    }
    
    return NO;
}

-(int) getCacheCountWithFuncId:(int) funcId{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString* sql = [NSString stringWithFormat:@"select count(*) as count from cache where functionId = %d",funcId];
        FMResultSet *res = [db executeQuery:sql];
        if ([res next]) {
            return [res intForColumn:@"count"];
        }
        return -1;
    }
    return -1;
}

- (NSMutableArray*) getCacheWithFuncId:(int) funcId Index:(int) index{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        int currentPage = (index - 1)*PAGESIZE;
        NSString* sqlCondition = @"";
        if (funcId > 0) {
            sqlCondition = [NSString stringWithFormat:@" and functionId = %d",funcId];
        }
        NSString* sql = [NSString stringWithFormat:@"select * from cache where 1=1 %@  order by id desc limit %d,%d;",sqlCondition,currentPage,PAGESIZE];
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            if (funcId == FUNC_PATROL) {
                NSData* d = [rs dataForColumn:@"content"];
                Patrol* p = [Patrol parseFromData:d];
                [result addObject:p];
            }
            if (funcId == FUNC_VIDEO) {
                NSData* d = [rs dataForColumn:@"content"];
                VideoTopic* p = [VideoTopic parseFromData:d];
                [result addObject:p];
            }
        }
        
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query cache.");
    }
    return nil;
}

- (BOOL) deleteCache:(int) funcId Content:(NSData*) content{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    NSString* objId = @"";
    switch (funcId) {
        case FUNC_PATROL:{
            Patrol* p = [Patrol parseFromData:content];
            objId = [p.filePath objectAtIndex:0];
            
            [self clearCacheWithFiles:p.filePath];
        }
            break;
        case FUNC_PATROL_TASK:{
            TaskPatrolDetail* p = [TaskPatrolDetail parseFromData:content];
            objId = [p.patrol.filePath objectAtIndex:0];
            
            [self clearCacheWithFiles:p.patrol.filePath];
        }
            break;
        case FUNC_VIDEO:{
            VideoTopic* p = [VideoTopic parseFromData:content];
            objId = [p.filePaths objectAtIndex:0];
            
            [self clearCacheWithFiles:p.filePaths];
        }
            break;
        default:
            break;
    }
    if ([db open])
    {
        [db beginTransaction];
        NSString * sql = [NSString stringWithFormat:@"delete from cache where objectId ='%@' and functionId=%d", objId,funcId];
        [db executeUpdate:sql];
        [db commit];
        [db close];
        
        return YES;
    }
    return NO;
}

- (int) getCacheCount{
    int ret = 0;
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        FMResultSet * rs = [db executeQuery:@"select count(id) from cache;"];
        while ([rs next])
        {
            ret = [rs intForColumnIndex:0];
        }
        
        [rs close];
        [db close];
        return ret;
        
    }
    else
    {
        NSLog(@"error when query cache.");
    }
    return ret;
}

- (BOOL) saveVideoCategories:(PBArray*) categories{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from video_category;"];
        
        for (VideoCategory* cc in categories)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into video_category (id,name) values (%d,'%@');",cc.id,cc.name]];
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (NSMutableArray*) getVideoCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from video_category";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            VideoCategory_Builder* ccb = [VideoCategory builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setName: [rs stringForColumn:@"name"]];
            VideoCategory* v = [ccb build];
            [result addObject:v];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query video category.");
        
    }
    return nil;
}

- (BOOL) saveVideoDurationCategories:(PBArray*) categories{
    int favId = 0;
    VideoDurationCategory* v1 = [self getFavVideoDurationCategory];
    if (v1 != nil) {
        favId = v1.id;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from video_duration_category;"];
        
        for (VideoDurationCategory* cc in categories)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into video_duration_category (id,name) values (%d,'%@');",cc.id,cc.durationValue]];
        }
        if (favId != 0) {
            [db executeUpdate:[NSString stringWithFormat:@"update video_duration_category set favorites = 1 where id=%d",favId]];
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (NSMutableArray*) getVideoDurationCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from video_duration_category order by cast(name as SIGNED) asc";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            VideoDurationCategory_Builder* ccb = [VideoDurationCategory builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setDurationValue: [rs stringForColumn:@"name"]];
            VideoDurationCategory* v = [ccb build];
            [result addObject:v];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query video category.");
        
    }
    return nil;
}

- (BOOL) favVideoDurationCategory:(int) categoryId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"update video_duration_category set favorites = 0;"];
        [db executeUpdate:[NSString stringWithFormat:@"update video_duration_category set favorites = 1 where id=%d",categoryId]];
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (VideoDurationCategory*) getFavVideoDurationCategory{
    VideoDurationCategory* v1 = nil;
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from video_duration_category where favorites = 1;";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            VideoDurationCategory_Builder* ccb = [VideoDurationCategory builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setDurationValue: [rs stringForColumn:@"name"]];
            v1 = [ccb build];
        }
        [rs close];
        [db close];
        return v1;
        
    }
    else
    {
        NSLog(@"error when query video category.");
        
    }
    return nil;
}

- (BOOL) saveFavoriteLangs:(PBArray*) langs SortIds:(NSArray*) sortIds{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from favorite_lang;"];
        for (int i = 0; i < langs.count; i++) {
            int sort = (int)langs.count - i - 1;
            FavoriteLang *f = [langs objectAtIndex:sort];
            [db executeUpdate:[NSString stringWithFormat:@"insert into favorite_lang (id,content,favorites) values (%d,'%@',%d);",f.id,f.commonLang,i]];
        }
//        for (FavoriteLangV1* f in langs)
//        {
//            if (sortIds != nil) {
//                for (int i = 0; i < sortIds.count; ++i) {
//                    [db executeUpdate:[NSString stringWithFormat:@"insert into favorite_lang (id,content,favorites) values (%d,'%@',%d);",f.id,f.commonLang,i]];
//                }
//            }else{
//                [db executeUpdate:[NSString stringWithFormat:@"insert into favorite_lang (id,content) values (%d,'%@');",f.id,f.commonLang]];
//            }
//        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (NSMutableArray*) getFavoriteLangs{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from favorite_lang order by favorites desc;";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            FavoriteLang_Builder* ccb = [FavoriteLang builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setCommonLang: [rs stringForColumn:@"content"]];
            [ccb setUser:USER];
            FavoriteLang* v = [ccb build];
            [result addObject:v];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query favorite lang.");
        
    }
    return nil;
}

- (BOOL) saveFavoriteLang:(FavoriteLang*) lang Status:(int) status{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        switch (status) {
            case CREATE:
                [db executeUpdate:[NSString stringWithFormat:@"insert into favorite_lang (id,content) values (%d,'%@');",lang.id,lang.commonLang]];
                break;
            case UPDATE:
                [db executeUpdate:[NSString stringWithFormat:@"update favorite_lang set content = '%@' where id = %d",lang.commonLang,lang.id]];
                break;
            case DELETE:
                [db executeUpdate:[NSString stringWithFormat:@"delete from favorite_lang where id = %d",lang.id]];
                break;
            default:
                break;
                
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (BOOL) savePatrolVideoDurationCategories:(PBArray*) categories{
    int favId = 0;
    PatrolVideoDurationCategory* v1 = [self getFavPatrolVideoDurationCategory];
    if (v1 != nil) {
        favId = v1.id;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from patrol_video_duration_category;"];
        
        for (PatrolVideoDurationCategory* cc in categories)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into patrol_video_duration_category (id,name) values (%d,'%@');",cc.id,cc.durationValue]];
        }
        if (favId != 0) {
            [db executeUpdate:[NSString stringWithFormat:@"update patrol_video_duration_category set favorites = 1 where id=%d",favId]];
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (NSMutableArray*) getPatrolVideoDurationCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from patrol_video_duration_category order by cast(name as SIGNED) asc";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            PatrolVideoDurationCategory_Builder* ccb = [PatrolVideoDurationCategory builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setDurationValue: [rs stringForColumn:@"name"]];
            PatrolVideoDurationCategory* v = [ccb build];
            [result addObject:v];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query video category.");
        
    }
    return nil;
}

- (BOOL) favPatrolVideoDurationCategory:(int) categoryId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"update patrol_video_duration_category set favorites = 0;"];
        [db executeUpdate:[NSString stringWithFormat:@"update patrol_video_duration_category set favorites = 1 where id=%d",categoryId]];
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (PatrolVideoDurationCategory*) getFavPatrolVideoDurationCategory{
    PatrolVideoDurationCategory* v1 = nil;
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from patrol_video_duration_category where favorites = 1;";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            PatrolVideoDurationCategory_Builder* ccb = [PatrolVideoDurationCategory builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setDurationValue: [rs stringForColumn:@"name"]];
            v1 = [ccb build];
        }
        [rs close];
        [db close];
        return v1;
    }
    else
    {
        NSLog(@"error when query video category.");
        
    }
    return nil;
}

- (BOOL) savePatrolMediaCategories:(PBArray*) categories{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from patrol_media_category;"];
        
        for (PatrolMediaCategory* cc in categories)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into patrol_media_category (id,name,value) values (%d,'%@','%@');",cc.id,cc.name,cc.value]];
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (NSMutableArray*) getPatrolMediaCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from patrol_media_category";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            PatrolMediaCategory_Builder* ccb = [PatrolMediaCategory builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setName: [rs stringForColumn:@"name"]];
            [ccb setValue: [rs stringForColumn:@"value"]];
            PatrolMediaCategory* v = [ccb build];
            [result addObject:v];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query video category.");
        
    }
    return nil;
}

- (BOOL) saveCustomerTags:(PBArray*) tags{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from customer_tag;"];
        [db executeUpdate:@"delete from customer_tag_values;"];
        
        for (CustomerTag* ct in tags)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into customer_tag (id,tag_name) values (%d,'%@');",ct.id,ct.name]];
            for (CustomerTagValue* ctv in ct.tagValues) {
                [db executeUpdate:[NSString stringWithFormat:@"insert into customer_tag_values (id,tag_id,tag_value,parent_id,tag_path) values (%d,%d,'%@',%d,'%@');",ctv.id,ct.id,ctv.name,ctv.parentId,ctv.path]];
            }
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (NSMutableArray*) getCustomerTags{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from customer_tag";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            CustomerTag_Builder* ccb = [CustomerTag builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setName: [rs stringForColumn:@"tag_name"]];
            CustomerTag* v = [ccb build];
            [result addObject:v];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query customer tags.");
        
    }
    return nil;
}

- (CustomerTag*) getCustomerTagWithId:(int) tagId{
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat:@"select * from customer_tag where id = %d",tagId];
        FMResultSet * rs = [db executeQuery:sql];
        CustomerTag* v = nil;
        if ([rs next])
        {
            CustomerTag_Builder* ccb = [CustomerTag builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setName: [rs stringForColumn:@"tag_name"]];
            v = [ccb build];
        }
        [rs close];
        [db close];
        return v;
    }
    else
    {
        NSLog(@"error when query customer tags.");
        
    }
    return nil;
}

- (NSMutableArray*) getCustomerTagValuesWithTagId:(int)tagId{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSString * sql = [NSString stringWithFormat:@"select * from customer_tag_values where tag_id=%d",tagId] ;
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            CustomerTagValue_Builder* ccb = [CustomerTagValue builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setName: [rs stringForColumn:@"tag_value"]];
            [ccb setParentId:[rs intForColumn:@"parent_id"]];
            CustomerTagValue* v = [ccb build];
            [result addObject:v];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query customer tag values.");
        
    }
    return nil;
}

- (CustomerTag *) getCustomerTagWithTagValueId:(int) valueId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSString * sql = [NSString stringWithFormat:@"select * from customer_tag_values where id=%d",valueId] ;
        FMResultSet * rs = [db executeQuery:sql];
        CustomerTag* v  = nil;
        if ([rs next])
        {
            int tagId = [rs intForColumn:@"tag_id"];
            v = [self getCustomerTagWithId:tagId];
        }
        [rs close];
        [db close];
        return v;
    }
    else
    {
        NSLog(@"error when query customer tag values.");
        
    }
    return nil;
}

- (NSMutableArray*) getCustomerTagValuesWithPartentId:(int)parentId{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSString * sql = [NSString stringWithFormat:@"select * from customer_tag_values where parent_id=%d",parentId] ;
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            CustomerTagValue_Builder* ccb = [CustomerTagValue builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setName: [rs stringForColumn:@"tag_value"]];
            [ccb setParentId:[rs intForColumn:@"parent_id"]];
            CustomerTagValue* v = [ccb build];
            [result addObject:v];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query customer tag values.");
        
    }
    return nil;
}

- (BOOL) saveProductCategories:(PBArray*) categories{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from product_category;"];
        
        for (ProductCategory* d in categories){
            [db executeUpdate:[NSString stringWithFormat:@"insert into product_category (id,name,parent_id,cat_path) values (%d,'%@',%d,'%@')",d.id,d.name,d.parentId,d.path]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (NSMutableArray*) getProductCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from product_category";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            ProductCategory_Builder* v1 = [ProductCategory builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setParentId: [rs intForColumn:@"parent_id"]];
            [v1 setPath: [rs stringForColumn:@"cat_path"]];
            
            ProductCategory* d = [v1 build];
            [result addObject:d];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query product category.");
        
    }
    return nil;
}

- (BOOL) saveProductSpecifications:(PBArray*) specs{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from product_specification;"];
        [db executeUpdate:@"delete from product_specification_values;"];
        
        for (ProductSpecification* ps in specs)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into product_specification (id,spec_name) values (%d,'%@');",ps.id,ps.name]];
            for (ProductSpecificationValue* psv in ps.specificationValues) {
                [db executeUpdate:[NSString stringWithFormat:@"insert into product_specification_values (id,spec_id,spec_value) values (%d,%d,'%@');",psv.id,ps.id,psv.name]];
            }
        }
        [db commit];
        [db close];
        return YES;
    }
    return NO;
}

- (NSMutableArray*) getProductSpecifications{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from product_specification";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            ProductSpecification_Builder* v1 = [ProductSpecification builder];
            [v1 setId: [rs intForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"spec_name"]];
            
            ProductSpecification* d = [v1 build];
            [result addObject:d];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query product specification.");
        
    }
    return nil;
}

- (NSMutableArray*) getProductSpecificationsWithSpecId:(int)specId{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        NSString * sql = [NSString stringWithFormat:@"select * from product_specification_values where spec_id=%d",specId] ;
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            ProductSpecificationValue_Builder* ccb = [ProductSpecificationValue builder];
            [ccb setId: [rs intForColumn:@"id"]];
            [ccb setName: [rs stringForColumn:@"spec_value"]];
            ProductSpecificationValue* v = [ccb build];
            [result addObject:v];
        }
        [rs close];
        [db close];
        return result;
    }
    else
    {
        NSLog(@"error when query customer tag values.");
        
    }
    return nil;
}

#pragma mark - AttendanceType
-(BOOL)saveAttendanceTypes:(PBArray*)attendancetypes {
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from attendance_type;"];
        
        for (AttendanceType* a in attendancetypes)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into attendance_type (value) values ('%@');",a.value]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;


}

-(NSMutableArray*)getAttendanceTypes{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from attendance_type";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            AttendanceType_Builder* ab = [AttendanceType builder];
           
            [ab setValue:[rs stringForColumn:@"value"]];
            AttendanceType* f = [ab build];
            [result addObject:f];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query attendance type.");
        
    }
    return nil;


}

#pragma mark - CheckInChannel
-(BOOL)saveCheckInChannels:(PBArray*)checkInChannels{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from checkin_channel;"];
        
        for (CheckInChannel* c in checkInChannels)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into checkin_channel (channelValue) values ('%@');",c.channelValue]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

-(NSMutableArray*)getCheckInChannels{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from checkin_channel";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            CheckInChannel_Builder* cb = [CheckInChannel builder];
            
            [cb setChannelValue:[rs stringForColumn:@"channelValue"]];
            CheckInChannel* f = [cb build];
            [result addObject:f];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query checkin channel.");
        
    }
    return nil;
    
    
}

#pragma mark -班次信息
-(BOOL)saveChenkInShift:(CheckInShift*)checkInshift {
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from checkin_shift;"];
        
        
        [db executeUpdate:[NSString stringWithFormat:@"insert into checkin_shift (id,name,checkInCount,isDaySpan,versionNo,workingTime,weekDay,humanizedSet,syncTime,checkInAhead,date) values (%d,'%@',%d,%d,'%@','%@','%@','%@','%@','%@','%@');",checkInshift.id,checkInshift.name,checkInshift.checkInCount,checkInshift.isDaySpan,checkInshift.versionNo,checkInshift.workingTime,checkInshift.weekDay,checkInshift.humanizedSet,checkInshift.syncTime,checkInshift.checkInAhead,checkInshift.date]];
        
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

-(CheckInShift*)getCheckInshift{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from checkin_shift";
        FMResultSet * rs = [db executeQuery:sql];
        CheckInShift* f= nil;
        while ([rs next]) {
            CheckInShift_Builder* cb = [CheckInShift builder];
            [cb setId:[rs intForColumn:@"id"]];
            [cb setName:[rs stringForColumn:@"name"]];
            [cb setCheckInCount:[rs intForColumn:@"checkInCount"]];
            [cb setIsDaySpan:[rs intForColumn:@"isDaySpan"]];
            [cb setVersionNo:[rs stringForColumn:@"versionNo"]];
            [cb setWorkingTime:[rs stringForColumn:@"workingTime"]];
            [cb setWeekDay:[rs stringForColumn:@"weekDay"]];
            [cb setHumanizedSet:[rs stringForColumn:@"humanizedSet"]];
            [cb setSyncTime:[rs stringForColumn:@"syncTime"]];
            [cb setCheckInAhead:[rs stringForColumn:@"checkInAhead"]];
            [cb setDate:[rs stringForColumn:@"date"]];
            f = [cb build];
        }
        [rs close];
        [db close];
        return f;
        
    }
    else
    {
        NSLog(@"error when query checkin shift.");
        
    }
    return nil;
}
#pragma mark - ShiftGroup
-(BOOL)saveShiftGroup:(PBArray*)track {
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from checkin_shiftgroup;"];
        
        for (CheckInTrack* f in track)
        {
             [db executeUpdate:[NSString stringWithFormat:@"insert into checkin_shiftgroup (id,name,date,checkInStatus,checkInType,checkInTime,checkInAbnormal) values ('%@','%@','%@',%d,%d,'%@',%d);",f.checkInShiftGroup.id,f.checkInShiftGroup.name,f.checkInShiftGroup.date,f.checkInShiftGroup.checkInStatus,f.checkInShiftGroup.checkInType,f.checkInShiftGroup.checkInTime,f.checkInShiftGroup.checkInAbnormal]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
 }

-(NSMutableArray*)getShiftGroup{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];

    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from checkin_shiftgroup";
        FMResultSet * rs = [db executeQuery:sql];
        CheckInShiftGroup* f= nil;
        while ([rs next]) {
            CheckInShiftGroup_Builder* cb = [CheckInShiftGroup builder];
            [cb setId:[rs stringForColumn:@"id"]];
            [cb setShift:[LOCALMANAGER getCheckInshift]];
            [cb setName:[rs stringForColumn:@"name"]];
            [cb setDate:[rs stringForColumn:@"date"]];
            [cb setCheckInStatus:[rs intForColumn:@"checkInStatus"]];
            [cb setCheckInType:[rs intForColumn:@"checkInType"]];
            [cb setCheckInTime:[rs stringForColumn:@"checkInTime"]];
            [cb setCheckInAbnormal:[rs intForColumn:@"checkInAbnormal"]];
            f = [cb build];
            [result addObject:f];
            
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query checkin shift.");
        
    }
    return nil;
}
//假期
-(BOOL)saveHolidays:(PBArray*)holidays {
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from checkin_holiday;"];
    
        for (int i = 0; i < holidays.count; i ++) {
             [db executeUpdate:[NSString stringWithFormat:@"insert into checkin_holiday (value) values ('%@');",[holidays objectAtIndex:i]]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

-(NSMutableArray*)getHolidays{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from checkin_holiday";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            [result addObject:[rs stringForColumn:@"value"]];
            
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query checkin_holiday.");
        
    }
    return nil;

}

#pragma mark - 调休类型的保存和获取
- (BOOL) saveHolidayCategories:(PBArray*) holidayCategoies{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from holiday_category;"];
        
        for (HolidayCategory* f in holidayCategoies)
        {
            [db executeUpdate:[NSString stringWithFormat:@"insert into holiday_category (id,name) values (%d,'%@');",f.id,f.name]];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (NSMutableArray*) getHolidayCategories{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from holiday_category";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            HolidayCategory_Builder* fb = [HolidayCategory builder];
            [fb setId: [rs intForColumn:@"id"]];
            [fb setName: [rs stringForColumn:@"name"]];
            
            HolidayCategory* f = [fb build];
            [result addObject:f];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query holiday category.");
        
    }
    return nil;
}

- (BOOL) savePaperTemplates:(PBArray*) templates{
    PaperTemplate* favd = [self getFavPaperTempate];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from paper_template;"];
        
        for (PaperTemplate* d in templates){
       
            if (favd == d) {
                [db executeUpdate:@"update paper_template set isDefault = 1;"];

            }
            
            NSString* sql = [NSString stringWithFormat:@"insert into paper_template (id,name,userId,fieldCount,fieldContent,totalRecords) values ('%@','%@',%d,%d,'%@',%d)",d.id,d.name,d.createUser.id,d.fieldCount,d.fieldContent,d.totalRecords];
            [db executeUpdate:sql];
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (NSMutableArray*) getPaperTemplates{
    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from paper_template";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            PaperTemplate_Builder* v1 = [PaperTemplate builder];
            [v1 setId: [rs stringForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setFieldCount: [rs intForColumn:@"fieldCount"]];
            [v1 setFieldContent:[rs stringForColumn:@"fieldContent"]];
            [v1 setTotalRecords: [rs intForColumn:@"totalRecords"]];
            PaperTemplate* d = [v1 build];
            [result addObject:d];
        }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query paper template.");
        
    }
    return nil;
}

- (BOOL) favPaperTemplate:(NSString*) templateId{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"update paper_template set isDefault = 0;"];
        NSString* sql = [NSString stringWithFormat:@"update paper_template set isDefault = 1 where id = '%@'",templateId];
        [db executeUpdate:sql];
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;
}

- (PaperTemplate*) getFavPaperTempate{
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from paper_template where isDefault = 1 limit 0,1";
        FMResultSet * rs = [db executeQuery:sql];
        PaperTemplate* d = nil;
        while ([rs next])
        {
            PaperTemplate_Builder* v1 = [PaperTemplate builder];
            [v1 setId: [rs stringForColumn:@"id"]];
            [v1 setName: [rs stringForColumn:@"name"]];
            [v1 setFieldCount: [rs intForColumn:@"fieldCount"]];
            [v1 setFieldContent:[rs stringForColumn:@"fieldContent"]];
            [v1 setTotalRecords: [rs intForColumn:@"totalRecords"]];
            d = [v1 build];
        }
        [rs close];
        [db close];
        return d;
        
    }
    else
    {
        NSLog(@"error when query paper template.");
        
    }
    return nil;
}

//权限 id name  value
-(BOOL)saveUserPermission:(User*)user {
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        [db beginTransaction];
        [db executeUpdate:@"delete from user_permission;"];
        
        if (user.permissions.count) {
            for(Permission *p in user.permissions){
                [db executeUpdate:[NSString stringWithFormat:@"insert into user_permission (name,value) values ('%@','%@')",p.name,p.value]];
            }
    
        }
        [db commit];
        [db close];
        return YES;
    }
    
    return NO;


}
-(NSMutableArray*)getUserPermisson {

    NSMutableArray* result = [[[NSMutableArray alloc]init]autorelease];
    NSMutableDictionary *resultDic = [[[NSMutableDictionary alloc]init] autorelease];
    Permission *permission = nil;
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString * sql = @"select * from user_permission";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            Permission_Builder *pb = [Permission builder];
            [pb setName:[rs stringForColumn:@"name"]];
            [pb setValue:[rs stringForColumn:@"value"]];
            permission = [pb build];
            [result addObject:permission];
    }
        [rs close];
        [db close];
        return result;
        
    }
    else
    {
        NSLog(@"error when query paper template.");
        
    }
    return nil;


}



- (void)setupManagedObjectContext{
    NSString* doc = PATH_OF_DOCUMENT;
    NSString* path = [doc stringByAppendingPathComponent:@"alarm.sqlite"];
    NSLog(@"alarm db path:%@",path);
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle JSLiteResourcesBundle]]];
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError *error = nil;
    self.storeURL = [[NSURL alloc] initFileURLWithPath:path];
    [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    if (error) {
        NSLog(@"error: %@", error);
    }
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

- (BOOL)saveSplashImage{
    UIImage* bgImage = [UIImage imageWithColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    NSString* title = [LOCALMANAGER getValueFromUserDefaults:KEY_APP_TITLE];//@"销售管家";
    int x;
    switch (title.length) {
        case 1:
            x = MAINWIDTH / 2 - 20;
            break;
        case 2:
            x = MAINWIDTH / 2 - 30;
            break;
        case 3:
            x = MAINWIDTH / 2 - 40;
            break;
        case 4:
            x = MAINWIDTH / 2 - 55;
            break;
        case 5:
            x = MAINWIDTH / 2 - 75;
            break;
        case 6:
            x = MAINWIDTH / 2 - 90;
            break;
        case 7:
            x = MAINWIDTH / 2 - 100;
            break;
        case 8:
            x = MAINWIDTH / 2 - 120;
            break;
        case 9:
            x = MAINWIDTH / 2 - 130;
            break;
        case 10:
            x = 10;
            break;
        default:
            x = 5;
            break;
    }
    CGSize constraint = CGSizeMake(MAINWIDTH - 10, 2000.0f);
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:title attributes:@{
                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:30]
                                                                                                     }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    UIImage* newImage = [bgImage imageWithStringWaterMark:title inRect:CGRectMake(x, MAINHEIGHT/2 - 50, rect.size.width, rect.size.height) color:WT_RED font:[UIFont systemFontOfSize:30.0f]];
    
    NSString* defaultImagePath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle]resourcePath],@"Default.png"];
    NSString* defaultImagePath2x = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle]resourcePath],@"Default@2x.png"];
    NSString* defaultImagePath568h2x = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle]resourcePath],@"Default-568h@2x.png"];
    NSLog(@"defaultImagePath:%@",defaultImagePath);
    [newImage writeImageToFileAtPath:defaultImagePath];
    [newImage writeImageToFileAtPath:defaultImagePath2x];
    [newImage writeImageToFileAtPath:defaultImagePath568h2x];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFile = [[NSString alloc] initWithString:[NSString UUID]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageFile]];
    
    [newImage writeImageToFileAtPath:imagePath];
    //[bgImage release];
    //bgImage = nil;
    
    //[newImage release];
    //newImage = nil;
    return YES;
}
-(void) checkVersion{
    [[UpdateVersion sharedInstance] setAppID:@"688032620"];
    
    /* (Optional) Set the Alert Type for your app
     By default, the Singleton is initialized to HarpyAlertTypeOption */
    [[UpdateVersion sharedInstance] setAlertType:AlertTypeOption];
    
    /* (Optional) If your application is not availabe in the U.S. Store, you must specify the two-letter
     country code for the region in which your applicaiton is available in. */
    //[[UpdateVersion sharedInstance] setCountryCode:@"<countryCode>"];
    
    // Perform check for new version of your app
    [[UpdateVersion sharedInstance] checkVersion:FALSE];
}
@end
