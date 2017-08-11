//
//  PersonViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 2017/5/8.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "PersonViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "LocalManager.h"
#import "MBProgressHUD.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"
#import "UIView+Util.h"
#import "NameFilterViewController.h"

@interface PersonViewController ()<MBProgressHUDDelegate,RequestAgentDelegate,HeaderSearchBarDelegate,DepartmentViewControllerDelegate,PullTableViewDelegate,NameFilterViewControllerDelegate,UITextFieldDelegate>

@property(nonatomic, strong) NSString *cusName;
@property(nonatomic, strong) NSString *cusPhone;
@end

@implementation PersonViewController{
    NSArray        *header;
    NSMutableArray *indexArray;
    NSMutableDictionary *dataDic;
    HeaderSearchBar *_searchBar;
    NSMutableArray*         _searchViews;
    NSMutableArray*         _departments;
    NSMutableArray*         _checkDepartments;
    DepartmentViewController* departmentVC ;
    UITextField* _customerNameTextFiled;
    UITextField* customerPhoneTextFiled;
    UIView *maskView;
    NSMutableArray *userMuArray;
    BOOL savebool;
    
    
}

@synthesize selectTels,parentCtrl,selectNames;


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
    userMuArray = [[NSMutableArray alloc] init];
    indexArray = [[NSMutableArray alloc] initWithArray:@[@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"
                                                         ,@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T"
                                                         ,@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    lblFunctionName.text = @"人员列表";
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    saveImageView.userInteractionEnabled = YES;
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    self.rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    //搜索条载入
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0,0, MAINWIDTH, 45)];
    NSArray* titles = [NSArray arrayWithObjects:@"部门",@"筛选", nil];
    NSArray*  icons = [NSArray arrayWithObjects:@"",@"",nil];
    _searchBar.titles = [titles copy];
    _searchBar.icontitles = [icons copy];
    _searchBar.delegate = self;
    _searchBar.layer.borderWidth = 0.5;
    _searchBar.layer.borderColor = [UIColor grayColor].CGColor;
    _searchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchBar];
    
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320,(parentCtrl == nil)? MAINHEIGHT - 44:MAINHEIGHT - 84) ];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    _tableView.bounces = NO;
    _tableView.allowsSelection = YES;
    //[tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    
    //计算frame
    CGRect tmpFrame = self.tableView.frame;
    
    //初始化数据
    _searchViews = [[NSMutableArray alloc] initWithCapacity:1];
    _departments = [[LOCALMANAGER getDepartments] retain];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    //部门视图
    departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.departmentArray = _departments;
    departmentVC.delegate = self;
    departmentVC.view.frame = tmpFrame;
    [self addChildViewController:departmentVC];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    [departmentVC release];
    //筛选视图
    [self configureFilterView];
    
    
    [self initData];
    
    
}

- (void)configureFilterView {
    //筛选视图
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT-45)];
    maskView.backgroundColor = [UIColor colorWithRed:63/255.0 green:65/255.0 blue:73/255.0 alpha:0.6];
    [_searchViews addObject:maskView];
     lblFunctionName.text = @"人员列表";
    
    UIView *filterView = [[UIView alloc]init];
    filterView.backgroundColor = [UIColor whiteColor];
    filterView.frame = CGRectMake(0, 0, MAINWIDTH, 180);
    [maskView addSubview:filterView];
    
    UILabel *tintNameLabel = [[UILabel alloc]init];
    tintNameLabel.frame = CGRectMake(20, 20, 70, 30);
    tintNameLabel.text = @"姓名:";
    tintNameLabel.font = [UIFont systemFontOfSize:14];
    [filterView addSubview:tintNameLabel];
    
    _customerNameTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, 12, MAINWIDTH-20-70-20-20, 30)];
    _customerNameTextFiled.font = [UIFont systemFontOfSize:14];
    
    _customerNameTextFiled.delegate = self;
    
    [filterView addSubview:_customerNameTextFiled];
    [filterView addSubview:[self setView]];
    
    UILabel *phoneNameLabel = [[UILabel alloc]init];
    phoneNameLabel.frame = CGRectMake(20, 70, 70, 30);
    phoneNameLabel.text = @"电话:";
    phoneNameLabel.font = [UIFont systemFontOfSize:14];
    [filterView addSubview:phoneNameLabel];
    
    customerPhoneTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, 70, MAINWIDTH-20-70-20-20, 30)];
    customerPhoneTextFiled.font = [UIFont systemFontOfSize:14];
    
    customerPhoneTextFiled.delegate = self;
    
    [filterView addSubview:customerPhoneTextFiled];
    [filterView addSubview:[self setPhoneView]];
    
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.frame = CGRectMake(20, 130, 60, 30);
    resetButton.backgroundColor = [UIColor redColor];
    resetButton.tag = 2000;
    resetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [resetButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [filterView addSubview:resetButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(MAINWIDTH-20-60, 130, 60, 30);
    searchButton.backgroundColor = [UIColor redColor];
    searchButton.tag = 2001;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setTitle:@"查询" forState:UIControlStateNormal];
    [filterView addSubview:searchButton];
}

