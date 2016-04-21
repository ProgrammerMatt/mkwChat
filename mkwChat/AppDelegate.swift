import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var label1: NSTextField!
    @IBOutlet weak var ipaddress: NSTextField!
    @IBOutlet weak var status: NSTextField!
    @IBOutlet weak var acceptButton: NSButton!
    @IBOutlet weak var contactLabel: NSTextField!
    var chatWindowController:ChatWindowController?
    var listenSocket : PassiveSocketIPv4?
    var client:TCPClient?
    var friend:String?
    var myAddress:String?
    var s:sockaddr_in?
    let Encryptor = Encryption()
    var encryptionMethod:String?
    

    

    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        acceptButton.hidden = true
        contactLabel.hidden = true
        //self.Encryptor = Encryption()
        
        self.myAddress = getIFAddresses()[0]
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var server:TCPServer = TCPServer(addr: self.myAddress!, port: 8080)
            var (success, msg) = server.listen()
            //print(success)
            if success {
                print("opened socket")
                while true {
                    if var client = server.accept() {
                        self.echoService(client: client)
                    } else {
                        print("accept error")
                    }
                }
            } else {
                print(msg)
            }        })
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
    
    @IBAction func connectAction(sender: AnyObject) {
        
        if self.encryptionMethod == nil{
            
            let answer = dialogOKCancel("Error", text: "You must select an encryption method.")
            return
        }
        
        self.friend = ipaddress.stringValue
        self.s = sockaddr_in(string: self.friend! + ":8080")

        let socket = ActiveSocket<sockaddr_in>()!
            .onRead { sock, _ in
                let (count, block, errno) = sock.read() // $0 for sock doesn't work anymore?
                guard count > 0 else {
                    print("EOF, or great error handling \(errno).")
                    return
                }
                print("Answer to ring,ring is: \(count) bytes: \(block)")
            }
            .connect(s!) { socket in
                socket.write("Connecting")
        }
    }
    
    
    
    func echoService(client c:TCPClient) {
        print("newclient from:\(c.addr)[\(c.port)]")
        if self.friend == nil{
            self.friend = c.addr
        }
        
        if(self.s == nil){
            self.friend = ipaddress.stringValue
            self.s = sockaddr_in(string: self.friend! + ":8080")
        }
        
        dispatch_async(dispatch_get_main_queue()){
            self.acceptButton.hidden = false
            self.contactLabel.hidden = false
            self.contactLabel.stringValue = self.friend!+" wants to chat with you using the " + self.encryptionMethod!
        }

        var d = c.read(1024*10)
        var s = ""
        if d != nil{
            for char in d! {
                s += "\(UnicodeScalar(char))"
            }
            if s == "Accepted"{
                dispatch_async(dispatch_get_main_queue()){
                self.chatWindowController = ChatWindowController(windowNibName:"ChatWindowController")
                self.chatWindowController?.showWindow(self)
                print(s+":here")
                }
            }
        print(s)
        chatWindowController?.append("Friend: "+s)
        c.send(data: d!)
        c.close()
        }
    }
    
    @IBAction func acceptAction(sender: AnyObject) {
        print("accepting")
        chatWindowController = ChatWindowController(windowNibName:"ChatWindowController")
        chatWindowController?.showWindow(self)
        
        let socket = ActiveSocket<sockaddr_in>()!
            .onRead { sock, _ in
                let (count, block, errno) = sock.read()
                guard count > 0 else {
                    print("EOF, or great error handling \(errno).")
                    return
                }
                print("Answer to ring,ring is: \(count) bytes: \(block)")
            }
            .connect(self.s!) { socket in
                socket.write("Accepted")
        }
    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
    
    
    @IBAction func chooseEncryption(sender: NSButton) {
        self.encryptionMethod = sender.title
    }

    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
        myPopup.addButtonWithTitle("OK")
        let res = myPopup.runModal()

        return false
    }
    
    

}