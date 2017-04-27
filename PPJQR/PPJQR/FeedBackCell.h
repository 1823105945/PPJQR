//
//  FeedBackCell.h
//  PPJQR
//
//  Created by liu_yakai on 17/4/24.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLable;
@property (weak, nonatomic) IBOutlet UIButton *cellButton;
-(void)_initCell:(NSString *)title Type:(BOOL)type Inddex:(NSInteger)index;
@property(nonatomic,copy)void (^ ClockCell)(NSInteger Index);
@end
