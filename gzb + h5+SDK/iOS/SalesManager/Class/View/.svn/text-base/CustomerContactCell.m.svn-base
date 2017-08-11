//
//  CustomerContactCell.m
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "CustomerContactCell.h"

@implementation CustomerContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell{

    [self.btTel addTarget:self action:@selector(toTel) forControlEvents:UIControlEventTouchUpInside];
    [self.btSms addTarget:self action:@selector(toSms) forControlEvents:UIControlEventTouchUpInside];

}

-(void)setIsChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    if (_isChecked) {
        [self.check setHidden:NO];
    }else{
        [self.check setHidden:YES];
    }
}

-(void)toTel{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phone]]];
}

-(void)toSms{

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickSmsButton:)]) {
        [self.delegate clickSmsButton:self.phone];
    }
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@;%@;%@",@"123",@"3456",tel.text]]];
}

- (void)dealloc {
    [self.customerName release];
    [self.personName release];
    [self.tel release];
    [self.btSms release];
    [self.btTel release];
    [self.check release];
    
    [super dealloc];
}
@end
