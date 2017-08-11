//
//  AttendanceViewController.m
//  SalesManager
//
//  Created by liu xueyan on 7/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "AttendanceViewController.h"
#import "LocationCell.h"
#import "TextFieldCell.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "AttendanceListViewViewController.h"

//#import "UITableGridViewCell.h"
//#import "UIImageButton.h"
#define kImageWidth  92
#define kImageHeight  40

@interface AttendanceViewController ()
@end

@implementation AttendanceViewController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    appDelegate = APPDELEGATE;
    
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(categoryRefresh)
                                                 name:@"refreshAttenceCatogory"
                                               object:nil];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.backgroundView = nil;
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [scrollView addSubview:tableView];
  
    
   [lblFunctionName setText:TITLENAME_REPORT(FUNC_ATTENDANCE_DES)];
    
    remarks = [[NSString alloc] initWithString:@""];
  
    [self toRefresh:nil];
}

-(void)categoryRefresh {

    [self _refresh:nil];
}

-(void)syncTitle {
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_ATTENDANCE_DES)];
}

-(void)_refresh:(id)sender{
     AGENT.delegate = self;
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
     hud.mode = MBProgressHUDModeCustomView;
     hud.labelText = NSLocalizedString(@"loading", @"");
     
     if (DONE != [AGENT sendRequestWithType:ActionTypeAttendanceCategoryList param:@""]){
         HUDHIDE2;
         [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)
                           description:NSLocalizedString(@"error_connect_server", @"")
                                  type:MessageBarMessageTypeError
                           forDuration:ERR_MSG_DURATION];
     }
}

-(void)toRefresh:(id)sender{
    if(categories == nil){
        
        categories = [[NSMutableArray  alloc] init];
    }else{
        [categories removeAllObjects];
    }
    
    categories = [[LOCALMANAGER getAttendanceCategories] retain];
    if (categories.count == 0) {
        /*
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_attendance", @"")
                          description:NSLocalizedString(@"no_attendance_category", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
         */
        [self _refresh:nil];
    }else{
        [self createAttendance];
    }
}

-(void) createAttendance{
    int x=10,y=260;
    if (btAttendances != nil) {
        for (UIButton *btItem in btAttendances) {
            [btItem removeFromSuperview];
        }
        [btAttendances removeAllObjects];
    }
    btAttendances = [[NSMutableArray alloc] init];
    for(int i=0;i<categories.count;i++){
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if(i%2 == 0){
            x=10;
        }else{
            x = 170;
        }
        if (i%2 == 0) {
            y = 50+y;
        }
        
        [bt setFrame:CGRectMake(x, y, 140, 40)];
        [bt setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateNormal];
        [bt setTitle:((AttendanceCategory *)[categories objectAtIndex:i]).name forState:UIControlStateNormal];
        bt.tag = i;
        [bt addTarget:self action:@selector(goWork:) forControlEvents:UIControlEventTouchUpInside];
        [btAttendances addObject:bt];
        [scrollView addSubview:[btAttendances objectAtIndex:i]];
    }
    
    [scrollView setContentSize:CGSizeMake(320, y+90)];

}

-(void) initData{
    if ([imageFiles count]>0) {
        [LOCALMANAGER clearImagesWithFiles:imageFiles];
        [imageFiles removeAllObjects];
    }
    imageFiles = [[NSMutableArray alloc] init];
    remarks = @"";
}

