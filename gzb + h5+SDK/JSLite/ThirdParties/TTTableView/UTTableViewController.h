//
//  UTTableViewController.h
//  KK UI
//
//  Created by KK UI on 12-12-5.
//
//

#import <UIKit/UIKit.h>
#import "TTTableViewDataSource.h"
#import "TTTableViewCell.h"
#import "TTCorePreprocessorMacros.h"
@class UTTableView;

@interface UTTableViewController : UIViewController<UITableViewDelegate> {
    UTTableView             *_tableView;
    TTTableViewDataSource   *_dataSource;
}

@property (nonatomic, retain) UITableView               *tableView;
@property (nonatomic, retain) TTTableViewDataSource     *dataSource;


/*!
 @method
 @abstract Build user interface
 */
- (void)buildUserInterface;

/*!
 @method
 @abstract Set data source to table view
 */
- (void)setDataSource:(TTTableViewDataSource *)newDataSource;


@end
