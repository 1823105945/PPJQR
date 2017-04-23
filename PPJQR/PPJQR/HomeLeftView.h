//
//  HomeLeftView.h
//  PPJQR
//
//  Created by liu_yakai on 17/4/2.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeLeftView : UIView

@property(nonatomic,copy)void (^ HomeLeftClock)();
@property(nonatomic,copy)void (^ LeftClockCell)(NSInteger index);
@property(nonatomic,copy)void (^ HomeLeftFootClock)(NSInteger index);
-(void)_initHomeLeftView;
@end
