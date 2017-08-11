//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTTableCaptionItemCell.h"

// UI
#import "TTTableCaptionItem.h"
//#import "UIViewAdditions.h"
//#import "UIFontAdditions.h"
//#import "UITableViewAdditions.h"

// Style
//#import "Three20Style/TTGlobalStyle.h"
//#import "Three20Style/TTDefaultStyleSheet.h"

static const CGFloat kKeySpacing = 12.0f;
static const CGFloat kKeyWidth = 75.0f;

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTableCaptionItemCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
  if (self) {
      self.textLabel.font = [UIFont boldSystemFontOfSize:15];
    self.textLabel.textColor = RGBCOLOR(87, 107, 149);;
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
	self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = UITextAlignmentRight;
    self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.textLabel.numberOfLines = 1;
    self.textLabel.adjustsFontSizeToFitWidth = YES;

    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:15];
    self.detailTextLabel.textColor = [UIColor blackColor];
    self.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
	self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    self.detailTextLabel.minimumFontSize = 8;
    self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.detailTextLabel.numberOfLines = 0;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  TTTableCaptionItem* item = object;

    CGFloat margin = (tableView.style == UITableViewStyleGrouped) ? 10.f : 0.f;
  CGFloat width = tableView.frame.size.width - (kKeyWidth + kKeySpacing + kTableCellHPadding*2 + margin*2);

  CGSize detailTextSize = [item.text sizeWithFont:[UIFont boldSystemFontOfSize:15]
                                constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                    lineBreakMode:UILineBreakModeWordWrap];

  CGSize captionTextSize = [item.caption sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                constrainedToSize:CGSizeMake(kKeyWidth, CGFLOAT_MAX)
                                    lineBreakMode:UILineBreakModeTailTruncation];

  return MAX(detailTextSize.height, captionTextSize.height) + kTableCellVPadding*2;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  [super layoutSubviews];

    CGFloat lineheight = (self.textLabel.font.ascender - self.textLabel.font.descender) + 1;
  self.textLabel.frame = CGRectMake(kTableCellHPadding, kTableCellVPadding,
                                    kKeyWidth, lineheight);

  CGFloat valueWidth = self.contentView.frame.size.width - (kTableCellHPadding*2 + kKeyWidth + kKeySpacing);
  CGFloat innerHeight = self.contentView.frame.size.height - kTableCellVPadding*2;
  self.detailTextLabel.frame = CGRectMake(kTableCellHPadding + kKeyWidth + kKeySpacing,
                                          kTableCellVPadding,
                                          valueWidth, innerHeight);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];

    TTTableCaptionItem* item = object;
    self.textLabel.text = item.caption;
    self.detailTextLabel.text = item.text;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)captionLabel {
  return self.textLabel;
}


@end
