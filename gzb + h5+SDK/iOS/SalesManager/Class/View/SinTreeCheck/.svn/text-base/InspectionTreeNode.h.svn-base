//
//  InspectionTreeNode.h
//  SalesManager
//
//  Created by liuxueyan on 14-12-1.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@class InspectionTreeNode;
@protocol InspectionTreeNodeDelegate <NSObject>

@optional
-(void)finishedCheckNode:(InspectionTreeNode *)node status:(BOOL)checked;

@end


// 对节点实施的操作委托
typedef BOOL(^BLOCK_ON_SINTREECHECKNODEINSPECTION)(InspectionTreeNode *node);
@interface InspectionTreeNode : NSObject
{
    NSInteger cid;  // ID，应该是唯一的
    id parentId;
    NSString *text; // 标题
    NSString *number;
    BOOL    checked;    // 是否被选中
    BOOL    expanded;   // 是否展开
    NSMutableArray *children;  // 子节点
    NSInteger level;    // 等级
    id<InspectionTreeNodeDelegate> delegate;
    Department *department;
    InspectionTarget *target;
}

@property(nonatomic, assign)id<InspectionTreeNodeDelegate> delegate;
@property(nonatomic, assign)    NSInteger cid;
@property(nonatomic, retain)    id parentId;
@property(nonatomic, copy)NSString *text;
@property(nonatomic, copy)NSString *number;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, retain)NSMutableArray *children;
@property(nonatomic, assign)BOOL expanded;
@property(nonatomic, assign)NSInteger level;
@property(nonatomic, retain)Department *department;
@property(nonatomic, retain)InspectionTarget *target;

// 根据节点属性创建节点
+(id)nodeWithProperties:(NSInteger)cid andText:(NSString *)andText andDepartment:(Department*)department;
+(id)nodeWithProperties:(NSInteger)cid andText:(NSString *)andText andDepartment:(Department*)department andLevel:(NSInteger)andLevel andChecked:(BOOL)andChecked andExpanded:(BOOL)andExpanded andChildren:(NSArray*)andChildren;

+(id)nodeWithProperties:(NSInteger)cid andText:(NSString *)andText andTarget:(InspectionTarget*)target;
+(id)nodeWithProperties:(NSInteger)cid andText:(NSString *)andText andTarget:(InspectionTarget*)target andLevel:(NSInteger)andLevel andChecked:(BOOL)andChecked andExpanded:(BOOL)andExpanded andChildren:(NSArray*)andChildren;

// 添加子节点
-(void)addChild:(InspectionTreeNode*)child;
// 设置节点选中状态，会对子节点进行相同的操作
-(void)changeCheckStatus:(BOOL)checkStatus linkage:(BOOL)linkage;
// 是否是容器
-(BOOL)isContainer;
// 判断是否有子节点
-(BOOL)hasChilren;
// 对节点进行遍历操作，包括节点自身和孩子
// 先操作节点自身，如果自身的返回值为NO，则停止对子节点进行操作
-(BOOL)ergodicNode:(BLOCK_ON_SINTREECHECKNODEINSPECTION)ope;

@end
