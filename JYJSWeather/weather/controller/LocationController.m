//
//  LocationController.m
//  JYJS
//
//  Created by DEV-IOS-2 on 15/12/17.
//  Copyright © 2015年 DEV-IOS-2. All rights reserved.
//

#import "LocationController.h"
#import <CoreLocation/CoreLocation.h>


#import "ASNetworking.h"
#import "DBModel.h"

#import "SqlDataBase.h"
#import "DBModel.h"
#import "Utils.h"

#define UserLocationManager @"userLocationManager"

@interface LocationController ()<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
{
    /*
     除了提供位置跟踪功能之外，在定位服务中还包含CLGeocoder类用于处理地理编码和逆地理编码（又叫反地理编码）功能。
     地理编码：根据给定的位置（通常是地名）确定地理坐标(经、纬度)。
     逆地理编码：可以根据地理坐标（经、纬度）确定位置信息（街道、门牌等）
     */
    //    CLGeocoder *_geocoder;
    
    /*
     YES:tableview上铺dataArr , 即所有保存的城市
     NO:tableview上铺resultArr , 即所有检索到的城市
     */
    BOOL change;
}
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *resultArr; // 搜索结果数组
@property (nonatomic, strong) UISearchBar *searchBar;
@property (retain) CLLocationManager *locationManager;

@property (nonatomic, strong) UIButton * myLocation;
@property (nonatomic, strong) UIButton * editBut;


@end

@implementation LocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"城市管理";
    [self handleData];
    [self creatTable];
    
}
- (void)handleData
{
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
    self.dataArr = [sqldata searchAllSaveCity];
    
}
- (void)creatTable
{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20) style:UITableViewStyleGrouped];
    [self.view addSubview:self.table];
    _table.delegate = self;
    _table.dataSource = self;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LOCATIONCELL"];
    
    [self createSearchBar];
}

#pragma mark - 定位
// 正则表达式
- (NSArray *)regex:(NSString *)regex text:(NSString *)text
{
    NSError *error;
    NSRegularExpression *regexnew = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
    if (regex != nil) {
        NSArray *array = [regexnew matchesInString:text options:0 range:NSMakeRange(0, [text length])];
        return array;
    }else{
        return nil;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations firstObject];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"出错啦%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        CLPlacemark *placemark=[placemarks firstObject];
        NSString * url = [NSString stringWithFormat:WeatherUrlForOneCity, placemark.location.coordinate.latitude,placemark.location.coordinate.longitude];
        [ASNetworking ASNetURLconnectionWith:url type:@"GET" Parmaters:nil FinishBlock:^(NSData *data) {
            if (data != nil) {
                NSLog(@"请求成功");
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
                NSDictionary *dictionary = [dic objectForKey:@"location"];
                
                NSString *citiname = [dictionary objectForKey:@"city"];
                NSArray *cityNameArr = [citiname componentsSeparatedByString:@" "];
                //                NSString * cityName = [cityNameArr firstObject];
                NSString * cityName = @"Hangzhou";
                
                SqlDataBase *sqldata = [[SqlDataBase alloc]init];
                DBModel * model = [sqldata searchWithCityName:cityName];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (model.cityCC) {
                        [self saveCityToDB:model];
                    } else {
                        NSLog(@"未找到当前定位城市");
                    }
                    
                    
                });
                
            }else{
                NSLog(@"请求失败");
            }
            
        }];
        
        
        NSLog(@"当前城市信息:%@",[placemark.addressDictionary objectForKey:@"City"]);
        [self.locationManager stopUpdatingLocation];
        
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
    NSLog(@"error.localizedDescription:%@",error.localizedDescription);
}
#pragma mark - 搜索
- (void)createSearchBar
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.table.tableHeaderView = _searchBar;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"%s",__func__);
    self.editBut.selected = YES;
    [self editAction:self.editBut];
    [searchBar setShowsCancelButton:YES animated:YES];
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    for (UIView *searchbuttons in [searchBar.subviews[0] subviews]){
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
            cancelButton.frame = CGRectMake(cancelButton.frame.origin.x+8, cancelButton.frame.origin.y, cancelButton.frame.size.width, cancelButton.frame.size.height);
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    for (UIView* subview in [[searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)subview;
            textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width+20, textField.frame.size.height);
        }
    }
    // 开始编辑
    return YES;
}
// 点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.resultArr = [NSMutableArray array];
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [searchBar.text stringByTrimmingCharactersInSet:set];
    if (searchBar.text == nil || trimedString.length == 0) {
        
        
    }else if (searchBar.text.length>0&&![Utils isAllChineseInString:searchBar.text]) {
        NSLog(@"searchBar.text1:%@",searchBar.text);
        self.resultArr =  [sqldata searchWithString:searchBar.text andIsCC:NO];
        
    }else if (searchBar.text.length>0&&[Utils isAllChineseInString:searchBar.text]) {
        NSLog(@"searchBar.text2:%@",searchBar.text);
        self.resultArr =  [sqldata searchWithString:searchBar.text andIsCC:YES];
        
    }
    if (self.resultArr.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"查询不到您输入的城市" delegate:self cancelButtonTitle:@"重新查询" otherButtonTitles: nil];
        [alert show];
        
    } else {
        change = YES;
        [self.table reloadData];
    }
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    // 结束编辑
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    change = NO;
    [searchBar resignFirstResponder];
    // 点击取消
}

