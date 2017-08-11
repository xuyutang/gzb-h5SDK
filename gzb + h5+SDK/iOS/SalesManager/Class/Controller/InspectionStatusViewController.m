
//
//  InspectionStatusViewController.m
//  SalesManager
//
//  Created by Administrator on 16/4/6.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "InspectionStatusViewController.h"
#import "Constant.h"

@interface InspectionStatusViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation InspectionStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblFunctionName setText:NSLocalizedString(@"inspection_status_select_bar", nil)];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 25, 25)];
    //[saveImageView setImage:[UIImage imageNamed:@"topbar_button_save"]];
//    [saveImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_SAVE]];
//    [saveImageView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
//    [saveImageView setTextColor:WT_RED];
//    [saveImageView setTextAlignment:UITextAlignmentCenter];
    saveImageView.userInteractionEnabled = YES;
    saveImageView.image = [UIImage imageNamed:@"ab_icon_save"];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    [rightView release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _status.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InspectionStatus *model = _status[indexPath.row];
    CGSize size = [model.name rebuildSizeWtihContentWidth:300.f FontSize:17];
    return MAX(44.f, size.height + 10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    InspectionStatus *model = _status[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    NSLog(@"%lf",cell.textLabel.frame.size.width);
    CGSize size = [model.name rebuildSizeWtihContentWidth:300.f FontSize:17];
    [cell.textLabel setText:model.name];
    CGRect r = cell.textLabel.frame;
    r.size.height = size.height;
    cell.textLabel.frame = r;
    if ([self isDefaultSelected:model]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellSelectionStyleNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_currentStatusList addObject:_status[indexPath.row]];
    }else{
        cell.accessoryType = UITableViewCellSelectionStyleNone;
        [_currentStatusList removeObject:_status[indexPath.row]];
    }
}


-(BOOL) isDefaultSelected:(InspectionStatus*) status{
    for (InspectionStatus *item in _currentStatusList) {
        if (item.id == status.id) {
            return YES;
        }
    }
    return  NO;
}


-(void) toSave:(id) sender{
    if (_currentStatusList.count == 0) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                          description:NSLocalizedString(@"inspection_status_select_bar", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (self.checkDone) {
        self.checkDone(_currentStatusList);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickLeftButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
