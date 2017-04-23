//
//  BaseView.h
//  HYJDriver
//
//  Created by test on 16/2/22.
//  Copyright © 2016年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
//提示窗体
+(void)_init:(NSString *)title;

+(BaseView *)baseShar;

-(void)_initPop:(UIView *)popView Type:(NSInteger)type;

-(void)dissMissPop:(BOOL)animated;
@end
