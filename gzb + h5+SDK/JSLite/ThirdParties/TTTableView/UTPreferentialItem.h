//
//  UTPreferentialItem.h
//  KK UI
//
//  Created by KK UI on 12-12-10.
//
//

#import "TTTableItem.h"

@interface UTPreferentialItem : TTTableItem {
    NSString    *_caption;
    NSString    *_details;
    id           _target;
}

@property (nonatomic, copy) NSString    *caption;
@property (nonatomic, copy) NSString    *details;
@property (nonatomic, assign) id        target;


/*!
 @method
 @abstract Constructor
 */
+ (id)itemWithCaption:(NSString *)caption details:(NSString *)details target:(id)target;



@end
