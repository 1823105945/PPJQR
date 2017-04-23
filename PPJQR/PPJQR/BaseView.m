//
//  BaseView.m
//  HYJDriver
//
//  Created by test on 16/2/22.
//  Copyright © 2016年 test. All rights reserved.
//

#import "BaseView.h"
#import "Toast+UIView.h"
#import "AppDelegate.h"
#import "KLCPopup.h"

@interface BaseView (){
    KLCPopup *popup;
}


@end

static BaseView *baseView;
@implementation BaseView

+(BaseView *)baseShar{
    if (baseView==nil) {
        baseView=[[BaseView alloc]init];
        
    }
    return baseView;
}


+(void)_init:(NSString *)title{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.window makeToast:title duration:2 position:@"center"];
}

/**
 *  动画弹窗动画类
 *
 *  @param popView 动画的view
 *  @param type    动画类型（1，2，3，。。。。）KLCPopupShowTypeNone = 0,
	KLCPopupShowTypeFadeIn,
 KLCPopupShowTypeGrowIn,
 KLCPopupShowTypeShrinkIn,
 KLCPopupShowTypeSlideInFromTop,
 KLCPopupShowTypeSlideInFromBottom,
 KLCPopupShowTypeSlideInFromLeft,
 KLCPopupShowTypeSlideInFromRight,
 KLCPopupShowTypeBounceIn,
 KLCPopupShowTypeBounceInFromTop,
 KLCPopupShowTypeBounceInFromBottom,
 KLCPopupShowTypeBounceInFromLeft,
 KLCPopupShowTypeBounceInFromRight,
 */
-(void)_initPop:(UIView *)popView Type:(NSInteger)type{
    if (popup!=nil) {
        [self dissMissPop:YES];
    }
    
    popup = [KLCPopup popupWithContentView:popView
                                  showType:type
                               dismissType:KLCPopupDismissTypeNone
                                  maskType:KLCPopupMaskTypeDimmed
                  dismissOnBackgroundTouch:YES
                     dismissOnContentTouch:NO];
    
    
    [popup show];
    
}

/**
 *  动画消失类
 *
 *  @param animated 是否动画消失yes   no
 */
-(void)dissMissPop:(BOOL)animated{
    [popup dismiss:animated];
    popup=nil;
}

@end
