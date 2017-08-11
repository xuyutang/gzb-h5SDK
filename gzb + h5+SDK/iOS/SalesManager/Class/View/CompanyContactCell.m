//
//  CompanyContactCell.m
//  SalesManager
//
//  Created by liu xueyan on 8/9/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "CompanyContactCell.h"

@implementation CompanyContactCell
@synthesize name,tel,check,position,department,delegate,isChecked,btSms,btTel;

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
    
    [btTel addTarget:self action:@selector(toTel) forControlEvents:UIControlEventTouchUpInside];
    [btSms addTarget:self action:@selector(toSms) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)checkCell{
    
    if (isChecked) {
        [check setHidden:NO];
    }else{
        [check setHidden:YES];
    }
}

-(void)toTel{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel.text]]];
}

-(void)toSms{
    
    if (delegate != nil && [delegate respondsToSelector:@selector(clickSmsButton:)]) {
        [delegate clickSmsButton:tel.text];
    }
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@;%@;%@",@"123",@"3456",tel.text]]];
}


- (void)dealloc {
    [name release];
    [tel release];
    [department release];
    [position release];
    [btSms release];
    [btTel release];
    [check release];
    [super dealloc];
}
@end
