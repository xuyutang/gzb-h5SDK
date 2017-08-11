//
//  BigImageViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/5/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"

@interface BigImageViewController : BaseViewController{

    UIImageView *imageView;
    NSString *filePath;

}

@property(nonatomic,retain) NSString *filePath;
@property(nonatomic,retain) UIImage* image;
@property(nonatomic,retain) NSString* functionName;
@end
