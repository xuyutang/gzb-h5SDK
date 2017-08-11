//
//  UTStatusInfoItemCell.m
//  30iMonitor
//
//  Created by KK UI on 13-2-21.
//  Copyright (c) 2013年 30iMonitor. All rights reserved.
//

#import "UTStatusInfoItemCell.h"
#import "TTCorePreprocessorMacros.h"
#import "UTStatusInfoItem.h"

@implementation UTStatusInfoItemCell
@synthesize item = _item;
@synthesize captionLabel = _captionLabel;
@synthesize detailsTextLabel = _detailsTextLabel;
@synthesize timestampLabel = _timestampLabel;
@synthesize statusInfoLabel = _statusInfoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont boldSystemFontOfSize:15.f];
        self.captionLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.captionLabel];
        
        newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont systemFontOfSize:12.f];
        newLabel.textColor = RGBCOLOR(79, 89, 105);
        newLabel.numberOfLines = 3;
        self.detailsTextLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.detailsTextLabel];
        
        newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont systemFontOfSize:12.f];
        self.timestampLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.timestampLabel];
        
        newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont systemFontOfSize:12.f];
        self.statusInfoLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.statusInfoLabel];
        
        self.captionLabel.frame = CGRectMake(20.f, 0.f, 150.f, 22.f);
        self.detailsTextLabel.frame  = CGRectMake(20.f, 23.f, 288.f, 36.f);
        self.timestampLabel.frame = CGRectMake(185.f, 0.f, 82.f, 21.f);
        self.statusInfoLabel.frame = CGRectMake(273.f, 0.f, 43.f, 21.f);
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont systemFontOfSize:15.f];
        self.captionLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.captionLabel];
        
        newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont systemFontOfSize:12.f];
        newLabel.textColor = RGBCOLOR(79, 89, 105);
        newLabel.numberOfLines = 2;
        self.detailsTextLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.detailsTextLabel];
        
        newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont systemFontOfSize:12.f];
        self.timestampLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.timestampLabel];
        
        newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont systemFontOfSize:12.f];
        self.statusInfoLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.statusInfoLabel];
        
        self.captionLabel.frame = CGRectMake(20.f, 0.f, 150.f, 22.f);
        self.detailsTextLabel.frame  = CGRectMake(20.f, 23.f, 288.f, 30.f);
        self.timestampLabel.frame = CGRectMake(185.f, 0.f, 90.f, 21.f);
        self.statusInfoLabel.frame = CGRectMake(273.f, 0.f, 43.f, 21.f);
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
    TT_RELEASE_SAFELY(_item);
    TT_RELEASE_SAFELY(_captionLabel);
    TT_RELEASE_SAFELY(_detailsTextLabel);
    TT_RELEASE_SAFELY(_timestampLabel);
    TT_RELEASE_SAFELY(_statusInfoLabel);
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 55.f;
}

- (id)object {
    return _item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (object !=  _item) {
        TT_RELEASE_SAFELY(_item);
        
        if ([object isKindOfClass:[UTStatusInfoItem class]]) {
            _item = [object retain];
        }
        
        self.captionLabel.text = _item.caption;
        self.detailsTextLabel.text = _item.detaisText;
        self.timestampLabel.text = _item.timestamp;
        self.statusInfoLabel.text = _item.statusInfo;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.captionLabel.frame = CGRectMake(20.f, 0.f, 150.f, 22.f);
    self.detailsTextLabel.frame  = CGRectMake(20.f, 23.f, 288.f, 30.f);
    self.timestampLabel.frame = CGRectMake(185.f, 0.f, 90.f, 21.f);
    self.statusInfoLabel.frame = CGRectMake(273.f, 0.f, 43.f, 21.f);
}


@end
