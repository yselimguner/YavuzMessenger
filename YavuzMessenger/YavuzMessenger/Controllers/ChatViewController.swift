//
//  ChatViewController.swift
//  YavuzMessenger
//
//  Created by iOS PSI on 24.10.2022.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.appName
        navigationItem.hidesBackButton = true

        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
        
        
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener() { (querySnapshot, error) in
            
            self.messages = []
            
            if let er = error {
                print("Error getting documents: \(er)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0) //messages.count-1
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        //Bu tu??a basarak mesaj??m??z?? firestore'a g??ndeririz.
        //Mesaj?? kim g??nderdi??ini firebase kimlik do??rulama'dan kullan??c??lar?? y??net k??sm??ndan ????reniriz. messageSender b??l??m??n?? yazar??z.
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            //i??leri bo?? de??ilse bu verileri al??r??z ve firestore'a g??ndeririz.
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField:messageSender,
                                                                      K.FStore.bodyField:messageBody,
                                                                      K.FStore.dateField: Date().timeIntervalSince1970
                                                                     ]) { (error) in
                if let e = error {
                    print(e.localizedDescription)
                } else{
                    print("Ba??ar??yla data kaydedildi.")
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
                }
                
            }
        }
       
        
        
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
}

extension ChatViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = message.body
        
        //Bu sat??rlar mevcut kullan??c??dan gelen mesajd??r.
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = .lightGray
            cell.messageLabel.textColor = .black
        }
        //Bu sat??r di??er kullan??c??n??n mesajlar?? olacak.
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = .systemGreen
            cell.messageLabel.textColor = .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}
