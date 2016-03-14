//
//  WLCContactsController.m
//  XMPP
//
//  Created by 王 on 16/3/11.
//  Copyright © 2016年 WLChopSticks. All rights reserved.
//

#import "WLCContactsController.h"
#import "WLCXMPPTool.h"

@interface WLCContactsController ()<XMPPRosterDelegate>

@property (strong, nonatomic) NSArray *allContacts;

@end

@implementation WLCContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[WLCXMPPTool sharedXMPPTool].xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [[WLCXMPPTool sharedXMPPTool].xmppRoster fetchRoster];
}

#pragma -mark roster代理方法
//开始点名
-(void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    NSLog(@"xmppRosterDidBeginPopulating");
}
//结束点名
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender {
    
    //获取好友列表
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSManagedObjectContext *context = [WLCXMPPTool sharedXMPPTool].xmppRosterCoreDataStorage.mainThreadManagedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *fetchObjects = [context executeFetchRequest:fetchRequest error:&error];
        NSLog(@"数组--%@",fetchObjects);
//        NSLog(@"数组--%@",error);
        self.allContacts = fetchObjects;
        [self.tableView reloadData];
        
    });
}

#pragma -mark tableView数据源代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allContacts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    XMPPUserCoreDataStorageObject *objc =self.allContacts[indexPath.row];
    
    
    
    cell.textLabel.text = objc.jidStr;
    
    //设置头像  好友的
    
    NSData *imageData =  [[WLCXMPPTool sharedXMPPTool].xmppvCardAvatarModule photoDataForJID:objc.jid];
    cell.imageView.image = [UIImage imageWithData:imageData];
    cell.imageView.layer.cornerRadius = 20;
    
    return cell;
}

#pragma -mark 加好友
- (IBAction)addFriend:(UIBarButtonItem *)sender {
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
