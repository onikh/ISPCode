import Scenes
import Igis
import Foundation
  /*
     This class is responsible for rendering the background.
   */


class Map1 : RenderableEntity, KeyDownHandler {



    
    // Intro Area/Map1
    let map1 : Image
    var destRect : Rect
    var sourceRect : Rect
    let audio : Audio
    var active = true
    
    var sourceHeight : Int
    var sourceWidth : Int

    //Canvas Data
    var canRender = false
    var canvasRatio : Double

    // Containment Testing
    var characterBoundingRect : Rect

    var testRect : Rect
    var testRect2 : Rect
    var testRect3 : Rect
    var testRect4 : Rect
    var testRect5 : Rect
    var testRect6 : Rect
    var testRect7 : Rect
    var testRect8 : Rect
    
    var canvasWidth : Int
    var canvasHeight : Int
   
    //movement locking
    var lockedUp = false
    var lockedDown = false
    var lockedLeft = false
    var lockedRight = false
    var mvmtLocked = false
    
    
    

    init() {

        guard let map1url = URL(string:"https://github.com/onikh/ISPData/blob/main/finalmap1.png?raw=true") else {
            fatalError("Failed to create URL for map1")
        }

        guard let AudioURL = URL(string:"https://github.com/onikh/ISPData/blob/main/map1audio.mp3?raw=true") else {
            fatalError("Failed to create URL for audio")
        }
        
        map1 = Image(sourceURL:map1url)
        audio = Audio(sourceURL:AudioURL)
        
        destRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        sourceRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        testRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testRect2 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testRect3 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testRect4 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testRect5 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1)) 
        testRect6 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testRect7 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testRect8 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        
        characterBoundingRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        
        canvasRatio = 0.0
        sourceHeight = 0
        sourceWidth = 0
        canvasWidth = 0
        canvasHeight = 0
        


        
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")
    }

   
