//
//  CropImageViewController.m
//  Club
//
//  Created by liu xueyan on 12/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "CropImageViewController.h"

@interface CropImageViewController ()

@end

@implementation CropImageViewController
@synthesize imageCropView;

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
	//
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:NO];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *seachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 25, 25)];
   
    [seachImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    
    seachImageView.userInteractionEnabled = YES;
//    [seachImageView setImage:[UIImage imageNamed:@"topbar_button_save"]];
//    seachImageView.textColor = WT_RED;
//    seachImageView.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20.f];
//    seachImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_SAVE];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    seachImageView.userInteractionEnabled = YES;
    [seachImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:seachImageView];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    [rightView release];
    [lblFunctionName setText:NSLocalizedString(@"bar_cut_photo", @"")];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.imageCropView = [[ImageCropView alloc] initWithFrame:self.view.bounds];
    self.imageCropView.controlColor = WT_RED;
    
    [self.view addSubview:self.imageCropView];
    
    self.imageCropView.image = self.image;
}

-(void)clickLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveImage:(id)sender{
    if ([self.delegate respondsToSelector:@selector(cropImageController:didFinishCroppingImage:)]) {
        [self.delegate cropImageController:self didFinishCroppingImage:[self.imageCropView getCropImage]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageCropView.image = image;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{

    [self.imageCropView release];
    [super dealloc];

}

@end
