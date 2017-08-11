//
//  CompanyContactCell.h
//  SalesManager
//
//  Created by liu xueyan on 8/9/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanyContactCellDelegate <NSObject>

-(void)clickTelButton:(int)section row:(int)row;
-(void)clickSmsButton:(NSString *)tel;

@end

@interface CompanyContactCell : UITableViewCell{

    id<CompanyContactCellDelegate> delegate;
    BOOL isChecked;
}

@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *tel;
@property (retain, nonatomic) IBOutlet UILabel *department;
@property (retain, nonatomic) IBOutlet UILabel *position;
@property (retain, nonatomic) IBOutlet UIButton *btSms;
@property (retain, nonatomic) IBOutlet UIButton *btTel;
@property (retain, nonatomic) IBOutlet UIImageView *check;

@property (assign,nonatomic) id<CompanyContactCellDelegate> delegate;
@property (assign,nonatomic) BOOL isChecked;

@end
