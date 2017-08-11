//
//  GZBTagList.m
//  SalesManager
//
//  Created by Administrator on 16/3/25.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "GZBTagList.h"
#import "Constant.h"
#import "TagButton.h"


@implementation GZBTagList
{
    NSMutableArray *specArray;
    NSMutableArray *specValArray;
    
    NSMutableArray *countArray; //纪录每个分组的选中个数
    float lastHeight;
    
    int select_count;
    int max_count;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void) initView{
    
    select_count = [LOCALMANAGER getKvoByKey:KEY_PRODUCT_SPEC_COUNT].intValue;
    max_count = [LOCALMANAGER getKvoByKey:KEY_PRODUCT_SPEC_MAX_COUNT].intValue;
    
    _selectedArray = [[NSMutableArray alloc] init];
    specArray = [LOCALMANAGER getProductSpecifications];
    
    //选择数量记录
    countArray = [[NSMutableArray alloc] initWithCapacity:specArray.count];
    for (int i = 0; i < specArray.count; i++) {
        [countArray addObject:@(0)];
    }
    
    float y = 10;
    int sectionId = 0; //分组编号
    for (ProductSpecification *item in specArray) {
        y = lastHeight + 20;
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, y, MAINWIDTH - 10, 30)];
        lable.text = item.name;
        [self addSubview:lable];
        
        lastHeight = lable.frame.origin.y + lable.frame.size.height + 10;
        float bx = 10;
        float by = 0;
        
        int index = 0;
        int row = 0;
        float btnHeight = 30;
        float btnWidth = (MAINWIDTH - 25 ) / 4 ;
        int count = 0;
        specValArray = [[LOCALMANAGER getProductSpecificationsWithSpecId:item.id] retain];
        for (ProductSpecificationValue *val in specValArray) {
            bx = index * btnWidth + (5 * (index + 1));
            by = lastHeight + row * btnHeight + (row * 5);
            TagButton *button = [[TagButton alloc] initWithFrame:CGRectMake(bx, by,btnWidth , btnHeight)
                                                            name:val.name
                                                             obj:val];
            button.tag = sectionId;
            button.click = ^(TagButton *sender){
                [self btnClickWithButton:sender];
            };
            [self addSubview:button];
            
            index++;
            if (index == 4) {
                index = 0;
                row++;
            }
            //只记录最后一个button
            count++;
            if (count == specValArray.count) {
                lastHeight = button.frame.origin.y + button.frame.size.height;
            }
        }
        [lable release];
        sectionId++;
    }
    CGRect r = self.frame;
    r.size.height = lastHeight;
    self.frame = r;
}


-(void) btnClickWithButton:(TagButton*) sender{
    
    
    id obj = sender.obj;
    if (sender.bCheck) {
        
        if([self checkCount:sender]){return;};
        
        if (![_selectedArray containsObject:obj]) {
            [_selectedArray addObject:obj];
        }
    }else{
        
        [self removeCheck:sender];
        [_selectedArray removeObject:obj];
    }
    
    NSLog(@"选择个数%d",[self getMaxCount]);
}


-(BOOL) checkCount:(TagButton *) button{
    //判断新的分组
    if ([countArray[button.tag] intValue] == 0) {
        if ([self getSectionCount] >= max_count) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                              description:[NSString stringWithFormat:NSLocalizedString(@"max_selected_count", nil),max_count]
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            [button cancelCheck];
            return YES;
        }
    }
    if (![self setSectionCountWithButton:button]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                          description:[NSString stringWithFormat:NSLocalizedString(@"section_selected_count", nil),select_count]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        [button cancelCheck];
        return YES;
    }
    return NO;
}

-(int) getSectionCount{
    int count = 0;
    for (int i  = 0; i < countArray.count; i++) {
        if ([countArray[i] intValue] > 0) {
            count ++;
        }
    }
    return count;
}

//分组个数
-(BOOL) setSectionCountWithButton:(TagButton *) button{
    int count = [countArray[button.tag] intValue];
    if (count < select_count) {
        [countArray replaceObjectAtIndex:button.tag withObject:@(++count)];
        return YES;
    }
    return NO;
}

-(void) removeCheck:(TagButton *) button{
    int count = [countArray[button.tag] intValue];
    if (--count < 0) {
        count = 0;
    }
    [countArray replaceObjectAtIndex:button.tag withObject:@(count)];
}

-(int) getMaxCount{
    int count = 0;
    for (int i = 0; i < countArray.count; i++) {
        count += [countArray[i] intValue];
    }
    return count;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
