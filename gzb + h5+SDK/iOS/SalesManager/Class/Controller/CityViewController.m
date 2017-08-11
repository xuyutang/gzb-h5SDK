//
//  CityViewController.m
//  SalesManager
//
//  Created by Administrator on 16/4/14.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "CityViewController.h"
#import "Constant.h"
#import "City.h"
#import "DropMenu.h"

@interface CityViewController ()<DropMenuDelegate>
{
    NSArray *provinces, *cities, *areas;
    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;
    NSMutableArray *areaArray;
    DropMenu *dropMenu4;
    
    Province *p;
    City *c;
    Area *a;
}
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(loadCityData) withObject:nil afterDelay:.2f];
    
    [self.lblFunctionName setText:NSLocalizedString(@"city_view_title", nil)];
    [self loadCityData];
    
    dropMenu4 = [[DropMenu alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH,MAINHEIGHT)];
    dropMenu4.delegate = self;
    dropMenu4.menuCount = 3;
    
    dropMenu4.array1 = [[NSMutableArray alloc] init];
//    [dropMenu4.array1 addObject:@"全部"];
    for (NSDictionary *p in provinces) {
        [dropMenu4.array1 addObject:[p objectForKey:@"province"]];
    }
    
    dropMenu4.array2 = [[NSMutableArray alloc] init];
    dropMenu4.array3 = [[NSMutableArray alloc] init];
    [dropMenu4 initMenu];
    [self.view addSubview:dropMenu4];
}

-(void)selectedDropMenuIndex:(int)index row:(int)row{
    if (index == 1) {
        p = (Province *)[provinces objectAtIndex:row];
        cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
        [dropMenu4.array2 removeAllObjects];
        for (NSDictionary *c in cities) {
            [dropMenu4.array2 addObject:[c objectForKey:@"city"]];
        }
        if (cities.count > 0)
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
        [dropMenu4.array3 removeAllObjects];
        [dropMenu4.tableView2 reloadData];
        [dropMenu4.tableView3 reloadData];
    }else if (index == 2){
        c = (City *)[cities objectAtIndex:row];
        areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
        [dropMenu4.array3 removeAllObjects];
        for (Area *a in areas) {
            [dropMenu4.array3 addObject:a.name];
        }
        [dropMenu4.tableView3 reloadData];
    }else if (index == 3){
        a = [areas objectAtIndex:row];
        if (self.selected) {
            self.selected(p,c,a);
        }
        [self.navigationController popViewControllerAnimated:YES];
  //      [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCityData{
    
    SHOWHUD;
    NSMutableArray* p = [LOCALMANAGER getProvinces];
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    provinceArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < p.count; i++) {
        Province *province = (Province*)[p objectAtIndex:i];
        NSMutableArray* c = [LOCALMANAGER getCities:province.name];
        NSMutableArray* cArray = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < c.count; j++) {
            City *city = (City *)[c objectAtIndex:j];
            NSMutableArray* a = [LOCALMANAGER getAreas:city.name];
            NSMutableDictionary *aDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:a,@"areas",city.name,@"city",[NSString stringWithFormat:@"%d",city.id],@"cityId", nil];
            [cArray addObject:aDict];
            
        }
        
        NSMutableDictionary *cDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:cArray,@"cities",province.name,@"province",[NSString stringWithFormat:@"%d",province.id],@"provinceId", nil];
        [pArray addObject:cDict];
        
        [provinceArray addObject:province.name];
    }
    NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:pArray,@"provinces", nil];
    
    
    provinces = [addressDict objectForKey:@"provinces"];
    cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
    areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
    HUDHIDE2;
}
@end
