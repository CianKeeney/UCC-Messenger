//
//  ChatViewController.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 10/16/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

//var clean_message : String = "This shit is so dumb"


class ChatViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    public let otherUserEmail: String
    public var isNewConversation = false

    private var messages = [Message]()
    private var selfSender: SenderType? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        return Sender(photoURL: "",
               senderId: email,
               displayName: "Cian Keeney")
    }
    
    init(with email:String) {
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let otherSender = Sender(photoURL: "",
                                     senderId: "2",
                                     displayName: "Fernando")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        messages.append(Message(sender: selfSender!,
                               messageId: "1",
                               sentDate: Date(),
                               kind: .text("Hello, how is your day?")))
        messages.append(Message(sender: otherSender,
                               messageId: "1",
                               sentDate: Date() - 1000,
                               kind: .text("My day was fine. How was yours?")))

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.reloadData()
        messageInputBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    @objc(inputBar:didPressSendButtonWith:) func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let selfSender = self.selfSender,
        let messageId = createMessageId() else {
            return
        }
        
        // I found these expletives on this GitHub: https://github.com/ryanmaxwell/GoshDarnIt/blob/master/Resources/Profanity.json
        let expletive_words = [
            "4r5e",
            "5h1t",
            "5hit",
            "a_s_s",
            "a55",
            "anal",
            "anus",
            "ar5e",
            "arrse",
            "arse",
            "ass-fucker",
            "ass",
            "assbutt",
            "assclown",
            "asses",
            "assfucker",
            "assfukka",
            "asshat",
            "asshole",
            "assholes",
            "asswhole",
            "b!tch",
            "b00bs",
            "b17ch",
            "b1tch",
            "ballbag",
            "ballsack",
            "bastard",
            "beastial",
            "beastiality",
            "bellend",
            "bestial",
            "bestiality",
            "bi+ch",
            "biatch",
            "bitch",
            "bitcher",
            "bitchers",
            "bitches",
            "bitchin",
            "bitching",
            "Bitchnugget",
            "bloody",
            "blowjob",
            "blowjob",
            "blowjobs",
            "boiolas",
            "bollock",
            "bollok",
            "boner",
            "boob",
            "boobs",
            "booobs",
            "boooobs",
            "booooobs",
            "booooooobs",
            "breasts",
            "buceta",
            "bugger",
            "bum",
            "bunnyfucker",
            "butt",
            "butthole",
            "buttmuch",
            "buttplug",
            "c0ck",
            "c0cksucker",
            "carpetmuncher",
            "cawk",
            "chink",
            "cipa",
            "cl1t",
            "clit",
            "clitoris",
            "clits",
            "clusterfuck",
            "cnut",
            "cock-sucker",
            "cock",
            "cockface",
            "cockhead",
            "cockmaster",
            "cockmunch",
            "cockmuncher",
            "cocks",
            "cocksuck",
            "cocksucked",
            "cocksucker",
            "cocksucking",
            "cocksucks",
            "cocksuka",
            "cocksukka",
            "cok",
            "cokmuncher",
            "coksucka",
            "coon",
            "crap",
            "cum",
            "cumguzzler",
            "cummer",
            "cumming",
            "cums",
            "cumshot",
            "cunilingus",
            "cunillingus",
            "cunnilingus",
            "cunt",
            "cuntlick",
            "cuntlicker",
            "cuntlicking",
            "cunts",
            "cyalis",
            "cyberfuc",
            "cyberfuck",
            "cyberfucked",
            "cyberfucker",
            "cyberfuckers",
            "cyberfucking",
            "d1ck",
            "damn",
            "dick",
            "dickbag",
            "dickhead",
            "dildo",
            "dildos",
            "dink",
            "dinks",
            "dirsa",
            "dlck",
            "dog-fucker",
            "doggin",
            "dogging",
            "donkeyribber",
            "doosh",
            "douche",
            "duche",
            "dyke",
            "ejaculate",
            "ejaculated",
            "ejaculates",
            "ejaculating",
            "ejaculatings",
            "ejaculation",
            "ejakulate",
            "f_u_c_k",
            "f4nny",
            "fag",
            "fagging",
            "faggitt",
            "faggot",
            "faggs",
            "fagot",
            "fagots",
            "fags",
            "fanny",
            "fannyflaps",
            "fannyfucker",
            "fanyy",
            "fatass",
            "fcuk",
            "fcuker",
            "fcuking",
            "feck",
            "fecker",
            "felching",
            "fellate",
            "fellatio",
            "fingerfuck",
            "fingerfucked",
            "fingerfucker",
            "fingerfuckers",
            "fingerfucking",
            "fingerfucks",
            "fistfuck",
            "fistfucked",
            "fistfucker",
            "fistfuckers",
            "fistfucking",
            "fistfuckings",
            "fistfucks",
            "flange",
            "fook",
            "fooker",
            "fuck",
            "fuck",
            "fucka",
            "fucked",
            "fucker",
            "fucker",
            "fuckers",
            "fuckhead",
            "fuckheads",
            "fuckin",
            "fucking",
            "fuckings",
            "fuckingshitmotherfucker",
            "fuckme",
            "fucknugget",
            "fucks",
            "fuckstick",
            "fucktard",
            "fucktrumpet",
            "fuckwhit",
            "fuckwit",
            "fudgepacker",
            "fudgepacker",
            "fuk",
            "fuker",
            "fukker",
            "fukkin",
            "fuks",
            "fukwhit",
            "fukwit",
            "fux",
            "fux0r",
            "gangbang",
            "gangbanged",
            "gangbangs",
            "gaylord",
            "gaysex",
            "goatse",
            "god-dam",
            "god-damned",
            "God",
            "goddamn",
            "goddamned",
            "hardcoresex",
            "hell",
            "heshe",
            "hoar",
            "hoare",
            "hoer",
            "homo",
            "hore",
            "horniest",
            "horny",
            "horsefucker",
            "hotsex",
            "jack-off",
            "jackoff",
            "jap",
            "jerk-off",
            "jism",
            "jiz",
            "jizm",
            "jizz",
            "kawk",
            "knob",
            "knobead",
            "knobed",
            "knobend",
            "knobhead",
            "knobjocky",
            "knobjockey",
            "kock",
            "kondum",
            "kondums",
            "kum",
            "kummer",
            "kumming",
            "kums",
            "kunilingus",
            "l3i+ch",
            "l3itch",
            "labia",
            "lmfao",
            "lust",
            "lusting",
            "m0f0",
            "m0fo",
            "m45terbate",
            "ma5terb8",
            "ma5terbate",
            "masochist",
            "master-bate",
            "masterb8",
            "masterbat*",
            "masterbat3",
            "masterbate",
            "masterbation",
            "masterbations",
            "masturbate",
            "mo-fo",
            "mof0",
            "mofo",
            "mothafuck",
            "mothafucka",
            "mothafuckas",
            "mothafuckaz",
            "mothafucked",
            "mothafucker",
            "mothafuckers",
            "mothafuckin",
            "mothafucking",
            "mothafuckings",
            "mothafucks",
            "motherfuck",
            "motherfucked",
            "motherfucker",
            "motherfuckers",
            "motherfuckin",
            "motherfucking",
            "motherfuckings",
            "motherfuckka",
            "motherfucks",
            "muff",
            "mutha",
            "muthafecker",
            "muthafuckker",
            "muther",
            "mutherfucker",
            "n1gga",
            "n1gger",
            "nazi",
            "nigg3r",
            "nigg4h",
            "nigga",
            "niggah",
            "niggas",
            "niggaz",
            "nigger",
            "niggers",
            "nob",
            "nobhead",
            "nobjocky",
            "nobjockey",
            "numbnuts",
            "nutsack",
            "orgasim",
            "orgasims",
            "orgasm",
            "orgasms",
            "p0rn",
            "pawn",
            "pecker",
            "penis",
            "penisfucker",
            "phonesex",
            "phuck",
            "phuk",
            "phuked",
            "phuking",
            "phukked",
            "phukking",
            "phuks",
            "phuq",
            "pigfucker",
            "pimpis",
            "piss",
            "pissed",
            "pisser",
            "pissers",
            "pisses",
            "pissflaps",
            "pissin",
            "pissing",
            "pissoff",
            "poo",
            "poop",
            "porn",
            "porno",
            "pornography",
            "pornos",
            "prick",
            "pricks",
            "pron",
            "pube",
            "pusse",
            "pussi",
            "pussies",
            "pussy",
            "pussys",
            "queef",
            "rectum",
            "retard",
            "rimjaw",
            "rimming",
            "s_h_i_t",
            "s.o.b.",
            "sadist",
            "schlong",
            "screwing",
            "scroat",
            "scrote",
            "scrotum",
            "semen",
            "sex",
            "sh!+",
            "sh!t",
            "sh1t",
            "shag",
            "shagger",
            "shaggin",
            "shagging",
            "shemale",
            "shi+",
            "shit",
            "shitdick",
            "shite",
            "shited",
            "shitey",
            "shitfuck",
            "shitfull",
            "shithead",
            "shiting",
            "shitings",
            "shits",
            "shitted",
            "shitter",
            "shitters",
            "shitting",
            "shittings",
            "shitty",
            "skank",
            "slut",
            "sluts",
            "smegma",
            "smut",
            "snatch",
            "son-of-a-bitch",
            "spac",
            "spunk",
            "spunky",
            "t1tt1e5",
            "t1tties",
            "teets",
            "teez",
            "testical",
            "testicle",
            "thundercunt",
            "tit",
            "titfuck",
            "tits",
            "titt",
            "tittie5",
            "tittiefucker",
            "titties",
            "tittyfuck",
            "tittywank",
            "titwank",
            "tosser",
            "turd",
            "tw4t",
            "twat",
            "twathead",
            "twatty",
            "twatwaffle",
            "twunt",
            "twunter",
            "v14gra",
            "v1gra",
            "vagina",
            "viagra",
            "vulva",
            "w00se",
            "wang",
            "wank",
            "wanker",
            "wanky",
            "whoar",
            "whore",
            "willies",
            "willy",
            "xrated",
            "xxx"
        ]
        
        let pattern = expletive_words.map { "\\b\($0)\\b" }.joined(separator: "|")
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        
        let clean_message = regex.stringByReplacingMatches(in: text, range: NSRange(location: 0, length: text.utf16.count), withTemplate: "****")
        
        print("Sending: \(clean_message)")
        
        messages.append(Message(sender: selfSender,
                                               messageId: "2",
                                               sentDate: Date(),
                                               kind: .text(clean_message)))
        
        print(messages)
        // Assuming you have a reference to your message view controller
        // and its collection view
        messagesCollectionView.reloadData()

        print("reload")
        
        
        
        if isNewConversation {
            let message = Message(sender: selfSender,
                                  messageId: messageId,
                                  sentDate: Date(),
                                  kind: .text(clean_message))
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: message, completion: { success in
                if success {
                    print("Message sent")
                } else {
                    print("Message failed to send")
                }
            })
        } else {
            
        }
    }
    
    private func createMessageId() -> String? {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") else {
            return nil
        }
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(currentUserEmail)_\(dateString)"
        print("created message id: \(newIdentifier)")
        return newIdentifier
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is nil, email should be cached")
        return Sender(photoURL: "", senderId: "12", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
