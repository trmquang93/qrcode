// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import UIKit
import Lottie



//MARK: - Create Views for QRCreateCodeCell
extension QRCreateCodeCell {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["container"] = container
        dictionary["iconView"] = iconView
        dictionary["nameLabel"] = nameLabel
        return dictionary
    }

    @objc dynamic func createViews() {

        let container = UIView()
        contentView.addSubview(container)
        self.container = container
        container.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView()
        container.addSubview(iconView)
        self.iconView = iconView
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        container.addSubview(nameLabel)
        self.nameLabel = nameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

    }
}




//MARK: - Create Views for QRHistoryCell
extension QRHistoryCell {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["menuStackView"] = menuStackView
        dictionary["contentStackView"] = contentStackView
        dictionary["menuView"] = menuView
        dictionary["selectionView"] = selectionView
        dictionary["itemIcon"] = itemIcon
        dictionary["textContainer"] = textContainer
        dictionary["accessoryContainerView"] = accessoryContainerView
        dictionary["titleLabel"] = titleLabel
        dictionary["dateLabel"] = dateLabel
        return dictionary
    }

    @objc dynamic func createViews() {

        let menuStackView = UIStackView()
        contentView.addSubview(menuStackView)
        self.menuStackView = menuStackView
        menuStackView.translatesAutoresizingMaskIntoConstraints = false

        let contentStackView = UIStackView()
        menuStackView.addArrangedSubview(contentStackView)
        self.contentStackView = contentStackView
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        let menuView = QRCellMenuView()
        menuStackView.addArrangedSubview(menuView)
        self.menuView = menuView
        menuView.translatesAutoresizingMaskIntoConstraints = false

        let selectionView = UIImageView()
        contentStackView.addArrangedSubview(selectionView)
        self.selectionView = selectionView
        selectionView.translatesAutoresizingMaskIntoConstraints = false

        let itemIcon = UIImageView()
        contentStackView.addArrangedSubview(itemIcon)
        self.itemIcon = itemIcon
        itemIcon.translatesAutoresizingMaskIntoConstraints = false

        let textContainer = UIView()
        contentStackView.addArrangedSubview(textContainer)
        self.textContainer = textContainer
        textContainer.translatesAutoresizingMaskIntoConstraints = false

        let accessoryContainerView = UIButton(type: .system)
        contentStackView.addArrangedSubview(accessoryContainerView)
        self.accessoryContainerView = accessoryContainerView
        accessoryContainerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        textContainer.addSubview(titleLabel)
        self.titleLabel = titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let dateLabel = UILabel()
        dateLabel.numberOfLines = 0
        dateLabel.lineBreakMode = .byWordWrapping
        textContainer.addSubview(dateLabel)
        self.dateLabel = dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

    }
}




//MARK: - Create Views for QRLookupItemCell
extension QRLookupItemCell {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["imageView"] = imageView
        return dictionary
    }

    @objc dynamic func createViews() {

        let imageView = UIImageView()
        contentView.addSubview(imageView)
        self.imageView = imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false

    }
}




//MARK: - Create Views for QRSettingCell
extension QRSettingCell {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["separatorView"] = separatorView
        dictionary["iconImageView"] = iconImageView
        dictionary["containerView"] = containerView
        dictionary["titleLabel"] = titleLabel
        dictionary["contentLabel"] = contentLabel
        return dictionary
    }

    @objc dynamic func createViews() {

        let separatorView = UIView()
        contentView.addSubview(separatorView)
        self.separatorView = separatorView
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView()
        contentView.addSubview(iconImageView)
        self.iconImageView = iconImageView
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        contentView.addSubview(containerView)
        self.containerView = containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        containerView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        containerView.addSubview(contentLabel)
        self.contentLabel = contentLabel
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

    }
}




//MARK: - Create Views for QRCodeLookupResultViewController
extension QRCodeLookupResultViewController {

