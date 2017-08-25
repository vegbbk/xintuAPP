//
//  ThreePartyPayTool.h
//  lifeKnown
//
//  Created by GW on 16/3/28.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//  [三方支付工具]  微信 支付宝

#import <Foundation/Foundation.h>
#import "chageljjMoneyModel.h"
@interface ThreePartyPayTool : NSObject

/**
 *  微信支付-购物
 *
 *  @param productName  购物栏目,比如"生活知了购物"
 *  @param payprice 价格,单位元
 *  @param payId    订单号,商家自定义
 */
+ (void)weChatPayWithProductName:(NSString*)productName payprice:(NSString*)payprice payId:(NSString*)payId;
/**
 *  微信支付-购物
 *
 *  @param productName  购物栏目
 *  @param payprice 价格,单位元
 *  @param payId    订单号,商家自定义
 */
+ (void)weChatPayWithProductName:(chageljjMoneyModel*)model;
/**
 *  支付宝-购物
 *
 *  @param productName        商品名
 *  @param productDescription 商品描述
 *  @param payprice           价格,单位元
 *  @param tradeNO            订单号
 */
+ (void)alipayPayWithProductName:(NSString *)productName productDescription:(NSString *)productDescription payprice:(NSString *)payprice tradeNO:(NSString *)tradeNO;
/**
 *  支付宝-服务器
 *
 *  @param productName        商品名
 *  @param productDescription 商品描述
 *  @param payprice           价格,单位元
 *  @param tradeNO            订单号
 */
+ (void)alipayPayWithProductName:(NSString*)signedString;
@end
