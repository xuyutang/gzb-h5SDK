//
//  IMGCommentView.m
//  SalesManager
//
//  Created by liuxueyan on 15-3-13.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "IMGCommentView.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+Helpers.h"

@implementation TitleViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *separateLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
        separateLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:separateLine];
        
        _tintLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, self.bounds.size.width - 30, 38)];
        _tintLabel.font = [UIFont systemFontOfSize:15];
        _tintLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_tintLabel];
        [_tintLabel release];
    }
    return self;
}
@end

@implementation IMGCommentView
@synthesize textViewCell,imageFiles,target,parentCtrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //tableView.allowsSelection = NO;
        [tableView setBackgroundColor:[UIColor clearColor]];
        tableView.backgroundView = nil;
        [self addSubview:tableView];
        
        UIButton *btSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [btSubmit setFrame:CGRectMake(8, 260, 305, 40)];
        [btSubmit setTitle:@"提交" forState:UIControlStateNormal];
        [btSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btSubmit setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateNormal];
        [self addSubview:btSubmit];
        
        [btSubmit addTarget:self action:@selector(submitComment) forControlEvents:UIControlEventTouchUpInside];
    }
    [self initData];
    return self;
}

- (void)initData{
    
    if ([imageFiles count]>0) {
        [LOCALMANAGER clearImagesWithFiles:imageFiles];
        [imageFiles removeAllObjects];
    }
    imageFiles = [[NSMutableArray alloc] init];
    
    textViewCell.textView.text = @"";
}

-(void)submitComment{
    if (target != nil && [target respondsToSelector:@selector(submitComment)]) {
        [target submitComment];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            return 120;
        }
            break;
        case 1:{
            return 40;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:{
            
            if(liveImageCell==nil){
                liveImageCell = [[LiveImageCell alloc] init];
                liveImageCell.delegate = self;
            }
            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return liveImageCell;
        }
            break;
        case 1:{
            
            if (titleViewCell == nil) {
                titleViewCell = [[TitleViewCell alloc]init];
                titleViewCell.tintLabel.text = @"回复：";
            }
            titleViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return titleViewCell;
        }
            break;
        case 2:{
            
            if (textViewCell == nil) {
                textViewCell = [[TextViewCell alloc] init];
                textViewCell.textView.placeHolder = @"必填（1000字以内）";
                
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
                //[textViewCell.textView setInputAccessoryView:topView];
                textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
                [topView release];
            }
            
            return textViewCell;
            
        }
            break;
        default:
            break;
    }
    
    return cell;
    
}

-(void)addPhoto{
    
    NSLog(@"delegate addphoto");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:NO];
        [parentCtrl presentViewController:cameraVC animated:YES completion:nil];
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
    [picker dismissViewControllerAnimated:YES completion:nil];
    [imageFile release];
    
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
    if (textViewCell.textView != nil) {
        [textViewCell.textView resignFirstResponder];
    }
}

-(IBAction)clearInput{
    
    textViewCell.textView.text = @"";
    
}



- (void)dealloc {
    
    [imageFiles release];
    [tableView release];
    [liveImageCell release];
    [textViewCell release];
    
    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
