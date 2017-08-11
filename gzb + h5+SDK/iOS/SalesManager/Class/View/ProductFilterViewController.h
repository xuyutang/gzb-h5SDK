//
//  ProductFilterViewController.h
//  SalesManager
//
//  Created by Administrator on 16/3/24.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductFilterViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *txtProdName;
@property (retain, nonatomic) IBOutlet UITextField *txtBarCode;
@property (retain, nonatomic) IBOutlet UITextField *txtPriceStart;
@property (retain, nonatomic) IBOutlet UITextField *txtPriceEnd;
@property (retain, nonatomic) IBOutlet UIButton *btnSearch;

@property (retain, nonatomic) IBOutlet UIButton *btnReset;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,copy) void(^search) (NSDictionary *dic);

-(instancetype)initWithFrame:(CGRect) frame;
-(void) resetForm;
@end
