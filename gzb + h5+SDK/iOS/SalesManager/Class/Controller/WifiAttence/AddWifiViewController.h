//
//  AddWifiViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/11/30.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "LocationCell.h"
#import "TextFieldCell.h"

@interface AddWifiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,RequestAgentDelegate> {
    UITableView *addWifiTabView;
    NSString *locationString;
    UITableViewCell *cell;
    LocationCell *locationCell;
    UIView *rightView;
    TextFieldCell *txtCell;
    NSString *remarks;
}

@end
