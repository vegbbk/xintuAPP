//
//  portLJJHeader.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/4/21.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#ifndef portLJJHeader_h
#define portLJJHeader_h
#define BASE_URL @"http://119.23.44.62:80/xintuInter" //真实地址192.168.199.177:8080//http://120.25.193.252:8090/xintuInter
//#define BASE_URL @"http://120.25.193.252:8090/xintuInter"
#define socketUrl @"http://120.25.193.252:8090/Websocket/"//长连接
#define HTTP_URLIP(_url_) [NSString stringWithFormat:@"%@/%@",BASE_URL,_url_]
#define HTTP_URLIMGIP(_url_,_path_) [NSString stringWithFormat:@"%@/%@/%@",BASE_URL,_path_,_url_]
#define HTTP_SOCKETIP(_url_) [NSString stringWithFormat:@"%@%@",socketUrl,_url_]
#define SET_OBJRCT(_KEY_,_VALUE_)  if(_VALUE_==nil){[parameters setObject:@"" forKey:_KEY_];}else{[parameters setObject:_VALUE_ forKey:_KEY_];}
#pragma mark --------------------------登录注册------------------------------
#define regist_User @"user/registUser" //注册
#define user_Login @"user/userLogin" //登录
#define send_SMSCode @"user/getSMSCode" //发送验证码
#define forget_UserPass @"user/forgetUserPass" //忘记密码
#define save_UserProfile @"user/saveUserProfile" //保存用户资料
#define upload_UserHeadImg @"user/uploadUserHeadImg" //保存用户资料
#define change_UserPhone @"user/changeUserPhone"//修改手机号
#pragma mark --------------------------个人中心------------------------------

#define collect_Driver @"collect/collectDriver" //收藏司机
#define getUser_CollectList @"collect/getUserCollectList" //收藏列表
#define remove_UserCollect @"collect/removeUserCollect" //删除收藏
#define get_DriverDetail @"driver/getDriverDetail"//司机详情
#define get_DriversList @"driver/getDriversList"//司机列表

#define get_Industry @"user/getIndustry"//获取行业
#define get_Job @"user/getJob"//获取职业

#define add_Stroke @"stroke/addStroke"//下单
#define cars_Type @"car/getCarTypeList"//获取车型

#define uploadLegal_PersonIDBImg  @"company/uploadLegalPersonIDBImg"//上传身份证
#define uploadompany_Lisence @"company/uploadompanyLisence"//上传营业执照
#define cert_Enterprise @"company/certEnterprise"//企业认证
#define get_EnterpriseDetail @"company/getEnterpriseDetail"//企业详情

#define save_Department @"company/saveDepartment"//新增部门
#define get_AllDepartment @"company/getAllDepartment"//获取部门列表
#define get_CompanyUsers @"company/getCompanyUsers"//获取公司所有员工
#define setUser_Department @"company/setUserDepartment"//设定用户到部门
#define set_UserDepartmentBatch @"company/setUserDepartmentBatch"//设定用户到部门


#define charge_Money @"charging/charging"//充值
#define charging_History @"charging/getChargingHistory"//充值记录
#define get_Balance @"account/getBalance"//查询余额
#define pay_Ment @"pay/payMent"//支付
#define get_VoucherHistory @"voucher/getVoucherHistory"//优惠券分页查询
#define Pay_mentList @"pay/getPaymentHistory"//支付记录
#define get_VoucherDetails @"voucher/getVoucherDetails"//优惠券详情
#define get_PaymentDetails @"payment/getPaymentDetails"//支付记录详情
#define receipt_apply @"receipt/apply"//发票申请
#define get_ReceiptHistory @"receipt/getReceiptHistory"//发票申请分页查询
#define get_ReceiptDetails @"receipt/getReceiptDetails"//发票申请详情
#define get_ChargingDetails @"charging/getChargingDetails"//充值记录详情
#define add_Comment @"order/addComment"//评论
#define get_CommentType @"order/getCommentType"//获取评论类型
#define get_StrokeDetail @"stroke/getStrokeDetail"//
#pragma mark --------------------------行程------------------------------

#define get_UserStrokeList @"stroke/getUserStrokeList"//行程列表
#define get_OrderAmount @"order/getOrderAmount"//获取用户可开票金额
#define get_OrderListByReciept @"order/getOrderListByReciept"//获取用户可开票行程
#define get_UserStrokeByStrokeId @"stroke/getUserStrokeByStrokeId"//行程详情
#define get_StudentStrokeList @"stroke/getStudentStrokeList"//学生单
#define get_StudentStrokeLngLat @"stroke/getStudentStrokeLngLat"//学生单坐标
#pragma mark --------------------------活动------------------------------
#define get_ActiveList @"active/getActiveList"//活动列表
#define get_SystemMessage @"chat/getSystemMessage"
#pragma mark --------------------------首页------------------------------
#define get_StrokeFee @"stroke/getStrokeFee"//获取实时计费
#define get_BusTypeList @"busType/getBusTypeList"//获取首页数据
#define get_BusTypeList @"busType/getBusTypeList"//获取首页数据
#define get_AddressList @"address/getAddressList"//获取常用地址列表
#define set_DefaultAddrss @"address/setDefaultAddrss"//设置默认地址
#define saveOrUpdate_Address @"address/saveOrUpdateAddress"//修改新增地址
#define get_AddressDetail @"address/getAddressDetail"//地址详情
#define remove_Address @"address/removeAddress"//删除地址
#define Pre_Expenses @"stroke/PreExpenses"//费用计算

#define get_AboutApp @"system/getAboutApp"//关于产品
#define get_CompainType @"system/getCompainType"//投诉类型
#define add_Compain @"system/addCompain"//投诉
#define cancel_Order @"order/cancelOrder"//取消行程
#define cancel_Reason @"order/cancelReason"//取消类型
#define change_UserPassword @"user/changeUserPassword"//修改密码
#endif /* portLJJHeader_h */
