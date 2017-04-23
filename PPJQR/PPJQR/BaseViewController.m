//
//  BaseViewController.m
//  PPJQR
//
//  Created by liu_yakai on 17/3/30.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "BaseViewController.h"
#import "PPJQR.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithImage:SETIMAGENAME(@"登录1_03_03") style:UIBarButtonItemStylePlain target:self action:@selector(blackController)];
    self.navigationItem.leftBarButtonItem=item;
}

-(void)blackController{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)homeNaviUI{
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithImage:SETIMAGENAME(@"首页-查看2_02") style:UIBarButtonItemStylePlain target:self action:@selector(mulist)];
    self.navigationItem.leftBarButtonItem=item;
}

-(void)rightUI{
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(Submit)];
    self.navigationItem.rightBarButtonItem=item;
}

-(void)Submit{

}

-(void)mulist{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
