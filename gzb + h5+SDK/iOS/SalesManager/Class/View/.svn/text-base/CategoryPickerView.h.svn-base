//
//  CategoryPickerView.h
//  SalesManager
//
//  Created by liu xueyan on 1/23/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryPickerDelegate <NSObject>

-(void)dismiss;
-(void)confirm;

@end

@interface CategoryPickerView : UIView<UIPickerViewDelegate>{
    
    UIToolbar *toolBar;
    UIPickerView *picker;

}

@property(nonatomic,retain) UIPickerView *picker;
@property(nonatomic,assign) id<CategoryPickerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame tag:(id)tag;

@end
