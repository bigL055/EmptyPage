//
//  EmptyPage
//
//  Copyright (c) 2018 linhey - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import UIKit

/// `EmptyPageForStandard` 混合样式模板
open class EmptyPageForStandard: UIStackView, EmptyPageTemplateProtocol {

    public var edge: UIEdgeInsets = .zero
    
    // MARK: - Public property
    /// 图片 imageView
    public let imageView = EmptyPageForImage(frame: .zero)
    /// 标题 Label
    public let titleLabel = EmptyPageForText(frame: .zero)
    /// 描述 Label
    public let textLabel = EmptyPageForText(frame: .zero)
    /// 底部按钮 button
    public let button = EmptyPageForButton(frame: .zero)

    private var views: [UIView] { return [imageView, titleLabel, textLabel, button] }
    
    // MARK: - Override
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .fill
        alignment = .center

        views.forEach { view in
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(view)
        }

        titleLabel.config { view in
            view.font = UIFont.systemFont(ofSize: 16)
            view.textColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        }

        textLabel.config { view in
            view.font = UIFont.systemFont(ofSize: 14)
            view.textColor = UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)
        }

        _ = layout(type: .afterSpac(20), views: [.imageView])
        _ = layout(view: .textLabel, types: [.afterSpac(28), .height(20)])
        _ = layout(view: .titleLabel, types: [.afterSpac(8), .height(22.5)])
        _ = layout(view: .button, types: [.height(36)])
    }
    
}

public extension EmptyPageForStandard {
    
    func config(imageView call: (EmptyPageForImage) -> Void) -> Self {
        imageView.isHidden = false
        call(imageView)
        return self
    }
    
    func config(titleLabel call: (EmptyPageForText) -> Void) -> Self {
        titleLabel.isHidden = false
        call(titleLabel)
        return self
    }
    
    func config(textLabel call: (EmptyPageForText) -> Void) -> Self {
        textLabel.isHidden = false
        call(textLabel)
        return self
    }
    
    func config(button call: (EmptyPageForButton) -> Void) -> Self {
        button.isHidden = false
        call(button)
        return self
    }
    
}

// MARK: 调整 layout 相关枚举与函数
public extension EmptyPageForStandard {
    
    /// 视图高度调整
    ///
    /// - button: 按钮 default: 自适应
    enum ViewType {
        case imageView, titleLabel, textLabel, button
    }
    
    enum LayoutType {
        case width(_: CGFloat)
        case height(_: CGFloat)
        case insets(_: CGFloat)
        case afterSpac(_: CGFloat)
    }
    
    func view(for type: ViewType) -> UIView {
        switch type {
        case .imageView: return imageView
        case .titleLabel: return titleLabel
        case .textLabel: return textLabel
        case .button: return button
        }
    }

    func layout(type: LayoutType, views: [ViewType]) -> Self {
        views.forEach({ self.layout($0, type: type) })
        return self
    }

    func layout(view: ViewType, types: [LayoutType]) -> Self {
        types.forEach({ self.layout(view, type: $0) })
        return self
    }

    func layout(type: LayoutType, views: ViewType...) -> Self {
        return layout(type: type, views: views)
    }
    
    func layout(view: ViewType, types: LayoutType...) -> Self {
        return layout(view: view, types: types)
    }

    private func layout(_ view: ViewType, type: LayoutType) {
        let view = self.view(for: view)
        switch type {
        case .height(let v):
            view.heightAnchor.constraint(equalToConstant: v).isActive = true
        case .width(let v):
            view.widthAnchor.constraint(equalToConstant: v).isActive = true
        case .afterSpac(let v):
            addCustomSpacing(v, after: view)
        case .insets(let v):
            view.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: v).isActive = true
            view.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: v).isActive = true
        }
    }

    private func addCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        if #available(iOS 11.0, *) {
            setCustomSpacing(spacing, after: arrangedSubview)
            return
        }
        
        guard arrangedSubviews.last != arrangedSubview, let index = arrangedSubviews.firstIndex(of: arrangedSubview) else {
            return
        }
        
        let tag = 5625235
        let nextarrangedSubview = arrangedSubviews[index + 1]
        let separatorView = nextarrangedSubview.tag == tag ? nextarrangedSubview : UIView(frame: .zero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        switch axis {
        case .horizontal:
            separatorView.widthAnchor.constraint(equalToConstant: spacing).isActive = true
        case .vertical:
            separatorView.heightAnchor.constraint(equalToConstant: spacing).isActive = true
        @unknown default:
            return
        }
        guard nextarrangedSubview.tag == tag else {
            return
        }
        insertArrangedSubview(separatorView, at: index + 1)
        separatorView.tag = tag
    }
    
}