-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, MAINWIDTH - 100, 20)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(90, 10, 0.5, 3)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(90, 13, MAINWIDTH - 20 - 90, 0.5)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 20 - 0.5, 10, 0.5, 3)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
}
-(UIView*)setPhoneView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 78, MAINWIDTH - 100, 20)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(90, 10, 0.5, 3)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(90, 13, MAINWIDTH - 20 - 90, 0.5)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 20 - 0.5, 10, 0.5, 3)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    /**
     *  @author xuyutang, 16-08-16 12:08:03
     *
     *   针对机型4，4s无法进行筛选，键盘不能弹出问题的解决
     */
    if (SCREENHEIGHT == 480) {
        if ([textField isEqual:_customerNameTextFiled]) {
            [maskView setFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT-45)];
        }else {
            [maskView setFrame:CGRectMake(0, -70, MAINWIDTH, MAINHEIGHT-45)];
        }
        
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (SCREENHEIGHT == 480) {
        [maskView setFrame:CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT-45)];
    }
    
    
}
- (void)operationButtonClick:(UIButton *)sender {
    if (sender.tag == 2000) {
        self.cusName = nil;
        _customerNameTextFiled.text = @"";
        customerPhoneTextFiled.text = @"";
    } else {
        self.cusName = _customerNameTextFiled.text;
        self.cusPhone = customerPhoneTextFiled.text;
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        [_searchBar setColor:1];
        [self choseRefreshParams];
    }
}


-(NSInteger) getStrInArrayIndex:(NSString*)str{
    for (int i = 0; i < header.count; i++) {
        if ([header[i] isEqualToString:str]) {
            return i;
        }
    }
    return -1;
}

-(void)getPersonsWithBlock:(chosePerson)block {
    self.choseBlock = block;
}

- (void)toSave:(id)sender {
    savebool = YES;
    if (self.radioBool == YES) {
        if (userMuArray.count > 1) {
            [MESSAGE showMessageWithTitle:self.messageTitle
                        description:NSLocalizedString(@"chose_one_person_only", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:ERR_MSG_DURATION];
            return;
        }
        
        if (!userMuArray.count) {
            [MESSAGE showMessageWithTitle:self.messageTitle
                              description:@"请选择人员"
                                     type:MessageBarMessageTypeInfo
                              forDuration:ERR_MSG_DURATION];
            return;
        }

        
    }else {
        if (!userMuArray.count) {
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_MESSAGE_DES)
                              description:@"请选择人员"
                                     type:MessageBarMessageTypeInfo
                              forDuration:ERR_MSG_DURATION];
            return;
        }

    
    
    }
   self.choseBlock(userMuArray);
   [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    if (!userMuArray.count || !savebool) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_ui" object:nil];
    }

}
#pragma -mark DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"选择了 %lu 个部门",(unsigned long)departments.count);
    _checkDepartments = [departments retain];
    
    //设置状态
    [_searchBar setColor:0];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    NSMutableString* sb = [[NSMutableString alloc] init];
    int i = 0;
    for (Department* item in departments) {
        if (i > 5) {
            break;
        }
        [sb appendFormat:@"%@,",item.name];
        i++;
    }
    UIButton* btn = _searchBar.buttons[0];
    [btn setTitle:departments.count > 0 ?[sb substringToIndex:sb.length - 1] : _searchBar.titles[0] forState:UIControlStateNormal];
    
    [self refreshParamsAndTable];
}


#pragma -mark 更新参数
-(void) refreshParamsAndTable{
    [self refreshParams];
}

