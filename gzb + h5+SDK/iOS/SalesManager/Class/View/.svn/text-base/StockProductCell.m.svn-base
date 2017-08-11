//
//  StockProductCell.m
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "StockProductCell.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>

@implementation StockProductCell
@synthesize productName,count,unit;

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

- (void)initSubviews{
    [super initSubviews];
    productName = [[UILabel alloc] initWithFrame:CGRectMake(10,10,290,20)];
    [productName setFont:[UIFont systemFontOfSize:14]];
    productName.numberOfLines = 2;
    productName.backgroundColor = [UIColor clearColor];
    [self addSubview:productName];
    
    UILabel *lblCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 51, 20)];
    [lblCount setText:@"数量:"];
    [lblCount setFont:[UIFont systemFontOfSize:14]];
    lblCount.backgroundColor = [UIColor clearColor];
    [self addSubview:lblCount];
    [lblCount release];
    
    count = [[UITextField alloc] initWithFrame:CGRectMake(48, 40, 80, 30)];
    [count setFont:[UIFont systemFontOfSize:14]];
    [count setTextColor:RGBA(65, 105, 225, 1.0)];
    [count setBackground:[UIImage imageNamed:@"bg_edit_text"]];
    [count setBorderStyle:UITextBorderStyleNone];
    [count setKeyboardType:UIKeyboardTypeDecimalPad];
    [count setTextAlignment:NSTextAlignmentCenter];
    count.backgroundColor = [UIColor clearColor];
    [self addSubview:count];
    
    
    unit = [[UILabel alloc] initWithFrame:CGRectMake(135, 45, 42, 20)];
    [unit setFont:[UIFont systemFontOfSize:14]];
    unit.backgroundColor = [UIColor clearColor];
    [self addSubview:unit];
    
}


- (void)dealloc {
    [productName release];
    [count release];
    [unit release];
    [super dealloc];
}


@end
