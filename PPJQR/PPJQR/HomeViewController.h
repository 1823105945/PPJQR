//
//  HomeViewController.h
//  PPJQR
//
//  Created by liu_yakai on 17/4/2.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//



#import "BaseViewController.h"

typedef NS_OPTIONS(NSInteger, SynthesizeType) {
    NomalType           = 5,//普通合成
    UriType             = 6, //uri合成
};


typedef NS_OPTIONS(NSInteger, Status) {
    NotStart            = 0,
    Playing             = 2, //高异常分析需要的级别
    Paused              = 4,
};

@interface HomeViewController : BaseViewController

@end
