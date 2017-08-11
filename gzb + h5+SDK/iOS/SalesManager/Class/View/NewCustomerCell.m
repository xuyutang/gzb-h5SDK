//
//  NewCustomerCell.m
//  SalesManager
//
//  Created by liu xueyan on 9/6/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "NewCustomerCell.h"

@implementation NewCustomerCell
@synthesize txtContact,txtCustomerCategory,txtCustomerName,txtTel,btCancel,btConfirm;

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

- (void)dealloc {
    [txtCustomerCategory release];
    [txtCustomerName release];
    [txtContact release];
    [txtTel release];
    [btConfirm release];
    [btCancel release];
    [super dealloc];
}
@end
