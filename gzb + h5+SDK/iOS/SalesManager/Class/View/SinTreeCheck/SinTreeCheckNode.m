//
//  TreeCheckNode.m
//  GDDJ
//
//  Created by RobinTang on 12-12-19.
//  Copyright (c) 2012年 com.sin All rights reserved.
//

#import "SinTreeCheckNode.h"

@implementation SinTreeCheckNode

@synthesize cid,parentId, text, checked, children, expanded, level,delegate,department,target;


-(id)init{
    self = [super init];
    if(self){
        self.cid = 0;
        self.parentId = nil;
        self.text = nil;
        self.level = 0;
        self.checked = NO;
        self.expanded = NO;
        self.children = nil;
    }
    return self;
}

-(void)dealloc{
    NSLog(@"dealoc:%@", text);
    self.text = nil;
    self.children = nil;

    [super dealloc];
}

+(id)nodeWithProperties:(NSInteger)cid andText:(NSString *)andText andChecked:(BOOL)bChecked andDepartment:(id)department{
    return [SinTreeCheckNode nodeWithProperties:cid andText:andText andDepartment:department andLevel:0 andChecked:bChecked andExpanded:NO andChildren:nil];
}

+(id)nodeWithProperties:(NSInteger)cid andText:(NSString *)andText andDepartment:(id)department andLevel:(NSInteger)andLevel andChecked:(BOOL)andChecked andExpanded:(BOOL)andExpanded andChildren:(NSArray*)andChildren{
    SinTreeCheckNode *node = [[[SinTreeCheckNode alloc] init]autorelease];
    node.cid = cid;
    node.text = andText;
    node.level = andLevel;
    node.checked = andChecked;
    node.expanded = andExpanded;
    node.department = department;

    if(andChildren!=nil){
        for (SinTreeCheckNode *ch in andChildren) {
            [node addChild:ch];
        }
    }
    return node;
}

+(id)nodeWithProperties:(NSInteger)cid andText:(NSString *)andText andChecked:(BOOL)bChecked andTarget:(InspectionTarget*)target{
    return [SinTreeCheckNode nodeWithProperties:cid andText:andText andTarget:target andLevel:0 andChecked:bChecked andExpanded:NO andChildren:nil];
}

+(id)nodeWithProperties:(NSInteger)cid andText:(NSString *)andText andTarget:(InspectionTarget*)target andLevel:(NSInteger)andLevel andChecked:(BOOL)andChecked andExpanded:(BOOL)andExpanded andChildren:(NSArray*)andChildren{
    SinTreeCheckNode *node = [[[SinTreeCheckNode alloc] init]autorelease];
    node.cid = cid;
    node.text = andText;
    node.level = andLevel;
    node.checked = andChecked;
    node.expanded = andExpanded;
    node.target = target;
    
    if(andChildren!=nil){
        for (SinTreeCheckNode *ch in andChildren) {
            [node addChild:ch];
        }
    }
    return node;
}


-(NSString *)description{
    NSMutableString *s = [[[NSMutableString alloc]initWithCapacity:0] autorelease];
    [s appendFormat:@"cid:%d text:%@ level:%d expanded:%@", self.cid, self.text, self.level, self.expanded?@"YES":@"NO"];
    if (self.hasChilren) {
        [s appendString:@" children:["];
        BOOL notfirst = NO;
        for (SinTreeCheckNode *ch in children) {
            if (notfirst) {
                [s appendString:@","];
            }
            [s appendFormat:@"(%@)", [ch description]];
            notfirst = YES;
        }
        [s appendString:@"]"];
    }
    return s;
}

-(BOOL)isContainer{
    return children != nil;
}

-(BOOL)hasChilren{
    return children!=nil && [children count]>0;
}
-(void)changeLevel:(NSInteger)newlevel{
    if(newlevel != level){
        self.level = newlevel;
        if([self hasChilren]){
            for (SinTreeCheckNode *ch in children) {
                [ch changeLevel:level+1];
            }
        }
    }
}
-(void)changeCheckStatus:(BOOL)checkStatus linkage:(BOOL)linkage{
    //单选
    if (_bSingle) {
        if ([self hasChilren]) {
            return;
        }
    }
    self.checked = checkStatus;
    /*
    if (self.checked) {
        NSLog(@"add node : %@",self.text);
    }else{
        NSLog(@"remove node : %@",self.text);
    }
    */
    if([self.delegate respondsToSelector:@selector(finishedCheckNode:status:)]){
        [self.delegate finishedCheckNode:self status:checkStatus];
    }
    if([self hasChilren]&&linkage){
        if (!_bSingle) {
            for (SinTreeCheckNode *ch in children) {
                [ch changeCheckStatus:checkStatus linkage:YES];
            }
        }
    }
}
-(void)addChild:(SinTreeCheckNode*)child{
    if(self.children == nil){
        self.children = [NSMutableArray arrayWithCapacity:0];
    }
    child.parentId = self;
    [self.children addObject:child];
    [child changeLevel:level+1];
}
-(BOOL)ergodicNode:(BLOCK_ON_SINTREECHECKNODE)ope{
    if(ope(self)){  // 如果几点自身操作成功则遍历孩子
        if(self.hasChilren){
            for (SinTreeCheckNode *ch in self.children) {
                [ch ergodicNode:ope];
            }
        }
        return YES;
    }
    // 否则的话就不遍历孩子了
    return NO;
}
@end
