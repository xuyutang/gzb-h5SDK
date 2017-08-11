//
//  CustomTransition.m
//  KYPresentationControllerDemo
//
//  Created by Kitten Yang on 2/1/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "CustomTransition.h"
#import "WTPrintViewController.h"

@interface CustomTransition()

@property(nonatomic,assign)BOOL isPresenting;
@property(nonatomic,strong)UIView *containerView;

@end

@implementation CustomTransition


//定义一个类的 property,用来区别我们到底现在是 呈现 还是 消失

-(id)initWithBool:(BOOL)ispresenting{
    self = [super init];
    if (self) {
        self.isPresenting = ispresenting;               }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //iOS7 的处理
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 ) {
        //Create the differents 3D animations
        CATransform3D viewFromTransform;
        CATransform3D viewToTransform;
        
        UIView *generalContentView = [transitionContext containerView];
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        
        viewFromTransform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0);
        viewToTransform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0);
        [toView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [fromView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        toView.layer.transform = viewToTransform;
        
        //Add the to- view
        [generalContentView addSubview:toView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            [generalContentView setTransform:CGAffineTransformMakeTranslation(-generalContentView.frame.size.width/2.0, 0)];
            
            fromView.layer.transform = viewFromTransform;
            toView.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            //Set the final position of every elements transformed
            [generalContentView setTransform:CGAffineTransformIdentity];
            fromView.layer.transform = CATransform3DIdentity;
            toView.layer.transform = CATransform3DIdentity;
            [fromView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
            [toView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
            
            if ([transitionContext transitionWasCancelled]) {
                [toView removeFromSuperview];
            } else {
                [fromView removeFromSuperview];
            }
            
            // inform the context of completion  
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];  
            
            }];
        
      }else {
        if (self.isPresenting) {
            WTPrintViewController *toVC = (WTPrintViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            
            self.containerView = [transitionContext containerView];
            //设定presented view 一开始的位置，在屏幕下方
            CGRect initialframe = [transitionContext finalFrameForViewController:toVC];
            CGRect startframe = CGRectOffset(initialframe, 0, initialframe.size.height);
            toView.frame = startframe;
            //[self.containerView addSubview:toView];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                
                //secondviewcontroller 滑上来
                toView.frame = initialframe;
                
            } completion:^(BOOL finished) {
                if (finished) {
                    
                    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                }
            }];
        }else{
            UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
            
            self.containerView = [transitionContext containerView];
            [self.containerView addSubview:toView];
            
            // 添加一个动画，让要消失的 view 向下移动，离开屏幕
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                
                //secondviewcontroller 滑下去
                CGRect finalframe = fromView.frame;
                finalframe.origin.y = self.containerView.bounds.size.height;
                fromView.frame = finalframe;
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [transitionContext completeTransition:![transitionContext transitionWasCancelled] || ![transitionContext isInteractive]];
                }
                
            }];
        }
    }
}

@end