#pragma mark - table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOCATIONCELL" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"当前定位城市";
    }
    if (change) {
        DBModel *model = [self.resultArr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.cityCC;
    }else{
        if (self.dataArr.count == 0) {
            cell.textLabel.text = @"当前未添加城市";
        } else {
            DBModel *model = [self.dataArr objectAtIndex:indexPath.row];
            cell.textLabel.text = model.cityCC;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (change) {
        return self.resultArr.count;
    }else{
        if (self.dataArr.count == 0) {
            return 1;
        } else {
            return self.dataArr.count;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (change) {
        
        change = NO;
        DBModel * model = [self.resultArr objectAtIndex:indexPath.row];
        [self saveCityToDB:model];
    } else {
        
        
    }
    
    //    [self.navigationController popViewControllerAnimated:YES];
}
// 判断这个城市是否已经添加过,如果未添加过则添加到表中
- (void)saveCityToDB:(DBModel *)model
{
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
    
    if ([sqldata searchOneCity:model] != nil) {
        [self.table reloadData];
        return;
    }else{
        
        [sqldata saveCityToDB:model];
        
        [self.dataArr removeAllObjects];
        self.dataArr = [sqldata searchAllSaveCity];
        [self.table reloadData];
    }
    
}
#pragma mark - 滚动键盘退出
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, EditHeight)];
    
    
    self.myLocation = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, EditWidth, EditHeight)];
    [view addSubview:_myLocation];
    [_myLocation setTitle:@"当前位置" forState:UIControlStateNormal];
    [_myLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_myLocation addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"定位图标_天气指数页.png"]];
    [view addSubview:titleImageView];
    titleImageView.frame = CGRectMake(EditWidth, (EditHeight-19.5)/2, 15, 19.5);
    
    
    self.editBut = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width - EditWidth, 0, EditWidth, EditHeight)];
    [view addSubview:_editBut];
    [_editBut setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editBut addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [_editBut setTitle:@"完成" forState:UIControlStateSelected];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return EditHeight;
}
// 编辑 / 完成 点击事件
- (void)editAction:(UIButton *)button
{
    [_searchBar resignFirstResponder];
    
    button.selected = !button.selected;
    if (button.selected) {
        
        [self.table setEditing:YES animated:YES];
    }else{
        [self.table setEditing:NO animated:YES];
    }
    
}
- (void)locationAction
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务尚未打开");
        return;
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        NSLog(@"shahsasha");
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"tantanatan");
    }
    [_locationManager requestWhenInUseAuthorization];
    
    //设置代理
    _locationManager.delegate=self;
    //设置定位精度
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //    //定位频率,每隔多少米定位一次
    //    CLLocationDistance distance=10;//十米定位一次
    //    _locationManager.distanceFilter=distance;
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
    self.geocoder=[[CLGeocoder alloc]init];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}
// 删除城市
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
    [sqldata deleateCityFromSaveCity:[self.dataArr objectAtIndex:indexPath.row]];
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
// 交换城市位置
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    id object = [self.dataArr objectAtIndex:fromRow];
    [self.dataArr removeObjectAtIndex:fromRow];
    [self.dataArr insertObject:object atIndex:toRow];
}

@end
