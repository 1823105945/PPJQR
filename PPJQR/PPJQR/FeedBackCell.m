//
//  FeedBackCell.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/24.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "FeedBackCell.h"

@implementation FeedBackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clockCell:(id)sender {
    UIButton *button=(UIButton *)sender;
    if (button.selected) {
        button.selected=NO;
    }else button.selected=YES;
    if (self.ClockCell) {
        self.ClockCell(button.tag);
    }
}

-(void)_initCell:(NSString *)title Type:(BOOL)type Inddex:(NSInteger)index{
    if (type) {
        self.cellButton.selected=YES;
    }else self.cellButton.selected=NO;
    self.cellLable.text=title;
    self.cellLable.font=[UIFont systemFontOfSize:13];
    self.cellButton.tag=index;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
