//
//  TCAdministrativeAreaViewController.m
//  TouCe
//
//  Created by Ethan Guo on 2018/3/10.
//  Copyright © 2018年 ebeitech. All rights reserved.
//

#import "TCAdministrativeAreaViewController.h"
#import "TCAdministrativeAreaPresenter.h"

#define kAdministrativeAreaCellIdentifier @"kAdministrativeAreaCellIdentifier"

@interface TCAdministrativeAreaViewController () <UITableViewDelegate, UITableViewDataSource, TCAdministrativeAreaProtocol>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;
@property (strong, nonatomic) TCAdministrativeAreaPresenter *presenter;

@end

@implementation TCAdministrativeAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    self.title = @"请选择行政区划";
    [self setNavigationLeftBarButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.saveButton];
}

- (void)layoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.saveButton.mas_top);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(UI_SIZE_BTN_HEIGHT);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}

- (void)setupData {
    [self.tableView reloadData];
}

#pragma mark - Private Method
- (void)saveButtonClicked:(id)sender {
    if (self.CommitBlock) {
        self.CommitBlock(@[self.presenter.nationModel,
                           self.presenter.provinceModel,
                           self.presenter.cityModel,
                           self.presenter.strictModel,
                           self.presenter.streetModel]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TCAdministrativeAreaProtocol
- (void)showIndicatorWithInfo:(NSString *)infoString {
    [SVProgressHUD showWithStatus:infoString];
}

- (void)showDelayIndicatorWithInfo:(NSString *)infoString {
    [SVProgressHUD showErrorWithStatus:infoString];
    [SVProgressHUD dismissWithDelay:2];
}

- (void)hideIndicator {
    [SVProgressHUD dismiss];
}

- (void)reloadAreaList {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.currentAreaList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAdministrativeAreaCellIdentifier forIndexPath:indexPath];
    
    TCAdministrativeAreaModel *model = self.presenter.currentAreaList[indexPath.row];
    cell.textLabel.text = model.areaName;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TCAdministrativeAreaModel *model = self.presenter.currentAreaList[indexPath.row];
   
    switch (self.presenter.type) {
        case TCAdministrativeAreaTypeNation: {
            self.presenter.nationModel = model;
            break;
        }
        case TCAdministrativeAreaTypeProvince: {
            self.presenter.provinceModel = model;
            break;
        }
        case TCAdministrativeAreaTypeCity: {
            self.presenter.cityModel = model;
            break;
        }
        case TCAdministrativeAreaTypediStrict: {
            self.presenter.strictModel = model;
            break;
        }
        case TCAdministrativeAreaTypeStreet: {
            self.presenter.streetModel = model;
            [self saveButtonClicked:nil];
            return;
        }
    }
    if(self.presenter.type == self.toAreaType){
        [self saveButtonClicked:nil];
        return;
    }else{
        [self.presenter getAdministrativeAreaWithType:self.presenter.type+1];
    }
}

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 45;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kAdministrativeAreaCellIdentifier];
    }
    return _tableView;
}

- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [[UIButton alloc] initWithText:@"保存"
                                           textColor:COLOR_BG_WHITE
                                                font:FONT_30
                                     backgroundColor:COLOR_BTN_CYAN];
        [_saveButton addTarget:self
                        action:@selector(saveButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _saveButton;
}

- (TCAdministrativeAreaPresenter *)presenter {
    if (!_presenter) {
        _presenter = [[TCAdministrativeAreaPresenter alloc] init];
        _presenter.toAreaType = self.toAreaType;
        [_presenter attachView:self];
    }
    return _presenter;
}
@end
