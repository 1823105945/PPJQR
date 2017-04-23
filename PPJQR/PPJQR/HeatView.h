//
//  HeatView.h
//  PPJQR
//
//  Created by liu_yakai on 17/4/20.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeatView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *HeatImageView;
@property (weak, nonatomic) IBOutlet UIButton *HeatButton;
@property(nonatomic,copy)void (^ Clock)();

@end
