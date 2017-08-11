//
//  NewTaskCell.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-20.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *taskNum;
@property (retain, nonatomic) IBOutlet UITextField *content;
@property (retain, nonatomic) IBOutlet UIButton *btnAdd;

@end
