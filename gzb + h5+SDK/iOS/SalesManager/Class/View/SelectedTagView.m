//
//  SelectedTagView.m
//  SalesManager
//
//  Created by liuxueyan on 15-4-29.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "SelectedTagView.h"
#import "Constant.h"
@implementation SelectedTag

@end

@implementation SelectedTagView

-(void)addSelectedTag:(SelectedTag*)tag{
    if (tagArray == nil) {
        tagArray = [[NSMutableArray alloc] init];
    }
    if (tagViewArray == nil) {
        tagViewArray = [[NSMutableArray alloc] init];
    }
    TagItemView *lastTagView;
    if (tagViewArray.count >0) {
        lastTagView = [tagViewArray objectAtIndex:tagViewArray.count-1];
    }else{
        lastTagView = [[TagItemView alloc] init];
    }

    CGSize size;
    int x=5,y=5;
    if (tagViewArray.count > 0) {
        size =[lastTagView getContentSize];
        x = size.width + 20;
    }else{
        size = [lastTagView getContentSize:tag.content];
    }
    
    int width=size.width+10;
    int height= size.height+10;
    
    if (x+width>(MAINWIDTH-20)) {
        x = 5;
        y = size.height +20;
    }
    size = [lastTagView getContentSize:tag.content];
    UIImage *backgroundImage = [[UIImage imageNamed:@""]
                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0,13,0,13)];
    
    TagItemView *tagView = [[TagItemView alloc] initWithContent:tag.content background:backgroundImage closeImage:[UIImage imageNamed:@"ic_close"] frame:CGRectMake(x, y, width, height)];
    [tagViewArray addObject:tagView];
    [tagArray addObject:tag];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,size.height +20)];

}
-(void)removeSelectedTag:(int)tagId{

}

@end
