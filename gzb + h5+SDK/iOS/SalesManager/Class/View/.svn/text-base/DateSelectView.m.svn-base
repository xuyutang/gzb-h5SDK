//
//  DateSelectView.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-6.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "DateSelectView.h"
#import "Constant.h"
#import "SelectCell.h"
#import "NSDate+Util.h"
@implementation DateSelectView

- (void)initView
{

    fromDate = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
    toDate = [[NSString alloc] initWithString:[NSDate getCurrentTime]];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 90) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.backgroundView = nil;
    [self addSubview:_tableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor redColor]];
    [button setFrame:CGRectMake(30, CGRectGetMaxY(_tableView.frame)+10, MAINWIDTH-60, 35)];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    switch (indexPath.row) {
        case 0:{
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                selectCell.title.text = NSLocalizedString(@"search_label_start_date", nil);
                selectCell.value.text = fromDate;
            }
        }
            break;
        case 1:{
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                selectCell.title.text = NSLocalizedString(@"search_label_end_date", nil);
                selectCell.value.text = toDate;
            }
        }
            break;
            
        default:
            break;
    }

    return selectCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    currentIndexPath = [indexPath retain];
    switch (indexPath.row) {
        case 0:
        case 1:{
            [self datePickerDidCancel];
            datePicker = [[DatePicker alloc] init];
            datePicker.tag = indexPath.row;
            [datePicker setBackgroundColor:[UIColor whiteColor]];
            //[datePicker setFrame:CGRectMake(0, 0, MAINWIDTH,CGRectGetHeight(self.frame))];
            [_parentView addSubview:datePicker];
            [datePicker setDelegate:self];
            [datePicker setCenter:CGPointMake(_parentView.frame.size.width*.5, _parentView.frame.size.height-datePicker.frame.size.height*.5)];
            /*
            CGRect tableFrame = tableView.frame;
            distance = IS_IPHONE5?0:80;//(tableFrame.origin.y+tableFrame.size.height)-datePicker.frame.origin.y;
            tableFrame.origin.y -= distance;
            [tableView setFrame:tableFrame];*/
            [datePicker release];
            
        }
            break;
            
    }
}

-(NSString *)intToDoubleString:(int)d{
    
    if (d<10) {
        return [NSString stringWithFormat:@"0%d",d];
    }
    return [NSString stringWithFormat:@"%d",d];
    
}
-(void)datePickerDidDone:(DatePicker*)picker{
    
    if(currentIndexPath.row == 0)
        fromDate = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    else if (currentIndexPath.row == 1)
        toDate = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    
    [self datePickerDidCancel];
    [_tableView reloadData];
}
-(void)datePickerDidCancel{
    
    for(UIView *view in _parentView.subviews){
        if([view isKindOfClass:[DatePicker class]]){
            
            [view removeFromSuperview];
        }
    }
    /*
    CGRect tableFrame = _tableView.frame;
    tableFrame.origin.y += distance;
    distance = 0;
    [_tableView setFrame:tableFrame];*/
    // [datePicker removeFromSuperview];
}

-(void)toConfirm{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(selectedDateFrom:to:)]) {
        [_delegate selectedDateFrom:fromDate to:toDate];
    }

}

@end
