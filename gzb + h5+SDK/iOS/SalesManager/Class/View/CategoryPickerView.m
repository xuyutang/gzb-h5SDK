//
//  CategoryPickerView.m
//  SalesManager
//
//  Created by liu xueyan on 1/23/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "CategoryPickerView.h"
#import "GlobalConstant.h"

@implementation CategoryPickerView
@synthesize delegate,picker;

- (id)initWithFrame:(CGRect)frame tag:(id)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        
        [toolBar setBarStyle:UIBarStyleDefault];
        [toolBar setBackgroundColor:WT_TOOLBAR_GRAY];
        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(toCancel)];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(toConfirm)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
        [doneButton release];
        [btnSpace release];
        [helloButton release];
        [toolBar setItems:buttonsArray];

        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 35, 320, 216)];
        picker.delegate = tag;
        picker.showsSelectionIndicator = YES;
        [self addSubview:toolBar];
        [self addSubview:picker];
        [self setBackgroundColor:[UIColor whiteColor]];
        delegate = tag;
    }
    return self;
}


-(void)toCancel{
    if (delegate != nil && [delegate respondsToSelector:@selector(dismiss)]) {
        [delegate dismiss];
    }
}

-(void)toConfirm{
    if (delegate != nil && [delegate respondsToSelector:@selector(confirm)]) {
        [delegate confirm];
    }
}

-(void)dealloc{
    [super dealloc];
    [toolBar release];
    [picker release];
}


@end
