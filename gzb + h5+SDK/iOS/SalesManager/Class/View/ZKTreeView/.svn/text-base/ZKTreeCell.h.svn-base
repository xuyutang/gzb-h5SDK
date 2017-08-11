//
//  ZKTreeCell.h
//  MyTreeView
//
//  Created by Administrator on 16/1/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKTreeCell : UITableViewCell

@property (nonatomic,assign) int nid;
@property (nonatomic,strong) UILabel *lbTitle;
@property (nonatomic,assign) BOOL bChecked;
@property (nonatomic,assign) BOOL bExpand;
@property (nonatomic,strong) NSMutableArray *children;
@property (nonatomic,assign) int depth;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) id target;
@property (nonatomic,strong) ZKTreeCell *parent;
@property (nonatomic,strong) UIImageView *expandIcon;
@property (nonatomic,assign) BOOL bCheckParent;         //父节点是否可选
@property (nonatomic,assign) int rootId;                //所属根节点ID

@property (nonatomic,copy) void(^clicked) (ZKTreeCell *cell);


-(void) changeChcecked:(BOOL) checked;
-(instancetype)initWithTitle:(NSString *)title depth:(int) depth bExpand:(BOOL) bExpand bCheckParent:(BOOL) bCheckParent parent:(ZKTreeCell *)parent target:(id) target rootId:(int) rootId;
@end
