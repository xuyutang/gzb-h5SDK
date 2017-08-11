//
//  BoxViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/8/24.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BoxViewController.h"

#import "TestCell.h"
@interface BoxViewController ()<UITableViewDelegate,UITableViewDataSource,TestCellDelegate> {
    UIButton *button;
    UITableView *tableView;
    UIView *rightView;

}

@end


@implementation BoxViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     [lblFunctionName setText:@"请选择-多选"];
    self.selectorPatnArray = [[NSMutableArray alloc]init];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.contentMode = UIViewContentModeScaleAspectFit;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    [tapGesture1 release];

    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];

  
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: tableView];
   
    //移除之前选中的内容
    if (self.selectorPatnArray.count > 0) {
        [self.selectorPatnArray removeAllObjects];
    }
    
}

-(void)toSave {
    if (self.myBlock != nil) {
        self.myBlock(self.selectorPatnArray);
    }

    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"选中个数是 : %lu   内容为 : %@",(unsigned long)self.selectorPatnArray.count,self.selectorPatnArray);
}

-(void)getUserTrtByBlock:(BoxBlock)block {
    self.myBlock = block;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.boxMulArray.count;
    
}

#pragma mark cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
    if (!cell) {
        cell = [[TestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestCell"];
    }
    
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [self.boxMulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              [array addObject:[obj objectForKey:@"content"]];
        }];
    
    cell.testLb.text = array[indexPath.row];
    cell.testBtn.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;

}


#pragma mark -TestCell Delegate
-(void)SelectedCell:(UIButton *)sender{
    if (sender.selected) {
        [self.selectorPatnArray  addObject:self.boxMulArray[sender.tag]];//选中添加
    }else{
        [self.selectorPatnArray removeObject:self.boxMulArray[sender.tag]];//再选取消
    }
    for (int i=0; i<self.selectorPatnArray.count; i++) {
        NSLog(@"%@",self.selectorPatnArray[i]);//便于观察选中后的数据
    }
    NSLog(@"==============");
}


-(void)clickLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
