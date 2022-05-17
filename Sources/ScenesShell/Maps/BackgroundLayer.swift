import Scenes
import Igis
import Foundation
  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class BackgroundLayer : Layer, KeyDownHandler {
    let transition = Transition()
    let map1 = Map1()
    let map2 = Map2()
    let seaText = Textbox(dialogue:"The sea shines a brilliant blue.")
    let signText = Textbox(dialogue:"\"Entrance to the Forbidden Forest\"")
    let rockIntro = Textbox(dialogue:"A strange aura emanates from the rock ahead...")
    let miguelText = Textbox(dialogue:"MIGUEL: Miguel 🐐🐐🐐")
    let mc = Mc()
    let water = Water()

    var miguelCount = 0 

   

    
    var transitionCount = 0

    var transTo2 = false
    var transTo1 = false

      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")

          // We insert our RenderableEntities in the constructor
          insert(entity:map2, at:.back)
          insert(entity:map1, at:.back)
          insert(entity:water, at:.back)
          insert(entity:mc, at:.front)
          insert(entity:seaText, at:.front)
          insert(entity:signText, at:.front)
          insert(entity:rockIntro, at:.front)
          insert(entity:miguelText, at :.front)
          insert(entity:transition, at:.front)
      }

      override func preSetup(canvasSize:Size, canvas:Canvas) {
          dispatcher.registerKeyDownHandler(handler:self)
      }

      override func postTeardown() {
          dispatcher.unregisterKeyDownHandler(handler:self)
      }

      override func postCalculate(canvas:Canvas) {
          if let canvasSize = canvas.canvasSize {

              // Map1 Events
              if map1.sourceRect.topLeft.y < 2 && map1.active {
                  map1.active = false
                  transition.active = true
                  transTo2 = true

                  map1.sourceRect.topLeft.y += 2*5
                  map1.testRect.topLeft.y -= Int(Double(map1.canvasHeight)/100.0)*5
                  map1.testRect2.topLeft.y -= Int(Double(map1.canvasHeight)/100.0)*5
                  map1.testRect3.topLeft.y -= Int(Double(map1.canvasHeight)/100.0)*5
                  map1.testRect4.topLeft.y -= Int(Double(map1.canvasHeight)/100.0)*5
                  map1.testRect5.topLeft.y -= Int(Double(map1.canvasHeight)/100.0)*5
                  map1.testRect6.topLeft.y -= Int(Double(map1.canvasHeight)/100.0)*5
                  map1.testRect7.topLeft.y -= Int(Double(map1.canvasHeight)/100.0)*5
                  map1.testRect8.topLeft.y -= Int(Double(map1.canvasHeight)/100.0)*5
                  print("if1")
              }

              if transTo2 {
                  transitionCount += 1
                  print("if2")
                  if transitionCount == 30 {
                      transition.active = false
                      transTo2 = false
                      map2.active = true
                      rockIntro.active = true
                      transitionCount = 0
                  }
              }

              //Map2 Events
              
              if map2.sourceRect.bottomLeft.y > 470 && map2.active {
                  print("if3")
                  map2.active = false
                  transition.active = true
                  transTo1 = true

                  map2.sourceRect.topLeft.y -= 10
                  map2.boundRect.topLeft.y += Int(Double(map2.canvasHeight)/100.0)*5
                  map2.boundRect2.topLeft.y += Int(Double(map2.canvasHeight)/100.0)*5
                  map2.boundRect3.topLeft.y += Int(Double(map2.canvasHeight)/100.0)*5
                  map2.boundRect4.topLeft.y += Int(Double(map2.canvasHeight)/100.0)*5
                  map2.boundRect5.topLeft.y += Int(Double(map2.canvasHeight)/100.0)*5
                  map2.miguelrect.topLeft.y += Int(Double(map2.canvasHeight)/100.0)*5 
              }

              if transTo1 {
                  print("if4")
                  transitionCount += 1
                  if transitionCount == 30 {
                      transition.active = false
                      transTo1 = false
                      map1.active = true
                      transitionCount = 0
                  }
              }

              // interaction locking
              if seaText.active || rockIntro.active || signText.active || map2.rendermiguel {
                  mc.mvmtLocked = true
                  map1.mvmtLocked = true
                  map2.mvmtLocked = true
              } else {
                  mc.mvmtLocked = false
                  map1.mvmtLocked = false
                  map2.mvmtLocked = false
              }

              if map2.rendermiguel {
                  miguelCount += 1
                  if miguelCount == 20 {
                      miguelText.active = true
                  }

                  
              }


              if miguelText.nextbox {
                  print("Ready to switch!")
                  func switchToGame() {
                      director.enqueueScene(scene: BattleScene())
                      director.transitionToNextScene()
                      
                  }
                  switchToGame()
              }


              if map1.lockedUp || map2.lockedUp {
                  water.lockedUp = true
              } else {
                  water.lockedUp = false
              }

              if map1.lockedDown || map2.lockedDown {
                  water.lockedDown = true 
              } else {
                  water.lockedDown = false
              }

              if map1.lockedLeft || map2.lockedLeft {
                  water.lockedLeft = true
              } else {
                  water.lockedLeft = false
              }

              if map1.lockedRight || map2.lockedRight {
                  water.lockedRight = true
              } else {
                  water.lockedRight = false
              }
                  
                      
      }
      }




      func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
          if code == "Enter" {

              let signContainment = map1.testRect7.containment(target:map1.characterBoundingRect)
              let seaContainment = map1.testRect.containment(target:map1.characterBoundingRect)
              let miguelContainment = map2.miguelrect.containment(target:map2.characterBoundingRect)
              
              if map1.active && (!seaContainment.intersection([.overlapsTop]).isEmpty && seaContainment.contains(.contact)) && !seaText.active  {
                  seaText.active = true
                  
              } else {
                  seaText.active = false
              }

              if map1.active && (!signContainment.intersection([.overlapsBottom]).isEmpty && signContainment.contains(.contact)) && !signText.active {
                  signText.active = true
                  
              } else {
                  signText.active = false
              }

              rockIntro.active = false

              if map2.active && (!miguelContainment.intersection([.overlapsBottom]).isEmpty && miguelContainment.contains(.contact)) && !map2.rendermiguel {
                  map2.rendermiguel = true
              }

    
                  

      }
      }

}


      


// first map is 528*480
