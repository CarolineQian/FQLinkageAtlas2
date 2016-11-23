//
//  ViewController.m
//  FQLinkageAtlas2
//
//  Created by 冯倩 on 2016/11/23.
//  Copyright © 2016年 冯倩. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    btn.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    btn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction
{
    ViewController2 *vc = [[ViewController2 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
