//
//  FeedBackView.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/23.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "FeedBackView.h"
#import "FeedBackCell.h"
#import "PPJQR.h"
#import "BaseView.h"

static NSString *CELLID=@"CELLID";
@interface FeedBackView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *bootArray;
    NSArray *array;
    __weak IBOutlet UITableView *feedTableView;
}
@end


@implementation FeedBackView

-(void)_init{
    bootArray=[[NSMutableArray alloc]init];
    array=@[@"功能意见",@"页面意见",@"新的需求",@"操作意见",@"流量问题",@"其他"];
    [feedTableView registerNib:[UINib nibWithNibName:@"FeedBackCell" bundle:nil] forCellReuseIdentifier:CELLID];
    feedTableView.delegate=self;
    feedTableView.dataSource=self;
    for (int i=0; i<array.count; i++) {
        if (i==0) {
             [bootArray addObject:[NSNumber numberWithBool:YES]];
        }else  [bootArray addObject:[NSNumber numberWithBool:NO]];
       
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel*heatView=[[UILabel alloc]init];
    heatView.text=@"  反馈类型";
    heatView.backgroundColor=RGBA(239, 204, 79, 1);
    heatView.font=[UIFont systemFontOfSize:14];
    return heatView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedBackCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell _initCell:[array objectAtIndex:indexPath.row] Type:[[bootArray objectAtIndex:indexPath.row] boolValue]Inddex:indexPath.row];
    cell.ClockCell=^(NSInteger Index){
        for (int i=0; i<array.count; i++) {
            if (i==Index) {
                [bootArray replaceObjectAtIndex:Index withObject:[NSNumber numberWithBool:YES]];
            }else  [bootArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            
        }
        [feedTableView reloadData];
        [[BaseView baseShar]dissMissPop:YES];
        self.title=[array objectAtIndex:indexPath.row];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[BaseView baseShar]dissMissPop:YES];
}


@end
