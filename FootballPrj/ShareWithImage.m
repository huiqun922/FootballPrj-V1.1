//
//  ShareWithImage.m
//  FootballPrj
//
//  Created by mokbid on 13-5-20.
//  Copyright (c) 2013年 ytt. All rights reserved.
//


#import "ShareWithImage.h"

#import "MainPageAppDelegate.h"
#import "AboutUsViewController.h"
#import "WXApi.h"
#import "MainPage.h"

@interface ShareWithImage (){

    NSString *pathString;
   
}
@property(nonatomic,retain) UIImage *image;
@property(nonatomic,retain) MainPage *CustomStateBar;
@end


@implementation ShareWithImage
@synthesize theContent;
@synthesize CustomStateBar;
-(id)init{
    if (self=[super init]) {
      //  _appDelegate = (MainPageAppDelegate *)[UIApplication sharedApplication].delegate;
        _scene = WXSceneSession;
        self.CustomStateBar=[[[MainPage alloc] initWithFrame:CGRectZero] autorelease];


    }
    return self;
}

-(void)getMainImage{
    
    self.image=[UIImage imageNamed:@"shareimage.jpg"];
}
-(void)getImageFromView:(UIView *)orgView{
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
      
    pathString = [rootPath stringByAppendingPathComponent:@"Share.png"];
    
    //also be .jpg or another
    NSData *imageData = UIImagePNGRepresentation(self.image);
    //UIImageJPEGRepresentation(image)
    [imageData writeToFile:pathString atomically:NO];

    //return savedImagePath;
}

- (void)simpleShareAllButtonClickHandler:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"腾讯微博",@"微信好友",@"微信朋友圈",nil];
    [sheet showInView:(UIView *)sender];
    [sheet release];
}

#pragma mark - SinaWeibo Delegate
- (void)removeAuthData
{
    if(_krShare.shareTarget == KRShareTargetSinablog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Sina"];
    }
    else if(_krShare.shareTarget == KRShareTargetTencentblog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Tencent"];
    }
    else if(_krShare.shareTarget == KRShareTargetDoubanblog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Douban"];
    }
    else if(_krShare.shareTarget == KRShareTargetRenrenblog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KRShareAuthData-Renren"];
    }
}



- (void)KRShareDidLogIn:(KRShare *)krShare
{
    if(krShare.shareTarget == KRShareTargetSinablog)
    {
        [krShare requestWithURL:@"statuses/upload.json"
                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 theContent, @"status",
                                 self.image, @"pic", nil]
                     httpMethod:@"POST"
                       delegate:self];
    }
    
    else if(krShare.shareTarget == KRShareTargetTencentblog)
    {
        [krShare requestWithURL:@"t/add_pic"
                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 theContent, @"content",
                                 @"json",@"format",
                                 @"221.232.172.30",@"clientip",
                                 @"all",@"scope",
                                 krShare.userID,@"openid",
                                 @"ios-sdk-2.0-publish",@"appfrom",
                                 @"0",@"compatibleflag",
                                 @"2.a",@"oauth_version",
                                 kTencentWeiboAppKey,@"oauth_consumer_key",
                                 self.image, @"pic", nil]
                     httpMethod:@"POST"
                       delegate:self];
    }
    else if(krShare.shareTarget == KRShareTargetDoubanblog)
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"草根足球管家";
        message.description = theContent;
        [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"http://www.szmobkid.com";
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        req.scene = _scene;
        
        [WXApi sendReq:req];
    }
    else if(krShare.shareTarget == KRShareTargetRenrenblog)
    {
        [krShare requestWithURL:@"restserver.do"
                         params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"1.0",@"v",
                                 @"这是我分享的图片", @"caption",
                                 @"json",@"format",
                                 @"photos.upload",@"method",
                                 [UIImage imageNamed:@"Default.png"],@"upload",
                                 kRenrenBroadAppKey,@"api_key",
                                 nil]
                     httpMethod:@"POST"
                       delegate:self];
    }
    
}

- (void)KRShareDidLogOut:(KRShare *)sinaweibo
{
    [self removeAuthData];
}

- (void)KRShareLogInDidCancel:(KRShare *)sinaweibo
{
    NSLog(@"用户取消了登录");
}

