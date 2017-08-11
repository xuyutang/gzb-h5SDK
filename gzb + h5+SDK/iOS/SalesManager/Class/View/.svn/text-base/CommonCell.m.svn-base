//
//  CommonCell.m
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "CommonCell.h"

@implementation CommonCell
@synthesize title,ivFavorate,delegate,bFavorate,section,row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

    }
    return self;
}


-(void) hideFavButton{
    self.ivFavorate.hidden = YES;
}

- (void)setCell{
    dispatch_async(dispatch_get_main_queue(), ^{
        ivFavorate.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toFavorate:)];
        [tapGesture setNumberOfTapsRequired:1];
        [ivFavorate addGestureRecognizer:tapGesture];
        tapGesture.view.tag = self.tag;
        [tapGesture release];
        
        if (bFavorate) {
            [ivFavorate setImage:[UIImage imageNamed:@"ic_favorite_on"]];
        }else{
            [ivFavorate setImage:[UIImage imageNamed:@"ic_favorite_off"]];
        }
    });

}

-(void)toFavorate:(id)sender{
    
    if (bFavorate) {
        [ivFavorate setImage:[UIImage imageNamed:@"ic_favorite_off"]];
        bFavorate = NO;
    }else{
        [ivFavorate setImage:[UIImage imageNamed:@"ic_favorite_on"]];
        bFavorate = YES;
    }

    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;

    if (delegate != nil && [delegate respondsToSelector:@selector(clickFavorate:favorate:)]) {
        [delegate clickFavorate:tapGesture.view.tag favorate:bFavorate];
        
    }else if(delegate != nil && [delegate respondsToSelector:@selector(clickFavorate:row:favorate:)]){
        [delegate clickFavorate:section row:row favorate:bFavorate];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [title release];
    [ivFavorate release];
    [super dealloc];
}
@end
