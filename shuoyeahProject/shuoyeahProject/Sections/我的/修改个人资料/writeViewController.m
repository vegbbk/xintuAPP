//
//  writeViewController.m
//  IMshuoyeah
//
//  Created by shuoyeah on 16/4/1.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "writeViewController.h"
#import "CustomTextVeiw.h"
@interface writeViewController ()
@property (nonatomic,strong)CustomTextVeiw * writeText;
@end

@implementation writeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑个性签名";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    _writeText = [[CustomTextVeiw alloc]initWithFrame:CGRectMake(8, 74, SCREEN_WIDTH-16, 160)];
    _writeText.layer.borderWidth = 1;
    _writeText.layer.cornerRadius = 4;
    if(self.signatureStr){
        _writeText.text = _signatureStr;
    }
    _writeText.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _writeText.customPlaceholder = @"请输入内容";
    [self.view addSubview:_writeText];
    // Do any additional setup after loading the view.
}

-(void)createUI{

    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(0, 0, 60, 30);
    [releaseButton setTitle:@"确定" forState:normal];
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseButton.layer.cornerRadius = 3;
   // [releaseButton setBackgroundColor:MAINThemeColor];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

}

-(void)releaseInfo{
    
    [_writeText resignFirstResponder];
    if(_writeText.text.length==0){
        ToastWithTitle(@"输入内容不能为空");
        return;
    }
    if(_writeText.text.length>50){
        ToastWithTitle(@"个性签名不能多于50字");
        return;
    }
    
    [self.delegate sendInfowith:_writeText.text];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