override func setup(canvasSize:Size, canvas:Canvas) {
    canvas.setup(map1)
    canvas.setup(audio)


    // canvas setup
    
    if let canvasSize = canvas.canvasSize {
        canvasRatio = Double(canvasSize.width)/Double(canvasSize.height)
        sourceHeight = 200
        sourceWidth = Int(Double(sourceHeight)*canvasRatio)

        let heightratio = Double(canvasSize.height)/Double(sourceHeight)
        let widthratio = Double(canvasSize.height)/(Double(sourceHeight)*canvasRatio)
          
          canRender = true


        //map1
        destRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:canvasSize.width, height:canvasSize.height))
        sourceRect = Rect(topLeft:Point(x:208-(sourceWidth/2), y:376-(sourceHeight/2)), size:Size(width:sourceWidth, height:sourceHeight))

        //keyhandler setup
        dispatcher.registerKeyDownHandler(handler:self)

        
        print("Canvas Height to Width Ratio:", canvasRatio)
        print("Canvas Height: \(canvasSize.height)")
        print("Canvas Width: \(canvasSize.width)")
        print("")
        
        print("Canvas to Displayed Source Image Height Ratio: \(heightratio)")
        print("Canvas to Displayed Source Image Width Ratio: \(widthratio)")
        print("Resolution in game: \(sourceRect.width)x\(sourceRect.height)")
        print("")
        print("")
        print("Left Edge: \(208-(sourceWidth/2))")
        print("Right Edge: \(208+(sourceWidth/2))")
      
        

        func generateBoundingRect(xpoint:Int, ypoint:Int, width:Int, height:Int) -> Rect {
            let rect = Rect(topLeft:Point(x: Int((Double(xpoint - Int(208-(sourceWidth/2)))/Double(sourceRect.width))*Double(canvasSize.width)), y:Int((Double(ypoint-275)/200.0)*Double(canvasSize.height))), size:Size(width:Int((Double(width)/Double(sourceRect.width))*Double(canvasSize.width)), height:Int((Double(height)/Double(200))*Double(canvasSize.height))))
            return rect
        }

        func generateBoundingOffset(xtoreach:Int, ytoreach:Int) -> Point {
            let stepspermovey = Double(canvasSize.height)/(Double(sourceHeight)/2.0)
            let losspery = stepspermovey.truncatingRemainder(dividingBy:1.0)
            let totalyloss = (Double(ytoreach)/2.0)*losspery

            let stepspermovex = Double(canvasSize.width)/(Double(sourceWidth)/2.0)
            let lossperx = stepspermovex.truncatingRemainder(dividingBy:1.0)
            let totalxloss = (Double(xtoreach)/2.0)*lossperx

            return Point(x: Int(totalxloss), y: Int(totalyloss))
        }
            
            
        


        //Containment
        let stepspermovey = Double(canvasSize.height)/(Double(sourceHeight)/2.0)
        let losspery = stepspermovey.truncatingRemainder(dividingBy:1.0)

        let stepspermovex = Double(canvasSize.width)/(Double(sourceWidth)/2.0)
        let lossperx = stepspermovex.truncatingRemainder(dividingBy:1.0)

        characterBoundingRect = generateBoundingRect(xpoint:211, ypoint:389, width:14, height:7)
        
          
        testRect = generateBoundingRect(xpoint:208, ypoint:405, width:120, height:30)
        testRect2 = generateBoundingRect(xpoint:192, ypoint:376, width:16, height:30)
        testRect3 = generateBoundingRect(xpoint:208, ypoint:96, width:80, height:279)
        testRect4 = generateBoundingRect(xpoint:320, ypoint:303, width:145, height:102)
        testRect5 = generateBoundingRect(xpoint:464, ypoint:128, width:16, height:176)
        testRect6 = generateBoundingRect(xpoint:336, ypoint:144, width:138, height:16)
        testRect7 = generateBoundingRect(xpoint:320, ypoint:96, width:16, height:62)
        testRect8 = generateBoundingRect(xpoint:320, ypoint:176, width:112, height:112)
        

        testRect.topLeft -= generateBoundingOffset(xtoreach:-4, ytoreach:15)
        testRect2.topLeft -= generateBoundingOffset(xtoreach:-10, ytoreach:-6)
        testRect3.topLeft -= generateBoundingOffset(xtoreach:76, ytoreach:-2)
        testRect4.topLeft -= generateBoundingOffset(xtoreach:98, ytoreach:-92)
        testRect5.topLeft -= generateBoundingOffset(xtoreach:242, ytoreach:-91)
        testRect6.topLeft -= generateBoundingOffset(xtoreach:113, ytoreach:-220)
        testRect7.topLeft -= generateBoundingOffset(xtoreach:94, ytoreach:-237)
        testRect8.topLeft -= generateBoundingOffset(xtoreach:98, ytoreach:-93)

        testRect8.width -= Int(62.0*lossperx)
        
        testRect8.topLeft.y += Int(68.0*losspery)
        testRect8.height -= Int(68.0*losspery)
        
        canvasWidth = canvasSize.width
        canvasHeight = canvasSize.height
    }
}

override func teardown() {
    dispatcher.unregisterKeyDownHandler(handler:self)
}



