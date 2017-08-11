//
//  SyncButton.h
//  SalesManager
//
//  Created by Administrator on 16/4/1.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncButton : UIButton


@property (nonatomic,copy) void(^onClick) (SyncButton *sender);
@end
