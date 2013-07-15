//
//  AddMemberView.m
//  FootballPrj
//
//  Created by mokbid on 13-5-10.
//  Copyright (c) 2013年 ytt. All rights reserved.
//

#import "AddMemberView.h"
#import "FMDBServers.h"
#import "SetDefaultPhotoView.h"
#import "ActionSheetPicker.h"


@interface AddMemberView (){
   // NSIndexPath *indexpathNow;
}
@property(nonatomic,retain)NSArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arraySelect;
@property (nonatomic,retain)UIPickerView *thePickerView;
@property (nonatomic,retain)NSMutableArray *arrayPicker;
@property (nonatomic,retain)NSIndexPath *indexpathNow;
@property (nonatomic,retain)NSDictionary *dicInfo;
@end

@implementation AddMemberView
@synthesize arrayData,arraySelect;
@synthesize thePickerView;
@synthesize arrayPicker;
@synthesize indexpathNow;
@synthesize dicInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil theInfo:(NSDictionary *)Dic
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"编辑球员信息";
        self.dicInfo=[NSDictionary dictionaryWithDictionary:Dic];
        
        self.arrayData=[NSArray arrayWithObjects:@"头        像",@"姓        名",@"电        话",@"Q  Q",@"个人简介",@"场上位置",@"球衣号码", nil];
        if (Dic==NULL) {
            self.arraySelect=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"morentou.png"],@" ",@" ",@" ",@" ",@" ",@" ",nil];
        }else{
        self.arraySelect=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"morentou.png"],[Dic objectForKey:@"Name"],[Dic objectForKey:@"phoneNum"],[Dic objectForKey:@"QQ"],[Dic objectForKey:@"Jianjie"],[Dic objectForKey:@"weiZhi"],[Dic objectForKey:@"Number"],nil];
        }
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
        
        UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeCustom];
        [buttonleft setBackgroundImage:[UIImage imageNamed:@"按钮_2.png"] forState:UIControlStateNormal];
        [buttonleft setTitle:@"保存" forState:UIControlStateNormal];
        [buttonleft.titleLabel setTextColor:[UIColor whiteColor]];
        [buttonleft setFrame:CGRectMake(0, 0, 50.5, 30.0)];
        [buttonleft.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        
        [buttonleft addTarget:self action:@selector(SaveDate:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:buttonleft];
        self.navigationItem.rightBarButtonItem=right;
        [right release];
       // NSLog(@"arraySelect :%@",self.arraySelect);
        [self getPhoto:[Dic objectForKey:@"ID"]];
        
    }
    return self;
}
-(void)ComeBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getPhoto:(NSString *)ID{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    // NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *savedImagePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"touxiang%@.png",ID]];
    UIImage *image=[UIImage imageWithContentsOfFile:savedImagePath];
    if (image!=nil) {
    [self.arraySelect replaceObjectAtIndex:0 withObject:image];
    }
}
-(void)SaveDate:(id)sender{
        int theID=0;
    
    
    
    for (int i=1; i<[self.arraySelect count]; i++) {
        if([[self.arraySelect objectAtIndex:i] isEqualToString:@" "]||[[self.arraySelect objectAtIndex:i] isEqualToString:@""]){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整内容" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }
    
    
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
    
    if ([fmdbs OpenDatabase]) {
        FMResultSet *rs111=[fmdbs.dbs executeQuery:@"SELECT name, Number from User order by ID desc"];
        while ([rs111 next]) {
            if ([[rs111 stringForColumn:@"name"] isEqualToString:[self.arraySelect objectAtIndex:1]]&&![[self.arraySelect objectAtIndex:1] isEqualToString:[self.dicInfo objectForKey:@"Name"]]) {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经存在改姓名" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                [rs111 close];
                [fmdbs close];
                [fmdbs release];
                return ;
            }else if ([[rs111 stringForColumn:@"Number"] isEqualToString:[self.arraySelect objectAtIndex:6]]&&![[self.arraySelect objectAtIndex:6] isEqualToString:[self.dicInfo objectForKey:@"Number"]]){
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"球衣号码已经被人选了" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                [rs111 close];
                [fmdbs close];
                [fmdbs release];
                return ;
            }
        }
        [rs111 close];
    }
    [fmdbs close];
    [fmdbs release];
    
    
    if ([dicInfo objectForKey:@"ID"]==nil) {
        
    
    NSMutableArray *array=[NSMutableArray arrayWithArray:self.arraySelect];
    [array removeObjectAtIndex:0];
    [array addObject:@"0"];
    [array addObject:@"0"];
    [array addObject:@"0"];
        
        
        
    FMDBServers *fmdbs=[[FMDBServers alloc] init];
        
        if ([fmdbs OpenDatabase]) {
            if([fmdbs InsertDataWithIndex:0 InsertData:array]){
        NSLog(@"INSERT SUCCESS");
         }
        FMResultSet *rs = [fmdbs.dbs executeQuery:@"SELECT ID FROM User order by ID desc"];
        if([rs next]) {
            theID=[[rs stringForColumn:@"ID"]intValue];
            NSLog(@"MMM :%d",theID);
            
        }
        [rs close];
        
        NSMutableArray *arrayCaiWu=[NSMutableArray arrayWithCapacity:50];
        [arrayCaiWu addObject:[self.arraySelect objectAtIndex:1]];
        [arrayCaiWu addObject:@"0"];
        [arrayCaiWu addObject:@"0"];
        [arrayCaiWu addObject:@" "];
        [arrayCaiWu addObject:[NSString stringWithFormat:@"%d",theID]];
        if ([fmdbs InsertDataWithIndex:5 InsertData:arrayCaiWu]) {
            NSLog(@"INSERT SUCCESS");
        }
        
    }
    
    [fmdbs close];
    [fmdbs release];
        
    }else{
        
        NSMutableArray *array=[NSMutableArray arrayWithArray:self.arraySelect];
        [array removeObjectAtIndex:0];
        FMDBServers *fmdbsUP=[[FMDBServers alloc] init];
       // [fmdbs OpenDatabase]
       int numberID=[[self.dicInfo objectForKey:@"ID"]intValue];
        if([fmdbsUP UpdateDataWithIndex:0 UpdateData:array Condition:numberID]){
            NSLog(@"UPDATA SUCCESS %d",[[self.dicInfo objectForKey:@"ID"]intValue]);
        }
        [fmdbsUP close];
        [fmdbsUP release];
        
        theID=[[self.dicInfo objectForKey:@"ID"]intValue];
    }
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savedImagePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"touxiang%d.png",theID]];
    UIImage *image=[self.arraySelect objectAtIndex:0];
    //also be .jpg or another
    NSData *imageData = UIImagePNGRepresentation(image);
    //UIImageJPEGRepresentation(image)
    [imageData writeToFile:savedImagePath atomically:NO];
    
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.contents=(id)[UIImage imageNamed:@"背景.jpg"].CGImage;
//    self.thePickerView=[[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 230, 260)   ] autorelease];
//    self.thePickerView.delegate=self;
//    self.thePickerView.dataSource=self;
//    self.thePickerView.showsSelectionIndicator=YES;
    [self.theTableView setFrame:CGRectMake(10, 10, 300, 48*6+70)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//EditViewDelegate
-(void)EditData:(NSString *)theString Index:(NSInteger)index{
    
    [self.arraySelect replaceObjectAtIndex:index withObject:theString];
    [self.theTableView reloadData];
}

//tableview datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    cell.textLabel.text=[self.arrayData objectAtIndex:indexPath.row];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleGray;

    if (indexPath.row==0) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(200, 10, 55, 55)];
        [imageView setImage:[self.arraySelect objectAtIndex:0]];
        [cell.contentView addSubview:imageView];
        [imageView release];
    }else{
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(120, 5, 150,42)];
        //label.textAlignment=UITextAlignmentCenter;
        label.text=[self.arraySelect objectAtIndex:indexPath.row];
        [cell.contentView addSubview:label];
        [label release];
    }
    
    return cell;
}
//tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0)
        return 70.0f;
    return 48.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger m=0;
    NSInteger length=12;
    NSArray *stringtitle=[NSArray arrayWithObjects:@"",@"姓名",@"电话",@"QQ",@"个人简介",nil];
    
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机",nil];
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
            [actionSheet release];
            return ;
        }
            break;
        case 1:{
            m=1;
            length=10;
            //stringtitle=@"姓名";
        }break;
        case 4:{
            m=1;
            //stringtitle=@"个人简介";
            length=500;
        }break;
        case 2:{
            //stringtitle=@"电话";
        }
        case 3:{
            //m=0;

        
        }
            break;
            case 5:
        {
            self.arrayPicker=[NSMutableArray arrayWithObjects:@"门将",@"后卫",@"中场",@"前锋", nil];
            [self SetinputView:indexPath];
            return;
        }
            break;
        case 6:
        {
            self.arrayPicker=[NSMutableArray arrayWithCapacity:50];
            for (int i=0; i<100; i++) {
                [self.arrayPicker addObject:[NSString stringWithFormat:@"%d",i]];
            }
          [self SetinputView:indexPath];
            return;
        }
            break;
        default:
        {
        }
            break;
    }
    
    EditViewController *edit=[[EditViewController alloc] initWithTitleIndex:indexPath.row Conten:[self.arraySelect objectAtIndex:indexPath.row] Length:length KeyType:m];
    edit.editdelegate=self;
    edit.title=[stringtitle objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:edit animated:YES];
    [edit release];
}

