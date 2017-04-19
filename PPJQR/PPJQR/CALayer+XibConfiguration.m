//
//  CALayer+XibConfiguration.m
//  SAAS
//
//  Created by test on 16/5/26.
//  Copyright © 2016年 test. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)
-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}
-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
