//
//  StepTwoViewController.m
//  touch
//
//  Created by Ariel Xin on 1/15/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "StepTwoViewController.h"
#import "IHKeyboardAvoiding.h"
#import "CommonDefine.h"
#import "InsetTextField.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "User.h"
#import "UINavigationController+SGProgress.h"
#import "LoginViewController.h"

@interface StepTwoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet InsetTextField *major;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gender;
@property (weak, nonatomic) IBOutlet InsetTextField *classlevel;
@end

@implementation StepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    [self.view addGestureRecognizer:pan];
}

- (void)closeKeyboard:(id)sender {
    [self.major resignFirstResponder];
    [self.gender resignFirstResponder];
    [self.classlevel resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

//click "next" to finish the signup process
- (IBAction)nextStep:(id)sender {
    [ProgressHUD show:@"Signing Up" Interaction:NO];
    
    User *user=[User currentUser];
    user.major=self.major.text;
    user.classlevel=self.classlevel.text;
    if (self.gender.selectedSegmentIndex == 0)
        user.gender=@"female";
    else
        user.gender=@"male";
    
    //Signup in background, database record the username, password, major, gender, classlevel information
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:NO completion:^{
                [ProgressHUD showSuccess:@"Register succeeded"];
            }];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate goToLogin];
            
        } else {
            //Something bad has ocurred
            [ProgressHUD dismiss];
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

@end
