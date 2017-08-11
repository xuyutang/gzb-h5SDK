//
//  DataReportListViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/8/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "Constant.h"
#import "PullTableView.h"
@interface DataReportListViewController : BaseViewController
{
    PaperPostParams_Builder *pBuilder;
    int currentPage;
    int pageSize;
    int totalSize;
    
    
    
    NSMutableArray *dataReportArray;
    int currentRow;
//    PaperPost* currentPaperPost;
}


//@property (retain ,nonatomic) PaperTemplate* dateReportParams;
@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain, nonatomic) PaperPostParams *pParams;
@end