    override var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = super.viewsDictionary
        dictionary["lookupHeaderLabel"] = lookupHeaderLabel
        dictionary["lookupView"] = lookupView
        return dictionary
    }

    override func createViews() {
        super.createViews()

        let lookupHeaderLabel = UILabel()
        lookupHeaderLabel.numberOfLines = 0
        lookupHeaderLabel.lineBreakMode = .byWordWrapping

        view.addSubview(lookupHeaderLabel)
        self.lookupHeaderLabel = lookupHeaderLabel
        lookupHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        let lookupView = UIView()

        view.addSubview(lookupView)
        self.lookupView = lookupView
        lookupView.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Create Views for QRCreateInputViewController
extension QRCreateInputViewController {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["contentView"] = contentView
        dictionary["createButton"] = createButton
        return dictionary
    }

    @objc dynamic func createViews() {

        let contentView = UIView()

        view.addSubview(contentView)
        self.contentView = contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let createButton = DefaultButton()

        view.addSubview(createButton)
        self.createButton = createButton
        createButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Create Views for QRHistoryViewController
extension QRHistoryViewController {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["contentStackView"] = contentStackView
        dictionary["toolBar"] = toolBar
        return dictionary
    }

    @objc dynamic func createViews() {

        let contentStackView = UIStackView()

        view.addSubview(contentStackView)
        self.contentStackView = contentStackView
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        let toolBar = UIView()

        contentStackView.addArrangedSubview(toolBar)
        self.toolBar = toolBar
        toolBar.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Create Views for QRInputsViewController
extension QRInputsViewController {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["scrollView"] = scrollView
        dictionary["stackContainer"] = stackContainer
        return dictionary
    }

    @objc dynamic func createViews() {

        let scrollView = UIScrollView()

        view.addSubview(scrollView)
        self.scrollView = scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let stackContainer = UIStackView()

        scrollView.addSubview(stackContainer)
        self.stackContainer = stackContainer
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Create Views for QRMyCodeViewController
extension QRMyCodeViewController {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["emptyContentView"] = emptyContentView
        dictionary["emptyIconView"] = emptyIconView
        dictionary["emptyTitleLabel"] = emptyTitleLabel
        dictionary["emptyMessageLabel"] = emptyMessageLabel
        return dictionary
    }

    @objc dynamic func createViews() {

        let emptyContentView = UIView()

        view.addSubview(emptyContentView)
        self.emptyContentView = emptyContentView
        emptyContentView.translatesAutoresizingMaskIntoConstraints = false
        let emptyIconView = UIImageView()

        emptyContentView.addSubview(emptyIconView)
        self.emptyIconView = emptyIconView
        emptyIconView.translatesAutoresizingMaskIntoConstraints = false
        let emptyTitleLabel = UILabel()
        emptyTitleLabel.numberOfLines = 0
        emptyTitleLabel.lineBreakMode = .byWordWrapping

        emptyContentView.addSubview(emptyTitleLabel)
        self.emptyTitleLabel = emptyTitleLabel
        emptyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let emptyMessageLabel = UILabel()
        emptyMessageLabel.numberOfLines = 0
        emptyMessageLabel.lineBreakMode = .byWordWrapping

        emptyContentView.addSubview(emptyMessageLabel)
        self.emptyMessageLabel = emptyMessageLabel
        emptyMessageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Create Views for QRResultViewController
extension QRResultViewController {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["codeDetailView"] = codeDetailView
        dictionary["actionButton"] = actionButton
        dictionary["shareButton"] = shareButton
        return dictionary
    }

    @objc dynamic func createViews() {

        let codeDetailView = UIView()

        view.addSubview(codeDetailView)
        self.codeDetailView = codeDetailView
        codeDetailView.translatesAutoresizingMaskIntoConstraints = false
        let actionButton = DefaultButton()

        view.addSubview(actionButton)
        self.actionButton = actionButton
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        let shareButton = DefaultButton()

        view.addSubview(shareButton)
        self.shareButton = shareButton
        shareButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Create Views for QRScanResultViewController
extension QRScanResultViewController {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["codeView"] = codeView
        dictionary["codeDetailView"] = codeDetailView
        return dictionary
    }

    @objc dynamic func createViews() {

        let codeView = UIImageView()

        view.addSubview(codeView)
        self.codeView = codeView
        codeView.translatesAutoresizingMaskIntoConstraints = false
        let codeDetailView = UIView()

        view.addSubview(codeDetailView)
        self.codeDetailView = codeDetailView
        codeDetailView.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Create Views for QRScanViewController
extension QRScanViewController {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["previewView"] = previewView
        dictionary["scanIndicator"] = scanIndicator
        dictionary["pickPhotoButton"] = pickPhotoButton
        dictionary["flashButton"] = flashButton
        return dictionary
    }

    @objc dynamic func createViews() {

        let previewView = PreviewView()

        view.addSubview(previewView)
        self.previewView = previewView
        previewView.translatesAutoresizingMaskIntoConstraints = false
        let scanIndicator = QRScanView()

        view.addSubview(scanIndicator)
        self.scanIndicator = scanIndicator
        scanIndicator.translatesAutoresizingMaskIntoConstraints = false
        let pickPhotoButton = UIButton(type: .system)

        view.addSubview(pickPhotoButton)
        self.pickPhotoButton = pickPhotoButton
        pickPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        let flashButton = UIButton(type: .system)

        view.addSubview(flashButton)
        self.flashButton = flashButton
        flashButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Create Views for QRTabbarViewController
extension QRTabbarViewController {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["stackContentView"] = stackContentView
        dictionary["contentView"] = contentView
        dictionary["tabbar"] = tabbar
        return dictionary
    }

    @objc dynamic func createViews() {

        let stackContentView = UIStackView()

        view.addSubview(stackContentView)
        self.stackContentView = stackContentView
        stackContentView.translatesAutoresizingMaskIntoConstraints = false
        let contentView = UIView()

        stackContentView.addArrangedSubview(contentView)
        self.contentView = contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let tabbar = UITabBar()

        stackContentView.addArrangedSubview(tabbar)
        self.tabbar = tabbar
        tabbar.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Create Views for QRCellMenuView
extension QRCellMenuView {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["contentStackView"] = contentStackView
        dictionary["copyView"] = copyView
        dictionary["openView"] = openView
        dictionary["deleteView"] = deleteView
        dictionary["copyButton"] = copyButton
        dictionary["copyButtonTitle"] = copyButtonTitle
        dictionary["openButton"] = openButton
        dictionary["openButtonTitle"] = openButtonTitle
        dictionary["deleteButton"] = deleteButton
        dictionary["deleteButtonTitle"] = deleteButtonTitle
        return dictionary
    }

    @objc dynamic func createViews() {

        let contentStackView = UIStackView()
        addSubview(contentStackView)
        self.contentStackView = contentStackView
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        let copyView = UIView()
        contentStackView.addArrangedSubview(copyView)
        self.copyView = copyView
        copyView.translatesAutoresizingMaskIntoConstraints = false
        let openView = UIView()
        contentStackView.addArrangedSubview(openView)
        self.openView = openView
        openView.translatesAutoresizingMaskIntoConstraints = false
        let deleteView = UIView()
        contentStackView.addArrangedSubview(deleteView)
        self.deleteView = deleteView
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        let copyButton = UIButton(type: .system)
        copyView.addSubview(copyButton)
        self.copyButton = copyButton
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        let copyButtonTitle = UILabel()
        copyButtonTitle.numberOfLines = 0
        copyButtonTitle.lineBreakMode = .byWordWrapping
        copyView.addSubview(copyButtonTitle)
        self.copyButtonTitle = copyButtonTitle
        copyButtonTitle.translatesAutoresizingMaskIntoConstraints = false
        let openButton = UIButton(type: .system)
        openView.addSubview(openButton)
        self.openButton = openButton
        openButton.translatesAutoresizingMaskIntoConstraints = false
        let openButtonTitle = UILabel()
        openButtonTitle.numberOfLines = 0
        openButtonTitle.lineBreakMode = .byWordWrapping
        openView.addSubview(openButtonTitle)
        self.openButtonTitle = openButtonTitle
        openButtonTitle.translatesAutoresizingMaskIntoConstraints = false
        let deleteButton = UIButton(type: .system)
        deleteView.addSubview(deleteButton)
        self.deleteButton = deleteButton
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        let deleteButtonTitle = UILabel()
        deleteButtonTitle.numberOfLines = 0
        deleteButtonTitle.lineBreakMode = .byWordWrapping
        deleteView.addSubview(deleteButtonTitle)
        self.deleteButtonTitle = deleteButtonTitle
        deleteButtonTitle.translatesAutoresizingMaskIntoConstraints = false
    }
}


//MARK: - Create Views for QRScanView
extension QRScanView {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["scanSquareView"] = scanSquareView
        dictionary["scanIndicator"] = scanIndicator
        return dictionary
    }

    @objc dynamic func createViews() {

        let scanSquareView = UIImageView()
        addSubview(scanSquareView)
        self.scanSquareView = scanSquareView
        scanSquareView.translatesAutoresizingMaskIntoConstraints = false
        let scanIndicator = AnimationView()
        scanSquareView.addSubview(scanIndicator)
        self.scanIndicator = scanIndicator
        scanIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
}


//MARK: - Create Views for TextScrollView
extension TextScrollView {

    @objc dynamic var viewsDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["textView"] = textView
        return dictionary
    }

    @objc dynamic func createViews() {

        let textView = TextViewWithPlaceholder()
        addSubview(textView)
        self.textView = textView
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
}