- (void)krShare:(KRShare *)krShare logInDidFailWithError:(NSError *)error
{
    //[SysFunction AlertWithMessage:@"登录失败"];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)krShare:(KRShare *)krShare accessTokenInvalidOrExpired:(NSError *)error
{
    [self removeAuthData];
}

- (void)KRShareWillBeginRequest:(KRShareRequest *)request
{
    NSLog(@"开始请求");
    //_loadingView.hidden = NO;
    [CustomStateBar showStatusMessage:@"正在发送..."];
}

-(void)request:(KRShareRequest *)request didFailWithError:(NSError *)error
{
    [CustomStateBar hide];
    //_loadingView.hidden = YES;
    NSLog(@"didFailWithError");
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        [SysFunction AlertWithMessage:@"发表微博失败"];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        [SysFunction AlertWithMessage:@"发表微博失败"];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    //发表人人网相片回调
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        
        [SysFunction AlertWithMessage:@"发表人人网相片失败"];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
}


- (void)request:(KRShareRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"请求已完成，结果是：%@",result);
    //_loadingView.hidden = YES;
    [CustomStateBar hide];

    //新浪微博响应
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        if([[result objectForKey:@"error_code"] intValue]==20019)
        {
            [SysFunction AlertWithMessage:@"发送频率过高，请您过会再发"];
        }
        else if([[result objectForKey:@"error_code"] intValue]==0)
        {
            [SysFunction AlertWithMessage:@"发送微博成功"];
        }
    }
    //腾讯微博响应
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        if([[result objectForKey:@"errcode"] intValue]==0)
        {
            [SysFunction AlertWithMessage:@"发表微博成功"];
        }
        else{
            [SysFunction AlertWithMessage:@"发表微博失败"];
        }
    }
    //豆瓣说响应
    else if ([request.url hasSuffix:@"shuo/v2/statuses/"])
    {NSLog(@"%@",request.url);
        if([[result objectForKey:@"code"] intValue]==0)
        {
            [SysFunction AlertWithMessage:@"发表豆瓣说成功"];
        }
        else{
            NSLog(@"%@",result);
            [SysFunction AlertWithMessage:@"发表豆瓣说失败"];
        }
    }
    //发表人人网相片回调
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        if([[result objectForKey:@"error_code"] intValue]==0)
        {
            [SysFunction AlertWithMessage:@"发表人人网相片成功"];
        }
        else{
            [SysFunction AlertWithMessage:@"发表人人网相片失败"];
        }
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"...%d", UIImageJPEGRepresentation(self.image, 0.1).length);
    if (buttonIndex==2) {
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未安装微信" delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"草根足球管家";
        message.description = theContent;
        //[message setThumbImage:self.image];
        [message setThumbData: UIImageJPEGRepresentation(self.image, 0.1)];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"http://www.szmobkid.com";
        //ext.imageData = UIImagePNGRepresentation(self.image);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        req.scene = _scene;
        [WXApi sendReq:req];
        return ;
    }else if(buttonIndex==3){
        
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未安装微信" delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        _scene=WXSceneTimeline;
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"草根足球管家";
        message.description = theContent;
       // self.image=[UIImage imageNamed:@"time.png"];
      //  [message setThumbImage:self.image];
        [message setThumbData: UIImageJPEGRepresentation(self.image, 0.1)];

        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"http://www.szmobkid.com";
        //ext.imageData = UIImagePNGRepresentation(self.image);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        req.scene = _scene;
        
        [WXApi sendReq:req];
        return ;
    }
    if(buttonIndex != actionSheet.cancelButtonIndex)
    {
//        _krShare  = [KRShare sharedInstanceWithTarget:buttonIndex];
//        
//        _krShare.delegate = self;
//        
//        [_krShare logIn];
        [self ShowTheView:buttonIndex];
    }
}
//weixin

-(void) onReq:(BaseReq*)req
{
//    if([req isKindOfClass:[GetMessageFromWXReq class]])
//    {
//        [self onRequestAppMessage];
//    }
//    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
//    {
//        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
//        [self onShowMediaMessage:temp.message];
//    }
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        NSString *strMsg = [NSString stringWithFormat:@"发送消息结果:%@", resp.errStr];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
-(void)ShowTheView:(NSInteger)theTag{
    
    CGRect rect=[[UIScreen mainScreen] bounds];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, rect.size.height)];
    view.tag=41;

    
    
    UIImageView *imageView0=[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 20.0, 320, 209)];
    [imageView0 setImage:[UIImage imageNamed:@"AGShareBG.png"]];
    [view addSubview:imageView0];
    
    
    UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(220.0, 90.0, 77, 77)];
    [imageView1 setImage:[UIImage imageNamed:@"AGShareImageBG.png"]];
    [view addSubview:imageView1];
    
    UIImageView *imageView3=[[UIImageView alloc] initWithFrame:CGRectMake(220.0, 90.0, 77, 77)];
    imageView3.contentMode=UIViewContentModeScaleAspectFit;
    [imageView3 setImage:self.image];
    [view addSubview:imageView3];
    
    UIImageView *imageView2=[[UIImageView alloc] initWithFrame:CGRectMake(320.0-80, 75.0, 80, 36)];
    [imageView2 setImage:[UIImage imageNamed:@"AGSharePin.png"]];
    [view addSubview:imageView2];
    
    [imageView0 release];
    [imageView1 release];
    [imageView2 release];
    [imageView3 release];
    
    UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonleft setBackgroundImage:[UIImage imageNamed:@"AGShareCancelButton.png"] forState:UIControlStateNormal];
    [buttonleft setTitle:@"取消" forState:UIControlStateNormal];
    [buttonleft setFrame:CGRectMake(10.0, 38.0, 49.0, 30.0)];
    [buttonleft.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonleft addTarget:self action:@selector(ComeBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonrighrt=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonrighrt setBackgroundImage:[UIImage imageNamed:@"AGShareSubmitButton.png"] forState:UIControlStateNormal];
    buttonrighrt.tag=theTag;
    [buttonrighrt setTitle:@"发表" forState:UIControlStateNormal];
    [buttonrighrt setFrame:CGRectMake(310.0-49, 38.0, 49.0, 30.0)];
    [buttonrighrt.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [buttonrighrt setTintColor:[UIColor grayColor]];
    [buttonrighrt addTarget:self action:@selector(Share:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:buttonleft];
    [view addSubview:buttonrighrt];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 38, 320, 30)];
    label.text=@"内容分享";
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:19]];
    [label setTextColor:[UIColor grayColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    [view addSubview:label];
    [label release];
    
    UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(5.0, 72.0, 215, 106)];
    [textView setFont:[UIFont systemFontOfSize:17]];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView becomeFirstResponder];
    textView.tag=42;
    textView.text=theContent;
    [view addSubview:textView];
    [textView release];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view release];
    
}
-(void)ComeBack:(id)sender{
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:41];
    [view removeFromSuperview];
    
}
-(void)Share:(UIButton *)sender{
    
            _krShare  = [KRShare sharedInstanceWithTarget:sender.tag];
    
            _krShare.delegate = self;
    
            [_krShare logIn];
    
    UIView *view=(UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:41];
    [view removeFromSuperview];
    
    
}
@end
