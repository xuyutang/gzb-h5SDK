//
//  UTTableViewController.m
//  KK UI
//
//  Created by KK UI on 12-12-5.
//
//

#import "UTTableViewController.h"
#import "UTTableView.h"

@interface UTTableViewController ()

@end

@implementation UTTableViewController
@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self buildUserInterface];
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_tableView);
    TT_RELEASE_SAFELY(_dataSource);
    [super dealloc];
}

- (void)buildUserInterface {
    UTTableView *newTableView = [[UTTableView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 416.f)
                                                             style:UITableViewStyleGrouped];
    newTableView.delegate = self;
    self.tableView = newTableView;
    [newTableView release];
    
    UIImageView *v = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, 568.f)];
    [v setImage:[UIImage imageNamed:@"tableView_Background.png"]];
    [v setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:v];
    [v release];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
}

- (void)setDataSource:(TTTableViewDataSource *)newDataSource {
    _dataSource = [newDataSource retain];
//    NSLog(@"%d",[_dataSource retainCount]);
    
    self.tableView.dataSource = newDataSource;
    [self.tableView reloadData];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<TTTableViewDataSource> dataSource = (id<TTTableViewDataSource>)self.tableView.dataSource;
    
    id object = [dataSource tableView:self.tableView objectForRowAtIndexPath:indexPath];
    Class cls = [dataSource tableView:self.tableView cellClassForObject:object];
    return [cls tableView:self.tableView rowHeightForObject:object];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


@end
