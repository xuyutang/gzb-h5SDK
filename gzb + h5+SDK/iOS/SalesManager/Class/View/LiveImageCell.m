//
//  LiveImageCell.m
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LiveImageCell.h"
#import "SDImageView+SDWebCache.h"


@implementation LiveImageCell
@synthesize delegate;
@synthesize imageFiles;
@synthesize bDetail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _liveBool = YES;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        imageViews = [[NSMutableArray alloc] init];
        [imageView setImage:[UIImage imageNamed:@"add_photo"]];
        [imageViews addObject:imageView];
        
        [scrollView setContentSize:CGSizeMake(1000, 80)];
        [scrollView addSubview:imageView];
    }
    return self;
}

-(id)initWithImages:(NSMutableArray *)imageUrls{

    bDetail = YES;
    if (self = [super init]) {
        bDeleting = NO;
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 5, 290, 86)];
        [self addSubview:scrollView];
        
        imageFiles = imageUrls;
        [self addDetailImage:imageFiles];
    }
    return self;

}


- (void)addCallback:(void(^)(NSInteger tag))callback
{
    _callback = [callback copy];
}

-(id)init{
    
    if (self = [super init]) {
        bDeleting = NO;
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 5, 290, 110)];
       // scrollView.showsHorizontalScrollIndicator = NO;
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            imageView.layer.cornerRadius = 8;
            imageView.layer.masksToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            imageViews = [[NSMutableArray alloc] init];
            [imageView setImage:[UIImage imageNamed:@"add_photo"]];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPhoto:)];
            [tapGesture setNumberOfTapsRequired:1];
            [imageView addGestureRecognizer:tapGesture];
            tapGesture.view.tag = [imageViews count];
            [tapGesture release];
            [imageViews addObject:imageView];
            
            [scrollView setContentSize:CGSizeMake(80*[imageViews count], 80)];
        UILabel *expainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 200, 30)];
        expainLabel.text = @"长按图片可以删除";
        expainLabel.font = [UIFont systemFontOfSize:12];
        expainLabel.textColor = [UIColor lightGrayColor];
        
        [scrollView addSubview:imageView];
        [scrollView addSubview:expainLabel];
        [self addSubview:scrollView];
        
        imageFiles = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addDetailImage:(NSMutableArray *)imageUrls{

    int i = 0;
    for (NSString *url in imageUrls) {
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*85, 0, 80, 80)];
        tmpImageView.layer.cornerRadius = 8;
        tmpImageView.layer.masksToBounds = YES;
        tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
        [tmpImageView setImageWithURL:[NSURL URLWithString:url] refreshCache:YES placeholderImage:[UIImage imageNamed:@"ic_default_rect_pic"]];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSelectImage:)];
        [tapGesture setNumberOfTapsRequired:1];
        
        tmpImageView.userInteractionEnabled = YES;
        [tmpImageView addGestureRecognizer:tapGesture];
        tapGesture.view.tag = i;
        [scrollView addSubview:tmpImageView];
        [tapGesture release];
        [tmpImageView release];
        
        i++;
    }
    
    [scrollView setContentSize:CGSizeMake(80*[imageUrls count]+40, 80)];
    
}

-(void)toSelectImage:(id)sender{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    
        if (delegate != nil && [delegate respondsToSelector:@selector(openPhoto:)]) {
            [delegate openPhoto:tapGesture.view.tag];
        }
    if (delegate != nil && [delegate respondsToSelector:@selector(openPhotos:index:)]) {
        [delegate openPhotos:self index:tapGesture.view.tag];
    }
}

-(void)toPhoto:(id)sender{
 !_callback?:_callback(self.tag);
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    NSLog(@"tag=%d, imageviews count-1=%d",tapGesture.view.tag,[imageViews count]-1);
    if (tapGesture.view.tag == [imageViews count]-1) {
        NSLog(@"add photo");
        
        if (_liveBool) {
            if (delegate != nil && [delegate respondsToSelector:@selector(addPhoto)]) {
                [delegate addPhoto];
            }

        }else {
            if (delegate != nil && [delegate respondsToSelector:@selector(anyPhoto)]) {
                [delegate anyPhoto];
            }

        
        }
        
        
    }

}

