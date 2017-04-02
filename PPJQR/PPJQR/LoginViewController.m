//
//  ViewController.m
//  PPJQR
//
//  Created by liu_yakai on 17/3/30.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginClock:(id)sender {
    
    [self performSegueWithIdentifier:@"Home" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
