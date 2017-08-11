//
//  FavCustomerCell.m
//  SalesManager
//
//  Created by Administrator on 16/3/30.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "FavCustomerCell.h"

@implementation FavCustomerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        _bCheck = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void) initView{
    float wh = 20;
    float x = self.frame.size.width - 30;
    float y = 30;
    _favButton = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
    _favButton.userInteractionEnabled = YES;
    _favButton.image = [UIImage imageNamed:@"ic_favorite_on"];
    [self addSubview:_favButton];
    
    UILabel *btn = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 7, 70, self.frame.size.height)];
    [btn setUserInteractionEnabled:YES];
    btn.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *favAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favAction:)];
    favAction.numberOfTapsRequired = 1;
    [_favButton addGestureRecognizer:favAction];
    [favAction release];
    
    UITapGestureRecognizer *favAction2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favAction:)];
    favAction2.numberOfTapsRequired = 1;
    [btn addGestureRecognizer:favAction2];
    [favAction2 release];
    [self addSubview:btn];
    [btn release];
    
    _type = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 160 - 10, 5, 160, 20)];
    _type.textColor = [UIColor grayColor];
    _type.font = [UIFont systemFontOfSize:13.f];
    _type.textAlignment = UITextAlignmentRight;
    [self addSubview:_type];
    [_type release];
}

-(void) setFav:(BOOL) ist{
    if (ist) {
        _favButton.image = [UIImage imageNamed:@"ic_favorite_on"];
    }else{
        _favButton.image = [UIImage imageNamed:@"ic_favorite_off"];
    }
}


-(void) favAction:(id) sender{
    _bCheck = !_bCheck;
    [self setFav:_bCheck];
    if (self.click) {
        self.click(self);
    }
}

-(void)dealloc{
    [_cust release];
    [_favButton release];
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
