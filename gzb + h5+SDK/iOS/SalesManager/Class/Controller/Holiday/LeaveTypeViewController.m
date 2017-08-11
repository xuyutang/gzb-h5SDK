//
//  LeaveTypeViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/10/11.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "LeaveTypeViewController.h"

@interface LeaveTypeViewController () {
    UITableView *tableView;
    HolidayCategory *holidayCate;
    NSMutableArray *arr;
}

@end

@implementation LeaveTypeViewController

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [lblFunctionName setText:@"假休类型选择"];
    [leftImageView setImage:[UIImage imageNamed:@"topbar_button_goback"]];

    _radioMulArray = [[NSMutableArray alloc]init];
    _radioMulArray = [[LOCALMANAGER getHolidayCategories] retain];
    
    HolidayCategory_Builder *tmpCategory = [HolidayCategory builder];
    [tmpCategory setId:0];
    [tmpCategory setName:@"全部"];
    [_radioMulArray insertObject:tmpCategory atIndex:0];
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT - 44   )];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: tableView];
  
}

#pragma mark - tableViewdelegate
#pragma mark numberOfRowsInSection
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _radioMulArray.count ;
    
}

#pragma mark numberOfRowsInSection
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    arr = [[NSMutableArray alloc]init];
    [self.radioMulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:((HolidayCategory*)obj).name];
    }];


        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
        cell.textLabel.text = arr[indexPath.row];
        

    
    return cell;
    
}

#pragma mark heightForRowAtIndexPath
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
    
}
#pragma mark didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    holidayCate = _radioMulArray[indexPath.row];
    if (self.Myblock != nil) {
        self.Myblock(holidayCate);
    }

    [self.view removeFromSuperview];
}

#pragma mark getUserTrtByBlock
-(void)getUserTrtByBlock:(tryBlock)block {
    self.Myblock = block ;
}

#pragma mark 返回
-(void)clickLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark  didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
