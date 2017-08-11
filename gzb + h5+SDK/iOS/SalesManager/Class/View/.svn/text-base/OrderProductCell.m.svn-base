//
//  OrderProductCell.m
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "OrderProductCell.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>

@implementation OrderProductCell
@synthesize productName,count,unit,price;

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
    
    UILabel *lblCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 51, 51, 20)];
    [lblCount setText:@"数量:"];
    [lblCount setFont:[UIFont systemFontOfSize:14]];
    lblCount.backgroundColor = [UIColor clearColor];
    [self addSubview:lblCount];
    [lblCount release];
    
    count = [[UITextField alloc] initWithFrame:CGRectMake(48, 49, 80, 30)];
    [count setFont:[UIFont systemFontOfSize:14]];
    [count setTextColor:RGBA(65, 105, 225, 1.0)];
    [count setBackground:[UIImage imageNamed:@"bg_edit_text"]];
    [count setBorderStyle:UITextBorderStyleNone];
    [count setKeyboardType:UIKeyboardTypeDecimalPad];
    [count setTextAlignment:NSTextAlignmentCenter];
    count.backgroundColor = [UIColor clearColor];
    [self addSubview:count];
    
    
    unit = [[UILabel alloc] initWithFrame:CGRectMake(135, 51, 42, 20)];
    [unit setFont:[UIFont systemFontOfSize:14]];
    unit.backgroundColor = [UIColor clearColor];
    [self addSubview:unit];
    
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(163, 51, 45, 20)];
    [lblPrice setFont:[UIFont systemFontOfSize:14]];
    [lblPrice setText:@"单价:"];
    lblPrice.backgroundColor = [UIColor clearColor];
    [self addSubview:lblPrice];
    [lblPrice release];
    
    price = [[UITextField alloc] initWithFrame:CGRectMake(210, 49, 80, 30)];
    [price setFont:[UIFont systemFontOfSize:14]];
    [price setTextColor:RGBA(65, 105, 225, 1.0)];
    [price setBackground:[UIImage imageNamed:@"bg_edit_text"]];
    [price setBorderStyle:UITextBorderStyleNone];
    [price setKeyboardType:UIKeyboardTypeDecimalPad];
    [price setTextAlignment:NSTextAlignmentCenter];
    price.backgroundColor = [UIColor clearColor];
    [self addSubview:price];
    
    UILabel *lblUnit = [[UILabel alloc] initWithFrame:CGRectMake(288, 51, 30, 20)];
    [lblUnit setFont:[UIFont systemFontOfSize:14]];
    [lblUnit setText:@"元"];
    lblUnit.backgroundColor = [UIColor clearColor];
    [self addSubview:lblUnit];
    [lblUnit release];

}

- (void)dealloc {
    [productName release];
    [count release];
    [unit release];
    [price release];
    [super dealloc];
}
@end
