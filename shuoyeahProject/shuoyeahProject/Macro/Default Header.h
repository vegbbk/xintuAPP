//
//  Default Header.h
//  shuoyeahProject
//
//  Created by liujianji on 16/11/22.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#ifndef Default_Header_h
#define Default_Header_h

#define defaultImgName  @"默认图片"
#define defaultHeadName @"user"
#define defaultFailNet @"网络请求失败哦"
#define PicHeadLifeArr @[@"lift_home",@"lift_company",@"sofa",@"briefcase",@"train",@"aircraft",@"shopping",@"bachelor"]
//通知相关
//弹出登录界面通知
#define presentLoginViewMessage  @"presentLoginViewMessage"
//登陆成功
#define loginSucFreshData  @"loginSucFreshData"
//退出登录
#define exitSucFreshData  @"exitSucFreshData"
//APP系统字体大小统一管理
#define fontSizeLJJ 15
#define MAINtextFont(size) [UIFont systemFontOfSize:size]
//弹出视图
#define ToastWithTitle(title)  [[UIApplication sharedApplication].keyWindow makeToast:title duration:1.5 position:CSToastPositionCenter]
//项目主色调
#define MAINThemeColor rgb(223, 44, 53)
#define MAINThemeOrgColor rgb(255, 171, 39)
#define textMainColor rgb(0, 0, 0)
#define LINECOLOR rgb(238,238,238)
#define BACKLJJcolor rgb(249,249,251)
#define RGB170 rgb(170,170,170)
//#define LThemeColor  [UIColor colorForHexString:@"#ffaa46"]
#define HEXCOLOR(hexColor)  [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1]
#define kHomeColor HEXCOLOR(0xebebeb)
//  圆角和边框
#define ViewBorderRadiusColor(view,radius,width,color)\
[view.layer setCornerRadius:(radius)];\
[view.layer setMasksToBounds:YES];\
[view.layer setBorderWidth:(width)];\
[view.layer setBorderColor:[color CGColor]];
#define W_In_375(w)    round((w)*[UIScreen mainScreen].bounds.size.width/375.0)
#define widSize(size) size/375.0*SCREEN_WIDTH
#define heiSize(size) size/667.0*SCREEN_HEIGHT
//友盟分享key
#define UMshare_APPKEY  @"58c64eed99f0c73a6400035c"
//微信相关
#define WXAppID @"wx21ea923ac7deef79"
#define WXAppSecret @"d91f466145aed31a948a48a6e9a01d27"
//qq相关
#define QQAppID @"1105128120"//QQAppID 1104911525   41DB9CA5 十六进制  1104982656
#define QQAppKey @"DxR7WR95UeGrvQlp"
//高德地图相关
#define GaoDeMAPKey @"38b70847f9a653b6d352f2ad9ddffe4d"
//环信相关
#define IMAPPKEY @"1131170531115705#shuoyeahxintuapp"

