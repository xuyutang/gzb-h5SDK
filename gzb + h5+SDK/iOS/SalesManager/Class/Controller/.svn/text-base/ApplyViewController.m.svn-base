//
//  GiftViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-9-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "ApplyViewController.h"
#import "LiveImageCell.h"
#import "ApplyTypeViewController.h"
#import "AppDelegate.h"
#import "CustomerSelectViewController.h"
#import "ApplyListViewController.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+Helpers.h"
#import "UIView+CNKit.h"
#import "PersonViewController.h"
#import "AuditListViewController.h"

@interface ApplyViewController ()

@end

@implementation ApplyViewController
@synthesize currentApplyCategory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          _showListImageBool = YES;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    //保存
    UIImageView*  saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture3 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture3];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    [tapGesture3 release];
    
   //申请列表
    UIImageView *approImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [approImageView setImage:[UIImage imageNamed:@"ab_icon_apply"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    approImageView.userInteractionEnabled = YES;
    [approImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:approImageView];
    
    [approImageView release];
    
    //审核列表
    UIImageView * auditImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [auditImageView setImage:[UIImage imageNamed:@"ab_icon_audi"]];
    
    auditImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(auditAction:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    auditImageView.contentMode = UIViewContentModeScaleAspectFit;
    [auditImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:auditImageView];
    [auditImageView release];
    [tapGesture2 release];
    
    if (!_showListImageBool) {
        approImageView.hidden = YES;
        auditImageView.hidden = YES;
        saveImageView.x = 100;
    }

    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];

    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    appDelegate = APPDELEGATE;
    tableView.separatorStyle = NO;
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_APPROVE_DES)];
    hasProcessBool = YES;
    AGENT.delegate = self;
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasSync)
                                                 name:SYNC_NOTIFICATION_MENU object:nil];
    
    
}

-(void)syncTitle {
  [lblFunctionName setText:TITLENAME_REPORT(FUNC_APPROVE_DES)];
}

-(void)clickLeftButton:(id)sender {
    if (_showListImageBool) {
        [super clickLeftButton:sender];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        
   }
}

-(void)viewWillAppear:(BOOL)animated {
    
    if (bHasSync) {
        applyCategories = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getApplyCategories]];
        
        ApplyCategory_Builder *ab = [ApplyCategory builder];
        [ab setName:@"请选择"];
        [ab setId:-1];
        [ab setUsersArray:nil];
        [applyCategories insertObject:[ab build] atIndex:0];
        
        if ([applyCategories count]>0) {
            currentApplyCategory = [applyCategories objectAtIndex:0];
        }
        [tableView reloadData];
    }
    bHasSync = NO;
}

-(void)hasSync {
    bHasSync = YES;
}

- (void)initData {
    if (!checkBool) {
         [self checkHasUsers:currentApplyCategory];
    }
   
    applyCategories = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getApplyCategories]];
    applyTitle = [[NSString alloc] initWithString:@""];
    applyContent = [[NSString alloc] initWithString:@""];
    textViewCell.textView.text = @"";
    if (_showListImageBool !=NO) {
      
        ApplyCategory_Builder *ab = [ApplyCategory builder];
        [ab setName:@"请选择"];
        [ab setId:-1];
        [ab setUsersArray:nil];
        [applyCategories insertObject:[ab build] atIndex:0];
        
        if ([applyCategories count]>0) {
            currentApplyCategory = [applyCategories objectAtIndex:0];
        }
      
    }
   
}

