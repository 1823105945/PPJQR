//
//  HomeLeftView.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/2.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "HomeLeftView.h"
#import "MenuTVViewCell.h"
#import "HeatView.h"
#import "FootView.h"

static NSString *CELLID=@"CELLID";
@interface HomeLeftView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation HomeLeftView
-(void)_initHomeLeftView{
    self.leftTableView.delegate=self;
    self.leftTableView.dataSource=self;
    self.dataSource=@[@{@"使用说明":@"侧栏_15"},@{@"意见反馈":@"侧栏_19"},@{@"当前版本  1.0":@"侧栏_06"}];
    [self.leftTableView registerNib:[UINib nibWithNibName:@"MenuTVViewCell" bundle:nil] forCellReuseIdentifier:CELLID];
    FootView *footView=[[[NSBundle mainBundle]loadNibNamed:@"FootView" owner:self options:nil]lastObject];
    footView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/1.5-10);
    footView.ClockFoot=^(NSInteger Index){
        if (self.HomeLeftFootClock) {
            self.HomeLeftFootClock(Index);
        }
    };
    footView.ClockFoot=^(NSInteger Index){
        NSLog(@"sdlkfl");
    };
    self.leftTableView.tableFooterView=footView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     HeatView*heatView=[[[NSBundle mainBundle]loadNibNamed:@"HeatView" owner:self options:nil]lastObject];
    heatView.Clock=^(){
        if (self.HomeLeftClock) {
            self.HomeLeftClock();
        }
    };
    
    return heatView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTVViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    [cell _initCell:[self.dataSource objectAtIndex:indexPath.row]];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.LeftClockCell) {
        self.LeftClockCell(indexPath.row);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden=YES;
}

@end
