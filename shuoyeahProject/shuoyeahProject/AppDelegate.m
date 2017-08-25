//
//  AppDelegate.m
//  shuoyeahProject
//
//  Created by shuoyeah on 16/7/27.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreLaunchLite.h"
#import "CoreLaunchCool.h"
#import "MMDrawerController.h"
#import "baseTabBarViewController.h"
#import "welcomePageViewController.h"
#import "testSliderViewController.h"
#import "IQKeyboardManager.h"
#import "LBLaunchImageAdView.h"
#import "loginViewController.h"
#import "GWNavC.h"
#import "priceDiffLJJViewController.h"
#import "routingLJJViewController.h"
#import "paySuccessViewController.h"
#import <Bugly/Bugly.h>
//com.shupyeah.shuoyeahProjectTest   com.shupyeah.xintu
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,EMClientDelegate>
@property (nonatomic,strong) MMDrawerController * drawerController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:@"完成"];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    baseTabBarViewController * tab = [[baseTabBarViewController alloc]init];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    //初始化一个adView
    LBLaunchImageAdView * adView = [[LBLaunchImageAdView alloc]initWithWindow:self.window adType:FullScreenAdType];
    adView.localAdImgName = @"启动页ADD";
   // [CoreLaunchLite animWithWindow:self.window image:nil];
    //避免在一个界面上同时点击多个button  com.shupyeah.shuoyeahProjectTest
    [[UIButton appearance] setExclusiveTouch:YES];
    
    [AMapServices sharedServices].apiKey = GaoDeMAPKey;
    [WXApi registerApp:WXAppID];
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:IMAPPKEY];
    options.apnsCertName = @"iosxintudev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:IMAPPKEY
                                         apnsCertName:@"iosxintudev"
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    if([GVUserDefaults standardUserDefaults].LOGINSUC){
        [[EMClient sharedClient] loginWithUsername:[GVUserDefaults standardUserDefaults].userHXAccount password:[GVUserDefaults standardUserDefaults].userHXPassword];
    }
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:0
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    // 应用程序右上角数字
    [JPUSHService resetBadge];
    [Bugly startWithAppId:@"c1c2a59b6a"];
    //iOS10 注册APNs
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
    return YES;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    //NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    NSLog(@"312312312--------------%@%@",content,extras);
    [JPUSHService handleRemoteNotification:userInfo];
    //completionHandler(UNNotificationPresentationOptionAlert);
    
}

- (void)userAccountDidLoginFromOtherDevice{

    NSLog(@"哈哈哈你被挤掉了");
    [JPUSHService setTags:nil aliasInbackground:@""];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录信息过期请重新登录"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [GVUserDefaults standardUserDefaults].LOGINSUC = NO;
        loginViewController *loginVC=[[loginViewController alloc] init];
         GWNavC *gwnav=[[GWNavC alloc] initWithRootViewController:loginVC];
        [self.window.rootViewController presentViewController:gwnav animated:YES completion:nil];
    }];
    [alert addAction:action];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

- (void)autoLoginDidCompleteWithError:(EMError *)error{

    NSLog(@"环信自动登录%@",error);

}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        NSDictionary *responseDict = [logicDone dictionaryWithJsonString:userInfo[@"extra"]];
        NSLog(@"%@----",responseDict);
        if([responseDict isKindOfClass:[NSDictionary class]]){
            [self jpushNotiReceiveDic:responseDict];
        }
    }
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"%@",userInfo);
    NSDictionary * responseDict = [logicDone dictionaryWithJsonString:userInfo[@"extra"]];
    NSLog(@"%@----",responseDict);
    if([responseDict isKindOfClass:[NSDictionary class]]){
    [self jpushNotiReceiveDic:responseDict];
    }
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);// 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    // Required, iOS 7 Support
    NSDictionary *responseDict = [logicDone dictionaryWithJsonString:userInfo[@"extra"]];
    NSLog(@"%@----",responseDict);
    if([responseDict isKindOfClass:[NSDictionary class]]){
        [self jpushNotiReceiveDic:responseDict];
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)jpushNotiReceiveDic:(NSDictionary *)responseDict{

    if([unKnowToStr(responseDict[@"type"]) isEqualToString:@"1"]){
        UITabBarController *tab = (UITabBarController *)_window.rootViewController;
        UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
        priceDiffLJJViewController *vc = [[priceDiffLJJViewController alloc] init];
        if([responseDict[@"value"] isKindOfClass:[NSDictionary class]]){
        vc.orderSn = unKnowToStr(responseDict[@"value"][@"orderSn"]);
        }
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"routingFreshDeleLJJ" object:nil];
    }else if([unKnowToStr(responseDict[@"type"]) isEqualToString:@"2"]){
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"routingFreshDeleLJJ" object:nil];
    }else if([unKnowToStr(responseDict[@"type"]) isEqualToString:@"3"]){
        UITabBarController *tab = (UITabBarController *)_window.rootViewController;
        UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
        paySuccessViewController *vc = [[paySuccessViewController alloc] init];
        if([responseDict[@"value"] isKindOfClass:[NSDictionary class]]){
        vc.orderSn = unKnowToStr(responseDict[@"value"][@"orderSn"]);
        }
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"routingFreshDeleLJJ" object:nil];
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
    //[JPUSHService setBadge:badge];
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSString *str1 = [url absoluteString];
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultCode=[resultDic objectForKey:@"resultStatus"];
            
            if ([resultCode intValue] == 9000)
            {
                NSLog(@"--支付成功--");
                [[NSNotificationCenter defaultCenter ] postNotificationName:@"successPayLJJALIPAY" object:nil];
                //                [[NSNotificationCenter defaultCenter] postNotificationName:orderPaySuccesskey object:nil];
            }
            else
            {
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"支付失败" message:[resultDic objectForKey:@"memo"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertview show];
                //交易失败
            }

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else  if ([str1 rangeOfString:WXAppID].location != NSNotFound)
        
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }

    return YES;
}
//支付回调
-(void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter ] postNotificationName:@"successPayLJJ" object:nil];
                break;
                
            default:
                
                [[NSNotificationCenter defaultCenter ] postNotificationName:@"failedPay" object:nil];
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                break;
        }
    }
  
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    [JPUSHService resetBadge];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.shupyeah.shuoyeahProject" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"shuoyeahProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"shuoyeahProject.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