//UIPickerView DataSoure
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.arrayPicker count];
}
//UIPickerView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.arrayPicker objectAtIndex:row];
}

-(void)dealloc{
    [arraySelect release];
    [arrayData release];
    [_theTableView release];
    [thePickerView release];
    [arrayPicker release];
    [indexpathNow release];
    [dicInfo release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTheTableView:nil];
    self.thePickerView=nil;
    [super viewDidUnload];
}
-(void)SetinputView:(NSIndexPath *)indexPath{
    self.indexpathNow=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];

    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([self respondsToSelector:@selector(setText:)]) {
            [self performSelector:@selector(setText:) withObject:selectedValue];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };

    [ActionSheetStringPicker showPickerWithTitle:@"" rows:self.arrayPicker initialSelection:0 doneBlock:done cancelBlock:cancel origin:self.theTableView];
}
-(void)setText:(id)sender{
    [self.arraySelect replaceObjectAtIndex:indexpathNow.row withObject:[NSString stringWithFormat:@"%@",sender]];
    [self.theTableView reloadData];

}
-(void)dismissKeyBoard:(id)sender{
    
    UITableViewCell *cell=[self.theTableView cellForRowAtIndexPath:self.indexpathNow];
    UITextField *text=(UITextField *)[cell.contentView viewWithTag:12];
    [text resignFirstResponder];
    [text removeFromSuperview];
    
    NSInteger selectRow=[self.thePickerView selectedRowInComponent:0];
    //[self.arraySelect objectAtIndex:indexPath.row]
    
    [self.arraySelect replaceObjectAtIndex:indexpathNow.row withObject:[self.arrayPicker objectAtIndex:selectRow]];
    [self.theTableView reloadData];
    
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
        default:
            break;
    }
    
}

- (void)selectExistingPicture{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing=YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
        picker.allowsEditing=YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    [self.arraySelect replaceObjectAtIndex:0 withObject:image];
    [picker dismissModalViewControllerAnimated:YES];
    [self.theTableView reloadData];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}
//选取默认图片的委托
-(void)theSelectPhoto:(UIImage *)image{
    
    [self.arraySelect replaceObjectAtIndex:0 withObject:image];
    [self.theTableView reloadData];
}
@end
