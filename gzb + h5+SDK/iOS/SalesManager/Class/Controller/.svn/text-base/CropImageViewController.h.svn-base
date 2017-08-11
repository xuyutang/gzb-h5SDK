//
//  CropImageViewController.h
//  Club
//
//  Created by liu xueyan on 12/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageCropView.h"

@class CropImageViewController;
@protocol CropImageViewControllerDelegate <NSObject>

- (void)cropImageController:(CropImageViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage;
- (void)cropImageControllerDidCancel:(CropImageViewController *)controller;

@end

@interface CropImageViewController : BaseViewController{

    ImageCropView* imageCropView;

}

@property(nonatomic,retain) ImageCropView* imageCropView;

@property (nonatomic, assign) id<CropImageViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, assign) BOOL keepingCropAspectRatio;
@property (nonatomic, assign) CGFloat cropAspectRatio;

@property (nonatomic, assign) CGRect cropRect;

@end
