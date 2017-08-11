//
//  BigImageViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/5/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BigImageViewController.h"
#import "SDImageView+SDWebCache.h"

@interface BigImageViewController ()

@end

@implementation BigImageViewController
@synthesize filePath,image,functionName;

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
    
    [self.navigationController setNavigationBarHidden:NO];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *seachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
    seachImageView.image = [UIImage imageNamed:@"ab_icon_save"];
    //[seachImageView setImage:[UIImage imageNamed:@"topbar_button_save"]];
//    seachImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_SAVE];
//    seachImageView.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
//    seachImageView.textAlignment = UITextAlignmentCenter;
//    seachImageView.textColor = WT_RED;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    seachImageView.userInteractionEnabled = YES;
    [seachImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:seachImageView];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    [rightView release];

    
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT)];
    if (image == nil) {
        [imageView setImageWithURL:[NSURL URLWithString:filePath] refreshCache:YES placeholderImage:[UIImage imageNamed:@"ic_default_rect_pic_white"]];
    }else{
        [imageView setImage:image];
    }
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setBackgroundColor:[UIColor blackColor]];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:imageView];
    
    if ((functionName == nil) || ([functionName isEqualToString:@""]) ) {
        [lblFunctionName setText:NSLocalizedString(@"bar_detail_image", @"")];
    }else{
        [lblFunctionName setText:functionName];
    }
    
}
-(void)clickLeftButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)saveImage:(id)sender{

        UIImageWriteToSavedPhotosAlbum([imageView image], nil, nil,nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储照片成功"
                                                        message:@"您已将照片存储于图片库中，打开照片程序即可查看。"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