-(void)alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        for (int i = alertView.tag; i<[imageViews count]-2; i++) {

            ((UIImageView *)[imageViews objectAtIndex:i]).tag = i;
            [((UIImageView *)[imageViews objectAtIndex:i]) setImage:[UIImage imageWithContentsOfFile:[imageFiles objectAtIndex:(i+1)]]];
        }
        UIImageView *tailView = [imageViews objectAtIndex:[imageViews count]-1];
        [tailView removeFromSuperview];
        
        [imageViews removeObjectAtIndex:([imageViews count]-1)];
        [((UIImageView *)[imageViews objectAtIndex:[imageViews count]-1]) setImage:[UIImage imageNamed:@"add_photo"]];
        ((UIImageView *)[imageViews objectAtIndex:[imageViews count]-1]).tag = [imageViews count]-1;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPhoto:)];
        [tapGesture setNumberOfTapsRequired:1];
        
        ((UIImageView *)[imageViews objectAtIndex:[imageViews count]-1]).userInteractionEnabled = YES;
        [((UIImageView *)[imageViews objectAtIndex:[imageViews count]-1]) addGestureRecognizer:tapGesture];
        tapGesture.view.tag = [imageViews count]-1;
        [tapGesture release];
        
        [scrollView setContentSize:CGSizeMake(85*[imageViews count], 80)];
        [imageFiles removeObjectAtIndex:alertView.tag];
        if ([self.delegate respondsToSelector:@selector(deletePhoto:)]) {
             [self.delegate deletePhoto:alertView.tag];
        }
       
    }
    
}

-(void)deleteImage:(id)sender{
    
    if (bDeleting) {
        return;
    }
    bDeleting = YES;
    UILongPressGestureRecognizer *longPressGestureRecognizer = (UILongPressGestureRecognizer*)sender;
    if (longPressGestureRecognizer.view.tag == [imageViews count]-1) {
        return;
    }
    NSString *strInfo = [NSString stringWithFormat:@"确定删除第%d张图片吗？",longPressGestureRecognizer.view.tag+1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:strInfo delegate:self
                                          cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = longPressGestureRecognizer.view.tag;
    [alert show];
    
    
    bDeleting = NO;
    

}

-(void)clearCell{

    [imageFiles removeAllObjects];
    for(UIImageView *item in imageViews){
        [item removeFromSuperview];
    }
    [imageViews removeAllObjects];
    [imageView setImage:[UIImage imageNamed:@"add_photo"]];
    [imageViews addObject:imageView];
    [scrollView addSubview:imageView];
    [scrollView setContentSize:CGSizeMake(85*[imageViews count], 80)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)insertPhoto:(NSString *)imageFile{
    
    [imageFiles addObject:imageFile];
    
    [((UIImageView *)[imageViews objectAtIndex:([imageViews count]-1)]) setImage:[UIImage imageWithContentsOfFile:imageFile]];
    UIImageView *justImageView = [imageViews objectAtIndex:([imageViews count]-1)];
    justImageView.layer.cornerRadius = 8;
    justImageView.layer.masksToBounds = YES;
    justImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(deleteImage:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    [justImageView addGestureRecognizer:longPressGestureRecognizer];
    longPressGestureRecognizer.view.tag = [imageViews count]-1;
    [longPressGestureRecognizer release];
    
    
    //setImage:[UIImage imageWithContentsOfFile:imagePath]
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(([imageViews count])*85, 0, 80, 80)];
    tmpImageView.layer.cornerRadius = 8;
    tmpImageView.layer.masksToBounds = YES;
    tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
    [tmpImageView setImage:[UIImage imageNamed:@"add_photo"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPhoto:)];
    [tapGesture setNumberOfTapsRequired:1];
    NSLog(@"tag= %d, imageviews count=%d",tapGesture.view.tag,[imageViews count]);
    tmpImageView.userInteractionEnabled = YES;
    [tmpImageView addGestureRecognizer:tapGesture];
    tapGesture.view.tag = [imageViews count];
    [tapGesture release];
    [imageViews addObject:tmpImageView];
    [scrollView addSubview:tmpImageView];
    [tmpImageView release];
    
    [scrollView setContentSize:CGSizeMake(85*[imageViews count], 80)];
}

- (void)dealloc {
    [scrollView release];
    [imageView release];
    [super dealloc];
}
@end
