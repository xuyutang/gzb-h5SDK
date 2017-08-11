//
//  PDRightHeaderCell.h
//  ProductMenu
//
//  Created by Administrator on 16/2/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDRightHeaderCell : UIView
@property (strong, nonatomic) UILabel *lbtitle;
@property (strong, nonatomic) UIImageView *lbicon;
@property (nonatomic,assign) BOOL bChecked;
@property (nonatomic,assign) int section;

-(instancetype)initWithTitle:(NSString *)title;
@property (nonatomic,copy) void(^clicked) (PDRightHeaderCell*);
@end
