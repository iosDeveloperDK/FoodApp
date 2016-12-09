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

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position adress:(NSString *)adress;

@end

@implementation DKPoint

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position adress:(NSString *)adress {
    if ((self = [super init])) {
        _position = position;
        _adress = adress;
    }
    return self;
}

@end

@interface DKContactsViewController () <GMSMapViewDelegate,CLLocationManagerDelegate, GMUClusterManagerDelegate>
{
    GMUClusterManager *_clusterManager;
    CLLocation* currentLocation;
    NSString* adress;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UILabel *labelAdress;

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

}

#pragma mark - Actions

- (IBAction)actionCurrentLocation:(UIButton *)sender {
    
    self.labelAdress.text = adress;
    
    
    
    [self showCurrentLocation:currentLocation];
    
}


-(void)showCurrentLocation:(CLLocation*)location{

    GMSMarker *marker = [[GMSMarker alloc] init];
    
    marker.position = location.coordinate;
    
    marker.icon = [UIImage imageNamed:@"current_map_location"];

    marker.map = self.containerView;
    
    GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:5];
    
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:newCamera];
    
    [self.containerView animateWithCameraUpdate:update];
    
    [self.locationManager stopUpdatingLocation];

    
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    if (locations.lastObject) {
        
        currentLocation = locations.lastObject;
        
        CLGeocoder* geo = [[CLGeocoder alloc]init];
        
        [geo reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            adress = [placemarks lastObject].locality;
            
        }];

    }
    
}




#pragma mark - GMSMapViewDelegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    //отображения адреса при нажатии на маркер

    DKPoint *poiItem = marker.userData;
    
    if (poiItem != nil) {
        
        self.labelAdress.text = poiItem.adress;
        
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
    
    //можно было получать адреса при помощи CLGeocoder, но с Беларусью он не дружит(, можно было использовать Google Maps Geocoding API для этой задачи
    
    NSArray* arrayAdress = @[@"50 лет победы", @"Абрикосовая ул.", @"Авакяна ул.", @"Нагорный пер."];
    
    for (NSString* str in arrayAdress) {
        
        double lat = 53 + [self randomScale];
        
        double lng = 27 + [self randomScale];

        id<GMUClusterItem> item = [[DKPoint alloc] initWithPosition:CLLocationCoordinate2DMake(lat, lng) adress:str];

        [_clusterManager addItem:item];

    }
    
}

- (double)randomScale {
    
    return (double)arc4random() / UINT32_MAX * 2.0 - 1.0;
    
}


@end
