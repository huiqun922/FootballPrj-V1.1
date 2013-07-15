//
//  SetDefaultPhotoView.m
//  FootballPrj
//
//  Created by mokbid on 13-5-14.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "SetDefaultPhotoView.h"

@interface SetDefaultPhotoView ()

@end

@implementation SetDefaultPhotoView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title=@"默认队徽";
        UIButton *buttonback=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonback setBackgroundImage:[UIImage imageNamed:@"返回_2.png"] forState:UIControlStateNormal];
        [buttonback setTitle:@"  返回" forState:UIControlStateNormal];
        [buttonback setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonback.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [buttonback addTarget:self action:@selector(ComeBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:buttonback];
        self.navigationItem.leftBarButtonItem =back;
        self.navigationItem.hidesBackButton = YES;
        [back release];
    }
    return self;
}
-(void)ComeBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"背景.jpg"];
    self.view.layer.contents = (id) image.CGImage;
    for (int i=0; i<9; i++) {
        int row=i/3;
        int column=i%3;
        CGFloat rows=44+row*(44 + 80); //y
        CGFloat columns=20 + column*(20 + 80); //x
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i;
        [button setFrame:CGRectMake(columns,rows, 80.0, 80.0)];
        [button addTarget:self action:@selector(ReturnPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"队徽图片0%d",i+1]] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ReturnPhoto:(UIButton *)sender {
    
    int i=sender.tag;
  [_photoDelegate theSelectPhoto:[UIImage imageNamed:[NSString stringWithFormat:@"队徽图片0%d",i+1]]];
  
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [_theScroller release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheScroller:nil];
    [super viewDidUnload];
}
@end
