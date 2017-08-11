//
//  ThreeFilterViewController.h
//  SalesManager
//
//  Created by Administrator on 15/10/16.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThreeFilterViewControllerDelegate <NSObject>

-(void) ThreeFilterToSearch:(NSString*) name custName:(NSString*) custName giftName:(NSString*) giftName formTime:(NSString*) formTime endTime:(NSString*) endTime;

@end

@interface ThreeFilterViewController : UIView

@property(nonatomic,retain) NSString* lable1;
@property(nonatomic,retain) NSString* lable2;
@property(nonatomic,retain) NSString* lable3;


@property(nonatomic,retain) IBOutlet UITextField *txtCustName;
@property(nonatomic,retain) IBOutlet UITextField *txtName;

@property (retain, nonatomic) IBOutlet UIButton *btnSearch;
@property (retain, nonatomic) IBOutlet UIButton *btnReset;
@property(nonatomic,assign) id<ThreeFilterViewControllerDelegate> delegate;

@end
