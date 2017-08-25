//
//  driverAndStudentMapViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/15.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "driverAndStudentMapViewController.h"
#import "CustomAnnotationLJJView.h"
#import "driverAndStudentMapModel.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
static const NSInteger RoutePlanningPaddingEdge                    = 20;
static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
@interface driverAndStudentMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>{

    MAMapView *_mapView ;
    NSMutableArray * _dataArr;
    MAPolyline *commonPolyline;
    NSArray * listArr;
     AMapGeoPoint*_startPoint;//起点
    AMapGeoPoint* _endPoint;//终点
}
@property(nonatomic,strong)AMapSearchAPI * search;
@property (nonatomic) MANaviRoute * naviRoute;
@property (nonatomic, strong) AMapRoute *route;
@end

@implementation driverAndStudentMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"司机位置";
    _dataArr = [NSMutableArray array];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT-64)];
    ///把地图添加至view
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [self loadLat];
    
    UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake(SCREEN_WIDTH-120, SCREEN_HEIGHT-120, 80, 80) andTitle:@"刷新位置" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(freshDress) andTarget:self];
    btn.layer.cornerRadius = 40;
    btn.clipsToBounds = YES;
    [self.view addSubview:btn];
    //构造折线数据对象
   }

-(void)dealloc{

    _mapView.delegate = nil;
    self.search.delegate = nil;

}

-(void)freshDress{

    [self loadLat];
}

-(void)loadLat{

    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    SET_OBJRCT(@"strokeId", self.strokeId)
    [HttpRequest postWithURL:HTTP_URLIP(get_StudentStrokeLngLat) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        if(_dataArr.count>0){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dict in responseObject[@"data"]){
    
            driverAndStudentMapModel * model = [[driverAndStudentMapModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArr addObject:model];
        }
        if(_dataArr.count>1){
        [self loadLine];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadLine{
    
    NSMutableArray * Latarr = [NSMutableArray array];
    for(int i=0;i<_dataArr.count;i++){
        driverAndStudentMapModel * model = _dataArr[i];
        if(model.lnglat){
        NSArray * arr = [model.lnglat componentsSeparatedByString:@","];
        AMapGeoPoint * point = [AMapGeoPoint locationWithLatitude:[arr[1] floatValue]
                                                        longitude:[arr[0] floatValue]];
        [Latarr addObject:point];
        }
    }
    
    
    [self.naviRoute removeFromMapView];
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.strategy = 5;
    navi.waypoints = Latarr;
    /* 出发点. */
    _startPoint = Latarr[0];
    navi.origin = _startPoint;
    /* 目的地. */
    if (Latarr.count>1) {
    _endPoint = Latarr[Latarr.count-1];
    }else{
    _endPoint = _startPoint;
    }
    navi.destination = _endPoint;
    [self.search AMapDrivingRouteSearch:navi];
    NSLog(@"%@----%@",_startPoint,_endPoint);
    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude = _endPoint.latitude;
    coordinate1.longitude = _endPoint.longitude;
    [_mapView setCenterCoordinate:coordinate1 animated:YES];
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    self.route = response.route;
    if (response.count > 0)
    {
        [self presentCurrentCourse];
  }
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    MAPointAnnotation *StartpointAnnotation = [[MAPointAnnotation alloc] init];
    StartpointAnnotation.coordinate = CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude);
    StartpointAnnotation.title = @"起点";
    [_mapView addAnnotation:StartpointAnnotation];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude);
    pointAnnotation.title = @"终点";
    [_mapView addAnnotation:pointAnnotation];
    
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:_startPoint.latitude longitude:_startPoint.longitude] endPoint:[AMapGeoPoint locationWithLatitude:_endPoint.latitude longitude:_endPoint.longitude]];
    [self.naviRoute addToMapView:_mapView];
    [_mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                    edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                       animated:YES];

}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 4.f;
        polylineRenderer.strokeColor  = MAINThemeColor;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;

    /* 起点. */
    if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
    {
        poiAnnotationView.image = [UIImage imageNamed:@"行程-学生单-坐标"];
    }
    /* 终点. */
    else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
    {
        poiAnnotationView.image = [UIImage imageNamed:@"首页_小车"];
    }
     return poiAnnotationView;
    }
    return nil;
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
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
