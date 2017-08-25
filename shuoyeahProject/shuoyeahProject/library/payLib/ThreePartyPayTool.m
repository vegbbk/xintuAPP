//
//  ThreePartyPayTool.m
//  lifeKnown
//
//  Created by GW on 16/3/28.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "ThreePartyPayTool.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation ThreePartyPayTool

/**
 *  微信支付
 *
 *  @param productName  购物栏目
 *  @param payprice 价格,单位元
 *  @param payId    订单号,商家自定义
 */
+ (void)weChatPayWithProductName:(NSString*)productName payprice:(NSString*)payprice payId:(NSString*)payId
{
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:WXAppID mch_id:WX_MCH_ID];
    //设置密钥
    [req setKey:WX_PARTNER_ID];
    req.payordername=productName;
    NSInteger paypriceInt=[payprice floatValue]*100;
    //NSInteger paypriceInt=1;
    req.payorderprice=[NSString stringWithFormat:@"%ld",(long)paypriceInt];//转成单位分
    req.payorderId=payId;
    //}}}
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPayOrde];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"提示信息%@",debug]];
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
    
}

+ (void)weChatPayWithProductName:(chageljjMoneyModel*)model
{
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = model.appid;
        req.partnerId           = model.partnerid;
        req.prepayId            = model.prepayid;
        req.nonceStr            = model.noncestr;
        req.timeStamp           = model.timestamp.intValue;
        req.package             = model.package;
        req.sign                = model.sign;
        [WXApi sendReq:req];
    
}


/**
 *  支付宝
 *
 *  @param productName        商品名
 *  @param productDescription 商品描述
 *  @param payprice           价格,单位元
 *  @param tradeNO            订单号
 */
+ (void)alipayPayWithProductName:(NSString *)productName productDescription:(NSString *)productDescription payprice:(NSString *)payprice tradeNO:(NSString *)tradeNO
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
//    NSString *partner = @"2088221393885186";
//    NSString *seller = @"linh@zzzzzzzl.com";
//    NSString *privateKey = gwPriviteKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2088221393885186";
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = gwPriviteKey;
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    // NOTE: app_id设置
    order.app_id = appID;
    // NOTE: 支付接口名称
    order.method = @"mobile.securitypay.pay";
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    // NOTE: 支付版本
    order.version = @"1.0";
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = productDescription;
    order.biz_content.subject = productName;
    order.biz_content.out_trade_no = tradeNO; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = payprice; //商品价格
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"educationShuoyuea";
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:@"alipay_sdk=alipay-sdk-java-dynamicVersionNo&app_id=2017050207086007&biz_content=%7B%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%22CH2017060817012324531%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22App%E6%94%AF%E4%BB%98%E6%B5%8B%E8%AF%95Java%22%2C%22timeout_express%22%3A%2230m%22%2C%22total_amount%22%3A%220.01%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2F120.25.193.252%3A8090%2FxintuInter%2Fcharging%2FaliChargingNotify&sign=HMEI4KJMYhEUtj6zXml4jlLflXJYCbEsBzne9QWZTtqaoM1CLDxFXSrXF2AIoluNFpZGcumq9zg%2B9w8SmX2wM7WDL1UYcpDNoKgMzvYs34WH87KGo1bPXq7AXR9aElNO4edkZbDGAkuxBC2V5bov4jzI9vLIq9qNfrCYGa33Jwt6LKZa1shdcJLvgTteUWgZl8Y72cxAzAFXdQwnNooUHQU316Np%2B8QagMSHXHMafWB9uqX59hiFV0PiyKaQF0qTb3CHu6PVSfv0kiNmX%2Fikdgzch98M4vkcErhhzF02K8tVmSq%2BoCHYfhBIXEvwnEAZQnmyioOwstPa3K9U%2BzdiFQ%3D%3D&sign_type=RSA2&timestamp=2017-06-08+17%3A10%3A03&version=1.0" fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"-----支付结果result-1---%@",resultDic);
            
            NSString *resultCode=[resultDic objectForKey:@"resultStatus"];
            
            if ([resultCode intValue] == 9000)
            {
                NSLog(@"--支付成功--");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"paysucess"object:nil];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"支付成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                //                [[NSNotificationCenter defaultCenter] postNotificationName:orderPaySuccesskey object:nil];
            }
            else
            {
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"支付失败" message:[resultDic objectForKey:@"memo"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertview show];
                //交易失败
            }
        }];
    }
    
}


/**
 *  支付宝 服务器
 *
 *  @param productName        商品名
 *  @param productDescription 商品描述
 *  @param payprice           价格,单位元
 *  @param tradeNO            订单号
 */
+ (void)alipayPayWithProductName:(NSString*)signedString{
    
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"educationShuoyuea";
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"-----支付结果result-1---%@",resultDic);
            
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
    }


}
@end
