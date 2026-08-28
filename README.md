# PKHUD

[![Swift](https://img.shields.io/badge/Swift-5.9%20%7C%206.0-orange.svg?style=flat)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platforms-iOS%2013.0+-blue.svg?style=flat)](https://developer.apple.com/ios/)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](LICENSE)

A modern, lightweight, and concurrency-safe Swift HUD library for iOS 13 and up. Built on UIKit and CoreAnimation with official SF Symbols and adaptive Visual Effects.

一款现代、轻量、支持 Swift 6 并发安全（`@MainActor` / `Sendable`）的纯 Swift iOS HUD 库。支持深浅色模式自适应、SF Symbols 矢量图标、平滑连续圆角及极简单段提示文本调用语法。

---

## ✨ Features (特性)

- 🔒 **Swift 6 & Strict Concurrency Ready**: 全面支持 Swift 5.9+ / Swift 6 并发安全，主线程隔离保证与 `@MainActor`。
- 🎨 **Adaptive Material Design**: 采用系统自适应材质毛玻璃（`UIBlurEffect`），无缝适配深色/浅色（Dark Mode）模式。
- 📐 **Golden Ratio & Symmetric Centering**: 精致的 `110 × 110 pt` 卡片尺寸与严格的 `[图片 + 间距 + 文字]` 整体绝对垂直对称居中排版。
- ⭕ **Smooth Continuous Corners**: 采用 Apple 原生 `.continuous` 平滑连续曲率圆角，支持自由定制（`HUD.cornerRadius`）。
- 🔤 **Global Appearance Customization**: 开放全局字体、字体颜色、卡片尺寸及主题色静态配置。
- 🌟 **SF Symbols & Vector Icons**: 原生集成苹果官方 SF Symbols 矢量图标与原作者经典矢量动画。
- ⚡ **Ergonomic Dot-Syntax API**: 全新单文本极简语法（`.success("保存成功")`、`.progress("加载中...")`），告别冗余的双标题参数。
- 📱 **Keyboard Avoidance**: 内置智能键盘监听，自动避让键盘垂直居中。

---

## 📦 Installation (安装)

### Swift Package Manager (Recommended)

在 Xcode 中选择 **File** -> **Add Package Dependencies...**，输入仓库地址：

```
https://github.com/Geoege-xll/PKHUD.git
```

或者在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/Geoege-xll/PKHUD.git", from: "5.7.0")
]
```

### CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'PKHUD', :git => 'https://github.com/Geoege-xll/PKHUD.git', :tag => '5.7.0'
```

---

## 🚀 Quick Start (快速上手)

### 1. 基础提示调用

```swift
import PKHUD

// 1. 成功提示（纯图标 / 图标+文字）
HUD.flash(.success, delay: 1.5)
HUD.flash(.success("保存成功"), delay: 1.5)

// 2. 错误提示
HUD.flash(.error("网络连接失败"), delay: 2.0)

// 3. 耗时加载中（需手动 hide）
HUD.show(.progress("加载中..."))

// 异步任务完成后隐藏并展示结果
Task {
    await performNetworkTask()
    HUD.hide()
    HUD.flash(.success("完成"))
}

// 4. 纯文本 Toast 提示
HUD.flash(.label("请先同意用户服务协议"), delay: 2.0)

// 5. 系统 SF Symbol 矢量图标
HUD.flash(.systemImage("heart.fill", "已添加到收藏"), delay: 1.5)
```

---

## 🛠 Global Configuration (全局配置)

你可以在 `AppDelegate`、`SceneDelegate` 或封装层中一行代码完成全局样式定制：

```swift
import PKHUD

// 1. 卡片尺寸与圆角
HUD.squareSize = CGSize(width: 110, height: 110)
HUD.cornerRadius = 16.0

// 2. 提示文本字体与颜色
HUD.titleFont = UIFont.systemFont(ofSize: 14, weight: .medium)
HUD.titleColor = UIColor.label.withAlphaComponent(0.85)

// 3. 图标主题色（默认自适应系统深浅模式）
HUD.tintColor = UIColor.label.withAlphaComponent(0.85)

// 4. 背景遮罩与交互拦截
HUD.dimsBackground = true      // 是否显示半透明遮罩变暗背景
HUD.allowsInteraction = false  // 是否允许穿透 HUD 交互
```

---

## 📋 HUDContentType Overview (内容类型一览)

| 类型 | 说明 | 调用示例 |
| :--- | :--- | :--- |
| `.success` | 成功动画对勾（支持文字） | `HUD.flash(.success("成功"))` |
| `.error` | 错误动画叉号（支持文字） | `HUD.flash(.error("失败"))` |
| `.progress` | 旋转加载菊花（支持文字） | `HUD.show(.progress("加载中..."))` |
| `.systemImage` | SF Symbol 矢量图标（支持文字） | `HUD.flash(.systemImage("star.fill", "已收藏"))` |
| `.label` | 纯文本卡片（最多 3 行） | `HUD.flash(.label("提示内容"))` |
| `.systemActivity` | 原生大号 Activity 指示器 | `HUD.show(.systemActivity("请稍候"))` |
| `.image` | 自定义静态图片 | `HUD.flash(.image(myImage, "已保存"))` |
| `.rotatingImage` | 自定义旋转动画图片 | `HUD.show(.rotatingImage(mySpinnerImage, "正在处理"))` |
| `.customView` | 完全自定义 UIView 视图 | `HUD.show(.customView(view: myCustomView))` |

---

## 📄 License

PKHUD is released under the **MIT License**. See [LICENSE](LICENSE) for details.
