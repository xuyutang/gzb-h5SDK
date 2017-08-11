//
//  Harpy.h
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdateVersionDelegate <NSObject>

@optional
- (void)DidShowUpdateDialog;       // User presented with update dialog
- (void)UserDidLaunchAppStore;     // User did click on button that launched App Store.app
- (void)UserDidSkipVersion;        // User did click on button that skips version update
- (void)UserDidCancel;             // User did click on button that cancels update dialog
@end

typedef NS_ENUM(NSUInteger, AlertType)
{
    AlertTypeForce,    // Forces user to update your app
    AlertTypeOption,   // (DEFAULT) Presents user with option to update app now or at next launch
    AlertTypeSkip      // Presents User with option to update the app now, at next launch, or to skip this version all together
};

@interface UpdateVersion : NSObject{
    NSString* _changelog;
}

/**
 The harpy delegate can be used to know when the update dialog is shown and which action a user took.
 See the @protocol declaration above.
 */
@property (weak, nonatomic) id<UpdateVersionDelegate> delegate;

/**
 The app id of your app.
 */
@property (strong, nonatomic) NSString *appID;

/**
 (OPTIONAL) The alert type to present to the user when there is an update. See the `HarpyAlertType` enum above.
 */
@property (assign, nonatomic) AlertType alertType;

/**
 (OPTIONAL) If your application is not availabe in the U.S. Store, you must specify the two-letter 
 country code for the region in which your applicaiton is available in.
 */
@property (copy, nonatomic) NSString *countryCode;

/**
 Haroy's Singleton method.
 */
+ (id)sharedInstance;

/**
 Checks the installed version of your application against the version currently available on the iTunes store.
 If a newer version exists in the AppStore, Harpy prompts your user to update their copy of your app.
 Place in application:didFinishLaunchingWithOptions: AFTER calling makeKeyAndVisible on your UIWindow iVar.
 Do not use this method if you are using checkVersionDaily or checkVersionWeekly.
 */
- (void)checkVersion:(BOOL)bAtOnce;

/**
 Perform daily check for new version of your app.
 Useful if user returns to you app from background after extended period of time.
 Place in applicationDidBecomeActive:.
 Do not use this method if you are using checkVersion or checkVersionWeekly.
 */
- (void)checkVersionDaily;

/**
 Perform weekly check for new version of your app.
 Useful if user returns to you app from background after extended period of time.
 Place in applicationDidBecomeActive:.
 Do not use this method if you are using checkVersion or checkVersionDaily.
 */
- (void)checkVersionWeekly;

@end
