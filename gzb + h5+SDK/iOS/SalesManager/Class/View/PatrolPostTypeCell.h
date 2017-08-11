//
//  PatrolPostTypeCell.h
//  SalesManager
//
//  Created by Administrator on 15/12/9.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolPostTypeCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UISegmentedControl *checkbox;

-(void) initMenu;
@end
