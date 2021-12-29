//
//  TranslateViewController.swift
//  Translate
//
//  Created by yc on 2021/12/28.
//

import UIKit
import SnapKit

class TranslateViewController: UIViewController {
    
    private var translateManager = TranslatorManager()
    
    private lazy var sourceLanguageButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(translateManager.sourceLanguage.title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        button.layer.cornerRadius = 9.0
        button.addTarget(
            self,
            action: #selector(didTapSourceLanguageButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var targetLanguageButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(translateManager.targetLanguage.title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        button.layer.cornerRadius = 9.0
        button.addTarget(
            self,
            action: #selector(didTapTargetLanguageButton),
            for: .touchUpInside
        )

        
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        
        [
            sourceLanguageButton,
            targetLanguageButton
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var resultBaseView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 23.0, weight: .bold)
        label.textColor = .mainTintColor
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapBookmarkButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    @objc func didTapBookmarkButton() {
        guard let sourceText = sourceLabel.text,
              let translatedText = resultLabel.text,
              bookmarkButton.imageView?.image == UIImage(systemName: "bookmark") else { return }
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        
        let currentBookmarks: [Bookmark] = UserDefaults.standard.bookmarks
        let newBookmark = Bookmark(
            sourceLanguage: translateManager.sourceLanguage,
            translatedLanguage: translateManager.targetLanguage,
            sourceText: sourceText,
            translatedText: translatedText
        )
        UserDefaults.standard.bookmarks = [newBookmark] + currentBookmarks
    }
    
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCopyButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    @objc func didTapCopyButton() {
        UIPasteboard.general.string = resultLabel.text
    }
    
    private lazy var sourceLabelBaseButton: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSourceLabelBaseButton))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    @objc func didTapSourceLabelBaseButton() {
        let sourceTextViewController = SourceTextViewController(delegate: self)
        
        present(sourceTextViewController, animated: true, completion: nil)
    }
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 23.0, weight: .semibold)
        label.textColor = .tertiaryLabel
        label.text = NSLocalizedString("Enter_text", comment: "텍스트 입력")
        label.numberOfLines = 0
        
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        setupViews()
    }
}

extension TranslateViewController: SourceTextViewControllerDelegate {
    func didEnterText(_ sourceText: String) {
        if sourceText == "" { return }
        
        sourceLabel.text = sourceText
        sourceLabel.textColor = .label
        
        translateManager.translate(from: sourceText) { [weak self] translatedText in
            self?.resultLabel.text = translatedText
        }
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
}

private extension TranslateViewController {
    func setupViews() {
        [
            buttonStackView,
            resultBaseView,
            resultLabel,
            bookmarkButton,
            copyButton,
            sourceLabelBaseButton,
            sourceLabel
        ].forEach { view.addSubview($0) }
        
        let defaultSpacing: CGFloat = 16.0
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(defaultSpacing)
            make.height.equalTo(50.0)
        }
        
        resultBaseView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(buttonStackView.snp.bottom).offset(defaultSpacing)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(resultBaseView).inset(24.0)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.leading.equalTo(resultLabel.snp.leading)
            make.top.equalTo(resultLabel.snp.bottom).offset(24.0)
            make.width.height.equalTo(40.0)
        }
        
        copyButton.snp.makeConstraints { make in
            make.leading.equalTo(bookmarkButton.snp.trailing).offset(8.0)
            make.top.equalTo(bookmarkButton.snp.top)
            make.width.height.equalTo(40.0)
            make.bottom.equalTo(resultBaseView.snp.bottom).inset(defaultSpacing)
        }
        
        sourceLabelBaseButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(resultBaseView.snp.bottom).offset(defaultSpacing)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        sourceLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(sourceLabelBaseButton).inset(24.0)
        }
    }
    
    @objc func didTapSourceLanguageButton() {
        didTapLanguageButton(type: .source)
    }
    
    @objc func didTapTargetLanguageButton() {
        didTapLanguageButton(type: .target)
    }
    
    func didTapLanguageButton(type: Type) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        Language.allCases.forEach { language in
            let action = UIAlertAction(title: language.title, style: .default) { [weak self] _ in
                switch type {
                case .source:
                    self?.translateManager.sourceLanguage = language
                    self?.sourceLanguageButton.setTitle(language.title, for: .normal)
                case .target:
                    self?.translateManager.targetLanguage = language
                    self?.targetLanguageButton.setTitle(language.title, for: .normal)
                }
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "취소하기"), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
}
