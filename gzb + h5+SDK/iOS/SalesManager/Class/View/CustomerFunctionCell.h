//
//  CustomerFunctionCell.h
//  SalesManager
//
//  Created by liuxueyan on 15-5-5.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
@interface FunctionItem : NSObject
@property (nonatomic,retain) NSString *name;
@property (nonatomic,assign) int fid;

@end


@interface CustomerFunctionCell : UITableViewCell{
    NSMutableArray *myFunctions;
}
@property (retain, nonatomic) IBOutlet UIButton *bt1;
@property (retain, nonatomic) IBOutlet UIButton *bt2;
@property (retain, nonatomic) IBOutlet UIButton *bt3;
@property (retain, nonatomic) IBOutlet UIButton *bt4;
@property (retain, nonatomic) IBOutlet UIButton *bt5;
@property (retain, nonatomic) IBOutlet UIButton *bt6;
@property (retain, nonatomic) IBOutlet UIButton *bt7;
@property (retain, nonatomic) IBOutlet UIButton *bt8;

@property (retain, nonatomic) NSMutableArray *functions;
@property (nonatomic,retain) UIViewController *vctrl;
@property (nonatomic,retain) Customer *customer;

@end
