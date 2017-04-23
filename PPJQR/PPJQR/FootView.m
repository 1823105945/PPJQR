//
//  FootView.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/20.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "FootView.h"

@implementation FootView
- (IBAction)footClockButton:(id)sender {
    UIButton *button=(UIButton *)sender;
    if (self.ClockFoot) {
        self.ClockFoot(button.tag);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
