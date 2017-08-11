//
//  IMGCommentDetailView.m
//  SalesManager
//
//  Created by liuxueyan on 15-3-17.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "IMGCommentDetailView.h"
#import "BigImageViewController.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+Helpers.h"

@implementation IMGCommentDetailView
@synthesize content,imageFiles,parentCtrl,parentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 240) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        //tableView.allowsSelection = NO;
        [tableView setBackgroundColor:[UIColor clearColor]];
        tableView.backgroundView = nil;
        [self addSubview:tableView];
    }

    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            return 88;
        }
            break;
        case 1:{
            return 120;
        }
            break;
        default:
            break;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            
        }
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    
    switch (indexPath.row) {
        case 0:{
            liveImageCell = [[LiveImageCell alloc] initWithImages:imageFiles];
            liveImageCell.delegate = self;
            if(liveImageCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LiveImageCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[LiveImageCell class]])
                        liveImageCell=(LiveImageCell *)oneObject;
                }
            }
            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return liveImageCell;
        }
            break;
        case 1:{
            if (textViewCell == nil) {
                textViewCell = [[TextViewCell alloc] init];
                textViewCell.textView.text = content;
                [textViewCell.textView setEditable:NO];
                textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            return textViewCell;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

-(void)openPhoto:(int)index{
    if(parentView != nil)
        [parentView dismiss];
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [imageFiles objectAtIndex:index];
    ctrl.functionName = [NSString stringWithFormat:@"%@",content];
    [self.parentCtrl.navigationController setNavigationBarHidden:YES];
    [self.parentCtrl.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)dealloc {
    
    [imageFiles release];
    [tableView release];
    [liveImageCell release];
    [textViewCell release];
    [super dealloc];
}


@end
