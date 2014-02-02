//
//  HKViewController.m
//  Demo
//
//  Created by Panos on 2/1/14.
//  Copyright (c) 2014 Panos. All rights reserved.
//

#import "HKViewController.h"
#import <UIActionSheet+HKToolKit.h>
#import <UIAlertView+HKToolKit.h>
#import <UIControl+HKToolKit.h>

@interface HKViewController ()

@property (nonatomic, strong) UIControlBlockId blockId;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation HKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.blockId = [self.button addBlockWithSenderAndControlEvents:^(id sender, UIControlEvents controlEvents) {
        NSLog(@"Button touched up inside, now removing the action block.");
        [self.button removeControlBlockWithId:self.blockId
                             forControlEvents:UIControlEventTouchUpInside];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)displayActionSheet:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:NSLocalizedString(@"Action Sheet", nil)
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  destructiveButtonTitle:NSLocalizedString(@"Destruct", nil)
                                  otherButtonTitles:@[NSLocalizedString(@"Other Button 1", nil),
                                                      NSLocalizedString(@"Other Button 2", nil)]
                                  clickedBlock:^(UIActionSheet *as, NSInteger i) {
                                      NSLog(@"Action sheet clicked button %li", (long)i);
                                  }
                                  willDismissBlock:^(UIActionSheet *as, NSInteger i) {
                                      NSLog(@"Action sheet will dismiss with button %li", (long)i);
                                  }
                                  didDismissBlock:^(UIActionSheet *as, NSInteger i) {
                                      NSLog(@"Action sheet did dismiss with button %li", (long)i);
                                  }
                                  cancelBlock:^(UIActionSheet *as) {
                                      NSLog(@"%@", @"Action sheet cancelled");
                                  }];
    
    [actionSheet showInView:self.view];
}

- (IBAction)displayAlertView:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Alert View", nil)
                              message:NSLocalizedString(@"Alert View Message", nil)
                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                              otherButtonTitles:@[NSLocalizedString(@"Other Button 1", nil),
                                                  NSLocalizedString(@"Other Button 2", nil)]
                              clickButtonBlock:^(UIAlertView *aView, NSInteger button) {
                                  NSLog(@"Alert view clicked button at index %ld", (long)button);
                              }
                              willDismissBlock:^(UIAlertView *aView, NSInteger button) {
                                  NSLog(@"Alert view will dismiss with button at index %ld", (long)button);
                              }
                              didDismissBlock:^(UIAlertView *aView, NSInteger button) {
                                  NSLog(@"Alert view clicked button at index %ld", (long)button);
                              }
                              cancelBlock:^(UIAlertView *aView) {
                                  NSLog(@"Alert view cancel");
                              }
                              shouldEnableOtherButtonBlock:^BOOL(UIAlertView *aView) {
                                  NSLog(@"Alert view should enable first other button");
                                  
                                  return YES;
                              }];
    
    [alertView show];
}

@end
