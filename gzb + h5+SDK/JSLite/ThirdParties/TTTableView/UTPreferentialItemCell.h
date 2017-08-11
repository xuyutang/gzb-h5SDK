//
//  UTPreferentialItemCell.h
//  KK UI
//
//  Created by KK UI on 12-12-10.
//
//

#import "TTTableViewCell.h"

@class UTPreferentialItem;

@interface UTPreferentialItemCell : TTTableViewCell {
    UTPreferentialItem *_item;
 @private
    UIImageView     *_titleBackgroundImageView;
    UILabel         *_captionLabel;
    UILabel         *_detailsLabel;
    UIButton        *_preferentialButton;
}

@property (nonatomic, retain) UTPreferentialItem    *item;
@property (nonatomic, retain) UILabel               *captionLabel;
@property (nonatomic, retain) UILabel               *detailsLabel;
@property (nonatomic, retain) UIButton              *preferentialButton;

@end
