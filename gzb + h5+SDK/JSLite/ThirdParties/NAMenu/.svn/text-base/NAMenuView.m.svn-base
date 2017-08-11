//
//  NAMenuView.m
//
//  Created by Cameron Saul on 02/20/2012.
//  Copyright 2012 Cameron Saul. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NAMenuView.h"
#import "NAMenuItemView.h"
#import "NSString+FontAwesome.h"
#import "GlobalConstant.h"

@interface NAMenuView()
@property (nonatomic, retain) NSMutableArray *itemViews;
- (void)setupItemViews;
- (void)itemPressed:(id)sender;
@end

@implementation NAMenuView
@synthesize menuDelegate;
@synthesize itemViews;
@synthesize columnCountPortrait, columnCountLandscape, itemSize;

#pragma mark - Memory Management

- (id)init {
	self = [super init];
	
	if (self) {
		itemViews = [[NSMutableArray alloc] init];
		
		// set some defaults
		columnCountPortrait = 3;
		columnCountLandscape = 3;
		itemSize = CGSizeMake(90, 90);
	}
	
	return self;
}

- (void)dealloc {
	menuDelegate = nil;
	
	[itemViews release];
	
	[super dealloc];
}


#pragma mark - View Lifecycle

- (void)layoutSubviews {
	[super layoutSubviews];
	
	NSUInteger numColumns = self.bounds.size.width > self.bounds.size.height ? self.columnCountLandscape : self.columnCountPortrait;
	if(numColumns == 0) numColumns = 3;
	NSUInteger numItems = [self.menuDelegate menuViewNumberOfItems:self];
	if (self.itemViews.count != numItems) {
		[self setupItemViews];
	}
	
	CGFloat padding = roundf((self.bounds.size.width - (self.itemSize.width * numColumns)) / (numColumns + 1));
	NSUInteger numRows = numItems % numColumns == 0 ? (numItems / numColumns) : (numItems / numColumns) + 1;
	CGFloat totalHeight = ((self.itemSize.height + padding) * numRows) + padding;
	
	// get an even y padding if less than the max number of rows
	CGFloat yPadding = padding;
	if (totalHeight < self.bounds.size.height) {
		CGFloat leftoverHeight = self.bounds.size.height - totalHeight;
		CGFloat extraYPadding = roundf(leftoverHeight / (numRows + 1));
		yPadding += extraYPadding;
		
		totalHeight = ((self.itemSize.height + yPadding) * numRows) + yPadding;
	}
	
	// get an even x padding if we have less than a single row of items
	if (numRows == 1 && numItems < numColumns) {
		padding = roundf((self.bounds.size.width - (numItems * self.itemSize.width)) / (numItems + 1));
	}
	for (int i = 0; i < numItems; i++) {
		UIView *item = [self.itemViews objectAtIndex:i];
		NSUInteger column = i % numColumns;
		NSUInteger row = i / numColumns;
		
        CGFloat xOffset = (column * (self.itemSize.width + padding)) + padding;
		CGFloat yOffset = (row * (self.itemSize.height + yPadding)) + yPadding;
		CGFloat lxOffset = ((column+1) * (self.itemSize.width + padding)) + padding;
		CGFloat lyOffset = (row * (self.itemSize.height + yPadding)) + yPadding;
		item.frame = CGRectMake(xOffset, yOffset, self.itemSize.width, self.itemSize.height);
        UIImage *hLine = [UIImage imageNamed:@"line_horizontal"];
        if(column<numColumns){
            [hLine drawInRect:CGRectMake(lxOffset, lyOffset, 1, 20)];
        }

	}
	
	
	
	self.contentSize = CGSizeMake(self.bounds.size.width, totalHeight);
}


#pragma mark - Local Methods

- (void)setupItemViews {
	for (UIView *view in self.itemViews) {
		[view removeFromSuperview];
	}
	
	[self.itemViews removeAllObjects];
	
	// now add the new objects
	NSUInteger numItems = [self.menuDelegate menuViewNumberOfItems:self];
	
	for (NSUInteger i = 0; i < numItems; i++) {
		NAMenuItemView *itemView = [[[NAMenuItemView alloc] init] autorelease];
		NAMenuItem *menuItem = [self.menuDelegate menuView:self itemForIndex:i];
        if (i == numItems - 1) {
            itemView.lblIcon.frame = CGRectMake(22, 32, 47, 47);
        } else {
        
          itemView.lblIcon.frame = CGRectMake(22, 12, 47, 47);
        }
		itemView.frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
		itemView.label.text = menuItem.title;
        itemView.label.font = [UIFont systemFontOfSize:13];
        [itemView.label setTextColor:[UIColor blackColor]];
        
		//itemView.imageView.image = menuItem.icon;
        //图片来自自定义字体库
        itemView.lblIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:35];
        [itemView.lblIcon setText:menuItem.faIcon];
        [itemView.lblIcon setTextColor:menuItem.faColor];
        //end
		itemView.tag = i;
		[itemView.button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];//
//        新功能提示
//        UILabel *new = [[UILabel alloc] initWithFrame:CGRectMake(itemView.frame.size.width - 19, 3, 16, 16)];
//        new.backgroundColor = [UIColor redColor];
//        new.textColor = [UIColor whiteColor];
//        new.textAlignment = UITextAlignmentCenter;
//        new.text = @"新";
//        new.font = [UIFont systemFontOfSize:12];
//        new.layer.cornerRadius = 8.f;
//        new.layer.masksToBounds = YES;
//        [itemView addSubview:new];
		[self.itemViews addObject:itemView];
		[self addSubview:itemView];
	}
}

- (void)itemPressed:(UIButton *)sender {
	NSParameterAssert(sender);
	[self.menuDelegate menuView:self didSelectItemAtIndex:sender.tag];
}

@end
