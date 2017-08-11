//
//  CustomerContactCell.h
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomerContactCellDelegate <NSObject>

-(void)clickTelButton:(int)section row:(int)row;
-(void)clickSmsButton:(NSString *)tel;

@end

@interface CustomerContactCell : UITableViewCell{
    BOOL bChecked;

}
@property (retain, nonatomic) IBOutlet UILabel *tel;
@property (retain, nonatomic) IBOutlet UIButton *btTel;
@property (retain, nonatomic) IBOutlet UIButton *btSms;
@property (retain, nonatomic) IBOutlet UILabel *customerName;
@property (retain, nonatomic) IBOutlet UILabel *personName;
@property (retain, nonatomic) IBOutlet UIImageView *check;

@property (assign, nonatomic) BOOL isChecked;

@property (assign,nonatomic) id<CustomerContactCellDelegate> delegate;
@property (nonatomic,retain) NSString *phone;

- (void)setCell;
@end
