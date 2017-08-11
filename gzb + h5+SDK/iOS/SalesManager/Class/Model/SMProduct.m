//
//  SMProduct.m
//  SalesManager
//
//  Created by liuxueyan on 14-11-25.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "SMProduct.h"

@implementation SMProduct
@synthesize productArray;
@synthesize category;
@synthesize bExpand;

-(id)init{
    
    if (self = [super init]) {
        //self.category = [[CustomerCategory alloc] init];
        //self.customerArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