#pragma mark 去往申请列表
-(void)toList:(id)sender {
    [self dismissKeyBoard];
    ApplyListViewController *ctrl = [[ApplyListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

#pragma mark 去往审核列表
-(void)auditAction:(id)sender {
    AuditListViewController* auditVC = [[AuditListViewController alloc] init];
    [self.navigationController pushViewController:auditVC animated:YES];

}

#pragma mark 保存操作
-(void)toSave:(id)sender {
    [self dismissKeyBoard];
    
    if ([currentApplyCategory.name isEqualToString:@"请选择"]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)                            description:NSLocalizedString(@"apply_no_type", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }

    if (titleCell.inputField.text == nil || titleCell.inputField.text.length == 0) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)                          description:NSLocalizedString(@"apply_hint_title", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
     if (applyContent.length == 0) {
         [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)                            description:NSLocalizedString(@"apply_hint_content", @"")
                                  type:MessageBarMessageTypeInfo
                           forDuration:INFO_MSG_DURATION];
     
         return;
     }
    if (applyContent.trim.length > 1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)                            description:NSLocalizedString(@"input_limit_1000", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }

     if ([NSString stringContainsEmoji:textViewCell.textView.text] || [NSString stringContainsEmoji:titleCell.inputField.text]) {
         [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
                           description:NSLocalizedString(@"post_hint_text_error", @"")
                                  type:MessageBarMessageTypeInfo
                           forDuration:INFO_MSG_DURATION];
     
         return;
     }
    
    if(currentApplyCategory == nil){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES) description:NSLocalizedString(@"post_hint_apply_category", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
    
    if(hasProcessBool == NO && [chosePersonCell.value.text isEqualToString:NSLocalizedString(@"apply_hint_no_auitPerson", @"")]){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES) description:NSLocalizedString(@"apply_hint_no_auitPerson", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    ApplyItem_Builder* pb = [ApplyItem builder];
    [pb setId:-1];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *file in liveImageCell.imageFiles) {
        UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
        NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
        [images addObject:dataImg];
    }
    if (images.count >0) {
        [pb setFilesArray:images];
    }
    
    if(textViewCell.textView.text != nil && textViewCell.textView.text.length>0){
         [pb setContent:textViewCell.textView.text];
     }
    
    if(titleCell.inputField.text != nil && titleCell.inputField.text.length>0){
        [pb setTitle:titleCell.inputField.text];
    }
    
    [pb setCategory:currentApplyCategory];
    
    if (appDelegate.myLocation != nil){
        [pb setLocation:appDelegate.myLocation];
    }
    
    [pb setUser:USER];
    
    if (hasProcessBool == NO) {
        [pb setAuditUsersArray:userMuarray];
    }
     AGENT.delegate = self;
     
     if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemSave param:[pb build]]) {
         HUDHIDE2;
         [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)                            description:NSLocalizedString(@"error_connect_server", @"")
                                  type:MessageBarMessageTypeError
                           forDuration:ERR_MSG_DURATION];
     }
    
}

