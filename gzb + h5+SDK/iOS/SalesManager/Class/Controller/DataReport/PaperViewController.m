//
//  PaperViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/8/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "PaperViewController.h"
#import "DataReportMenuBtn.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "DataReportViewController.h"
#import "NoPaperViewController.h"
#import "UIView+CNKit.h"

@class AppDelegate;
@interface PaperViewController () {
    UIScrollView *_menuView;
    UIView *rightView;
    AppDelegate* appDelegate;
    NSMutableArray *paperTypes;
    NSMutableArray *menuTitles;
    NSMutableArray *dataMulArray;
    NSString *defaultTempleStr;
}

@end

@implementation PaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WT_WHITE;
    paperTypes = [[NSMutableArray alloc]init];
 
    paperTypes = [[LOCALMANAGER getPaperTemplates] retain];
  ;
    menuTitles = [[NSMutableArray alloc]init];
    dataMulArray = [[NSMutableArray alloc]init];
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    UIImageView *refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [refreshImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_refresh:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    refreshImageView.userInteractionEnabled = YES;
    [refreshImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:refreshImageView];
    [refreshImageView release];

    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    self.rightButton = btRight;
    [btRight release];
    
    //同步后及时更新界面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUI)
                                                 name:SYNC_PAPER_TEMPLE
                                               object:nil];

    //同步默认模板
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncDefaultTemple)
                                                 name:SYNC_PAPER_DEFAULT
                                               object:nil];

    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 0.3)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:viewLine];
    [self createDataReportMenu];
    [lblFunctionName setText:TITLENAME_TEMPLATE(FUNC_PAPER_POST_DES)];
    [self toRefresh:nil];
    // Do any additional setup after loading the view.
}

-(void)syncDefaultTemple {
[LOCALMANAGER favPaperTemplate:defaultTempleStr];
}

-(void)_refresh:(id)sender {
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    if (DONE != [AGENT sendRequestWithType:ActionTypePaperTemplateList param:@""]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PAPER_POST_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }

}

-(void)refreshUI {
    [self toRefresh:nil];
}

#pragma mark 刷新操作
-(void)toRefresh:(id)sender {
    
    if(paperTypes == nil){
        
        paperTypes = [[NSMutableArray  alloc] init];
    }else{
        [paperTypes removeAllObjects];
    }
    
    paperTypes = [[LOCALMANAGER getPaperTemplates] retain];
    
    [menuTitles removeAllObjects];
    [dataMulArray removeAllObjects];
    [_menuView removeFromSuperview];
    [paperTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [menuTitles addObject: ((PaperTemplate*)obj).name];
        // json 相关的字段
        [dataMulArray addObject: ((PaperTemplate*)obj)];
        
        
    }];

    if (paperTypes.count == 0) {
        [self _refresh:nil];
    }else{
        [self createDataReportMenu];
    }
}

#pragma mark 模板选择菜单
-(void)createDataReportMenu {

    CGFloat menuViewW = self.view.frame.size.width;
    CGFloat spacing   = 1;
    CGFloat menuW = (menuViewW - (spacing * 4)) / 3;
    CGFloat menuH = menuW;
 //   CGFloat menuViewH = menuH * 3 + 2 * spacing ;
    CGFloat x = 0;
    CGFloat y = 0;
    _menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  0.3, menuViewW, MAINHEIGHT)];
    if (menuTitles.count % 3 == 0) {
         _menuView.contentSize = CGSizeMake(MAINWIDTH, menuTitles.count/3 * (menuH + 2*spacing));
    }else {
     _menuView.contentSize = CGSizeMake(MAINWIDTH, menuTitles.count/3  * (menuH + 2*spacing) + menuH + spacing);
    
    }
  
    _menuView.backgroundColor = [UIColor clearColor];
    for(NSInteger i = 0 ; i < menuTitles.count; i ++)
    {
        x = (i % 3) * (spacing + menuW);
        if(i > 0 && i % 3 == 0)
        {
            x = 0 ;
            y = y + menuH + spacing;
        }
        
        DataReportMenuBtn *btn = [[DataReportMenuBtn alloc] initWithFrame:CGRectMake(x, y, menuW, menuH)];;
        
        [btn.label setFrame:CGRectMake(0,0,50,50)];
        [btn.label setCenter:CGPointMake(menuW/2 + 5, menuW/2)];
        btn.label.font = [UIFont fontWithName:kFontAwesomeFamilyName size:35];
        btn.label.text = [NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD];
        btn.label.textColor = WT_RED;
        
        
        [btn.titlelabel setFrame:CGRectMake(50,0,menuW - 10,40)];
        [btn.titlelabel setCenter:CGPointMake(menuW/2 + 8, menuW)];
       
        btn.titlelabel.lineBreakMode = UILineBreakModeWordWrap;
        btn.titlelabel.numberOfLines = 0;
      
        btn.titlelabel.font = [UIFont systemFontOfSize:15];
        btn.titlelabel.text = menuTitles[i];
        
        [btn.titlelabel sizeToFit];
        btn.titlelabel.centerX = menuW/2;
        btn.titlelabel.textAlignment = 1;
        btn.backgroundColor = [UIColor clearColor];
     
        btn.tag = 1000 + i;
        
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"%@", NSStringFromCGRect(btn.frame));
        [_menuView addSubview:btn];
    }
    
    [self.view addSubview:_menuView];
}

#pragma mark 模板被点击
-(void)menuClick:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    [LOCALMANAGER favPaperTemplate:((PaperTemplate*)dataMulArray[btn.tag - 1000]).id];
    defaultTempleStr = ((PaperTemplate*)dataMulArray[btn.tag - 1000]).id;
    [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_PAPER_POST Object:dataMulArray[btn.tag - 1000] Delegate:nil NeedBack:YES];
}

-(void)clickLeftButton:(id)sender {
 
   if (paperTypes.count == 0 || [LOCALMANAGER getFavPaperTempate] == nil) {
        NoPaperViewController *noPaperVC = [[NoPaperViewController alloc]init];
        [self.navigationController pushViewController:noPaperVC animated:YES];
     //   [super clickLeftButton:sender];
    }else {
      [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE( cr.type)) {
        case ActionTypePaperTemplateList:{
           
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                PBAppendableArray* templates = [[PBAppendableArray alloc] autorelease];
                for (int i = 0; i < cr.datas.count; ++i) {
                    PaperTemplate* pt = [PaperTemplate parseFromData:[cr.datas objectAtIndex:i]];
                    [templates addObject:pt];
                }
                
                if (templates.count > 0) {
                  [LOCALMANAGER savePaperTemplates:templates];
                  [self toRefresh:nil];
                }
            }
            
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
