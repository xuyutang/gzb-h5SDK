//
//  InspectionTargetCell.h
//  SalesManager
//
//  Created by liuxueyan on 14-12-2.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionTargetCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *number;
@property (retain, nonatomic) IBOutlet UILabel *value;


-(float) getHeight:(NSString *) tname number:(NSString *) tnumber value:(NSString *) tvalue status:(NSString *) status;
-(void) resetFrame:(NSString *)name number:(NSString *) number;
@end
