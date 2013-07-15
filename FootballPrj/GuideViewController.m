//
//  GuideViewController.m
//  FindMe
//
//  Created by  on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GuideViewController.h"
#import "MainPageAppDelegate.h"

@interface GuideViewController (){
    MainPageViewController *theMainview;
}

-(void)pushMainViewController;

@end

@implementation GuideViewController
@synthesize jianjie;
@synthesize DisDelegate;

int pageCount = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *NavimageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [NavimageView setImage:[UIImage imageNamed:@"title_足球管家.png"]];
    [self.view addSubview:NavimageView];
    
    
    CGRect curentRect=[[UIScreen mainScreen] bounds];
    NSLog(@"size :%f",curentRect.size.height);

    if (iPhone5) {
        [guideScrollView setFrame:CGRectMake(0,44, curentRect.size.width, curentRect.size.height-64)];
        [guidePageControl setFrame:CGRectMake(80, 416+88, 150, 36)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"content_iPhone5" ofType:@"plist"];
        contentAr = [NSArray arrayWithContentsOfFile:path];
    }else{
    [guideScrollView setFrame:CGRectMake(0,44, curentRect.size.width, curentRect.size.height-64)];
    [guidePageControl setFrame:CGRectMake(80, 426, 150, 36)];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"content_iPhone" ofType:@"plist"];
    contentAr = [NSArray arrayWithContentsOfFile:path];
    }
    pageCount = [contentAr count];
    
    if (pageCount == 0) {
        NSLog(@"file lose or non data");
        return;
    }
    [guideScrollView setBackgroundColor:[UIColor redColor]];
    guideScrollView.pagingEnabled = YES;
    guideScrollView.contentSize = CGSizeMake(guideScrollView.frame.size.width * pageCount, guideScrollView.frame.size.height);
    guideScrollView.showsHorizontalScrollIndicator = NO;
    guideScrollView.showsVerticalScrollIndicator = NO;
    guideScrollView.scrollsToTop = NO;
    guideScrollView.delegate = self;
    guideScrollView.bounces=NO;
   
    CGRect frame;
    int i = 0;
    for (NSDictionary *dic in contentAr) {
 //       NSString *nameStr   = [dic objectForKey:@"nameKey"];
        NSString *imageStr  = [dic objectForKey:@"imageKey"];
        UIViewController *tempVC = [[UIViewController alloc]initWithNibName:nil bundle:nil];
        [tempVC.view setBackgroundColor:[UIColor yellowColor]];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageStr]];
        frame = tempVC.view.frame;
        frame.origin.y =0;
        frame.size.height = guideScrollView.bounds.size.height;
        imageView.frame = frame;
        [tempVC.view addSubview:imageView];
        [imageView release];
        imageView = nil;

        frame = guideScrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        [tempVC.view setFrame:frame];
        [guideScrollView addSubview:tempVC.view];
        NSLog(@"%f %f",tempVC.view.frame.size.height,imageView.frame.size.height);
        
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"isFirstLogin.plist"];
        NSMutableDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        if (i == pageCount-1) {
            UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
            jumpBtn.frame = CGRectMake(180, 360, 180, 36);
            if (iPhone5) {
                jumpBtn.frame = CGRectMake(180, 360+55, 180, 36);

            }
            [jumpBtn setTitle:@"" forState: UIControlStateNormal];
            if (tempDict) {
                [jumpBtn addTarget:self
                            action:@selector(removeTheView)
                  forControlEvents:UIControlEventTouchUpInside];
            }else{
            [jumpBtn addTarget:self
                              action:@selector(pushMainViewController)
                    forControlEvents:UIControlEventTouchUpInside];
            }
            [tempVC.view addSubview:jumpBtn];
        }else{
            UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            jumpBtn.tag=i+1;
            jumpBtn.frame = CGRectMake(272.0 + 320*i, 310, 36, 36);
            if (iPhone5) {
                jumpBtn.frame = CGRectMake(272.0 + 320*i, 310+52, 36, 36);

            }
            [jumpBtn setTitle:@"" forState: UIControlStateNormal];
            [jumpBtn addTarget:self
                        action:@selector(jumpTotheView:)
              forControlEvents:UIControlEventTouchUpInside];
            [guideScrollView addSubview:jumpBtn];
        }
        [tempVC release];
        tempVC = nil;
        
        i ++;
    }
    
    guidePageControl.numberOfPages = pageCount;
    guidePageControl.currentPage = 0;
    
    if (iPhone5) {
        theMainview=[[MainPageViewController alloc] initWithNibName:@"MainPageViewController_i5" bundle:nil];

    }else{
    theMainview=[[MainPageViewController alloc] initWithNibName:@"MainPageViewController" bundle:nil];
    }
    theMainview.view.hidden=YES;
    theMainview.fuckday=10086;
    [self.view addSubview:theMainview.view];
}

-(void)jumpToFirstView
{
    [guideScrollView setContentOffset:CGPointMake(0, 0)];
    guidePageControl.currentPage = 0;
}
-(void)jumpTotheView:(UIButton *)sender{
    [guideScrollView setContentOffset:CGPointMake(sender.tag * 320, 0) animated:YES];
    guidePageControl.currentPage = sender.tag;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = guideScrollView.frame.size.width;
    int page = floor((guideScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    guidePageControl.currentPage = page;
}

-(void)pushMainViewController
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"isFirstLogin.plist"];
    NSMutableDictionary *plistDict = [[[NSMutableDictionary alloc]init]autorelease];
    [plistDict writeToFile:plistPath atomically:YES];
    
    
    NSUserDefaults *userdefalut=[NSUserDefaults standardUserDefaults];
    if ([userdefalut objectForKey:@"TheTeamMoney"]==nil) {
        [userdefalut setObject:@"0" forKey:@"TheTeamMoney"];
    }
    [userdefalut synchronize];
    
//    [((MainPageAppDelegate*)[UIApplication sharedApplication].delegate) changeToMainWindow:self.view];
    
    
//    MainPageViewController *theMainview=[[[MainPageViewController alloc] init] autorelease];

    
   // [theMainview.view popIn:3 delegate:nil];
    [theMainview.view fallIn:2 delegate:theMainview startSelector:nil stopSelector:@selector(showALert)];
    theMainview.fuckday=10000;

    
}
-(void)removeTheView{
    
    [self dismissModalViewControllerAnimated:NO];
    [DisDelegate disMissView];
}
@end
