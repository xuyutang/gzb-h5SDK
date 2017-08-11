//
//  PDRightCollectionView.h
//  ProductMenu
//
//  Created by Administrator on 16/2/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDRightCollectionView : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,copy) void(^clicked) (id);
@end
