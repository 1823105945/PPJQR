//
//  ViewController.m
//  PPJQR
//
//  Created by liu_yakai on 17/3/30.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseView.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *pswField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginClock:(id)sender {
    if (self.userNameField.text.length==0) {
        [BaseView _init:@"请输入账号"];
    }else if(self.pswField.text.length==0){
        [BaseView _init:@"请输入密码"];
    }else{
        [self performSegueWithIdentifier:@"Home" sender:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
