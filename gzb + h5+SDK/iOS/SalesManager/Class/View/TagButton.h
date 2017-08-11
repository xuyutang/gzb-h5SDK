//
//  TagButton.h
//  SalesManager
//
//  Created by Administrator on 16/3/26.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagButton : UIButton

@property (nonatomic,assign) BOOL bCheck;

@property (nonatomic,copy) void(^click) (TagButton *sender);

@property (nonatomic,retain) id obj;

-(void) cancelCheck;
-(instancetype)initWithFrame:(CGRect)frame name:(NSString *) name obj:(id) obj;
@end
