//
//  HintHelper.m
//  HintMakerExample
//
//  Created by Eric McConkie on 3/16/12.
/*
Copyright (c) 2012 Eric McConkie

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "HintHelper.h"
#import "NSBundle+JSLite.h"
#import "GlobalConstant.h"

@implementation HintHelper
#pragma mark --------------modal delegate
-(void)doNext{
    switch (_hintView) {
        case HintViewDashboard:
            switch (_curType) {
                case 0:
                    [modalState presentModalMessage:[NSBundle JSLocalizedString:@"hint_info" Comment:@""] where:_vc.navigationController.view];
                    break;
                case 1:
                    [modalState presentModalMessage:[NSBundle JSLocalizedString:@"hint_dashboard_person" Comment:@""] where:_vc.navigationController.view];
                    break;
                case 2:
                    [modalState presentModalMessage:[NSBundle JSLocalizedString:@"hint_dashboard_item" Comment:@""] where:_vc.navigationController.view];
                    break;
                case 3:
                    [modalState presentModalMessage:[NSBundle JSLocalizedString:@"hint_dashboard_menu_more" Comment:@""] where:_vc.navigationController.view];
                    break;
                }

            break;
        case HintViewAttendance:
            switch (_curType) {
                case 0:
                    [modalState presentModalMessage:[NSBundle JSLocalizedString:@"hint_gps" Comment:@""] where:_vc.navigationController.view];
                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }
}

#pragma mark --------------Hint Delegate
-(BOOL)hintStateShouldCloseIfPermitted:(id)hintState{
    _curType ++;
    if(_curType >= _hintCount){
        _curType = 0;//reset for next time
        return YES;
    }
    [self doNext];
    return NO;
}

-(void)hintStateWillClose:(id)hintState{
    
}

-(void)hintStateDidClose:(id)hintState{
   
}

-(CGRect)hintStateRectToHint:(id)hintState{
    CGFloat ht = 50.0;
    CGFloat statusBarHt = 20.0;
    CGRect rect;
    switch (_hintView) {
        case HintViewDashboard:
            switch (_curType) {
                case 0:
                    rect = CGRectMake(0,0,1,1);
                    break;
                case 1:
                    rect = CGRectMake(MAINWIDTH / 2, 90, 100,120);
                    break;
                case 2:
                    rect= CGRectMake(50, 220, 80, 80);
                    break;
                case 3:
                    rect = CGRectMake(25, ht/2,ht,ht);
                    break;
                default:
                    rect = CGRectMake(0, 0, 1, 1);
                    break;
            }

            break;
        case HintViewAttendance:
            switch (_curType) {
                case 0:
                    rect = CGRectMake(MAINWIDTH / 2,280,100,50);
                    break;
                default:
                    rect = CGRectMake(0, 0, 1, 1);
                    break;
            }
            
            break;
        default:
            break;
    }
    return rect;
}

- (id)initWithViewController:(UIViewController*)vc HintView:(EHintView) hintView{
    self = [super init];
    if (self) {
        _vc = vc;
        _hintView = hintView;
        _curType = 0;
        
        modalState = [[EMHint alloc] init];
        [modalState setHintDelegate:self];
        
        switch (_hintView) {
            case HintViewDashboard:
                _hintCount = 4;
                break;
            case HintViewAttendance:
                _hintCount = 1;
                break;
            default:
                break;
        }
        [self doNext];
    }
    return self;
}

-(UIView*)hintStateViewForDialog:(id)hintState{
    switch (_hintView) {
        case HintViewDashboard:{
            switch (_curType) {
                case 1:{
                    return [self showInfo:CGRectMake(50, 200, 240, 50) Info:[NSBundle JSLocalizedString:@"hint_dashboard_person" Comment:@""]];
                }
                    break;
                case 2:{
                    return [self showInfo:CGRectMake(50, 270, 240, 50) Info:[NSBundle JSLocalizedString:@"hint_dashboard_item" Comment:@""]];
                }
                    break;
                case 3:{
                    return [self showInfo:CGRectMake(50, 60, 240, 50) Info:[NSBundle JSLocalizedString:@"hint_dashboard_menu_more" Comment:@""]];
                }
                
                default:
                    break;
            }
            break;
        
        }
        case HintViewAttendance:{
            switch (_curType) {
                case 0:
                    return [self showInfo:CGRectMake(MAINWIDTH / 2 - 80, MAINHEIGHT - 100, 240, 140) Info:[NSBundle JSLocalizedString:@"hint_gps" Comment:@""]];
                    break;
                    
                default:
                    break;
            }
            
        }
            
        default:
            break;
    }
    return nil;
}

- (UIView*) showInfo:(CGRect) rect Info:(NSString*) info{
    UILabel *l = [[UILabel alloc] initWithFrame:rect];
    
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:info];
    return l;

}

- (void)dealloc {
    
    [modalState release];
    [super dealloc];
}

@end
