//
//  PDRightCollectionView.m
//  ProductMenu
//
//  Created by Administrator on 16/2/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "PDRightCollectionView.h"
#import "PDColelctionCell.h"
#import "PDMenuHeader.h"


static NSString *kPDColelctionCellID = @"kPDColelctionCellID";
@implementation PDRightCollectionView

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (PDMENU_IOS7) {
        layout.minimumInteritemSpacing = 2.5f;
        layout.minimumLineSpacing = 2.5f;
    }else{
        layout.minimumInteritemSpacing = 0.5f;
        layout.minimumLineSpacing = 0.5f;
    }
//    layout.itemSize = CGSizeMake(106.f, CELL_HEIGHT);
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGRect r = self.frame;
        r.origin = CGPointMake(0, 0);
        self.collectionView = [[UICollectionView alloc] initWithFrame:r collectionViewLayout:layout];
        self.collectionView.backgroundColor = RIGHT_BACK_COLOR;
        [self.collectionView registerNib:[UINib nibWithNibName:@"PDColelctionCell" bundle:nil] forCellWithReuseIdentifier:kPDColelctionCellID];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = NO;
        [self addSubview:self.collectionView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setDataList:(NSMutableArray *)dataList{
    _dataList = dataList;
    
    CGRect r = self.collectionView.frame;
    r.size.height = _dataList.count / 2 * CELL_HEIGHT;
    self.collectionView.frame = r;
}


#pragma -mark -- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"count:%d",_dataList.count);
    return _dataList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PDColelctionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPDColelctionCellID forIndexPath:indexPath];
    NSString *title = _dataList[indexPath.row];
    CGRect r = CGRectMake(0, 0,106, CELL_HEIGHT - 1);
    int lineIndex = (int)(indexPath.row / 2);
    BOOL bEvenNumber = indexPath.row % 2 == 0 ? YES : NO;
    float x = bEvenNumber ? 0 : cell.frame.size.width + 1;
    float y = lineIndex * CELL_HEIGHT;
    r.origin = CGPointMake(x,y + 1);
    cell.frame = r;
    cell.tag = indexPath.row;
    cell.lbtitle.text = title;
    cell.model = title;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(106.f, CELL_HEIGHT);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1, 0, 0, 0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PDColelctionCell *cell = (PDColelctionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.clicked) {
        self.clicked(cell.model);
    }
}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
@end
