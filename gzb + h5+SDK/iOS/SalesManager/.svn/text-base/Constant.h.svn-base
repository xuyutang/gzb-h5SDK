//
//  Constant.h
//  SalesManager
//

#ifndef SalesManager_Constant_h
#define SalesManager_Constant_h

#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLRegion.h>
#import <Foundation/Foundation.h>
#import "GlobalConstant.h"
#import "ViewControllerFactory.h"
#import "AppDelegate.h"

#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define MAINVIEW self.view
#define SELFWINDOW self.view.window

#define SHOWHUD if(SELFWINDOW != nil){ SHOWHUD2WINDOW ;\
                 }else{SHOWHUD2VIEW;}

#define SHOWHUD2WINDOW MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:SELFWINDOW animated:YES];\
                       hud.mode = MBProgressHUDModeCustomView;\
                       hud.labelText = NSLocalizedString(@"loading", nil);
#define SHOWHUD2VIEW   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];\
                       hud.mode = MBProgressHUDModeCustomView;\
                       hud.labelText = NSLocalizedString(@"loading", nil);
#define HUDHIDE if (self.view != nil) [MBProgressHUD hideHUDForView:self.view animated:YES];

#define HUDHIDE2 if (MAINVIEW != nil) [MBProgressHUD hideHUDForView:MAINVIEW animated:YES];\
                 if (SELFWINDOW != nil) [MBProgressHUD hideHUDForView:SELFWINDOW animated:YES];\
                 for (UIView *view in self.view.subviews) {\
                 if ([view isKindOfClass:[MBProgressHUD class]]) {\
                         [view removeFromSuperview];\
                     }\
                 }


#define VIEWCONTROLLER [ViewControllerFactory sharedInstance]
#define APPTITLE (![LOCALMANAGER getValueFromUserDefaults:KEY_APP_TITLE].isEmpty) ? [LOCALMANAGER getValueFromUserDefaults:KEY_APP_TITLE] : NSLocalizedString(@"app_name", nil)

#define VIDEOMAXDURATION @"8"



/*功能界面标题获取*/
#define TITLENAME(funcDes) ([LOCALMANAGER getFunctionNameWithDes:funcDes])

#define TITLENAME_REPORT(funcDes) ([NSString stringWithFormat:NSLocalizedString(@"func_title_report", nil),[LOCALMANAGER getFunctionNameWithDes:funcDes]])

#define TITLENAME_LIST(funcDes) ([NSString stringWithFormat:NSLocalizedString(@"func_title_list", nil),[LOCALMANAGER getFunctionNameWithDes:funcDes]])

#define TITLENAME_TEMPLATE(funcDes) ([NSString stringWithFormat:NSLocalizedString(@"func_title_template", nil),[LOCALMANAGER getFunctionNameWithDes:funcDes]])

#define TITLENAME_DETAIL(funcDes) ([NSString stringWithFormat:NSLocalizedString(@"func_title_detail", nil),[LOCALMANAGER getFunctionNameWithDes:funcDes]])

#define TITLENAME_CONFIRM(funcDes) ([NSString stringWithFormat:NSLocalizedString(@"func_title_confirm", nil),[LOCALMANAGER getFunctionNameWithDes:funcDes]])

#define TITLENAME_SUCESS(funcDes) ([NSString stringWithFormat:NSLocalizedString(@"func_title_sucess", nil),[LOCALMANAGER getFunctionNameWithDes:funcDes]])

#define TITLENAME_PRINT(funcDes) ([NSString stringWithFormat:NSLocalizedString(@"func_title_print", nil),[LOCALMANAGER getFunctionNameWithDes:funcDes]])

#define TITLENAME_STR(funcDes,str) ([NSString stringWithFormat:NSLocalizedString(@"func_title_str", nil),[LOCALMANAGER getFunctionNameWithDes:funcDes],str])




#endif






