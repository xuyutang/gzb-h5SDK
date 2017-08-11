//
//  CommonCell.h
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommonCellDelegate <NSObject>

-(void)clickFavorate:(int)index favorate:(BOOL)bFavorate;
-(void)clickFavorate:(int)section row:(int)row favorate:(BOOL)bFavorate;

@end

@interface CommonCell : UITableViewCell{

    id<CommonCellDelegate> delegate;
    BOOL bFavorate;
    int section;
    int row;
}

@property (nonatomic,assign) BOOL bFavorate;
@property (nonatomic,assign) id<CommonCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UIImageView *ivFavorate;

@property (nonatomic,assign) int section;
@property (nonatomic,assign) int row;


- (void)setCell;
-(void) hideFavButton;

@end
