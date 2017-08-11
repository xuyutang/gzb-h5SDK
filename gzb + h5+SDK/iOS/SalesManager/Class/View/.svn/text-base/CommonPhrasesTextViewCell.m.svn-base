//
//  TextViewCell.m
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "CommonPhrasesTextViewCell.h"
#import "CommonPhrasesListViewController.h"
#import "Constant.h"
#import "UIView+Util.h"

@implementation CommonPhrasesTextViewCell
@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{

    if(self = [super init]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 40)];
        recordLabel.text = @"现场记录：";
        recordLabel.font = [UIFont systemFontOfSize:14];
        recordLabel.textColor = [UIColor lightGrayColor];
        textView = [[PlaceTextView alloc] initWithFrame:CGRectMake(15, 40, 260, 70)];
        textView.placeHolder = @"必填（1000字以内）";
        
        textView.backgroundColor = WT_CLEARCOLOR;
        
        [self addSubview:recordLabel];
        [self addSubview:textView];
        UIButton *addBUtton = [UIButton buttonWithType:UIButtonTypeCustom];

        addBUtton.frame = CGRectMake(MAINWIDTH - 50, 100, 20, 20);
        [addBUtton addTarget:self action:@selector(addAction)
            forControlEvents:UIControlEventTouchUpInside];
        [addBUtton setImage:[UIImage imageNamed:@"ic_plus"] forState:UIControlStateNormal];
         [self addSubview:addBUtton];
        UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, MAINWIDTH - 200, 40)];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 5)];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, MAINWIDTH - 80, 0.5)];
        UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 60 - 0.5, 10, 0.5, 5)];
        view1.backgroundColor = [UIColor grayColor];
        view2.backgroundColor = [UIColor grayColor];
        view3.backgroundColor = [UIColor grayColor];
        
        [contView addSubview:view1];
        [contView addSubview:view2];
        [contView addSubview:view3];
        [self addSubview:contView];
        
        

//        if (IOS7) {
//            iconBtn = [[IconButton alloc] initWithFrame:CGRectMake(320 - 35, 110 / 2 - 15, 30, 30)];
//        }else{
//            iconBtn = [[IconButton alloc] initWithFrame:CGRectMake(320 - 40, 110 / 2 - 15, 30, 30)];
//        }
//        iconBtn.icon = ICON_PLUS;
//        iconBtn.backgroundColor = WT_CLEARCOLOR;
//        iconBtn.clicked = ^(NSInteger tag){
//            CommonPhrasesListViewController *listVC = [[CommonPhrasesListViewController alloc] init];
//            listVC.bSelect = YES;
//            listVC.bNeedBack = YES;
//            listVC.selectedItem = ^(FavoriteLang *item){
//                if (item != nil) {
//                    self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,item.commonLang];
//                }
//            };
//            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:listVC];
//            [((UIViewController*)[UIView findViewController:self]) presentViewController:navCtrl animated:YES completion:nil];
//            [listVC release];
//            [navCtrl release];
//            
//        };
//      //  [self addSubview:iconBtn];
//    }
    }
    return self;
}

-(void)addAction {
    CommonPhrasesListViewController *listVC = [[CommonPhrasesListViewController alloc] init];
    listVC.bSelect = YES;
    listVC.bNeedBack = YES;
    listVC.selectedItem = ^(FavoriteLang *item){
        if (item != nil) {
            self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,item.commonLang];
        }
    };
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:listVC];
    [((UIViewController*)[UIView findViewController:self]) presentViewController:navCtrl animated:YES completion:nil];
    [listVC release];
    [navCtrl release];
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc{
    //[textView release];
    //[iconBtn release];
    [super dealloc];
}

@end
