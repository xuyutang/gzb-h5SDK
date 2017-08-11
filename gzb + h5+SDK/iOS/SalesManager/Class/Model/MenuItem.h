//
//  MenuItem.h
//  SalesManager
//
//  Created by liu xueyan on 7/30/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@interface MenuItem : NSObject{

    NSString *image;
    NSString *name;
    int functionId;
    int row;

}

@property(nonatomic,retain) NSString *image;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,assign) int functionId;
@property(nonatomic,assign) int row;

@end
