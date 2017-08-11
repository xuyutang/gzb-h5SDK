//
//  CommonPrasesCellHeaderView.h
//  SalesManager
//
//  Created by Administrator on 15/12/24.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonPhrasesCellHeaderView : UIView
{
    UILabel *lbTitle;
}

@property (nonatomic,retain) NSString *headerTitle;
@property (nonatomic,copy) void(^selectedItem) (FavoriteLang *favoriteLang);
@end
