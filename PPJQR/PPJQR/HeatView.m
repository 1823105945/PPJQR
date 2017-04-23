//
//  HeatView.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/20.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "HeatView.h"

@implementation HeatView


- (IBAction)HeatClockButton:(id)sender {
    if (self.Clock) {
        self.Clock();
    }
}

@end
