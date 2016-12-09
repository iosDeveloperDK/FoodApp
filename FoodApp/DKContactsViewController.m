//
//  DKContactsViewController.m
//  FoodApp
//
//  Created by Denis on 09.12.16.
//  Copyright © 2016 Denis. All rights reserved.
//

#import "DKContactsViewController.h"
#import "DKContactsViewController.h"
#import "SWRevealViewController.h"
#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
#import <GoogleMaps/GoogleMaps.h>

@interface DKPoint : NSObject<GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;

@property(nonatomic, readonly) NSString *adress;
@property(nonatomic, readonly) NSString *phone;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position adress:(NSString *)adress;

@end

@implementation DKPoint

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position adress:(NSString *)adress phone:(NSString*)phone{
    if ((self = [super init])) {
        _position = position;
        _adress = adress;
        _phone = phone;
    }
    return self;
}

@end

@interface DKContactsViewController () <GMSMapViewDelegate,CLLocationManagerDelegate, GMUClusterManagerDelegate>
{
    GMUClusterManager *_clusterManager;
    CLLocation* currentLocation;
    NSString* currentAdress;

    NSString* adress;
    UILabel* labelAdress;
    UILabel* LabelPhone;
    UIView* infoView;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet GMSMapView *containerView;

@property (nonatomic) CLLocationManager* locationManager;

@end

@implementation DKContactsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    //Создаем mapView
    
    self.containerView.mapType = kGMSTypeNormal;
    
    GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(53.904284, 27.557024) zoom:5];
    
    self.containerView.camera = newCamera;
    
    self.containerView.delegate = self;

    //Создаем cluster для mapView
    id<GMUClusterAlgorithm> algorithm = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    
    id<GMUClusterIconGenerator> iconGenerator = [[GMUDefaultClusterIconGenerator alloc] init];
    
    id<GMUClusterRenderer> renderer = [[GMUDefaultClusterRenderer alloc] initWithMapView:self.containerView clusterIconGenerator:iconGenerator];
    
    _clusterManager =[[GMUClusterManager alloc] initWithMap:self.containerView algorithm:algorithm renderer:renderer];
    
    [_clusterManager setDelegate:self mapDelegate:self];

    //создаем рандомные точки
    [self generateClusterItems];
    
    //обновляем кластер
    [_clusterManager cluster];
    

    //создаем locationManager для получения текущий координат пользователя
    
    self.locationManager = [[CLLocationManager alloc]init];
    
    [self.locationManager requestAlwaysAuthorization];
    
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];

    [self.containerView layoutIfNeeded];
    
    //создаем деск вью
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    UIButton* location = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    location.frame = CGRectMake(CGRectGetMaxX(rect) - 40, 300, 30, 30);
    
    [location setBackgroundColor:[UIColor blackColor]];
    
    [location addTarget:self action:@selector(showCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* backImg = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 16, 16)];
    
    backImg.image = [UIImage imageNamed:@"home"];
    
    [location addSubview:backImg];
    
    [self.containerView addSubview:location];

    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 120, self.view.bounds.size.width, 120)];
    
    infoView.backgroundColor = [UIColor whiteColor];
    
    LabelPhone = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, CGRectGetWidth(infoView.bounds)-15, 21)];
    LabelPhone.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13.0f];
    
    [infoView addSubview:LabelPhone];
    
    labelAdress = [[UILabel alloc]initWithFrame:CGRectMake(15, 28, CGRectGetWidth(infoView.bounds)-15, 21)];
    labelAdress.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    
    [infoView addSubview:labelAdress];
    
    infoView.hidden = YES;

    [self.containerView addSubview:infoView];
    
}



#pragma mark - Actions


-(void)showCurrentLocation{

    infoView.hidden = NO;

    labelAdress.text = [NSString stringWithFormat:@"Адрес: %@", currentAdress];
    
    LabelPhone.text = [NSString stringWithFormat:@"Телефон: %@", @"233-00-00"];

    GMSMarker *marker = [[GMSMarker alloc] init];
    
    marker.position = currentLocation.coordinate;
    
    marker.icon = [UIImage imageNamed:@"current_map_location"];

    marker.map = self.containerView;
    
    GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:5];
    
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:newCamera];
    
    [self.containerView animateWithCameraUpdate:update];
    
    [self.locationManager stopUpdatingLocation];

    
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    if (locations.lastObject) {
        
        currentLocation = locations.lastObject;
        
        GMSGeocoder * geo = [GMSGeocoder geocoder];
        
        [geo reverseGeocodeCoordinate:currentLocation.coordinate completionHandler:^(GMSReverseGeocodeResponse * _Nullable data, NSError * _Nullable error) {
            
             currentAdress = data.firstResult.lines[0];
            
        }];
        
        [self.locationManager stopUpdatingLocation];
    }
    
}




#pragma mark - GMSMapViewDelegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    //отображения адреса при нажатии на маркер

    DKPoint *poiItem = marker.userData;
    
    if (poiItem != nil) {
        
        infoView.hidden = NO;

        labelAdress.text = [NSString stringWithFormat:@"Адрес: %@", poiItem.adress];
        
        LabelPhone.text = [NSString stringWithFormat:@"Телефон: %@", poiItem.phone];
        
    }
    
    return NO;
}

#pragma mark - GMUClusterManagerDelegate

- (void)clusterManager:(GMUClusterManager *)clusterManager didTapCluster:(id<GMUCluster>)cluster {
   
    //приближение при нажатии на кластер
    
    GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithTarget:cluster.position zoom:self.containerView.camera.zoom + 1];
    
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:newCamera];
    
    [self.containerView moveCamera:update];
}

#pragma mark Private

// рандомное генерирование кластеров

- (void)generateClusterItems {
    
    //можно было получать адреса при помощи CLGeocoder, но с Беларусью он не дружит
    
    NSArray* arrayAdress = @[@"263-23-19",@"243-23-00",@"253-33-66",@"223-33-09"];
    
    for (NSString* phone in arrayAdress) {
        
        double lat = 53 + [self randomScale];
        
        double lng = 27 + [self randomScale];

        GMSGeocoder * geo = [GMSGeocoder geocoder];
        
        CLLocation* location = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
        
        [geo reverseGeocodeCoordinate:location.coordinate completionHandler:^(GMSReverseGeocodeResponse * _Nullable data, NSError * _Nullable error) {
            
           id<GMUClusterItem> item = [[DKPoint alloc] initWithPosition:CLLocationCoordinate2DMake(lat, lng) adress:data.firstResult.lines[0] phone:phone];
            
            [_clusterManager addItem:item];

            [_clusterManager cluster];
            
        }];


    }
    
}

- (double)randomScale {
    
    return (double)arc4random() / UINT32_MAX * 2.0 - 1.0;
    
}


@end
