//
//  PatrolPictureListViewController.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-9.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullWaterflowView.h"

@interface PatrolPictureListViewController : BaseViewController<PullWaterflowViewDelegate>{
    PatrolParams* patrolParams;
    NSMutableArray *patrolArray;
    
    int currentPage;
    int pageSize;
    int totleSize;
    PullWaterflowView *waterFlowView;
}
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *imageSizes;

@end