//微信支付
//商户号，填写商户对应参数
#define WX_MCH_ID          @"1469472802"
//商户API密钥，填写相应参数
#define WX_PARTNER_ID      @"QPIM23X8KLK72D245JIOXMSWLK54ASKD"
//支付结果回调页面,商城支付
#define WX_NOTIFY_URL_STORE  [NSString stringWithFormat:@"%@%@",BASE_URL,@"/charging/wxChargingNotify"]
//获取服务器端支付数据地址（商户自定义）
#define WX_SP_URL          [NSString stringWithFormat:@"%@%@",BASE_URL,@"/appInterface/includes/wxpay.php"]
//支付宝
//回调地址,商城支付
#define ZFBNOTIFYURL [NSString stringWithFormat:@"%@%@",BASE_URL,@"/appInterface/index.php/Order/alipayCallback"]
#define gwPriviteKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMCNciwZCaqoNYK2IJ1jRqzs8l5cUvci2J09He3Vg9d0ZYPIiWh40kra73h+M8EREnO2Chbw9lNlgPxblZ3S9P7qeOGT1QWiFhxScAc+v7tzbNfdaxB0bdHcV3RJdoinyaHKQMEjaVWiART0JcQJPj92e/kZYp6trkXY+9iTw+7rAgMBAAECgYEAp2ENU0n8fi20Pkild0raH+3lDaOBtzTCSYTcJGdLMRoMOI806uzEGK/SJNLHmFeHy6/9e03BQmNkyXmvSD8eGYsz+J9WxUd88rMjjmrYZJonYO6Q4vD7f6S9QDSeLs5olBggkkf18pdWGFhvLfHafYhJ54SmZWum6S5vfb/gxGECQQDpB2vsAj+RbHTlJ35sxX2xV+kwNMe/g4+DHWh6AQCMC1A0Gj+UqvVrhp3t718MyE4Dn9BvsvXNi2dpI4+nSdobAkEA04iVtkcYF2b2a7bB2iOMr+DD0PN3H1dajgzijfiYwTie5scCXJ/smlMeqa5QvfX1B/eRDYbm2PjIK1A3NBqLcQJBAMiE9F8PyDeRBj2x8F4UywXxyd0Lbd7kjHectKxXdGsNySQseg2p1qmCGyAFXNsY+diwiqGzc0Q98uxMB29CY4UCQQDJvnJKrfNkHmbWxC6OBWmgNBWNqyXpVj6fS9qm3HmTjpS+NP8jp8LYTH3qBr4q7fEL8Cj/ZbG1LVB7Pr3ni4mBAkA6mdsm0SUbcbUm6E+H0m8wsqwTW+1143ec2iXi48f+cabrGSWLusDtObMJm3SzFQ2EG1IppiRa/SLf5dPTHxUZ"

//#define ZFB_NOTIFY_URL @"http://120.25.245.216/lifebrid/appInterface/alipay_callback.php"

#define orderPaySuccesskey @"orderPaySuccesskey"

//三方支付的目的:1商城购物?2打赏?
#define pay_Money_Goal_Key   @"payMoneyGoalValue"
//三方支付的方式
#define payMoneyPayWayKey   @"payMoneyPayWayKey"

#define gwPriviteKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMCNciwZCaqoNYK2IJ1jRqzs8l5cUvci2J09He3Vg9d0ZYPIiWh40kra73h+M8EREnO2Chbw9lNlgPxblZ3S9P7qeOGT1QWiFhxScAc+v7tzbNfdaxB0bdHcV3RJdoinyaHKQMEjaVWiART0JcQJPj92e/kZYp6trkXY+9iTw+7rAgMBAAECgYEAp2ENU0n8fi20Pkild0raH+3lDaOBtzTCSYTcJGdLMRoMOI806uzEGK/SJNLHmFeHy6/9e03BQmNkyXmvSD8eGYsz+J9WxUd88rMjjmrYZJonYO6Q4vD7f6S9QDSeLs5olBggkkf18pdWGFhvLfHafYhJ54SmZWum6S5vfb/gxGECQQDpB2vsAj+RbHTlJ35sxX2xV+kwNMe/g4+DHWh6AQCMC1A0Gj+UqvVrhp3t718MyE4Dn9BvsvXNi2dpI4+nSdobAkEA04iVtkcYF2b2a7bB2iOMr+DD0PN3H1dajgzijfiYwTie5scCXJ/smlMeqa5QvfX1B/eRDYbm2PjIK1A3NBqLcQJBAMiE9F8PyDeRBj2x8F4UywXxyd0Lbd7kjHectKxXdGsNySQseg2p1qmCGyAFXNsY+diwiqGzc0Q98uxMB29CY4UCQQDJvnJKrfNkHmbWxC6OBWmgNBWNqyXpVj6fS9qm3HmTjpS+NP8jp8LYTH3qBr4q7fEL8Cj/ZbG1LVB7Pr3ni4mBAkA6mdsm0SUbcbUm6E+H0m8wsqwTW+1143ec2iXi48f+cabrGSWLusDtObMJm3SzFQ2EG1IppiRa/SLf5dPTHxUZ"

#endif /* Default_Header_h */
