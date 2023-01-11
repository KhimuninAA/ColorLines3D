//
//  HelpView.swift
//  ColorLines3D
//
//  Created by Алексей Химунин on 11.01.2023.
//

import Foundation
import Cocoa

class HelpView: NSView{
    private var logoView: NSImageView?
    private var appNameLabel: KhLabel?
    private var appVersionLabel: KhLabel?
    private var helpText: NSTextField?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView(){
        logoView = NSImageView(frame: .zero)
        if let logoView = logoView{
            logoView.image = NSImage(named: "AppIcon")
            logoView.imageScaling = .scaleProportionallyDown
            addSubview(logoView)
        }
        
        let dictionary = Bundle.main.infoDictionary!
        let shortVersionString = dictionary["CFBundleShortVersionString"] as! String
        let appNameString = dictionary["CFBundleName"] as! String
        let bundleVersionString = dictionary["CFBundleVersion"] as! String
        

        appNameLabel = KhLabel(frame: .zero)
        if let appNameLabel = appNameLabel{
            appNameLabel.stringValue = appNameString
            appNameLabel.font = NSFont(name: "Menlo", size: 23)
            addSubview(appNameLabel)
        }
        
        appVersionLabel = KhLabel(frame: .zero)
        if let appVersionLabel = appVersionLabel{
            appVersionLabel.stringValue = shortVersionString + " (" + bundleVersionString + ")"
            appVersionLabel.font = NSFont(name: "Menlo", size: 13)
            addSubview(appVersionLabel)
        }
        
        helpText = NSTextField(frame: .zero)
        if let helpText = helpText{
            helpText.isBezeled = false
            helpText.isEditable = false
            helpText.drawsBackground = false
            //helpText.isSelectable = false
            helpText.stringValue = "    Игра происходит на квадратном поле в 9×9 клеток и представляет собой серию ходов. На каждом ходу сначала компьютер в случайных клетках выставляет три шарика случайных цветов, последних всего семь. Далее делает ход игрок, он может передвинуть любой шарик в другую свободную клетку, но при этом между начальной и конечной клетками должен существовать недиагональный путь из свободных клеток. Если после перемещения получается так, что собирается пять или более шариков одного цвета в линию по горизонтали, вертикали или диагонали, то все такие шарики исчезают и игроку даётся возможность сделать ещё одно перемещение шарика. Если после перемещения линии не выстраивается, то ход заканчивается, и начинается новый с появлением новых шариков. Если при появлении новых шариков собирается линия, то она исчезает, игрок получает очки, но дополнительного перемещения не даётся. Игра продолжается до тех пор, пока всё поле не будет заполнено шариками и игрок не потеряет возможность сделать ход.\n\r  Цель игры состоит в наборе максимального количества очков. Счёт устроен таким образом, что игрок при удалении за одно перемещение большего числа шариков, чем пять, получает существенно больше очков. Во время игры на экране показывается три цвета шариков, которые будут выброшены на поле на следующем ходу."
            addSubview(helpText)
        }
        
        resizeSubviews(withOldSize: frame.size)
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        let selfSize = frame.size
        let padding: CGFloat = 16
        
        let logoSize = 0.5 * (selfSize.width - 2 * padding)
        let logoTop = selfSize.height - padding - logoSize
        
        let logoViewFrame = CGRect(x: padding, y: logoTop, width: logoSize, height: logoSize)
        self.logoView?.frame = logoViewFrame
        
        let left = logoViewFrame.maxX + padding
        let leftWidth = selfSize.width - left - padding
        
        let appNameLabelSize = appNameLabel?.getSize() ?? CGSize(width: 0, height: 0)
        let appNameLabelTop = selfSize.height - padding - appNameLabelSize.height
        //selfSize.height - appNameLabelSize.height
        let appNameLabelFrame = CGRect(x: left, y: appNameLabelTop, width: leftWidth, height: appNameLabelSize.height)
        appNameLabel?.frame = appNameLabelFrame
        
        let appVersionLabelSize = appVersionLabel?.getSize() ?? CGSize(width: 0, height: 0)
        let appVersionLabelTop = appNameLabelFrame.minY - padding - appVersionLabelSize.height
        let appVersionLabelFrame = CGRect(x: left, y: appVersionLabelTop, width: leftWidth, height: appVersionLabelSize.height)
        appVersionLabel?.frame = appVersionLabelFrame
        
        let textHeight = logoTop - padding
        let textWidth = selfSize.width - 2 * padding
        let helpTextFrame = CGRect(x: padding, y: padding, width: textWidth, height: textHeight)
        helpText?.frame = helpTextFrame

    }
}