#pragma -mark 部门查询
-(void)refreshParams{
    [filterContacts removeAllObjects];
    filterContacts = [[NSMutableArray alloc] init];
    
    if (_checkDepartments.count == 0 || _checkDepartments.count == _departments.count) {
        [self _refresh];
        return;
    }
    
    for (int i = 0; i<[contacts count]; i++) {
        User* user = [contacts objectAtIndex:i];
        
        for (NSString *obj in _checkDepartments) {
            NSLog(@"%@gggggg",_checkDepartments);
            
            NSLog(@"%@hhhhhhhh",[obj valueForKey:@"name"]);
            if ([user.department.name isEqualToString:[obj valueForKey:@"name"]]){
                [filterContacts addObject:user];
            }
            dataDic = [[self getGroupData:filterContacts] retain];
            header = [[self getGroupHeaderSort:dataDic.allKeys] retain];
            
        }
        
        [_tableView reloadData];
        
    }
    
    
}

-(void)choseRefreshParams {
    
    [filterContacts removeAllObjects];
    filterContacts = [[NSMutableArray alloc] init];
    for (int i = 0; i<[contacts count]; i++) {
        if (!_cusPhone.length  && !_cusName.length) {
            [self _refresh];
            return;
        }
        
        User* user = [contacts objectAtIndex:i];
        NSRange rangeName ;
        NSRange rangeTel;
        if (IOS7) {
            rangeName = [user.realName rangeOfString:_cusName];
            rangeTel = [user.userName rangeOfString:_cusPhone];
            
        }else {
            if (_cusName.length) {
                rangeName = [user.realName rangeOfString:_cusName];
            }
            
            if (_cusPhone.length) {
                rangeTel = [user.userName rangeOfString:_cusPhone];
            }
        }
        
        if (!_cusName.length && _cusPhone.length) {
            if (rangeTel.location != NSNotFound) {
                [filterContacts addObject:user];
            }
        }else if (_cusName.length && !_cusPhone.length) {
            if (rangeName.location != NSNotFound) {
                [filterContacts addObject:user];
            }
            
        }else {
            if (rangeName.location != NSNotFound && rangeTel.location != NSNotFound ){
                [filterContacts addObject:user];
            }
            
        }
        
    }
    dataDic = [[self getGroupData:filterContacts] retain];
    header = [[self getGroupHeaderSort:dataDic.allKeys] retain];
    [_tableView reloadData];
}

#pragma -mark HeaderSearchBar delegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    NSLog(@"搜索条选择了:%d",index);
    NSLog(@"%@",_searchViews);
    if (current == index) {
        [UIView removeViewFormSubViews:-1 views:_searchViews ];
    }else{
        [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
        [UIView removeViewFormSubViews:index views:_searchViews];
    }
    
}


-(NSArray *)getGroupHeaderSort:(NSArray*) strs{
    NSArray *list = [strs sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return list;
}

-(NSMutableDictionary*) getGroupData:(NSMutableArray *) users{
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    for (int i = 0 ; i < indexArray.count; i++) {
        [dic setObject:[[[NSMutableArray alloc] init] autorelease] forKey:indexArray[i]];
    }
    
    for (User *u in users) {
        NSString* firstLetter = [[u.spell substringToIndex:1] uppercaseString];
        if ([dic.allKeys containsObject:firstLetter]) {
            [((NSMutableArray *)[dic objectForKey:firstLetter]) addObject:u];
        }
        if (![dic.allKeys containsObject:firstLetter]) {
            [((NSMutableArray *)[dic objectForKey:indexArray[0]]) addObject:u];
        }
    }
    for (NSString *key in indexArray) {
        if (((NSMutableArray*)[dic objectForKey:key]).count == 0) {
            [dic removeObjectForKey:key];
        }
    }
    return dic;
}

-(void) _refresh{
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeCompanyContactList param:@""]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
}

-(void) reload{
    [self _refresh];
}

-(void)initData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    [self _loadData];
    HUDHIDE2;
}

- (void) _loadData{
    [selectTels removeAllObjects];
    selectTels = [[NSMutableArray alloc] init];
     selectNames = [[NSMutableArray alloc] init];
    [filterContacts removeAllObjects];
    [contacts removeAllObjects];
    
    contacts = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getAllUsers]];
    
    filterContacts = [[NSMutableArray alloc] initWithArray:contacts];
    
    
    dataDic = [[self getGroupData:filterContacts] retain];
    header = [[self getGroupHeaderSort:dataDic.allKeys] retain];
    [_tableView reloadData];
}

-(BOOL)isSelected:(NSString *)phone{
    
    for(NSString *tel in selectNames){
        
        if ([tel isEqualToString:phone]) {
            return YES;
        }
        
    }
    return NO;
}

