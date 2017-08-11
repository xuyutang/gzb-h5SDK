//
//  ProgressButton.h
//  SalesManager
//
//  Created by liu xueyan on 1/6/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"

@interface ProgressButton : UIView{

    id _selTag;
    SEL _action;

}

@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *description;
@property (retain, nonatomic) IBOutlet UIButton *button;

-(void)addTag:(id)tag withAction:(SEL)action;

@end
