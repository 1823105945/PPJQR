//
//  MenuTVViewCell.h
//  PPJQR
//
//  Created by liu_yakai on 17/4/20.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTVViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellIamgeView;
@property (weak, nonatomic) IBOutlet UILabel *cellLable;
-(void)_initCell:(NSDictionary *)dic;
@end
