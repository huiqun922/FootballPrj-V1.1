//
//  EditViewController.m
//  FootballPrj
//
//  Created by mokbid on 13-5-9.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "EditViewController.h"
#import "SetDefaultPhotoView.h"
#import "FMDBServers.h"

@interface EditViewController (){
    NSInteger m;
    UIDatePicker *datePicker;
    UIKeyboardType *keyType;
    NSInteger ZhengZe;
    NSInteger theLength;
    
}
@property(nonatomic,copy)NSString *stringContent;

@end

@implementation EditViewController
//@synthesize editdelegatel;
@synthesize stringContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(id)initWithTitleIndex:(NSInteger)title Conten:(NSString *)ContenString Length:(NSInteger)length KeyType:(NSInteger)keyboardType{
    self=[super init];
    if (self) {
        m=title;
        self.stringContent=ContenString;
        ZhengZe=keyboardType;
        theLength=length;
        UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonleft setBackgroundImage:[UIImage imageNamed:@"按钮_2.png"] forState:UIControlStateNormal];
        [buttonleft setTitle:@"保存" forState:UIControlStateNormal];
        [buttonleft.titleLabel setTextColor:[UIColor whiteColor]];
        [buttonleft setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonleft.titleLabel setFont:[UIFont systemFontOfSize:15.0]];

        [buttonleft addTarget:self action:@selector(SaveArray:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:buttonleft];
        self.navigationItem.rightBarButtonItem=right;
        [right release];
        
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
        
        self.thetTextView.text=ContenString;
    }
    return self;
}
-(void)ComeBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)SaveArray:(id)sender{
    [_editdelegate EditData:self.thetTextView.text Index:m];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"背景.jpg"];
    self.view.layer.contents = (id) image.CGImage;
    
    self.theTextImage.layer.masksToBounds=YES;
    self.theTextImage.layer.cornerRadius=2.2;
    
    _theTextField.delegate=self;
    
    if ([stringContent isEqualToString:@" "]) {
        self.thetTextView.text=@"";
    }else{
    self.thetTextView.text=stringContent;
    }
    if (ZhengZe==0) {
        self.thetTextView.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
   
    }
    [self.thetTextView setBackgroundColor:[UIColor clearColor]];
    [self.thetTextView setTextColor:[UIColor whiteColor]];
    [self.thetTextView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // NSLog(@"%d %d  %@",theLength,range.location,text);

    if ([text isEqualToString:@""]) {
        return  YES;
    }
    
    if(text.length>1&&ZhengZe==0){
        //复制
       [self dianhuahaoma:text Index:textView.text];
        return NO;
    }else{
        //键盘输入
         if([self ZhengZePiPei:text Index:ZhengZe]){
        
        }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"只能输入数字" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    }
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSUInteger charLen = [self lenghtWithString:toBeString];
            if (charLen>theLength) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"长度超过限制，最大%d个字符",theLength] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
        }
 
    return YES;
}

-(BOOL)ZhengZePiPei:(NSString *)theString Index:(NSInteger)index{
    switch (index) {
        case 0:
        {
            //匹配数字
            NSString *regexString=@"[0-9]";
            return [theString isMatchedByRegex:regexString];
        }
            break;
            
        default:
            break;
    }
    return YES;
}
-(void)dianhuahaoma:(NSString *)theString Index:(NSString *)oldstring{
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:&error];
    NSMutableString *string=[NSMutableString stringWithCapacity:50];

    if (regex) {
    NSArray *array = [regex matchesInString:theString options:0 range:NSMakeRange(0, [theString length])];
    for (NSTextCheckingResult* b in array)
    {
       // str1 是每个和表达式匹配好的字符串。
        [string appendString:[theString substringWithRange:b.range]];
    }
    if ([oldstring stringByAppendingString:string].length>12) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能输入12个数字" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return ;
        }
    self.thetTextView.text=[oldstring stringByAppendingString:string];
    }
}
//计算NSString长度，一个中文占两个字符
- (NSUInteger) lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return len + numMatch;
}

- (void)dealloc {
    [_theTextField release];
    [_theLabel release];
    [datePicker release];
    [_thetTextView release];
    [_theTextImage release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheTextField:nil];
    [self setTheLabel:nil];
    [self setThetTextView:nil];
    [self setTheTextImage:nil];
    [super viewDidUnload];
}
//-(BOOL)UpdateData:(NSArray *)array{
//    FMDBServers *fmdbs=[[FMDBServers alloc] init];
//    if ([fmdbs OpenDatabase]) {
//        [fmdbs.dbs executeUpdate:@"UPDATE  JinQiu set MemberID = ? where ID = ?",];
//    }
//}
@end
