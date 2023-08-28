import UIKit
import MuxStatsAliPlayer
import MuxCore
import AliyunPlayer

class ViewController: UIViewController {
    var model:MuxVideoModel = .init()
    var mlyPlayer: MLYAliPlayer!
    var player:AliPlayer!
    var muxModel:MLYMuxModel = .init()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.initMuxSDK()
        self.playerVideo() 
    }
    
    func initMuxSDK(){
        let playerData = MUXSDKCustomerPlayerData(environmentKey: model.environmentKey)
        playerData?.playerName = model.title
        let videoData = MUXSDKCustomerVideoData()
        videoData.videoIsLive = false
        videoData.videoSourceUrl = model.url
        videoData.videoTitle = model.title
        let viewerData = MUXSDKCustomerViewerData()
        viewerData.viewerApplicationName = "mux-stats-alipalyer"
         
        guard let customerData = MUXSDKCustomerData(customerPlayerData: playerData, videoData: videoData, viewData: nil, customData: nil, viewerData: viewerData) else {
            return
        }
        DispatchQueue.main.async { [self] in
            _ = MUXAliSDKStats.monitorAliPlayerViewController(self.muxModel, withPlayerName: model.title, customerData: customerData)
        }
    }
    
    func setupView() {
        let playerView:UIView =  .init(frame: CGRect(x: 0, y: 0, width: UIView.screenWidth(), height: UIView.screenHeight()))
        self.mlyPlayer =  MLYAliPlayer.init(view: self.view, playerView: playerView,videoURL: self.model.url)
        self.player = self.mlyPlayer.player
        self.muxModel = self.mlyPlayer.getMuxConfigModel()
    }
    
    func playerVideo() {
        let source = AVPUrlSource()
        source.playerUrl = URL(string: model.url)
        self.player.setUrlSource(source)
        self.player.prepare()
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.player.stop()
        self.player.destroy()
        super.viewDidDisappear(animated)
    }
    
}
 
class MuxVideoModel:NSObject {
    var url:String = "https://vsp-stream.s3.ap-northeast-1.amazonaws.com/HLS/raw/SpaceX.m3u8"
    var humbnail:String = "https://image.mux.com/tcnlhO022JRdWiYarmtZ4S028reTa2IDsX/thumbnail.png"
    var title:String = "MuxStatsAliPlayer"
    var environmentKey:String = "8b6qt5193roge01u0nhgdpetb"
}

