//
//  DetailViewController.swift
//  Diary
//
//  Created by Yeseul Jang on 2023/08/30.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var bodyTextView: UITextView!
    private let item: Item?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let placeHolderText = "Input Text"
    
    init?(item: Item? = nil, coder: NSCoder) {
        self.item = item
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureNavigationTitle()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        bodyTextView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureNavigationTitle() {
        guard let createdDate = item?.itemCreatedDate else {
            let formattedTodayDate = CustomDateFormatter.formatTodayDate()
            self.navigationItem.title = formattedTodayDate
            return
        }
        let formattedSampleDate = CustomDateFormatter.formatTodayDate() // 수정해야함
        
        self.navigationItem.title = formattedSampleDate
    }
    
    private func configureTextView() {
        bodyTextView.layer.borderWidth = 1
        
        guard let item else {
            bodyTextView.text = placeHolderText
            bodyTextView.textColor = .lightGray
            bodyTextView.delegate = self
            return
        }
        
        bodyTextView.text = (item.itemTitle ?? "오류") + "\n" + (item.itemBody ?? "오류")
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            let safeAreaBottom = view.safeAreaInsets.bottom
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - safeAreaBottom, right: 0)
            
            bodyTextView.contentInset = contentInsets
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        bodyTextView.contentInset = UIEdgeInsets.zero
    }
    
    private func saveChanges() {
        guard let item = item else { return } //

        item.itemTitle = bodyTextView.text.components(separatedBy: .newlines).first
        item.itemBody = bodyTextView.text

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bodyTextView.text == placeHolderText {
            bodyTextView.text = nil
            bodyTextView.textColor = .black
        }
        saveChanges()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            bodyTextView.text = placeHolderText
            bodyTextView.textColor = .lightGray
        }
        saveChanges()
    }
}