#pragma -mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 44;
    }
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            return 60;
        }
            break;
        case 1:{
            return 160;
        }
            break;
        case 2:{
            return 120;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:{
            return NSLocalizedString(@" ", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@" ", nil);
        }
            break;
        default:
            break;
    }
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 44)];
        label.text = @"    内容";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.backgroundColor = [UIColor whiteColor];
        return label;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (hasProcessBool) {
            return 2;
        }else {
            return 3;
        
        }
        
    }else{
        return 1;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                ApplyTypeViewController *ctrl = [[ApplyTypeViewController alloc] init];
                ctrl.delegate = self;
                ctrl.bFavorate = NO;
                ctrl.bNeedAll = NO;
                UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [self presentViewController:patrolNavCtrl animated:YES completion:nil];
                [ctrl release];
            }
            
            if (indexPath.row == 1 && hasProcessBool == NO) {
                PersonViewController *personVC = [[PersonViewController alloc] init];
                //单选
                personVC .radioBool = YES;
                personVC.messageTitle = TITLENAME(FUNC_APPROVE_DES);
                [personVC getPersonsWithBlock:^(NSMutableArray *array) {
                    userMuarray  = array;
                    chosePersonCell.value.text = ((User*)array[0]).realName;
                }];
                [self.navigationController pushViewController:personVC animated:YES];
            }
        }
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            if (hasProcessBool) {
                if (indexPath.row == 0){
                    SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(selectCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[SelectCell class]])
                                selectCell=(SelectCell *)oneObject;
                        }
                        
                        selectCell.title.text = NSLocalizedString(@"title_apply_type", nil);
                        selectCell.value.frame = CGRectMake(60, 6, 200, 30);
                        if ([applyCategories count]>0) {
                            selectCell.value.text = currentApplyCategory.name;
                        }else{
                            selectCell.value.text = @"";
                        }
                        
                        selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
                        return selectCell;
                    }
                    
                }else if(indexPath.row == 1){
                    
                    titleCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                    if (titleCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[InputCell class]]) {
                                titleCell = (InputCell *)oneObject;
                            }
                        }
                        titleCell.title.text = NSLocalizedString(@"title_apply_title", nil);
                        
                        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        titleCell.inputField.tag = 24;
                        titleCell.inputField.delegate = self;
                        titleCell.inputField.frame = CGRectMake(60, 6, MAINWIDTH - 80, 30);
                        
                        titleCell.inputField.placeholder = NSLocalizedString(@"input_limit_200", nil);
                        if (applyTitle != nil && applyTitle.length>0) {
                            titleCell.inputField.text = applyTitle;
                        }
                    }
                    
                    return titleCell;
                }

            }else {
                if (indexPath.row == 0){
                    SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(selectCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[SelectCell class]])
                                selectCell=(SelectCell *)oneObject;
                        }
                        
                        selectCell.title.text = NSLocalizedString(@"title_apply_type", nil);
                        selectCell.value.frame = CGRectMake(60, 6, 200, 30);
                        if ([applyCategories count]>0) {
                            selectCell.value.text = currentApplyCategory.name;
                        }else{
                            selectCell.value.text = @"";
                        }
                        
                        selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
                        return selectCell;
                    }
                    
                }else if(indexPath.row == 2){
                    
                    titleCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                    if (titleCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[InputCell class]]) {
                                titleCell = (InputCell *)oneObject;
                            }
                        }
                        titleCell.title.text = NSLocalizedString(@"title_apply_title", nil);
                        
                        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        titleCell.inputField.tag = 24;
                        titleCell.inputField.delegate = self;
                        titleCell.inputField.frame = CGRectMake(60, 6, MAINWIDTH - 80, 30);
                        
                        titleCell.inputField.placeholder = NSLocalizedString(@"input_limit_200", nil);
                        if (applyTitle != nil && applyTitle.length>0) {
                            titleCell.inputField.text = applyTitle;
                        }
                    }
                    
                    return titleCell;
                } else if (indexPath.row ==  1) {
                    
                    chosePersonCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(chosePersonCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[SelectCell class]])
                                chosePersonCell=(SelectCell *)oneObject;
                        }
                        
                        chosePersonCell.title.text = NSLocalizedString(@"title_apply_person", nil);
                        chosePersonCell.value.frame = CGRectMake(80, 6, 200, 30);
                        
                        chosePersonCell.value.text = NSLocalizedString(@"apply_hint_no_auitPerson", @"");
                        
                        chosePersonCell.selectionStyle=UITableViewCellSelectionStyleNone;
                        return chosePersonCell;
                    }

                }}
        }
        break;
            
      
        case 1:{
            
            if(liveImageCell==nil){
                liveImageCell = [[LiveImageCell alloc] init];
                liveImageCell.delegate = self;
            }
            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return liveImageCell;
        }
            break;
        case 2:{
            
            if (textViewCell == nil) {
                textViewCell = [[TextViewCell alloc] init];
                textViewCell.textView.delegate = self;
                textViewCell.textView.text = NSLocalizedString(@"video_txtview_tip", nil);
                textViewCell.textView.textColor = [UIColor lightGrayColor];

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
                textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                [textViewCell addSubview:[self setView]];
                
                [topView release];
                
                if (applyContent != nil && applyContent.length>0) {
                    textViewCell.textView.text = applyContent;
                }
            }
            return textViewCell;
            
        }
            break;
            
            
        default:
            break;
    }
    
    return cell;
}

-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, MAINWIDTH - 200, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, MAINWIDTH - 50, 0.5)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 30 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
}

- (void)applyTypeSearch:(ApplyTypeViewController *)controller didSelectWithObject:(id)aObject{
    // 选择后进行判断，userArray 是否>0,有审批.否则自选择审批人
    if (![((ApplyCategory*)aObject).name isEqualToString:@"请选择"]) {
       [self checkHasUsers:aObject];   
    }else {
        hasProcessBool = YES;
        [tableView reloadData];
    }
  
    currentApplyCategory = [(ApplyCategory*)aObject retain];
    [tableView reloadData];
    
}

-(void) checkHasUsers:(id)aObject {
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");

    ApplyCategory_Builder *a = [ApplyCategory builder];
    [a setId:((ApplyCategory*)aObject).id];
    [a setName:((ApplyCategory*)aObject).name];
   
    

    [a setUsersArray:nil];
   
    
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeApplyCategoryUsers param:[a build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_HOLIDAY_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }


}

