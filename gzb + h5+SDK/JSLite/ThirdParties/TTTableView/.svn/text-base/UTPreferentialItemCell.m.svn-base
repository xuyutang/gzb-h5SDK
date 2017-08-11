//
//  UTPreferentialItemCell.m
//  KK UI
//
//  Created by KK UI on 12-12-10.
//
//

#import "UTPreferentialItemCell.h"
#import "TTCorePreprocessorMacros.h"
#import "UTPreferentialItem.h"


@implementation UTPreferentialItemCell
@synthesize item = _item;
@synthesize captionLabel = _captionLabel;
@synthesize detailsLabel = _detailsLabel;
@synthesize preferentialButton = _preferentialButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        //Build cell subviews
        _titleBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_titleBackgroundImageView setImage:[UIImage imageNamed:@"cake_hdbg.png"]];
        [self.contentView addSubview:_titleBackgroundImageView];
        
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont boldSystemFontOfSize:17.f];
        self.captionLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.captionLabel];
        
        newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont systemFontOfSize:14.f];
        newLabel.textColor = RGBCOLOR(79, 89, 105);
        newLabel.numberOfLines = 3;
        self.detailsLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.detailsLabel];
        
        _preferentialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preferentialButton setBackgroundImage:[UIImage imageNamed:@"cake_yhxf@2x.png"]
                                       forState:UIControlStateNormal];
        [self.contentView addSubview:_preferentialButton];
        
        _titleBackgroundImageView.frame = CGRectMake(1.f, 5.f, 271.f, 33.f);
        self.captionLabel.frame = CGRectMake(45.f, 11.f, 213.f, 21.f);
        self.detailsLabel.frame  = CGRectMake(20.f, 34.f, 185.f, 55.f);
        self.preferentialButton.frame = CGRectMake(200.f, 50.f, 95.f, 34.f);
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //Build cell subviews
        _titleBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_titleBackgroundImageView setImage:[UIImage imageNamed:@"cake_hdbg.png"]];
        [self.contentView addSubview:_titleBackgroundImageView];
        
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont boldSystemFontOfSize:17.f];
        self.captionLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.captionLabel];
        
        newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = [UIFont systemFontOfSize:14.f];
        newLabel.textColor = RGBCOLOR(79, 89, 105);
        self.detailsLabel = newLabel;
        [newLabel release];
        [self.contentView addSubview:self.detailsLabel];
        
        _preferentialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preferentialButton setBackgroundImage:[UIImage imageNamed:@"cake_yhxf@2x.png"]
                                       forState:UIControlStateNormal];
        [self.contentView addSubview:_preferentialButton];
        
        _titleBackgroundImageView.frame = CGRectMake(1.f, 5.f, 271.f, 33.f);
        self.captionLabel.frame = CGRectMake(45.f, 11.f, 213.f, 21.f);
        self.detailsLabel.frame  = CGRectMake(20.f, 34.f, 185.f, 55.f);
        self.preferentialButton.frame = CGRectMake(200.f, 50.f, 95.f, 34.f);
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_item);
    TT_RELEASE_SAFELY(_titleBackgroundImageView);
    TT_RELEASE_SAFELY(_captionLabel)
    TT_RELEASE_SAFELY(_detailsLabel);
    [super dealloc];
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 90.f;
}

- (id)object {
    return _item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (object !=  _item) {
        TT_RELEASE_SAFELY(_item);
        
        if ([object isKindOfClass:[UTPreferentialItem class]]) {
            _item = [object retain];
        }
        
        self.captionLabel.text = _item.caption;
        self.detailsLabel.text = _item.details;
        if (_item.target != nil && [_item.target respondsToSelector:@selector(preferentialButtonPressed)]) {
            [self.preferentialButton addTarget:_item.target action:@selector(preferentialButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleBackgroundImageView.frame = CGRectMake(1.f, 5.f, 271.f, 33.f);
    self.captionLabel.frame = CGRectMake(45.f, 11.f, 213.f, 21.f);
    self.detailsLabel.frame  = CGRectMake(20.f, 34.f, 185.f, 55.f);
    self.preferentialButton.frame = CGRectMake(200.f, 50.f, 95.f, 34.f);
}



@end
