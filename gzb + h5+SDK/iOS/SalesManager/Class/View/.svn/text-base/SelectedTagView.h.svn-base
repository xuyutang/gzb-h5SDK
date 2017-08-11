//
//  SelectedTagView.h
//  SalesManager
//
//  Created by liuxueyan on 15-4-29.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagItemView.h"


@interface SelectedTag : NSObject

@property(nonatomic,retain) NSString *content;
@property(nonatomic,assign) int tag;
@property(nonatomic,assign) int Id;
@property(nonatomic,assign) id object;
@end

@interface SelectedTagView : UIView{
    NSMutableArray *tagArray;
    NSMutableArray *tagViewArray;
}

-(void)addSelectedTag:(SelectedTag*)tag;
-(void)removeSelectedTag:(int)tagId;

@end
