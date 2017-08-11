//
//  TaskViewController.m
//  SalesManager
//
//  Created by ZhangLi on 14-1-14.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "TaskViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "SelectCell.h"
#import "NSDate+Util.h"
#import "NewTaskCell.h"
#import "SWTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation TaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [leftImageView setImage:[UIImage imageNamed:@"topbar_button_goback"]];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 15, 50, 30)];
    [saveImageView setImage:[UIImage imageNamed:@"topbar_button_save"]];
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = btRight;
    [btRight release];
	
    tableView = [[UTTableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    [lblFunctionName setText:NSLocalizedString(@"bar_task_post", @"")];
    
    fromTime = [[NSString alloc] initWithString:[NSDate getCurrentTime]];
    toTime = [[NSString alloc] initWithString:[NSDate getTomorrowTime]];
    
    SOCKET.delegate = self;
    
    taskArray = [[NSMutableArray alloc] init];
}

-(void)toSave{
    [self dismissKeyBoard];
    if (taskArray.count == 0) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_task_post", @"")
                          description:NSLocalizedString(@"task_hint_content", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
    if (![NSDate compareDate:fromTime otherDate:toTime]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_task_post", @"")
                          description:NSLocalizedString(@"task_hint_date", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
}

-(IBAction)dismissKeyBoard
{
    if (newTaskCell.content != nil) {
        [newTaskCell.content resignFirstResponder];
    }
    
    if (memoTextViewCell.textView != nil) {
        [memoTextViewCell.textView resignFirstResponder];
    }
}

-(void)clickLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                return 44.0f;
            }else{
                NSString *text = [taskArray objectAtIndex:[indexPath row] - 1];
                
                CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
                
                NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:FONT_SIZE] forKey:NSFontAttributeName];
                NSAttributedString *attributedText =
                [[NSAttributedString alloc]
                 initWithString:text
                 attributes:attributes];
                CGRect rect = [attributedText boundingRectWithSize:constraint
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
                CGSize size = rect.size;
                
                
                CGFloat height = MAX(size.height, 44.0f);
                NSLog(@"height + (CELL_CONTENT_MARGIN * 2) = %f",height + (CELL_CONTENT_MARGIN * 2));
                if (indexPath.row == taskArray.count) {
                    return height+5;
                }
                return height+2;
            }
        }
            break;
        case 1:{
            return 44;
        }
            break;
        case 2:{
            return 80;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:{
            return NSLocalizedString(@"task_label_content", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"task_label_info", nil);
        }
            break;
        case 2:{
            return NSLocalizedString(@"task_label_memo", nil);
        }
            break;
            
        default:
            break;
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return taskArray.count + 1;
    }
    if (section == 1) {
        return 3;
    }else{
        return 1;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    currentIndexPath = [indexPath retain];
    [self datePickerDidCancel];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1:
            case 2:{
                [self datePickerDidCancel];
                datePicker = [[DatePicker alloc] init];
                datePicker.tag = indexPath.row;
                [self.view addSubview:datePicker];
                [datePicker setDelegate:self];
                [datePicker setCenter:CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height-datePicker.frame.size.height*.5)];
                
                CGRect tableFrame = tableView.frame;
                distance = IS_IPHONE5?0:30;//(tableFrame.origin.y+tableFrame.size.height)-datePicker.frame.origin.y;
                tableFrame.origin.y -= distance;
                [tableView setFrame:tableFrame];
                
                [datePicker release];
            }
                break;

        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                newTaskCell =(NewTaskCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(newTaskCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"NewTaskCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[NewTaskCell class]])
                            newTaskCell=(NewTaskCell *)oneObject;
                    }
                    
                }
            
                UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
                
                [topView setBarStyle:UIBarStyleBlack];
                UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
                UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                
                NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
                [doneButton release];
                [btnSpace release];
                [helloButton release];
                
                [topView setItems:buttonsArray];
                [newTaskCell.content setInputAccessoryView:topView];
                newTaskCell.selectionStyle=UITableViewCellSelectionStyleNone;
                [topView release];
                
                newTaskCell.taskNum.text = [NSString stringWithFormat:@"%d.",taskArray.count + 1];
                [newTaskCell.btnAdd addTarget:self action:@selector(toAdd:) forControlEvents:UIControlEventTouchUpInside];
                return newTaskCell;
            }else{
                SWTableViewCell *cell;
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
                
                NSString *text = [taskArray objectAtIndex:[indexPath row] - 1];
                
                CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
                
                NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{
                                                                           NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]
                                                      }];
                CGRect rect = [attributedText boundingRectWithSize:constraint
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
                CGSize size = rect.size;
                NSLog(@"rect.size.height = %f",rect.size.height);
                
                if (cell == nil)
                {
                    //cell = [[[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
                    
                    
                    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
                    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
                    
                    [leftUtilityButtons addUtilityButtonWithColor:
                     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                             icon:[UIImage imageNamed:@"ic_checkmark_grey"]];
                    
                    [rightUtilityButtons addUtilityButtonWithColor:
                     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                             icon:[UIImage imageNamed:@"ic_delete_grey_group"]];
                    
                    cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"Cell"
                                              containingTableView:tableView // Used for row height and selection
                                                        rowHeight:MAX(size.height, 44.0f)
                                               leftUtilityButtons:leftUtilityButtons
                                              rightUtilityButtons:rightUtilityButtons];
                    cell.delegate = self;
                    cell.cellType = kCellTypeGroup;
                    
                    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
                    [cell.textLabel setMinimumScaleFactor:FONT_SIZE];
                    [cell.textLabel setNumberOfLines:0];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
                    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", indexPath.row,text];
                [cell.textLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
                
                return cell;
            }

        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(selectCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[SelectCell class]])
                            selectCell=(SelectCell *)oneObject;
                    }
                    selectCell.title.text = NSLocalizedString(@"task_label_status", nil);
                    selectCell.value.text = NSLocalizedString(@"task_status_starting", nil);
                    selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    selectCell.imageGo.hidden = YES;
                }
                return selectCell;
            }
            if (indexPath.row == 1) {
                SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(selectCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[SelectCell class]])
                            selectCell=(SelectCell *)oneObject;
                    }
                    selectCell.title.text = NSLocalizedString(@"task_label_starttime", nil);
                    selectCell.value.text = fromTime;
                    selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
                return selectCell;
            }
            
            if (indexPath.row == 2) {
                SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(selectCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[SelectCell class]])
                            selectCell=(SelectCell *)oneObject;
                    }
                    selectCell.title.text = NSLocalizedString(@"task_label_endtime", nil);
                    selectCell.value.text = toTime;
                    selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
                return selectCell;
            }
        }
            break;
        case 2:{
            if (memoTextViewCell == nil) {
                memoTextViewCell = [[TextViewCell alloc] init];
                memoTextViewCell.textView.frame = CGRectMake(15, 5, 290, 70);
                memoTextViewCell.textView.layer.cornerRadius = 6;
                memoTextViewCell.textView.layer.masksToBounds = YES;
                UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
                [topView setBarStyle:UIBarStyleBlack];
                UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
                UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                
                NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
                [doneButton release];
                [btnSpace release];
                [helloButton release];
                
                [topView setItems:buttonsArray];
                [memoTextViewCell.textView setInputAccessoryView:topView];
                memoTextViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
                [topView release];
            }
            
            return memoTextViewCell;
            
        }
            break;

        default:
            break;
    }
    
    return cell;
    
}

-(void)datePickerDidDone:(DatePicker*)picker{
    if(currentIndexPath.row == 1)
        fromTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    else if (currentIndexPath.row == 2)
        toTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    
    [self datePickerDidCancel];
    [tableView reloadData];
}

-(NSString *)intToDoubleString:(int)d{
    if (d<10) {
        return [NSString stringWithFormat:@"0%d",d];
    }
    return [NSString stringWithFormat:@"%d",d];
    
}

-(void)datePickerDidCancel{
    
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[DatePicker class]]){
            
            [view removeFromSuperview];
        }
    }
    
    CGRect tableFrame = tableView.frame;
    tableFrame.origin.y += distance;
    distance = 0;
    [tableView setFrame:tableFrame];
    // [datePicker removeFromSuperview];
}

- (void) toAdd:(id)sender{
    UIView *view = (UIView*)sender;
    NewTaskCell* cell = (NewTaskCell*)[[view superview] superview];
    if (![cell.content.text isEqualToString:@""]) {
        [taskArray addObject:cell.content.text];
        
        [tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SW Table View Cell Delegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
    
}
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    [taskArray removeObjectAtIndex:indexPath.row - 1];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}
@end
