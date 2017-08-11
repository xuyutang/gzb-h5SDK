//
//  GiftProductsCell.m
//  SalesManager
//
//  Created by 章力 on 14-9-26.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "GiftProductsCell.h"
#import "GiftProductItemCell.h"
#import "Constant.h"

@implementation GiftProductsCell
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
    _productTableView.frame = CGRectMake(6, 40, 320, products.count * 68);
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    _productTableView.allowsSelection = NO;
    _productTableView.scrollEnabled = YES;
    _productTableView.backgroundColor = [UIColor clearColor];
    _productTableView.backgroundView = nil;
    _productTableView.separatorColor = [UIColor clearColor];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"product count :%d",products.count);
    return 3;//products.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"GiftProductItemCell";
    
    GiftProductItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"GiftProductItemCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[GiftProductItemCell class]])
                cell=(GiftProductItemCell *)oneObject;
        }
    }
    GiftProductModel *p = [products objectAtIndex:indexPath.row];
    cell.count.text = [NSString stringWithFormat:@"%g",p.num];
    cell.price.text = [NSString stringWithFormat:@"%.2f",p.price];
    cell.product.text = p.giftProduct.name;
    cell.modelName.text = p.name;
    cell.unit.text = p.giftProduct.category.unit;
    
    return cell;
}

- (void)dealloc {
    [_customer release];
    //[_productTableView release];
    [_total release];
    [super dealloc];
}

@end
