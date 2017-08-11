//
//  Task0Cell.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-11.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Task0Cell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UIButton *btStatus;

@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *subTitle;
@property (retain, nonatomic) IBOutlet UILabel *duration;
@property (retain, nonatomic) IBOutlet UIButton *btComment;
@property (retain, nonatomic) IBOutlet UILabel *lMark;

@end
