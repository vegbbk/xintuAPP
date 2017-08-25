//
//  picPreviewViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/4/18.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "picPreviewViewController.h"
#import "PhotoView.h"
#import "ZXUploadImage.h"
@interface picPreviewViewController ()<PhotoViewDelegate,ZXUploadImageDelegate>{

    PhotoView *photoV;

}

@end

@implementation picPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BlackColor;
    
    photoV = [[PhotoView alloc] initWithFrame:self.view.frame withPhotoUrl:self.ImgUrlStr];
    photoV.delegate = self;
    [self.view addSubview:photoV];
    
    UIButton * button = [myLjjTools createButtonWithFrame:CGRectMake(15, 40, 60, 30) andTitle:@"更改" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(changeImgClick) andTarget:self];
    button.layer.cornerRadius = 5.0;
    button.clipsToBounds = YES;
    [self.view addSubview:button];

    // Do any additional setup after loading the view.
}

-(void)changeImgClick{

 [[ZXUploadImage shareUploadImage] showActionSheetInFatherViewController:self isTailoring:YES delegate:self];

}

-(void)uploadImageToServerWithImage:(UIImage *)image{

    photoV.imageView.image = image;
    
}
-(void)TapHiddenPhotoView{
    if(photoV.imageView.image){
    [self.delegate changePicPreViewClick:photoV.imageView.image withType:self.typeNum];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
