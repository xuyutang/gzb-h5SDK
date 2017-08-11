//
//  PopInputView.h
//  SalesManager
//
//  Created by liu xueyan on 12/3/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PopInputViewButtonBlock)();

@interface PopInputView : UIView

@property (nonatomic, retain) UILabel *titleName;
@property (nonatomic, retain) UITextView *textView;

- (void)show;

- (void)dismiss;

- (void)setDoneButtonWithTitle:(NSString *)aTitle block:(PopInputViewButtonBlock)block;

- (void)setCancelButtonTitle:(NSString *)aTitle block:(PopInputViewButtonBlock)block;

@end


