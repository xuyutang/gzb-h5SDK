//
//  RadioViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/8/24.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "RadioViewController.h"

@interface RadioViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableView;
    NSArray *array;
}

@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [lblFunctionName setText:@"请选择-单选"];
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: tableView];
    
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _radioMulArray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   UITableViewCell*cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [self.radioMulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:[obj objectForKey:@"content"]];
    }];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
        cell.textLabel.text = arr[indexPath.row];
        
    }
    
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    array = _radioMulArray[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getUserTrtByBlock:(tryBlock)block {
    self.Myblock = block ;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.Myblock != nil) {
        self.Myblock(array);
    }
}

-(void)clickLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

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

@end
