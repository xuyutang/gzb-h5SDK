//
//  NewOrderViewController.h
//  SalesManager
//
//  Created by Administrator on 16/3/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseOrderWebViewController.h"
#import "SelectCell.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"

@interface ProductJavaScriptParams : NSObject
@property (nonatomic,retain) NSString *categoryIds;
@property (nonatomic,retain) NSString *priceSort;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *code;
@property (nonatomic,retain) NSString *minPrice;
@property (nonatomic,retain) NSString *maxPrice;
@property (nonatomic,retain) NSString *specificationIds;
@property (nonatomic,retain) NSString *tags;
@end


@interface NewOrderViewController : BaseOrderWebViewController<HeaderSearchBarDelegate,DepartmentViewControllerDelegate>
{
    SelectCell *_customerCell;
    HeaderSearchBar *_headerSearchBar;
    NSMutableArray *_searchViews;
    NSArray *_headerTitles;
    NSArray *_headerIcons;
    
    
    NSMutableArray *_category;
    NSMutableArray *_checkCategory;
}
@end
