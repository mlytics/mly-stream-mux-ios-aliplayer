import MuxStatsAliPlayer
import AliyunPlayer
import MuxCore
import UIKit

class AliListViewController: UIViewController {
    var model:MuxVideoModel = .init()
    var mlyListPlayer: MLYAliListPlayer!
    var player:AliListPlayer!
    var customerData:MUXSDKCustomerData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func initMuxSDK(){
        let playerData = MUXSDKCustomerPlayerData(environmentKey: MuxKey.MUX_KEY)
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
        self.customerData = customerData
    }
    
    func setupView() {
        let playerView:UIView =  .init(frame: CGRect(x: 0, y: 0, width: UIView.screenWidth(), height: UIView.screenHeight()))
        self.mlyListPlayer =  MLYAliListPlayer.init(view: self.view,
                                                playerView: playerView,
                                                videoURLs: [
            "https://stream.mux.com/tcnlhO022JRdWiYarmtZ4S028reTa2IDsX.m3u8",
            "https://vsp-stream.s3.ap-northeast-1.amazonaws.com/HLS/raw/SpaceX.m3u8",
            "https://lowlatencydemo.mlytics.com/app/stream/abr.m3u8",
            "https://lowlatencydemo.mlytics.com/app/stream/llhls.m3u8"
        ])
        self.mlyListPlayer.listPlayer.delegate = self
        self.player = self.mlyListPlayer.listPlayer
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.player.stop()
        self.player.destroy() 
        super.viewDidDisappear(animated)
    }
}

extension AliListViewController: AVPDelegate {
    func onPlayerStatusChanged(_ player: AliPlayer!, oldStatus: AVPStatus, newStatus: AVPStatus) {
        switch (newStatus) {
        case AVPStatusPrepared: 
            break
        case AVPStatusStarted:
            break
        case AVPStatusPaused:
            break
        case AVPStatusStopped:
            break
        default:
            break
        }
    }
    
    public func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
        if eventType == AVPEventPrepareDone || eventType == AVPEventFirstRenderedStart {
            self.initMuxSDK()
        }
    }
}
