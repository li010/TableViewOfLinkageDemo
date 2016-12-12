//
//  ViewController.m
//  TableViewOfLinkageDemo
//
//  Created by li010 on 16/12/12.
//  Copyright © 2016年 li010. All rights reserved.
//

#import "ViewController.h"
#import "TitleTableView.h"
#import "DetailTableView.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet TitleTableView *titleTableView;
@property (weak, nonatomic) IBOutlet DetailTableView *detailTableView;

@property (nonatomic ,strong) NSMutableArray *titleDataSource;
@property (nonatomic ,strong) NSMutableArray *detailDataSourse;

@property (nonatomic ,assign) CGFloat detailViewOffsetY;
@property (nonatomic ,assign) BOOL isScrollUp;

@end

@implementation ViewController


//懒加载数据源
- (NSMutableArray *)titleDataSource {
    if (!_titleDataSource) {
        _titleDataSource = [NSMutableArray array];
        for (NSInteger i = 1; i < 21; i++) {
            NSString *titleStr = [NSString stringWithFormat:@"第--%ld大类",i];
            
            [_titleDataSource addObject:titleStr];
        }
    }
    return _titleDataSource;
}

- (NSMutableArray *)detailDataSourse {
    if (!_detailDataSourse) {
        _detailDataSourse = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
            NSString *detailStr = [NSString stringWithFormat:@"小类别--%ld",i];
            [_detailDataSourse addObject:detailStr];
        }
    }
    return _detailDataSourse;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isScrollUp = true;
    [_titleTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}
#pragma  mark --UITableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _detailTableView) {
        return self.titleDataSource.count;
    } else {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _titleTableView) {
        return self.titleDataSource.count;
    } else {
        return self.detailDataSourse.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _detailTableView) {
        return 30;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _detailTableView) {
        return 20;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _detailTableView) {
        return self.titleDataSource[section];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    if (tableView == _titleTableView) {
        cell.textLabel.text = self.titleDataSource[indexPath.row];
    } else {
        cell.textLabel.text = self.detailDataSourse[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (tableView == _detailTableView && !_isScrollUp) {
        [_titleTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (tableView == _detailTableView && _isScrollUp) {
        [_titleTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section + 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _titleTableView) {
        [_detailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _detailTableView) {
        self.isScrollUp = _detailViewOffsetY < scrollView.contentOffset.y;
        _detailViewOffsetY = scrollView.contentOffset.y;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
