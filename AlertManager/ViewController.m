//
//  ViewController.m
//  AlertManager
//
//  Created by zhengyi on 2020/5/19.
//  Copyright © 2020 zhengyi. All rights reserved.
//

#import "ViewController.h"
#import "BBAlertManager.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 370, SCREEN_WIDTH - 20, 20)];
    [self.view addSubview:label];
    
    [RACObserve([BBAlertManager shared], waitQueue) subscribeNext:^(id  _Nullable x) {
        NSArray *typeArray = [[BBAlertManager shared].waitQueue valueForKey:@"type"];
        label.text = [typeArray componentsJoinedByString:@","];
    }];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, SCREEN_WIDTH, 44*6) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    switch (indexPath.row+1) {
        case 1:
            cell.textLabel.text = @"BBAlertLevelNormal";
            break;
        case 2:
            cell.textLabel.text = @"BBAlertLevelNormal";
            break;
        case 3:
            cell.textLabel.text = @"BBAlertLevelAppend";
            break;
        case 4:
            cell.textLabel.text = @"BBAlertLevelForce";
            break;
        case 5:
            cell.textLabel.text = @"BBAlertLevelForce";
            break;
        case 6:
            cell.textLabel.text = @"BBAlertLevelForce 与5互斥";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    switch (indexPath.row+1) {
        case 1:{
            BBAlertItem *item = [BBAlertItem new];
            item.type = BBAlertTypePush;
            item.level = BBAlertLevelNormal;
            @weakify(item);
            item.showBlock = ^{
                @strongify(item);
                UILabel *alertView = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 30, 30)];
                alertView.backgroundColor = [UIColor systemPinkColor];
                alertView.text = [@(indexPath.row+1) description];
                [self.view addSubview:alertView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView removeFromSuperview];
                    [[BBAlertManager shared] removeItem:item];
                });
            };
            [[BBAlertManager shared] tryShowItem:item];
        }
            break;
        case 2:{
            BBAlertItem *item = [BBAlertItem new];
            item.type = BBAlertTypeLogin;
            item.level = BBAlertLevelNormal;
            @weakify(item);
            item.showBlock = ^{
                @strongify(item);
                UILabel *alertView = [[UILabel alloc] initWithFrame:CGRectMake(70, 300, 30, 30)];
                alertView.backgroundColor = [UIColor systemRedColor];
                alertView.text = [@(indexPath.row+1) description];
                [self.view addSubview:alertView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView removeFromSuperview];
                    [[BBAlertManager shared] removeItem:item];
                });
            };
            [[BBAlertManager shared] tryShowItem:item];
            
        }
            break;
        case 3:{
            BBAlertItem *item = [BBAlertItem new];
            item.type = BBAlertTypeGuide;
            item.level = BBAlertLevelAppend;
            @weakify(item);
            item.showBlock = ^{
                @strongify(item);
                UILabel *alertView = [[UILabel alloc] initWithFrame:CGRectMake(130, 300, 30, 30)];
                alertView.backgroundColor = [UIColor systemGreenColor];
                alertView.text = [@(indexPath.row+1) description];
                [self.view addSubview:alertView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView removeFromSuperview];
                    [[BBAlertManager shared] removeItem:item];
                });
            };
            item.canShowBlock = ^BOOL{
                @strongify(self);
                return YES;
            };
            [[BBAlertManager shared] tryShowItem:item];
            
        }
            break;
        case 4:{
            BBAlertItem *item = [BBAlertItem new];
            item.type = BBAlertType4;
            item.level = BBAlertLevelForce;
            @weakify(item);
            item.showBlock = ^{
                @strongify(item);
                UILabel *alertView = [[UILabel alloc] initWithFrame:CGRectMake(190, 300, 30, 30)];
                alertView.backgroundColor = [UIColor systemBlueColor];
                alertView.text = [@(indexPath.row+1) description];
                [self.view addSubview:alertView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView removeFromSuperview];
                    [[BBAlertManager shared] removeItem:item];
                });
            };
            [[BBAlertManager shared] tryShowItem:item];
            
        }
            break;
        case 5:{
            BBAlertItem *item = [BBAlertItem new];
            item.type = BBAlertType5;
            item.level = BBAlertLevelForce;
            @weakify(item);
            item.showBlock = ^{
                @strongify(item);
                UILabel *alertView = [[UILabel alloc] initWithFrame:CGRectMake(250, 300, 30, 30)];
                alertView.backgroundColor = [UIColor systemPinkColor];
                alertView.text = [@(indexPath.row+1) description];
                [self.view addSubview:alertView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView removeFromSuperview];
                    [[BBAlertManager shared] removeItem:item];
                });
            };
            [[BBAlertManager shared] tryShowItem:item];
            
        }
            break;
        case 6:{
            BBAlertItem *item = [BBAlertItem new];
            item.type = BBAlertType6;
            item.level = BBAlertLevelForce;
            item.exclusionTypes = @[@(BBAlertType5)];
            @weakify(item);
            item.showBlock = ^{
                @strongify(item);
                UILabel *alertView = [[UILabel alloc] initWithFrame:CGRectMake(310, 300, 30, 30)];
                alertView.backgroundColor = [UIColor systemPinkColor];
                alertView.text = [@(indexPath.row+1) description];
                [self.view addSubview:alertView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView removeFromSuperview];
                    [[BBAlertManager shared] removeItem:item];
                });
            };
            [[BBAlertManager shared] tryShowItem:item];
            
        }
            break;
        default:
            break;
    }

}


@end
