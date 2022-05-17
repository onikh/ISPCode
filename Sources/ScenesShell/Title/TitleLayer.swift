import Igis
import Scenes
import Foundation


class TitleBackground : RenderableEntity, KeyDownHandler {

    let backgroundGIF : Image
    let logo : Image

    let backgroundAudio : Audio

    var gifSource : Rect
    var destRect : Rect

    var logoDestRect : Rect

    var counter = 1
    var keyPressed = false

    var shouldChangeScene = false

    init() {

        guard let backgroundGIFURL = URL(string:"https://github.com/onikh/ISPData/blob/main/bggifsheet%20(1).png?raw=true") else {
            fatalError("Failed to create URL for backgroundGIF")
        }

        backgroundGIF = Image(sourceURL:backgroundGIFURL)

        guard let logoURL = URL(string:"https://github.com/onikh/ISPData/blob/main/logo2.png?raw=true") else {
            fatalError("Failed to create URL for logo")
        }
        logo = Image(sourceURL:logoURL)

        guard let AudioURL = URL(string:"https://github.com/onikh/ISPData/blob/main/untitled%20(1).mp3?raw=true") else {
            fatalError("Failed to create URL for audio")
        }
        backgroundAudio = Audio(sourceURL:AudioURL, shouldLoop:true)


        gifSource = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        destRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        logoDestRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        




        super.init(name:"TitleScreen")
    }



    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(backgroundGIF)
        canvas.setup(logo)
        canvas.setup(backgroundAudio)

       // if backgroundAudio.isReady {
     //       canvas.render(backgroundAudio)
       // }

        if let canvasSize = canvas.canvasSize {

            let canvasratio = Double(canvasSize.width)/Double(canvasSize.height)
            let sourceheight = 250
            let sourcewidth = Int(Double(sourceheight)*canvasratio)

            gifSource = Rect(topLeft:Point(x:250-(sourcewidth/2), y:65), size:Size(width:sourcewidth, height:250))
            destRect = Rect(topLeft:Point(x:0,y:0), size:Size(width:canvasSize.width, height:canvasSize.height))

            logoDestRect = Rect(topLeft:Point(x:canvasSize.width/2,y:canvasSize.height/9), size:Size(width:canvasSize.width/3, height:Int(Double(canvasSize.width/3)/2.96)))
            logoDestRect.topLeft.x -= logoDestRect.width/2

            dispatcher.registerKeyDownHandler(handler:self)

        }
    }

        override func teardown() {
            dispatcher.unregisterKeyDownHandler(handler:self)
        }

        
    

    override func render(canvas:Canvas) {
        if let canvasSize = canvas.canvasSize {

            let canvasratio = Double(canvasSize.width)/Double(canvasSize.height)
            let sourceheight = 250
            let sourcewidth = Int(Double(sourceheight)*canvasratio)

            if backgroundGIF.isReady && logo.isReady {
            backgroundGIF.renderMode = .sourceAndDestination(sourceRect:gifSource, destinationRect:destRect )
            canvas.render(backgroundGIF)

            logo.renderMode = .destinationRect(logoDestRect)
            canvas.render(logo)

            if counter%5 == 0 {

                gifSource.topLeft.x += 500
            }
            if gifSource.topLeft.x > 9500 {
                gifSource.topLeft.x = 250-(sourcewidth/2)
            }

            

            if backgroundAudio.isReady && !keyPressed {
                
                backgroundAudio.mode = .play
               canvas.render(backgroundAudio)
            } 

            counter += 1
                
            }
        }

        if shouldChangeScene {
            canvas.render(backgroundAudio)
            director.transitionToNextScene()           
        }
    }


    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {

        keyPressed = true
        backgroundAudio.mode = .pause
        shouldChangeScene = true
        director.enqueueScene(scene:MainScene())
        print("paused")
        

        

    }
}


    
