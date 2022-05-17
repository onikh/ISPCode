import Scenes
import Igis
import Foundation

class Map2 : RenderableEntity, KeyDownHandler {

    let map2 : Image
    let audio1 : Audio
    let audio2: Audio

    
    var destrect : Rect
    var sourceRect : Rect
    var active = false

    let miguel : Image
    var rendermiguel = false
    
    var sourceHeight : Int
    var sourceWidth : Int

    //Canvas Data
    var canrender = false
    var canvasratio : Double
    var canvasWidth : Int
    var canvasHeight : Int

    //containment
    var characterBoundingRect : Rect
    var boundRect : Rect
    var boundRect2 : Rect
    var boundRect3 : Rect
    var boundRect4 : Rect
    var boundRect5 : Rect
    var miguelrect : Rect

    //mvmt lock
    var lockedUp = false
    var lockedDown = false
    var lockedLeft = false
    var lockedRight = false
    var mvmtLocked = false

    
    






    init() {

        guard let map2url = URL(string:"https://github.com/onikh/ISPData/blob/main/map2final.png?raw=true") else {
            fatalError("Failed to create URL for map2")
        }

        guard let miguelURL = URL(string:"https://github.com/onikh/ISPData/blob/main/miguel.png?raw=true") else {
            fatalError("Failed to create URL for miguel")
        }

        guard let audio1URL = URL(string:"https://github.com/onikh/ISPData/blob/main/forest.mp3?raw=true") else {
            fatalError("Failed to create URL for audio1")
        }

        guard let audio2URL = URL(string:"https://github.com/onikh/ISPData/blob/main/paris.mp3?raw=true") else {
            fatalError("Failed to create URL for audio2")
        }

        map2 = Image(sourceURL:map2url)
        miguel = Image(sourceURL:miguelURL)
        audio1 = Audio(sourceURL:audio1URL)
        audio2 = Audio(sourceURL:audio2URL)

        destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        sourceRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        characterBoundingRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        boundRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        boundRect2 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        boundRect3 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        boundRect4 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        boundRect5 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        
        miguelrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))  

        canvasratio = 0.0
        sourceHeight = 0
        sourceWidth = 0
        canvasWidth = 0
        canvasHeight = 0

        super.init(name:"Map2")
    }

    override func teardown() {
        dispatcher.unregisterKeyDownHandler(handler:self)
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(map2)
        canvas.setup(miguel)
        canvas.setup(audio1)
        canvas.setup(audio2)
        dispatcher.registerKeyDownHandler(handler:self)
        if let canvasSize = canvas.canvasSize {

            canvasratio = Double(canvasSize.width)/Double(canvasSize.height)
            sourceHeight = 200
            sourceWidth = Int(Double(sourceHeight)*canvasratio)

            let heightratio = Double(canvasSize.height)/Double(sourceHeight)
            let widthratio = Double(canvasSize.height)/(Double(sourceHeight)*canvasratio)


            destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:canvasSize.width, height:canvasSize.height))
            sourceRect = Rect(topLeft:Point(x:266-(sourceWidth/2), y:313-(sourceHeight/2)), size:Size(width:sourceWidth, height:sourceHeight))

            func generateBoundingRect(xpoint:Int, ypoint:Int, width:Int, height:Int) -> Rect {
                let rect = Rect(topLeft:Point(x: Int((Double(xpoint - Int(266-(sourceWidth/2)))/Double(sourceRect.width))*Double(canvasSize.width)), y:Int((Double(ypoint-212)/200.0)*Double(canvasSize.height))), size:Size(width:Int((Double(width)/Double(sourceRect.width))*Double(canvasSize.width)), height:Int((Double(height)/Double(200))*Double(canvasSize.height))))
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


            characterBoundingRect = generateBoundingRect(xpoint:270, ypoint:322, width:13, height:11)   

            boundRect = generateBoundingRect(xpoint:160, ypoint:331, width:97, height:149)
            boundRect2 = generateBoundingRect(xpoint:174, ypoint:112, width:32, height:224)
            boundRect3 = generateBoundingRect(xpoint:175, ypoint:112, width:256, height:32)
            boundRect4 = generateBoundingRect(xpoint:320, ypoint:144, width:32, height:192)
            boundRect5 = generateBoundingRect(xpoint:288, ypoint:331, width:32, height:149)
            miguelrect = generateBoundingRect(xpoint:256, ypoint:224, width:16, height:16)

            
            boundRect.topLeft -= generateBoundingOffset(xtoreach:-18, ytoreach:0)
            boundRect2.topLeft -= generateBoundingOffset(xtoreach:-96, ytoreach:0)
            boundRect3.topLeft -= generateBoundingOffset(xtoreach:-96, ytoreach:-176)
            boundRect4.topLeft -= generateBoundingOffset(xtoreach:32, ytoreach:0)
            boundRect5.topLeft -= generateBoundingOffset(xtoreach:0, ytoreach:-4)
            miguelrect.topLeft -= generateBoundingOffset(xtoreach:-16, ytoreach:-81)   
            

            canvasWidth = canvasSize.width
            canvasHeight = canvasSize.height

            canrender = true
        }
        
    }

    override func render(canvas:Canvas) {
        if map2.isReady && canrender && active && audio2.isReady && audio1.isReady {

            audio2.mode = .pause
            audio1.mode = .play

            
            map2.renderMode = .sourceAndDestination(sourceRect:sourceRect, destinationRect:destrect)
            miguel.renderMode = .destinationRect(miguelrect)
            canvas.render(map2)

            /*
            canvas.render(Rectangle(rect:boundRect, fillMode:.stroke))
            canvas.render(Rectangle(rect:boundRect2, fillMode:.stroke))
            canvas.render(Rectangle(rect:boundRect3, fillMode:.stroke))
            canvas.render(Rectangle(rect:boundRect4, fillMode:.stroke))
            canvas.render(Rectangle(rect:boundRect5, fillMode:.stroke))
            canvas.render(Rectangle(rect:characterBoundingRect, fillMode:.stroke))
            canvas.render(Rectangle(rect:miguelrect, fillMode:.stroke))
            
             */
            
            if rendermiguel {
                canvas.render(miguel)
                audio2.mode = .play
                audio1.mode = .pause
            }
        } else {
            audio1.mode = .pause
            audio2.mode = .pause
        }

        if audio1.isReady && audio2.isReady {
            canvas.render(audio1)
            canvas.render(audio2)
        }
        
    }

    override func calculate(canvasSize:Size) {
        let boundRectcontainment = boundRect.containment(target:characterBoundingRect)
        let boundRect2containment = boundRect2.containment(target:characterBoundingRect)
        let boundRect3containment = boundRect3.containment(target:characterBoundingRect)
        let boundRect4containment = boundRect4.containment(target:characterBoundingRect)
        let boundRect5containment = boundRect5.containment(target:characterBoundingRect)
        let miguelcontainment = miguelrect.containment(target:characterBoundingRect)

        if (!boundRect3containment.intersection([.overlapsBottom]).isEmpty && boundRect3containment.contains(.contact)) || (!miguelcontainment.intersection([.overlapsBottom]).isEmpty && miguelcontainment.contains(.contact)) {
            lockedUp = true
            print("locked")
        } else {
            lockedUp = false
        }
        

        if (!boundRectcontainment.intersection([.overlapsTop]).isEmpty && boundRectcontainment.contains(.contact)) || (!boundRect5containment.intersection([.overlapsTop]).isEmpty && boundRect5containment.contains(.contact)) || (!miguelcontainment.intersection([.overlapsTop]).isEmpty && miguelcontainment.contains(.contact)) {
            lockedDown = true
        } else {
            lockedDown = false
        }


        if (!boundRectcontainment.intersection([.overlapsRight]).isEmpty && boundRectcontainment.contains(.contact)) || (!boundRect2containment.intersection([.overlapsRight]).isEmpty && boundRect2containment.contains(.contact)) || (!miguelcontainment.intersection([.overlapsRight]).isEmpty && miguelcontainment.contains(.contact)) {
            lockedLeft = true
        } else {
            lockedLeft = false
        }


        if (!boundRect4containment.intersection([.overlapsLeft]).isEmpty && boundRect4containment.contains(.contact)) || (!boundRect5containment.intersection([.overlapsLeft]).isEmpty && boundRect5containment.contains(.contact)) || (!miguelcontainment.intersection([.overlapsLeft]).isEmpty && miguelcontainment.contains(.contact)) {
            lockedRight = true
        } else {
            lockedRight = false
        }

        
        
    }
                                               

    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if active {

            if !mvmtLocked {
            if code == "ArrowUp" && sourceRect.topLeft.y > 0 && !lockedUp {
                sourceRect.topLeft.y -= 2
                boundRect.topLeft.y += Int(Double(canvasHeight)/100.0)
                boundRect2.topLeft.y += Int(Double(canvasHeight)/100.0)
                boundRect3.topLeft.y += Int(Double(canvasHeight)/100.0)
                boundRect4.topLeft.y += Int(Double(canvasHeight)/100.0)
                boundRect5.topLeft.y += Int(Double(canvasHeight)/100.0)
                miguelrect.topLeft.y += Int(Double(canvasHeight)/100.0) 
            }

            if code == "ArrowDown" && sourceRect.bottomLeft.y < 563 && !lockedDown {
                sourceRect.topLeft.y += 2
                boundRect.topLeft.y -= Int(Double(canvasHeight)/100.0)
                boundRect2.topLeft.y -= Int(Double(canvasHeight)/100.0)
                boundRect3.topLeft.y -= Int(Double(canvasHeight)/100.0)
                boundRect4.topLeft.y -= Int(Double(canvasHeight)/100.0)
                boundRect5.topLeft.y -= Int(Double(canvasHeight)/100.0)
                miguelrect.topLeft.y -= Int(Double(canvasHeight)/100.0)
            }

            if code == "ArrowRight" && sourceRect.bottomRight.x < 527 && !lockedRight {
                sourceRect.topLeft.x += 2
                boundRect.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                boundRect2.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                boundRect3.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                boundRect4.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                boundRect5.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                miguelrect.topLeft.x -= Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            }

            if code == "ArrowLeft" && sourceRect.topLeft.x > 2 && !lockedLeft {
                sourceRect.topLeft.x -= 2
                boundRect.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                boundRect2.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                boundRect3.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                boundRect4.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                boundRect5.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
                miguelrect.topLeft.x += Int(Double(canvasWidth)/(Double(sourceWidth)/2.0))
            }
        }
        }
    }

    
}
                         
