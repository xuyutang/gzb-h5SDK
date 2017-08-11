//
//  UIImageView+SDWebCache.m
//  SDWebData
//
//  Created by stm on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SDImageView+SDWebCache.h"
typedef NS_ENUM(NSInteger, NSPUIImageType)
{
    NSPUIImageType_JPEG,
    NSPUIImageType_PNG,
    NSPUIImageType_Unknown
};
static inline NSPUIImageType NSPUIImageTypeFromData(NSData *imageData)
{
    if (imageData.length > 4) {
        const unsigned char * bytes = [imageData bytes];
        
        if (bytes[0] == 0xff &&
            bytes[1] == 0xd8 &&
            bytes[2] == 0xff)
        {
            return NSPUIImageType_JPEG;
        }
        
        if (bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4e &&
            bytes[3] == 0x47)
        {
            return NSPUIImageType_PNG;
        }
    }
    
    return NSPUIImageType_Unknown;
}

@implementation UIImageView(SDWebCacheCategory)

- (void)setImageWithURL:(NSURL *)url
{
	[self setImageWithURL:url refreshCache:NO];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache
{
	[self setImageWithURL:url refreshCache:refreshCache placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder
{
    SDWebDataManager *manager = [SDWebDataManager sharedManager];
	
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
	
    self.image = placeholder;
	
    if (url)
    {
        [manager downloadWithURL:url delegate:self refreshCache:refreshCache];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebDataManager sharedManager] cancelForDelegate:self];
}

#pragma mark -
#pragma mark SDWebDataManagerDelegate

- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData
{
    if (NSPUIImageTypeFromData(aData) != NSPUIImageType_Unknown){
        //UIImage *img=[UIImage imageWithData:aData];
        UIImage *img=[[UIImage alloc] initWithData:aData];
        self.image = img;
        [img release];
    }
}

- (void)webDataManager:(SDWebDataManager *)dataManager didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}

@end
