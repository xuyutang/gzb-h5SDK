//
//  LableCell.h
//  SalesManager
//
//  Created by Administrator on 15/11/26.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface SWLableCell : SWTableViewCell

@property (nonatomic,retain) UILabel *lable;
@property (retain,nonatomic) NSString* text;

-(void)setText:(NSString *)text size:(CGSize) size;
@end
