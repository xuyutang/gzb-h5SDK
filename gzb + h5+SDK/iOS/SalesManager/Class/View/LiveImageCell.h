//
//  LiveImageCell.h
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveImageCellDelegate <NSObject>

-(void)addPhoto;
-(void)anyPhoto;
-(void)openPhoto:(int)index;
-(void)deletePhoto:(int)index;
-(void)openPhotos:(UIView *)superView index:(int)index;

@end

@interface LiveImageCell : UITableViewCell{

    UIScrollView *scrollView;

    NSMutableArray *imageFiles;
    NSMutableArray *imageViews;
    UIImageView *imageView;

    id<LiveImageCellDelegate> delegate;
    BOOL bDeleting;
    BOOL bDetail;
    void(^_callback)(NSInteger tag);

  
}

@property(nonatomic,assign) id<LiveImageCellDelegate> delegate;
@property(nonatomic,retain) NSMutableArray *imageFiles;
@property(nonatomic,assign) BOOL bDetail;
@property(nonatomic,assign) BOOL liveBool;

-(id)init;
-(id)initWithImages:(NSMutableArray *)imageUrlsl;
-(void)insertPhoto:(NSString *)imageFile;
-(void)addDetailImage:(NSMutableArray *)imageUrls;
-(void)clearCell;

- (void)addCallback:(void(^)(NSInteger tag))callback;
@end