override func render(canvas:Canvas) {

    if map1.isReady && canRender && active {
        map1.renderMode = .sourceAndDestination(sourceRect:sourceRect, destinationRect:destRect)
        canvas.render(map1)

        /*

        canvas.render(Rectangle(rect:characterBoundingRect, fillMode:.stroke))

        canvas.render(Rectangle(rect:testRect, fillMode:.stroke))
        canvas.render(Rectangle(rect:testRect2, fillMode:.stroke))
        canvas.render(Rectangle(rect:testRect3, fillMode:.stroke))
        canvas.render(Rectangle(rect:testRect4, fillMode:.stroke))
        canvas.render(Rectangle(rect:testRect5, fillMode:.stroke))
        canvas.render(Rectangle(rect:testRect6, fillMode:.stroke))
        canvas.render(Rectangle(rect:testRect7, fillMode:.stroke))
        canvas.render(Rectangle(rect:testRect8, fillMode:.stroke))
        */

        
         
        audio.mode = .play
    } else {
        audio.mode = .pause
    }

    if audio.isReady {

        canvas.render(audio)
    }

}
//////////////////////////
override func calculate(canvasSize:Size) {
    let rect1containment = testRect.containment(target:characterBoundingRect)
    let rect2containment = testRect2.containment(target:characterBoundingRect) 
    let rect8containment = testRect8.containment(target:characterBoundingRect)
    let rect3containment = testRect3.containment(target:characterBoundingRect) 
    let rect4containment = testRect4.containment(target:characterBoundingRect)
    let rect5containment = testRect5.containment(target:characterBoundingRect)  
    let rect6containment = testRect6.containment(target:characterBoundingRect)
    let rect7containment = testRect7.containment(target:characterBoundingRect)


    
    if (!rect1containment.intersection([.overlapsTop]).isEmpty && rect1containment.contains(.contact)) || (!rect8containment.intersection([.overlapsTop]).isEmpty && rect8containment.contains(.contact)) || (!rect4containment.intersection([.overlapsTop]).isEmpty && rect4containment.contains(.contact))  {
        lockedDown = true
    } else {
        lockedDown = false
    }

    if (!rect2containment.intersection([.overlapsRight]).isEmpty && rect2containment.contains(.contact)) || (!rect3containment.intersection([.overlapsRight]).isEmpty && rect3containment.contains(.contact)) || (!rect8containment.intersection([.overlapsRight]).isEmpty && rect8containment.contains(.contact)) {
        lockedLeft = true
    } else {
        lockedLeft = false
    }

    if (!rect3containment.intersection([.overlapsBottom]).isEmpty && rect3containment.contains(.contact)) || (!rect6containment.intersection([.overlapsBottom]).isEmpty && rect6containment.contains(.contact)) || (!rect8containment.intersection([.overlapsBottom]).isEmpty && rect8containment.contains(.contact)) || (!rect7containment.intersection([.overlapsBottom]).isEmpty && rect7containment.contains(.contact)) {
        lockedUp = true
    } else {
        lockedUp = false
    }

    if (!rect4containment.intersection([.overlapsLeft]).isEmpty && rect4containment.contains(.contact)) || (!rect5containment.intersection([.overlapsLeft]).isEmpty && rect5containment.contains(.contact)) || (!rect7containment.intersection([.overlapsLeft]).isEmpty && rect7containment.contains(.contact)) || (!rect8containment.intersection([.overlapsLeft]).isEmpty && rect8containment.contains(.contact)) {
        lockedRight = true
    } else {
        lockedRight = false
    }

}


func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
    if active {



        

        //boundingrect movement

        if !mvmtLocked {

        
 
        if code == "ArrowUp" && sourceRect.topLeft.y > 0 && !lockedUp {
            sourceRect.topLeft.y -= 2
            testRect.topLeft.y += Int(Double(canvasHeight)/100.0)
            testRect2.topLeft.y += Int(Double(canvasHeight)/100.0)
            testRect3.topLeft.y += Int(Double(canvasHeight)/100.0)
            testRect4.topLeft.y += Int(Double(canvasHeight)/100.0)
            testRect5.topLeft.y += Int(Double(canvasHeight)/100.0)
            testRect6.topLeft.y += Int(Double(canvasHeight)/100.0)
            testRect7.topLeft.y += Int(Double(canvasHeight)/100.0)
            testRect8.topLeft.y += Int(Double(canvasHeight)/100.0)
          }
   
        if code == "ArrowDown" && sourceRect.bottomLeft.y < 563 && !lockedDown {
            sourceRect.topLeft.y += 2
            testRect.topLeft.y -= Int(Double(canvasHeight)/100.0)
            testRect2.topLeft.y -= Int(Double(canvasHeight)/100.0)
            testRect3.topLeft.y -= Int(Double(canvasHeight)/100.0)
            testRect4.topLeft.y -= Int(Double(canvasHeight)/100.0)
            testRect5.topLeft.y -= Int(Double(canvasHeight)/100.0)
            testRect6.topLeft.y -= Int(Double(canvasHeight)/100.0)
            testRect7.topLeft.y -= Int(Double(canvasHeight)/100.0)
            testRect8.topLeft.y -= Int(Double(canvasHeight)/100.0)
        }

        if code == "ArrowRight" && sourceRect.bottomRight.x < 703 && !lockedRight {
            sourceRect.topLeft.x += 2
            testRect.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect2.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect3.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect4.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect5.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect6.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect7.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect8.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
        }

        if code == "ArrowLeft" && sourceRect.topLeft.x > 2 && !lockedLeft {
            sourceRect.topLeft.x -= 2
            testRect.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect2.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect3.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect4.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect5.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect6.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect7.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            testRect8.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
        }

        }

    }
    
    
        

        

    }

}
                   






