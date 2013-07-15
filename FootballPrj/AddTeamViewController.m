//
//  AddTeamViewController.m
//  FootballPrj
//
//  Created by mokbid on 13-5-9.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "AddTeamViewController.h"
#import "FMDBServers.h"
#import "ActionSheetPicker.h"



@interface AddTeamViewController (){
    UIDatePicker *datePicker;
}

@property(nonatomic,retain)NSArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arraySelect;
@property (nonatomic, strong) ActionSheetDatePicker *actionSheetPicker;


@end

@implementation AddTeamViewController
@synthesize arrayData;
@synthesize arraySelect;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"编辑球队信息";
        self.arrayData=[NSArray arrayWithObjects:@"队        徽",@"队        名",@"成立时间",@"队        长",@"财        务",@"球队介绍", nil];
        
        
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
        
        [self getDateFrompPlist];
        
//        UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [buttonleft setTitle:@"保存" forState:UIControlStateNormal];
//        [buttonleft setFrame:CGRectMake(0, 4, 60, 36)];
//        [buttonleft addTarget:self action:@selector(SaveArray:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:buttonleft];
//        self.navigationItem.rightBarButtonItem=right;
//        [right release];
        
    }
    return self;
}
-(void)ComeBack:(id)sender{
    for (int i=0; i<[self.arraySelect count]; i++) {
        NSLog(@"arraySelect %d :%@",i,[self.arraySelect objectAtIndex:i]);

        if([[self.arraySelect objectAtIndex:i] isEqualToString:@" "]||[self.arraySelect objectAtIndex:i]==NULL){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请将球队信息填写完整" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return ;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getDateFrompPlist{
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"theTeamInfo.plist"];
    
    // NSFileManager *fileMgr = [NSFileManager defaultManager];
    self.arraySelect = [NSMutableArray arrayWithContentsOfFile:plistPath];
    if ([self.arraySelect count]<1) {
        self.arraySelect=[NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",nil];
    }
      NSLog(@"TeamInfo:  %@",self.arraySelect);
    
}
-(UIImage *)GetPhotoFromPlist{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    
    // NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *savedImagePath = [rootPath stringByAppendingPathComponent:@"duihui.png"];
    UIImage *image=[UIImage imageWithContentsOfFile:savedImagePath];
    
    if (image==nil||image==NULL) {
        return [UIImage imageNamed:@"队徽图片01.png"];
    }else{
        return image;
    }
    
}
-(void)SaveArray:(id)sender{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"theTeamInfo.plist"];
    
//        NSString *savedImagePath = [rootPath stringByAppendingPathComponent:@"duihui.png"];
//    
//    UIImage *image=[self.arraySelect objectAtIndex:0];
//    //also be .jpg or another
//    NSData *imageData = UIImagePNGRepresentation(image);
//    //UIImageJPEGRepresentation(image)
//    [imageData writeToFile:savedImagePath atomically:NO];
    
    
    //[self.arraySelect removeObjectAtIndex:0];
    [self.arraySelect writeToFile:plistPath atomically:YES];
   // NSLog(@" Save TeamInfo:  %@",self.arraySelect);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [arrayData release];
    [arraySelect release];
    [_theTableView release];
    [super dealloc];
}
//tableview datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    cell.textLabel.text=[self.arrayData objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row==0) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(200, 10, 55, 55)];
        [imageView setImage:[self GetPhotoFromPlist]];
        [cell.contentView addSubview:imageView];
        [imageView release];
    }else{
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(120, 5, 150,42)];
        //label.textAlignment=UITextAlignmentCenter;
        label.text=[self.arraySelect objectAtIndex:indexPath.row-1];
        [cell.contentView addSubview:label];
        [label release];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;

    return cell;
}
//tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0)
        return 75.0f;
    return 52.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSInteger length=0;
    NSArray *arraytitle=[NSArray arrayWithObjects:@"",@"队名",@"成立时间",@"队长",@"财务",@"球队介绍",nil];
    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"选择队徽" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机",@"预设图片" ,nil];
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
            [actionSheet release];
            return;
        }
            break;
        case 1:{
            length=20;
        }break;
        case 2:{
            length=20;
            
            _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:self.theTableView];
            [self.actionSheetPicker addCustomButtonWithTitle:@"当前时间" value:[NSDate date]];
            //    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
                NSDate* minDate = [NSDate dateWithTimeIntervalSince1970:365*24*60*60];
                NSDate* maxDate =  [[NSDate date] dateByAddingTimeInterval:2 * 0];
            [self.actionSheetPicker SetDateWithMaxDate:maxDate MiniDate:minDate];
            self.actionSheetPicker.hideCancel = YES;
            [self.actionSheetPicker showActionSheetPicker];
            return;
        }break;
        case 3:{
            length=10;
            
        }break;
        case 4:{
            length=10;
            
        }break;
        case 5:{
            length=500;
            
        }break;
        default:
        {
        }
            break;
    }
    
    EditViewController *edit=[[EditViewController alloc] initWithTitleIndex:indexPath.row Conten:[self.arraySelect objectAtIndex:indexPath.row-1] Length:length KeyType:1];
    edit.editdelegate=self;
    edit.title=[arraytitle objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:edit animated:YES];
    [edit release];
}
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    NSLog(@"selectedDate %@",selectedDate);
    
    NSDateFormatter * formatter =[ [NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"]; //dd 必须为小写 DD大写回产生错误。
    NSString* string = [formatter stringFromDate:selectedDate];
    [self.arraySelect replaceObjectAtIndex:1 withObject:string];
    [self.theTableView reloadData];
    [formatter release];
    [self SaveArray:nil];
}
//EditViewDelegate
-(void)EditData:(NSString *)theString Index:(NSInteger)index{
    
    [self.arraySelect replaceObjectAtIndex:index-1 withObject:theString];
    [self.theTableView reloadData];
    
    [self SaveArray:nil];
}
//UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self selectExistingPicture];
            break;
            case 1:
            [self selectPhotoFromCamera];
            break;
        case 2:{
            SetDefaultPhotoView *setdefalut=[[SetDefaultPhotoView alloc] initWithNibName:@"SetDefaultPhotoView" bundle:nil];
            setdefalut.photoDelegate=self;
            [self.navigationController pushViewController:setdefalut animated:YES];
            [setdefalut release];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)selectExistingPicture{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing=YES;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问图片库错误"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(void)selectPhotoFromCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing=YES;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"请检查相机是否正常"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
//再调用以下委托：
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //[self.arraySelect replaceObjectAtIndex:0 withObject:image];
    [picker dismissModalViewControllerAnimated:YES];
    [self.theTableView reloadData];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savedImagePath = [rootPath stringByAppendingPathComponent:@"duihui.png"];
    
   // UIImage *image=[self.arraySelect objectAtIndex:0];
    //also be .jpg or another
    NSData *imageData = UIImagePNGRepresentation(image);
    //UIImageJPEGRepresentation(image)
    [imageData writeToFile:savedImagePath atomically:NO];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}
//选取默认图片的委托
-(void)theSelectPhoto:(UIImage *)image{
    
    //[self.arraySelect replaceObjectAtIndex:0 withObject:image];
    [self.theTableView reloadData];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savedImagePath = [rootPath stringByAppendingPathComponent:@"duihui.png"];
    
    // UIImage *image=[self.arraySelect objectAtIndex:0];
    //also be .jpg or another
    NSData *imageData = UIImagePNGRepresentation(image);
    //UIImageJPEGRepresentation(image)
    [imageData writeToFile:savedImagePath atomically:NO];
}
- (void)viewDidUnload {
    [self setTheTableView:nil];
    [super viewDidUnload];
}
@end
