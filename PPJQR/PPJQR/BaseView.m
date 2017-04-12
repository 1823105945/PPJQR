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

@interface BaseView ()


@end

static BaseView *baseView;
@implementation BaseView

+(BaseView *)baseShar{
    if (baseView==nil) {
        baseView=[[BaseView alloc]init];
        
    }
    return baseView;
}


+(void)_init:(NSString *)title View:(UIView *)view{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.window makeToast:title duration:2 position:@"center"];
}


@end
