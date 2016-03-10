//
//  WLCMyInformationController.m
//  XMPP
//
//  Created by 王 on 16/3/10.
//  Copyright © 2016年 WLChopSticks. All rights reserved.
//

#import "WLCMyInformationController.h"
#import "WLCXMPPTool.h"
#import "WLCInformationEditController.h"

@interface WLCMyInformationController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *myAvatar;
@property (weak, nonatomic) IBOutlet UILabel *myNickName;
@property (weak, nonatomic) IBOutlet UILabel *myJID;
@property (weak, nonatomic) IBOutlet UILabel *myAddress;
@property (weak, nonatomic) IBOutlet UILabel *myGender;
@property (weak, nonatomic) IBOutlet UILabel *mycity;
@property (weak, nonatomic) IBOutlet UILabel *myDesc;

@end

@implementation WLCMyInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //去网络获取个人信息数据并显示
    [self getDataFromInternet];
}


#pragma -mark 获得网络上数据并显示
-(void)getDataFromInternet {

    XMPPvCardTemp *vCardTemp = [WLCXMPPTool sharedXMPPTool].xmppvCardTempModule.myvCardTemp;
    self.myAvatar.image = [UIImage imageWithData:vCardTemp.photo];
    self.myNickName.text = vCardTemp.nickname;
    self.myDesc.text = vCardTemp.desc;
    self.myJID.text = [WLCXMPPTool sharedXMPPTool].xmppStream.myJID.bare;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        UIAlertController *actionSheetVC = [UIAlertController alertControllerWithTitle:@"选择头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //从相册读取图片
        UIAlertAction *albums = [UIAlertAction actionWithTitle:@"从相册读取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //打开相册
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc]init];
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerVC.delegate = self;
            [self presentViewController:imagePickerVC animated:YES completion:nil];

        }];
        [actionSheetVC addAction:albums];
        
        //从相机拍照
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"现在拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //打开相机(模拟器崩)
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc]init];
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerVC.delegate = self;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
            
        }];
        [actionSheetVC addAction:camera];
        
        //取消
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        [actionSheetVC addAction:cancel];
        
        [self presentViewController:actionSheetVC animated:YES completion:nil];
        
    }
}


#pragma -mark imagePickView代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *pickImage = info[@"UIImagePickerControllerOriginalImage"];

    self.myAvatar.image = pickImage;
    //上传服务器
    XMPPvCardTemp *vCardTemp = [WLCXMPPTool sharedXMPPTool].xmppvCardTempModule.myvCardTemp;
    [vCardTemp setPhoto:UIImageJPEGRepresentation(pickImage, 0.1)];
    [[WLCXMPPTool sharedXMPPTool].xmppvCardTempModule updateMyvCardTemp:vCardTemp];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma -mark 判断是点击的修改名字还是描述
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    WLCInformationEditController *infoEditVC = [segue destinationViewController];
    BOOL isNickname = [segue.identifier isEqualToString:@"nickname"]? YES : NO;
    infoEditVC.isNickname = isNickname;
    
    infoEditVC.myBlock = ^() {
        //更新界面
        [self getDataFromInternet];
    };
}

@end
