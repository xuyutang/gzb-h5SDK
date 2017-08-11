//
//  ProductFilterViewController.m
//  SalesManager
//
//  Created by Administrator on 16/3/24.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "ProductFilterViewController.h"
#import "GZBTagList.h"
#import "Constant.h"
#import "TagButton.h"

@interface ProductFilterViewController ()
{
    GZBTagList *tagList;
}

@end

@implementation ProductFilterViewController

-(instancetype)initWithFrame:(CGRect) frame{
    if (self = [super init]) {
        self.view.frame = frame;
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 45.f);
        
        
        tagList = [[GZBTagList alloc] initWithFrame:CGRectMake(0, 170.f, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 45.f)];
        [self.scrollView addSubview:tagList];
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, tagList.frame.origin.y + tagList.frame.size.height + 10);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 1, MAINWIDTH, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:line];
        [line release];
        
        CGRect r;
        r = _btnReset.frame;
        r.origin.y = self.scrollView.frame.size.height + self.scrollView.frame.origin.y + 10;
        _btnReset.frame = r;
        r = _btnSearch.frame;
        r.origin.y = self.scrollView.frame.size.height + self.scrollView.frame.origin.y + 10;
        _btnSearch.frame = r;
    }
    return self;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    
}

- (IBAction)resetAction:(id)sender {
    [self resetForm];
}


-(void) resetForm{
    for (UIView *item in self.scrollView.subviews) {
        if ([item isKindOfClass:[UITextField class]]) {
            UITextField *txt = (UITextField*)item;
            txt.text = @"";
            [txt resignFirstResponder];
        }
    }
    [tagList removeFromSuperview];
    [tagList release];
    tagList = nil;
    tagList = [[GZBTagList alloc] initWithFrame:CGRectMake(0, 170,self.scrollView.frame.size.width, self.scrollView.frame.size.height - 45.f)];
    [self.scrollView addSubview:tagList];
}

- (IBAction)searchAction:(id)sender {
    if (self.search) {
        NSMutableString *tags = [[[NSMutableString alloc] init] autorelease];
        NSMutableString *tagName = [[[NSMutableString alloc] init] autorelease];
        for (ProductSpecificationValue *item in tagList.selectedArray) {
            [tags appendFormat:@"%d,",item.id];
            [tagName appendFormat:@"%@,",item.name];
        }
        NSDictionary *dic = @{@"name":self.txtProdName.text,
                              @"code":self.txtBarCode.text,
                              @"start":self.txtPriceStart.text,
                              @"end":self.txtPriceEnd.text,
                              @"tags":tags.length > 0 ? [tags substringToIndex:tags.length - 1] : @"",
                              @"tagName":tagName.length > 0 ? [tagName substringToIndex:tagName.length - 1] : @""
                              };
        self.search(dic);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_txtProdName release];
    [_txtBarCode release];
    [_txtPriceStart release];
    [_txtPriceEnd release];
    [_scrollView release];
    [_btnReset release];
    [_btnSearch release];
    [tagList release];
    [super dealloc];
}
@end