-(void)toList:(id)sender{
    [self dismissKeyBoard];
    AttendanceListViewViewController *ctrl = [[AttendanceListViewViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)goWork:(id*)sender{
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"click id: %d",button.tag);
    
    if([NSString stringContainsEmoji:txtCell.txtField.text]){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
    
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    Attendance_Builder* ab = [Attendance builder];
    [ab setId:-1];
    if (appDelegate.myLocation != nil){
        [ab setLocation:appDelegate.myLocation];
    }
    
    if (liveImageCell.imageFiles.count >0) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSString *file in liveImageCell.imageFiles) {
            UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
            NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
            [images addObject:dataImg];
        }
        [ab setFilesArray:images];
    }
    if ((txtCell.txtField.textColor != [UIColor lightGrayColor])) {
         [ab setComment:[txtCell.txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
   
    [ab setCategory:[categories objectAtIndex:button.tag]];
    [ab setUser:USER];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeAttendanceSave param:[ab build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
}
/*
-(void)goHome{
    AGENT.delegate = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");

    //int cid = [self _checkIn];
    int cid = -1;
    
    Attendance_Builder* ab = [Attendance builder];
    [ab setId:cid];
    if (appDelegate.myLocation != nil){
        [ab setAddress:appDelegate.myLocation.address];
        [ab setLatitude:appDelegate.myLocation.latitude];
        [ab setLongitude:appDelegate.myLocation.longitude];
    }

    [ab setComment:txtCell.txtField.text];
    [ab setUser:appDelegate.currentUser];
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:appDelegate.currentUser,@"user", [ab build],@"attendance",nil];
    if (DONE != [AGENT sendRequestWithType:ActionTypeAttendanceCheckout param:params]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"go_home", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
    
    [params release];

}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不让tableviewcell有选中效果
    if(indexPath.section == 1)
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 120.0f;
        }else if(indexPath.row == 1){
            return 118.0f;
        }else{
            return 50.0f;
        }
    }else{
        return kImageHeight + 10;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    
    if ((categories.count % 3) == 0) {
        return categories.count/3;
    }
    
    
    return categories.count/3+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
    
    if (indexPath.row == 0) {
        txtCell=(TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(txtCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TextFieldCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[TextFieldCell class]])
                    txtCell=(TextFieldCell *)oneObject;
            }
        }
        txtCell.txtField.frame = CGRectMake(10, 10, 300, 200);
       // txtCell.backgroundColor = [UIColor redColor];
        txtCell.title.text = NSLocalizedString(@"memo", nil);
        txtCell.title.hidden = YES;
        txtCell.txtField.delegate=self;
        txtCell.txtField.text = @"输入备注";
        txtCell.txtField.textColor = [UIColor lightGrayColor];
        CGRect rect = txtCell.txtField.frame;
        rect.size.height = 110;
        txtCell.txtField.frame = rect;
    
        if (remarks !=nil && remarks.length>0)
            txtCell.txtField.text = remarks;
        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        [topView setBarStyle:UIBarStyleBlack];
        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
        //[doneButton release];
        //[btnSpace release];
        //[helloButton release];
        
        [topView setItems:buttonsArray];
        //[txtCell.txtField setInputAccessoryView:topView];
        cell = txtCell;
        
        [topView release];
        [helloButton release];
        [btnSpace release];
        [doneButton release];
        
        
    }else if(indexPath.row == 1){
        
        if(liveImageCell==nil){
            liveImageCell = [[LiveImageCell alloc] init];
            liveImageCell.delegate = self;
        }
        liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell = liveImageCell;
    
    }else if(indexPath.row == 2){
    
        locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(locationCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[LocationCell class]])
                    locationCell=(LocationCell *)oneObject;
            }
        }
        
        if (appDelegate.myLocation != nil) {
            if (!appDelegate.myLocation.address.isEmpty) {
                [locationCell.lblAddress setText:appDelegate.myLocation.address];
            }else{
                [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",appDelegate.myLocation.latitude,appDelegate.myLocation.longitude]];
            }
        }
        [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
        
        cell = locationCell;
    }
    }
    return cell;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"输入备注"]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length<1) {
        textView.text = @"输入备注";
          textView.textColor = [UIColor lightGrayColor];
    }
     remarks = [textView.text copy];
}


-(void)autorefreshLocation {
  [super refreshLocation];
  [tableView reloadData];
}

- (void)refreshLocation{
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    //[hud show:YES];
   
    
    [hud hide:YES afterDelay:1.0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        return NO;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}



-(IBAction)dismissKeyBoard
{
    [txtCell.txtField resignFirstResponder];
}

-(IBAction)clearInput{

    txtCell.txtField.text = @"";
    
}

-(void)addPhoto{
    
    NSLog(@"delegate addphoto");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:NO];
        [self.parentCtrl presentModalViewController:cameraVC animated:YES];
        [cameraVC release];
        
    }else {
        NSLog(@"Camera is not available.");
    }
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage *)fitSmallImage:(UIImage *)image
{
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
- (CGSize)fitsize:(CGSize)thisSize
{
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/720;
    CGFloat hscale = thisSize.height/960;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    return newSize;
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeAttendanceCategoryList:{
            HUDHIDE2;
            int categoryCount = cr.datas.count;
            if(categories == nil){
            
                categories = [[NSMutableArray  alloc] init];
            }else{
                [categories removeAllObjects];
            }
            PBAppendableArray* cs = [[PBAppendableArray alloc] autorelease];
            for (int i = 0 ;i < categoryCount;i++){
                AttendanceCategory* ac = [AttendanceCategory parseFromData:[cr.datas  objectAtIndex:i]];
                [categories addObject:ac];
                [cs addObject:ac];
                
            }
            if (categoryCount > 0) {
                [LOCALMANAGER saveAttendanceCategories:cs];
                [self createAttendance];
            }

        }
            break;
            
        case ActionTypeAttendanceSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [txtCell.txtField setText:@""];
                [liveImageCell clearCell];
                //[imageFiles removeAllObjects];
                [tableView reloadData];
                [MESSAGE showMessageWithTitle:TITLENAME(FUNC_ATTENDANCE_DES)                                  description:NSLocalizedString(@"attendance_msg_done", @"")
                                         type:MessageBarMessageTypeSuccess
                                  forDuration:SUCCESS_MSG_DURATION];
                [self initData];
            }
            
        }
            break;
            /*
        case ActionTypeAttendanceCheckout:{
            HUDHIDE2;
            if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]){
                txtCell.txtField.text = @"";
                
                [LOCALMANAGER saveValueToUserDefaults:KEY_CHECKIN_DATE Value:@""];
                [LOCALMANAGER saveValueToUserDefaults:KEY_CHECKOUT_DATE Value:[NSDate getCurrentDate]];
                btGoHome.enabled = (![[LOCALMANAGER getValueFromUserDefaults:KEY_CHECKOUT_DATE] isEqualToString:[NSDate getCurrentDate]]) ? YES : NO;
                btGoWork.enabled = YES;
            }
            [super showMessage2:cr Title:NSLocalizedString(@"menu_function_attendance", @"") Description:NSLocalizedString(@"attendance_checkout_msg_done", @"")];

        }
            break;
             */
            
        default:
            break;
    }
    [super showMessage2:cr Title:TITLENAME(FUNC_ATTENDANCE_DES) Description:@""];
}

@end