-(void)toSms:(id)sender{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        //self.navigationController.navigationBarHidden = YES;
        controller.body = @"";
        controller.recipients = selectTels;
        controller.messageComposeDelegate = self;
        if (parentCtrl != nil) {
            [self.parentCtrl.navigationController presentModalViewController:controller animated:YES];
        }else{
            //[(APPDELEGATE).contactsNavCtrl presentModalViewController:controller animated:YES];
            [self presentModalViewController:controller animated:YES];
        }
    }
}

#pragma mark - UITableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return header.count;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return indexArray;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return header[section];
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger _index = [self getStrInArrayIndex:indexArray[index]];
    return _index;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ((NSMutableArray*)[dataDic objectForKey:header[section]]).count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CompanyContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CompanyContactCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[CompanyContactCell class]])
                cell=(CompanyContactCell *)oneObject;
        }
    }
    
    //User *user = (User *)[filterContacts objectAtIndex:indexPath.row];
    NSString *key = header[indexPath.section];
    User *user = (User*) [dataDic objectForKey:key][indexPath.row];
    
    
    cell.name.text = user.realName;
    cell.tel.text = user.userName;
    cell.position.text = user.position.name;
    cell.department.text = user.department.name;
    cell.delegate = self;
    
    if ([self isSelected:user.realName]) {
        cell.isChecked = YES;
    }else{
        cell.isChecked =NO;
    }
    [cell checkCell];
    //cel            l.section = indexPath.section;
    //cell.row = indexPath.row;
    //cell.tag = indexPath.row;
    [cell setCell];
    
    return cell;
}


#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self searchDismissKeyBoard];
    NSString *key = header[indexPath.section];
    User *user = (User*) [dataDic objectForKey:key][indexPath.row];
  
    
    CompanyContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isChecked = ! cell.isChecked;
    
    [cell checkCell];
    if (cell.isChecked) {
        if (cell.tel.text != nil) {
            [selectNames addObject:cell.name.text];
        }
          [userMuArray addObject:user];
    }else{
        [userMuArray removeObject:user];
        [selectNames removeObject:cell.name.text];
    }
    [tableView reloadData];
}

-(void)clickSmsButton:(NSString *)tel{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        
        //self.navigationController.navigationBarHidden = YES;
        
        controller.body = @"";
        controller.recipients = [NSArray arrayWithObjects:tel, nil];
        controller.messageComposeDelegate = self;
        if (parentCtrl != nil) {
            [self.parentCtrl.navigationController presentModalViewController:controller animated:YES];
        }else{
            //[(APPDELEGATE).contactsNavCtrl presentModalViewController:controller animated:YES];
            
            [self presentModalViewController:controller animated:YES];
        }
        
    }
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:YES];
    //self.navigationController.navigationBarHidden = NO;
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
            
        case MessageComposeResultSent:
        {
            //do something
        }
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    
    if ([searchText isEqualToString:@""]) {
        [filterContacts removeAllObjects];
        filterContacts = [[NSMutableArray alloc] initWithArray:contacts];
        [_tableView reloadData];
        return;
    }
    
    [filterContacts removeAllObjects];
    filterContacts = [[NSMutableArray alloc] init];
    for (int i = 0; i<[contacts count]; i++) {
        User* user = [contacts objectAtIndex:i];
        NSRange rangeName = [user.realName rangeOfString:searchText];
        NSRange rangeTel = [user.userName rangeOfString:searchText];
        NSRange rangeDepart = [user.department.name rangeOfString:searchText];
        NSRange rangePy = [user.spell rangeOfString:searchText];
        if (rangePy.location != NSNotFound || rangeName.location != NSNotFound || rangeTel.location != NSNotFound || rangeDepart.location != NSNotFound){
            [filterContacts addObject:user];
        }
    }
    dataDic = [[self getGroupData:filterContacts] retain];
    header = [[self getGroupHeaderSort:dataDic.allKeys] retain];
    [_tableView reloadData];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

-(IBAction)searchDismissKeyBoard
{
    [searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE2;
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeCompanyContactList:{
            
            if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]) {
                BOOL ret = FALSE;
                for (int i = 0 ; i < cr.datas.count; ++i) {
                    User* user = [User parseFromData:[cr.datas objectAtIndex:i]];
                    
                    if ([super validateData:user]) {
                        ret = TRUE;
                        break;
                    }
                }
                if (ret) {
                    [LOCALMANAGER saveAllUsers:cr.datas];
                    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_USER_CONTACT Value:[NSString stringWithFormat:@"%d",cr.datas.count]];
                }
            }
            
            [self _loadData];
            if (cr.datas.count == 0) {
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
                
                [dataDic removeAllObjects];
                header = nil;
                
                
                [_tableView reloadData];
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}

-(void)clickLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
