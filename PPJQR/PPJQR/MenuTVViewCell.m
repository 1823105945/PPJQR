//
//  MenuTVViewCell.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/20.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "MenuTVViewCell.h"
#import "Tools.h"
#import "PPJQR.h"

@implementation MenuTVViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)_initCell:(NSDictionary *)dic{
    NSString *key=[Tools strPec:[dic allKeys]];
    self.cellIamgeView.image=SETIMAGENAME([dic valueForKey:key]);
    self.cellLable.text=key;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
