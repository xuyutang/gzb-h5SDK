//
//  SaleCell.m
//  SalesManager
//
//  Created by ZhangLi on 14-1-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "SaleCell.h"
#import "ProductCell.h"
#import "Constant.h"

@implementation SaleCell
@synthesize products,hiddenPrice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        hiddenPrice = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) showProducts{
    _productTableView.frame = CGRectMake(6, 40, 320, products.count * 60);
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    _productTableView.allowsSelection = NO;
    _productTableView.scrollEnabled = NO;
    _productTableView.backgroundColor = [UIColor clearColor];
    _productTableView.backgroundView = nil;
    _productTableView.separatorColor = [UIColor clearColor];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"product count :%d",products.count);
    return products.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"ProductCell";
    
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProductCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[ProductCell class]])
                cell=(ProductCell *)oneObject;
        }
    }
    Product *p = [products objectAtIndex:indexPath.row];
    cell.count.text = [NSString stringWithFormat:@"%g",p.num];
    cell.price.text = [NSString stringWithFormat:@"%.2f",p.price];
    cell.product.text = p.name;
    cell.unit.text = p.unit;
    
    cell.priceLabel.hidden = hiddenPrice;
    cell.price.hidden = hiddenPrice;
    cell.RMBLabel.hidden = hiddenPrice;
    
    return cell;
}

- (void)dealloc {
    [_customer release];
    [_name release];
    [_updateTime release];
    //[_productTableView release];
    [_total release];
    [_lMark release];
    [super dealloc];
}
@end
