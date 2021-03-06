//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "LMPickerView.h"
#import "NSObject+Markup.h"

static NSString * const kComponentSeparatorTarget = @"componentSeparator";
static NSString * const kComponentNameTarget = @"componentName";

static NSString * const kRowTag = @"row";
static NSString * const kRowTitleKey = @"title";
static NSString * const kRowValueKey = @"value";

@interface LMPickerViewRow : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) id value;

- (instancetype)initWithTitle:(NSString *)title value:(id)value;

@end

@interface LMPickerViewComponent : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic, readonly) NSMutableArray *rows;

@end

@interface LMPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation LMPickerView
{
    __weak id<UIPickerViewDataSource> _dataSource;
    __weak id<UIPickerViewDelegate> _delegate;

    NSMutableArray *_components;
}

#define INIT {\
    _components = [NSMutableArray new];\
    [super setDataSource:self];\
    [super setDelegate:self];\
    [self insertComponent:0];\
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) INIT

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];

    if (self) INIT

    return self;
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    _dataSource = dataSource;
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    _delegate = delegate;
}

- (void)insertComponent:(NSInteger)component
{
    [_components insertObject:[LMPickerViewComponent new] atIndex:component];
}

- (void)deleteComponent:(NSInteger)component
{
    [_components removeObjectAtIndex:component];
}

- (NSString *)nameForComponent:(NSInteger)component
{
    return [[_components objectAtIndex:component] name];
}

- (void)setName:(NSString *)name forComponent:(NSInteger)component
{
    [[_components objectAtIndex:component] setName:name];
}

- (NSInteger)numberOfComponents
{
    return [_components count];
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    return [[[_components objectAtIndex:component] rows] count];
}

- (void)insertRow:(NSInteger)row inComponent:(NSInteger)component withTitle:(NSString *)title value:(id)value
{
    [[[_components objectAtIndex:component] rows] insertObject:[[LMPickerViewRow alloc] initWithTitle:title value:value] atIndex:row];
}

- (void)deleteRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[[_components objectAtIndex:component] rows] removeObjectAtIndex:row];
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [(LMPickerViewRow *)[[[_components objectAtIndex:component] rows] objectAtIndex:row] title];
}

- (void)setTitle:(NSString *)title forRow:(NSInteger)row forComponent:(NSInteger)component
{
    [(LMPickerViewRow *)[[[_components objectAtIndex:component] rows] objectAtIndex:row] setTitle:title];
}

- (id)valueForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [(LMPickerViewRow *)[[[_components objectAtIndex:component] rows] objectAtIndex:row] value];
}

- (void)setValue:(id)value forRow:(NSInteger)row forComponent:(NSInteger)component
{
    [(LMPickerViewRow *)[[[_components objectAtIndex:component] rows] objectAtIndex:row] setValue:value];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger n;
    if ([_dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        n = [_dataSource numberOfComponentsInPickerView:pickerView];
    } else {
        n = [self numberOfComponents];
    }

    return n;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger n;
    if ([_dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        n = [_dataSource pickerView:pickerView numberOfRowsInComponent:component];
    } else {
        n = [self numberOfRowsInComponent:component];
    }

    return n;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if ([_delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        title = [_delegate pickerView:pickerView titleForRow:row forComponent:component];
    } else {
        title = [self titleForRow:row forComponent:component];
    }

    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [_delegate pickerView:pickerView didSelectRow:row inComponent:component];
    }
}

- (void)processMarkupInstruction:(NSString *)target data:(NSString *)data
{
    if ([target isEqual:kComponentSeparatorTarget]) {
        [self insertComponent:[self numberOfComponents]];
    } else if ([target isEqual:kComponentNameTarget]) {
        [self setName:data forComponent:[self numberOfComponents] - 1];
    }
}

- (void)processMarkupElement:(NSString *)tag properties:(NSDictionary *)properties
{
    if ([tag isEqual:kRowTag]) {
        NSInteger component = [self numberOfComponents] - 1;

        NSString *title = [properties objectForKey:kRowTitleKey];

        if (title != nil) {
            [self insertRow:[self numberOfRowsInComponent:component] inComponent:component
                withTitle:title value:[properties objectForKey:kRowValueKey]];
        }
    }
}

@end

@implementation LMPickerViewRow

- (instancetype)initWithTitle:(NSString *)title value:(id)value
{
    self = [super init];

    if (self) {
        _title = title;
        _value = value;
    }

    return self;
}

@end

@implementation LMPickerViewComponent

- (instancetype)init
{
    self = [super init];

    if (self) {
        _rows = [NSMutableArray new];
    }

    return self;
}

@end

