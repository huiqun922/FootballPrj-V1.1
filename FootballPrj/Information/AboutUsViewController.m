//
//  AboutUsViewController.m
//  FootballPrj
//
//  Created by mokbid on 13-5-9.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithTitle:(NSString *)title{
    self=[super init];
    if (self){
        self.title=title;

    }
    return self;
}

- (IBAction)ComeBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)OpenURL:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mobkid.com"]];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"背景.jpg"];
    self.view.layer.contents = (id) image.CGImage;
    [self.theNavBar setTintColor:[UIColor clearColor]];
    [self.theNavBar setBackgroundImage:[UIImage imageNamed:@"顶部条.png"] forBarMetrics:UIBarMetricsDefault];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"返回_1.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0.0, 0.0, 50.5, 30.0)];
    [button setTitle:@"  返回" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [button addTarget:self action:@selector(ComeBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithCustomView:button];
    UINavigationItem *Navitem=[[UINavigationItem alloc] initWithTitle:self.title];
    Navitem.leftBarButtonItem=left;
    [left release];
    [self.theNavBar pushNavigationItem:Navitem animated:NO];
    [Navitem release];
    
    if ([self.title isEqualToString:@"帮助"]) {
        
    }else{
        
    }
    

    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_theNavBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheNavBar:nil];
    [super viewDidUnload];
}
@end
