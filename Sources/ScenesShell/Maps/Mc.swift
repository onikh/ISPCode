//wwwww
import Scenes
import Igis
import Foundation



class Mc : RenderableEntity, KeyDownHandler, KeyUpHandler {
    let char : Image
    var charDestRect : Rect
    var charSourceRect : Rect
    var canRender = false
    var mvmtTracker = 0
    var renderMc = true
    var mvmtLocked = false

    var canInteract = false
    


    init() {
        guard let charurl = URL(string:"https://github.com/onikh/ISPData/blob/main/spritebase.png?raw=true") else {
            fatalError("Failed to create URL for char")

        }
        char = Image(sourceURL:charurl)
        charDestRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        charSourceRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        super.init(name:"Mc")
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        if let canvasSize = canvas.canvasSize {
            
            charDestRect = Rect(topLeft:canvasSize.center, size:Size(width:canvasSize.height/10, height:canvasSize.height/10))
            charSourceRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:64, height:64))
            
            canvas.setup(char)
            dispatcher.registerKeyDownHandler(handler:self)
            dispatcher.registerKeyUpHandler(handler:self)
            canRender = true
        }
    }

        override func teardown() {
            dispatcher.unregisterKeyDownHandler(handler:self)
            dispatcher.unregisterKeyUpHandler(handler:self)
        }
            
    

    override func render(canvas:Canvas) {
        if char.isReady && canRender && renderMc {
            char.renderMode = .sourceAndDestination(sourceRect:charSourceRect, destinationRect:charDestRect)
            canvas.render(char)
            
            }
        }
    

    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {

        if !mvmtLocked {
        if code == "ArrowDown" {
            charSourceRect.topLeft.y = 0
            mvmtTracker += 1
            if mvmtTracker%3 == 0 || mvmtTracker < 6 {
                charSourceRect.topLeft.x += 64
            }
            if charSourceRect.topLeft.x > 192 {
                charSourceRect.topLeft.x = 0
            }
        }

        if code == "ArrowLeft" {
            charSourceRect.topLeft.y = 64
            mvmtTracker += 1
            if mvmtTracker%3 == 0 || mvmtTracker < 6 {
                charSourceRect.topLeft.x += 64
            }
            if charSourceRect.topLeft.x > 192 {
                charSourceRect.topLeft.x = 0
            }
        }

        if code == "ArrowRight" {
            charSourceRect.topLeft.y = 128
            mvmtTracker += 1
            if mvmtTracker%3 == 0 || mvmtTracker < 6 {
                charSourceRect.topLeft.x += 64
            }
            if charSourceRect.topLeft.x > 192 {
                charSourceRect.topLeft.x = 0
            }
        }

        if code == "ArrowUp" {
            charSourceRect.topLeft.y = 192
            mvmtTracker += 1
            if mvmtTracker%3 == 0 || mvmtTracker < 6 {
                charSourceRect.topLeft.x += 64
            }
            if charSourceRect.topLeft.x > 192 {
                charSourceRect.topLeft.x = 0
            }
        }

        }
             
    }

    func onKeyUp(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {

        if !mvmtLocked {

        
        if code == "ArrowDown" {
            charSourceRect.topLeft = Point(x:0, y:0)
           
            mvmtTracker = 3
            canInteract = false
        }

        if code == "ArrowLeft" {
            charSourceRect.topLeft = Point(x:0, y:64)
            mvmtTracker = 3
            canInteract = false
        }

        if code == "ArrowRight" {
            charSourceRect.topLeft = Point(x:0, y:128)
            mvmtTracker = 3
            canInteract = false
        }

        if code == "ArrowUp" {
            charSourceRect.topLeft = Point(x:0, y:192)
            mvmtTracker = 3
            canInteract = true
        }

        }
    }
}
    


