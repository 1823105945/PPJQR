//
//  HomeLeftView.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/2.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "HomeLeftView.h"

static NSString *CELLID=@"CELLID";
@interface HomeLeftView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation HomeLeftView
-(void)_initHomeLeftView{
    self.dataSource=@[@"使用说明",@"意见反馈",@"当前版本"];
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MenuTVViewCell" bundle:nil] forCellReuseIdentifier:CELLID];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
