//
//  BaseViewController.h
//  SalesManager
//
//  Created by liu xueyan on 7/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchTableViewDelegate.h"
#import "UTTableView.h"
#import "HintHelper.h"
#import "NSString+Util.h"
#import "UIDevice+Util.h"
#import "UIImage+JSLite.h"
#import "RequestAgent.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@protocol InputFinishDelegate <NSObject>

-(void) didFinishInput:(int) tag Input:(NSString*) input;

@end

@protocol RefreshDelegate <NSObject>

- (void) refresh:(id)obj;

@end

@interface BaseViewController : UIViewController<TouchTableViewDelegate,RequestAgentDelegate,AppBecomeActiveDelegate,EMHintDelegate,ActionCodeDelegate>{

    UIImageView *leftImageView;
    UILabel *lblFunctionName;
    UIView *leftView;
    
    HintHelper* _hintHelper;
    BOOL bNeedBack;
    UIBarButtonItem *spaceButton;
    NSString *macAddrString;
    NSString *wifiNameString;

}

@property(nonatomic,retain) Customer *customer;
@property(nonatomic,retain) UIImageView *leftImageView;
@property(nonatomic,retain) UILabel *lblFunctionName;
@property(nonatomic,retain) UILabel *lblTitle;
@property(nonatomic,retain) UIView *leftView;
@property (nonatomic,assign) id<TouchTableViewDelegate> touchDelegate;
@property(nonatomic,assign) BOOL bNeedBack;

-(void)clickLeftButton:(id)sender;
-(void)showMessage2:(PBGeneratedMessage*) cr Title:(NSString*)title Description:(NSString*)desc;
-(void)showMessage:(ActionCode)resultCode Title:(NSString*)title Description:(NSString*)desc;
-(void)showMessage:(REQUEST_STATUS)status Title:(NSString*)title;
-(void)showHint:(EHintView) hintView;
-(void)refreshLocation;
-(void)readMessage:(int)type SourceId:(NSString*)sourceId;
-(BOOL)validateData:(id) data;
-(CGSize)rebuildSizeWithString:(NSString*) text ContentWidth:(double)width FontSize:(double)fontsize;
-(BOOL)validateResponse:(SessionResponse* )wtr;
-(BOOL)validateSessionResponse:(SessionResponse *)wtr;
-(void) setRightButton:(UIBarButtonItem *) barbutton;
-(void)syncTitle;

-(NSString*)getWifiName;
-(NSString*)getMacAddress;
-(NSString *)timeFormatted:(int)totalSeconds;



@end