- (void)applyTypeSearchDidCanceled:(ApplyTypeViewController *)controller {
    
    
}

- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject {
    [tableView reloadData];
}
- (void)customerSearchDidCanceled:(CustomerSelectViewController *)controller {
    
}
- (void)newCustomerDidFinished:(CustomerSelectViewController *)controller newCustomer:(id)aObject {
    [tableView reloadData];
}

-(void)addPhoto {
    NSLog(@"delegate addphoto");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:NO];
        [self presentModalViewController:cameraVC animated:YES];
        [cameraVC release];
        
    }else {
        NSLog(@"Camera is not available.");
    }
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage *)fitSmallImage:(UIImage *)image {
    if (nil == image)
    {
        return nil;
    }
    if (image.size.width<720 && image.size.height<960)
    {
        return image;
    }
    CGSize size = [self fitsize:image.size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newing;
}

- (CGSize)fitsize:(CGSize)thisSize {
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/720;
    CGFloat hscale = thisSize.height/960;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    return newSize;
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    //NSLog(@"image.size.width=%f  image.size.height=%f",image.size.width,image.size.height);
    if (image.size.width > image.size.height) {
        newSize.width = (newSize.height/image.size.height) *image.size.width;
    }else{
        newSize.height = (newSize.width/image.size.width) *image.size.height;
    }
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Obtain the path to save to
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFile = [[NSString alloc] initWithString:[NSString UUID]];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageFile]];
    
    // Extract image from the picker and save it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [self fitSmallImage:[info objectForKey:UIImagePickerControllerOriginalImage]] ;
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);//UIImagePNGRepresentation(image);
        [data writeToFile:imagePath atomically:YES];
    }
    [imageFiles addObject:imagePath];
    [liveImageCell insertPhoto:imagePath];
    
    //[imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
    [picker dismissModalViewControllerAnimated:YES];
    [imageFile release];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        return NO;
    }
    applyTitle = [textField.text retain];
    [textField resignFirstResponder];
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {

}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    applyTitle = [textField.text retain];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:NSLocalizedString(@"video_txtview_tip", nil)]) {
        textViewCell.textView.text =@"";
    }

}

-(void)textViewDidEndEditing:(UITextView *)textView{
    applyContent = [textView.text retain];
    if (textView.text.length<1) {
        textView.text =NSLocalizedString(@"video_txtview_tip", nil);
        textViewCell.textView.textColor = [UIColor lightGrayColor];
    }
    
    
}

-(UIToolbar*)createToolbar{
    UIToolbar * topView = [[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    [helloButton release];
    
    [topView setItems:buttonsArray];
    return topView;
}

-(IBAction)dismissKeyBoard {
    if (textViewCell.textView != nil) {
        [textViewCell.textView resignFirstResponder];
    }
    if (titleCell.inputField != nil){
        [titleCell.inputField resignFirstResponder];
    }
}

-(IBAction)clearInput {
    textViewCell.textView.text = @"";
    
}

- (void)dealloc {
    [rightView release];
    [tableView release];
    [textViewCell release];
    [super dealloc];
}

- (void)viewDidUnload {
    [rightView release];
    rightView = nil;
    [tableView release];
    tableView = nil;
    [textViewCell release];
    textViewCell = nil;
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:message];
    
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeApplyItemSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                checkBool = YES;
                [self initData];
                [liveImageCell clearCell];
                if(imageFiles != nil)
                    [imageFiles removeAllObjects];
                
                textViewCell.textView.text = NSLocalizedString(@"video_txtview_tip", nil);
                textViewCell.textView.textColor = [UIColor lightGrayColor];
                hasProcessBool = YES;
                
                [tableView reloadData];
            }
            
            if (!_showListImageBool) {
                [self.navigationController popViewControllerAnimated:YES];
            }

            [super showMessage2:cr Title:TITLENAME(FUNC_APPROVE_DES) Description:NSLocalizedString(@"apply_msg_saved", @"")];
            
        }
            break;
          
        case ActionTypeApplyCategoryUsers:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                ApplyCategory *apply = [ApplyCategory parseFromData:cr.data];
                if (apply.users.count) {
                    hasProcessBool = YES;
                }else {
                    hasProcessBool = NO;
                }
                [tableView reloadData];
            }
            
        }
            break;
            
        default:
            break;
    }
}

@end
