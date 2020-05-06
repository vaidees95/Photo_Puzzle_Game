//
//  ViewController.swift
//  PhotoPuzzle
//
//  Created by Vaideeswaran Kaliannan on 10/15/2019.
//  Copyright © 2019 Vaideeswaran Kaliannan. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation

class ViewController: UIViewController,UITextFieldDelegate {
    
    //******************************************//
    //***************  Properties **************//
    //******************************************//
    
    // - MARK: Properties
    
    // general variables
    //countdown timer
    var gameSpeed = 0.0
    var timer:Timer!
    var countdown = 600.00
    var moves = 0
    var player:AVAudioPlayer!
    @IBOutlet weak var lblCountTimer: UILabel!
    @IBOutlet weak var lblMovesCount: UILabel!
    
    var jumbleView: UIView? // holds the jumbled puzzle pieces
    var puzzleImageView: UIImageView?   // holds the puzzle image
    var gameBoard = GameBoard.sharedInstance    // the gameboard data
    var screenWidth: CGFloat = 375  // screen width (placeholder)
    var screenHeight: CGFloat = 700 // screen height (placeholder)
    var offScreenDistance: CGFloat = 700 // distance off screen to hide
    
    // formatting variables
    let borderWidth: CGFloat = 2.0
    let borderColor: CGColor = UIColor.white.cgColor
    
    // pictures collectionView variables
    @IBOutlet weak var picturesView: UIView!
    @IBOutlet weak var picturesHeaderView: UIView!
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    let imagePicker = UIImagePickerController() // access images from camera and library
    let reuseIdentifier = "PictureCell"
    let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)  // collectionView formatting
    let itemsPerRow: CGFloat = 1    // collectionView formatting
    var pictures = [UIImage]()
    var puzzleCount = 43

    // difficulty buttons
    var difficultyButtons = [UIButton]()
    
    //******************************************//
    //***************** Outlets ****************//
    //******************************************//
    
    @IBOutlet weak var powerUpView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

  
    @IBOutlet weak var difficultyView: UIView!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var extremeButton: UIButton!
    @IBOutlet weak var jumbleButton: UIButton!
    @IBOutlet weak var powerUpButton: UIButton!
    @IBOutlet weak var difficultyButton: UIButton!
    @IBOutlet weak var pictureButton: UIButton!
    
    var moveSound = AVAudioPlayer()
    var gameOverSound = AVAudioPlayer()
    //******************************************//
    //************  Button Actions *************//
    //******************************************//
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            //print("Long Press")
             gameBoard.solvePuzzle()
            countdown -= 5.0
           // showMissingPuzzlePiece()
        }
        else{
            gameBoard.resetPreviousLocation()
         // openAlertView()
            
            
        }

            
        
    }
    var textField: UITextField?

    @IBAction func btnGameOver(_ sender: Any) {
        
      //  gameBoard.solvePuzzle()
       //        print("game over: true")
      //         showMissingPuzzlePiece()
    }
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Some text";
        }
    }

    func openAlertView() {
        let alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            print("User click Ok button")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addLongPressGesture(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 1.5
        self.powerUpButton.addGestureRecognizer(longPress)
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let infor = segue.destination as! GamerNameVC
        infor.moves = self.moves
        infor.coutDown = self.countdown
       }

    @objc func countdownAction()
    {
        countdown -= 1.0
        if countdown <= 0.00{
            timer.invalidate()
            timer = nil
            gameOverSound.play()
            lblCountTimer.text = "Times up!!"
                         let title = "Game Over"
                                             let message = "You did a gread job!!!."
                                             
                                             // create alert
                                             let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                                             alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler:
                                                 { action in
                                                     
                                                     self.updateDifficulty(difficulty: self.gameBoard.difficulty)
                                             }))
                                             self.present(alert, animated: true, completion: nil)
                    }
        
        else
        {
            if(countdown <= 10)
            {
                lblCountTimer.textColor = UIColor.blue
            }
            else
            {
                lblCountTimer.textColor = UIColor.black
            }
            lblCountTimer.text = "\(countdown)"
            let flooredCounter = Int(floor(countdown))
            let hour = flooredCounter/3600
            let minute = (flooredCounter%3600)/60
            var minuteString = "\(minute)"
            if minute < 10 {
                minuteString = "0\(minute)"
            }
            let second = (flooredCounter%3600)%60
            var secondString = "\(second)"
            if second < 10 {
                secondString = "0\(second)"
            }
            
            lblCountTimer.text = "\(hour):\(minuteString):\(secondString)"
        }
    }
    
    @IBAction func pictureButton(_ sender: UIButton) {
        // show or hide pictureView to select new picture for puzzle
        print("button pressed: toggle view to select pictures from collection view")
        togglePictureView()
    }
    
    @IBAction func cancelPicturesButton(_ sender: UIButton) {
        // show or hide pictureView to select new picture for puzzle
        print("button pressed: cancel view to select pictures from collection view")
        togglePictureView()
    }
    
    @IBAction func difficultyButton(_ sender: UIButton) {
        // show or hide difficulty to select new difficulty setting
        print("button pressed: toggle view to select difficulty")
        toggleDifficultyView()
    }
    
    @IBAction func cameraButton(_ sender: UIButton) {
        // show photo alert to reset puzzle based on camera or existing user pictures
        print("button pressed: choose own picture from Camera or Photo Library")
        showPhotoAlert()
    }

    @IBAction func infoButton(_ sender: UIButton) {
        // show instructions view
        // currently omitted intentionally - application shows instructions on main screen for simplicity
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        // show settings view
        print("button pressed: show settings view")
        showSettings()
    }
    
    @IBAction func easyButton(_ sender: UIButton) {
        print("button pressed: change settings to easy, show jumble alert before proceeding")
        let difficulty = GameBoard.Difficulty.Easy
        showDifficultyWarning(sender: sender, difficulty: difficulty)
        
    }
    
    @IBAction func mediumButton(_ sender: UIButton) {
        print("button pressed: change settings to medium, show jumble alert before proceeding")
        let difficulty = GameBoard.Difficulty.Medium
        showDifficultyWarning(sender: sender, difficulty: difficulty)
    }
    
    @IBAction func hardButton(_ sender: UIButton) {
        print("button pressed: change settings to hard, show jumble alert before proceeding")
        let difficulty = GameBoard.Difficulty.Hard
        showDifficultyWarning(sender: sender, difficulty: difficulty)
    }
    
    @IBAction func extremeButton(_ sender: UIButton) {
        print("button pressed: change settings to extreme, show jumble alert before proceeding")
        let difficulty = GameBoard.Difficulty.Extreme
        showDifficultyWarning(sender: sender, difficulty: difficulty)
    }
    
    @IBAction func jumbleButton(_ sender: UIButton) {
        print("button pressed: jumble pieces")
        jumblePuzzlePieces()
    }
    
    @IBAction func btnFinish(_ sender: Any) {
        gameBoard.solvePuzzle()
        print("game over: true")
        showMissingPuzzlePiece()
        
    }
    @IBAction func powerUpBUtton(_ sender: UIButton) {
        // show powerUp available: current options is solve puzzle
        // this will later be updated based on hidden power ups inside puzzle
        print("button pressed: power up, currently solve puzzle")
      //  solvePuzzle()
    }
    
    //******************************************//
    //**********  Settings Overlay *************//
    //******************************************//
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var cameraSwitch: UISwitch!
    @IBOutlet weak var librarySwitch: UISwitch!
    
    @IBAction func goToSettingsButton(_ sender: UIButton) {
        // show iPhone settings
        print("button pressed: open iPhone settings")
        let url = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.open(url!)
    }
    
    @IBAction func returnToGameButton(_ sender: UIButton) {
        print("button pressed: hide settings and return to game")
        hideSettings()
    }
    
    //******************************************//
    //*************  View Did Load *************//
    //******************************************//
    override func viewWillAppear(_ animated: Bool) {
        // initial setup
      resetTimerandMoves()
        jumblePuzzlePieces()
        /*    setupMoveSound()
            setupGameOver()
             addLongPressGesture()
           // initial setup
            initialSetup()
            
            // set the puzzleImage and difficulty
            let puzzleImage = getRandomPicture()
            let difficulty = GameBoard.Difficulty.Easy
            
            // update which one is selected
            updateDifficultyButtons()
            
            // create the gameboard
            gameBoard.create(screenWidth: screenWidth, puzzleImage: puzzleImage, difficulty: difficulty)
            
            // show the puzzle
            revealGameBoard()
            timer = Timer.scheduledTimer(timeInterval: gameSpeed, target: self, selector: #selector(countdownAction), userInfo: nil, repeats: true)
            

            resetTimerandMoves()*/
          
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       setupMoveSound()
        setupGameOver()
         addLongPressGesture()
       // initial setup
        initialSetup()
        
        // set the puzzleImage and difficulty
        let puzzleImage = getRandomPicture()
        let difficulty = GameBoard.Difficulty.Easy
        
        // update which one is selected
        updateDifficultyButtons()
        
        // create the gameboard
        gameBoard.create(screenWidth: screenWidth, puzzleImage: puzzleImage, difficulty: difficulty)
        
        // show the puzzle
        revealGameBoard()
        timer = Timer.scheduledTimer(timeInterval: gameSpeed, target: self, selector: #selector(countdownAction), userInfo: nil, repeats: true)
        

        resetTimerandMoves() 
        
    
    }
    
    // Stop listening for notifications when view controller is gone
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //******************************************//
    //************  Gesture Control ************//
    //******************************************//
    
    func setupMoveSound() {
        if let correctGuessPath = Bundle.main.path(forResource: "lasersound", ofType: "wav") {
            let correctGuessURL = URL(fileURLWithPath: correctGuessPath)
            do {
                moveSound = try AVAudioPlayer(contentsOf: correctGuessURL)
            } catch {
                print("failed ro load sound file")
            }
        }
    }
    
    func setupGameOver() {
        if let wrongGuessPath = Bundle.main.path(forResource: "buzzer", ofType: "wav") {
            let wrongGuessURL = URL(fileURLWithPath: wrongGuessPath)
            do {
                gameOverSound = try AVAudioPlayer(contentsOf: wrongGuessURL)
            } catch {
                print("failed ro load sound file")
            }
        }
    }

    
    // add touch control for puzzle pieces
    private func addPlayerControl() {
        for puzzlePiece in gameBoard.puzzlePieces {
            createGesture(targetView: puzzlePiece.imageView)
        }
    }
    
    // remove user controls from puzzle pieces
    private func removePlayerControl() {
        for piece in gameBoard.puzzlePieces {
            piece.imageView.isUserInteractionEnabled = false
        }
    }
    
    // create gesture control
    private func createGesture(targetView: UIImageView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        targetView.addGestureRecognizer(panGesture)
        targetView.isUserInteractionEnabled = true
    }
    
    // shake to jumble puzzle
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if (motion == UIEventSubtype.motionShake) {
            jumblePuzzlePieces()
        }
    }
    // handle user touch: drag puzzle piece
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        // get the translation
        let translation = recognizer.translation(in: self.view)
        
        // get the view & puzzlePiece
        if let view = recognizer.view,
            let puzzlePiece = gameBoard.getCurrentPuzzlePiece(view: view) {
            
            // bring puzzlePiece to front
            view.superview?.bringSubview(toFront: view)
            let targetLocation = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
            let finalLocation = getFinalLocation(puzzlePiece: puzzlePiece, targetLocation: targetLocation)
            view.center = finalLocation
        }
        
        // reset the translation
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        // end of pan gesture: set piece in final location
        if (recognizer.state == UIGestureRecognizerState.ended) {
            // get the view, puzzlePiece, and square
            if let view = recognizer.view,
                let puzzlePiece = gameBoard.getCurrentPuzzlePiece(view: view),
                let gameBoardSquare = gameBoard.getClosestGameBoardSquare(puzzlePiece: puzzlePiece) {
                
                // update the puzzlePiece location
                puzzlePiece.currentLocation = gameBoardSquare
                
                // update open status for all puzzlePieces
                gameBoard.updateOpenDirectionForPuzzlePieces()
                
                // check if end of game
                checkGameOver()
                
                if (gameBoard.isSolved()) {
               
                 let title = "Game Over"
                     let message = "You did a gread job!!!."
                     timer.invalidate()
                    timer = nil
                     // create alert
                     let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                     alert.addAction(
                         UIAlertAction(title: "Finish", style: UIAlertActionStyle.default, handler:
                             { action in
                                self.performSegue(withIdentifier: "Game2GamerName", sender: self)
                               //  self.toggleDifficultyView()
                         }))
                     alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler:
                         { action in
                            self.resetTimerandMoves()
                             self.updateDifficulty(difficulty: self.gameBoard.difficulty)
                     }))
                     self.present(alert, animated: true, completion: nil)
                    
                }
                moves += 1
                moveSound.play()
                lblMovesCount.text = (String(moves))
            }
        }
    }

    // get final location based on puzzlePiece movement limits
    private func getFinalLocation(puzzlePiece: PuzzlePiece, targetLocation: CGPoint) -> CGPoint {
        // get the x and y values based on available movement range
        let x = getValueInRange(target: targetLocation.x,  min: puzzlePiece.minX, max: puzzlePiece.maxX)
        let y = getValueInRange(target: targetLocation.y,  min: puzzlePiece.minY, max: puzzlePiece.maxY)
        
        // return final point
        return CGPoint(x: x, y: y)
    }
    
    // helper function to return a value that is limited to a max and min
    private func getValueInRange(target: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        if (target > max) {
            return max
        } else if (target < min) {
            return min
        } else {
            return target
        }
    }
    
    //******************************************//
    //**************  Initialize ***************//
    //******************************************//
    
    // setup the inital items for the game
    private func initialSetup() {
        loadSettings()
        setScreenDimensions()
        setJumbleView()
        initializeDifficultyButtonArray()
        createPicturesCollection()
        setPictureCollectionDelegateAndDataSource()
    }
    
    // set the screenwidth
    private func setScreenDimensions() {
        screenWidth = self.view.bounds.size.width
        screenHeight = self.view.bounds.size.height
    }
    
    // get the imageView that holds the puzzle
    private func setJumbleView() {
        // define params
        let x: CGFloat = 0
        let yCushion: CGFloat = 5.0
        let y: CGFloat = infoView.frame.height + yCushion
        let width: CGFloat = screenWidth
        let height: CGFloat = width
        
        // create imageView and add to view
        let frame = CGRect(x: x, y: y, width: width, height: height)
        jumbleView = UIView(frame: frame)
        jumbleView?.layer.borderWidth = borderWidth // set border width for imageview
        jumbleView?.layer.borderColor = borderColor  // set border color for imageview
        jumbleView?.backgroundColor = UIColor.white
        self.view.addSubview(jumbleView!)
    }
    
    //******************************************//
    //************ Show GameBoard  *************//
    //******************************************//
    
    // set the original image (i.e. image that is split into puzzle pieces)
    func revealGameBoard() {
        // create an imageview to hold the unscrambled puzzle image
        let frame = CGRect(x: 0, y: 0, width: (jumbleView?.frame.width)!, height: (jumbleView?.frame.height)!)
        puzzleImageView = UIImageView(frame: frame)
        puzzleImageView?.contentMode = .scaleAspectFill
        puzzleImageView?.image = gameBoard.puzzleImage
        puzzleImageView?.alpha = 0.0
        
        // add it to the jumbleview
        jumbleView?.addSubview(puzzleImageView!)
        puzzleImageView?.isHidden = false
        
        // animate: reveal to be visible
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.puzzleImageView?.alpha = 1.0
        }, completion: { finished in
            
            // complete puzzle setup
            UIView.animate(withDuration: 0.5, delay: 1.0, animations: {
                self.completeGameBoardReveal()
            }, completion: { finished in
                
                // hide the unscrambled image
                self.puzzleImageView?.isHidden = true
            })
        })
    }
    
    // complete the reveal: show pieces & jumble
    func completeGameBoardReveal() {
        showPuzzlePieces()
        jumblePuzzlePieces()
    }
    
    // show the puzzle pieces
    private func showPuzzlePieces() {
        for puzzlePiece in gameBoard.puzzlePieces {
            jumbleView?.addSubview(puzzlePiece.imageView)
        }
    }
    
    // jumble puzzle pieces
    private func jumblePuzzlePieces() {        
        // shuffle the puzzle pieces
      //  gameBoard.updateDifficulty(difficulty:gameBoard.difficulty)
 gameBoard.puzzlePieces.shuffle()
        
        // set the max index based on # of puzzle pieces
        let maxIndex = gameBoard.puzzlePieces.count - 1
        
        // update the location of each puzzle piece
        for index in 0...maxIndex {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.gameBoard.puzzlePieces[index].currentLocation = self.gameBoard.squares[index]
            }, completion: { finished in
                // update the open direction for puzzle pieces after move
                self.gameBoard.updateOpenDirectionForPuzzlePieces()
                
                // add touch control to pieces
                self.addPlayerControl()
            })
        }
        resetTimerandMoves()
    }

    //******************************************//
    //************** Reset Puzzle **************//
    //******************************************//
    
    func resetPuzzleImage(puzzleImage: UIImage) {
        removeSubViews()
        gameBoard.updateImage(puzzleImage: puzzleImage)
        revealGameBoard()
        
    }
    
    func resetPuzzleDifficulty(difficulty: GameBoard.Difficulty) {
        removeSubViews()
        gameBoard.updateDifficulty(difficulty: difficulty)
        revealGameBoard()
    }
    
    //reset the time
    private func resetTimerandMoves() {
        
    countdown = 600.00
        if(timer == nil)
        {
        timer = Timer.scheduledTimer(timeInterval: gameSpeed, target: self, selector: #selector(countdownAction), userInfo: nil, repeats: true)
        }
            moves = 0
    lblMovesCount.text = (String(moves))
    }
    
    // remove all subviews
    private func removeSubViews() {
        if let subviews = jumbleView?.subviews {
            for view in subviews {
                view.removeFromSuperview()
            }
        }
    }
    
    //******************************************//
    //************* Handle GameOver ************//
    //******************************************//
    
    // check if gameOver: puzzle solved
    private func checkGameOver() {
        if (gameBoard.isSolved()) {
            print("game over: true")
            showMissingPuzzlePiece()

/*let alert = UIAlertController(title: "Great Title", message: "Please input something", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Name Input", style: .default) { (alertAction) in
              let textField = alert.textFields![0] as UITextField
            }
            alert.addTextField { (textField) in
            textField.placeholder = "Enter your name"
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)*/
        }
    }
    
    // solve the puzzle
    private func solvePuzzle() {
        gameBoard.solvePuzzle()
        print("game over: true")
      //  showMissingPuzzlePiece()
        gameBoard.resetPreviousLocation()
    }
    
    // add the missing puzzlePiece
    private func showMissingPuzzlePiece() {
        removePlayerControl()
        
        // get the missing image
        let missingImage = gameBoard.imagePieces.last
        
        // create an imageView for othe image and add to jumbleView
        let frame = gameBoard.squares.last?.square
        let missingImageView = UIImageView(frame: frame!)
        missingImageView.image = missingImage
        missingImageView.alpha = 0.0
        missingImageView.layer.borderWidth = borderWidth // set border width for imageview
        missingImageView.layer.borderColor = borderColor  // set border color for imageview
        jumbleView?.addSubview(missingImageView)
        
        // reveal the missing image
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            missingImageView.alpha = 1.0
        }, completion: { finished in
            
            // setup the puzzle image for reveal
            self.puzzleImageView?.alpha = 0.0
            self.puzzleImageView?.isHidden = false
            self.jumbleView?.bringSubview(toFront: self.puzzleImageView!)
            
            // reval the complete image
            UIView.animate(withDuration: 0.75, delay: 0.0, animations: {
                self.puzzleImageView?.alpha = 1.0
                
            }, completion: { finished in
                self.displayGameOver()  // display gameOver screen
            })
        })
        
    }
    
    //******************************************//
    //*********  Pictures Collection ***********//
    //******************************************//
    
    // set the pictures available for puzzle
    func createPicturesCollection() {
        // set max index based on hardcoded puzzleCount
        let maxIndex = puzzleCount - 1
        
        // create the puzzle images: all images are numerically named for easy processing
        for index in 0...maxIndex {
            let pictureName = "puzzle\(index).png"
            if let image = UIImage(named: pictureName) {
                let squareImage = image.cropToSquare()
                let picture = squareImage.resize(newWidth: screenWidth)
                pictures.append(picture)
            }
        }
        
        // shuffle order
        pictures.shuffle()
    }
    
    // set the delegate & datasource for the picture collection view
    private func setPictureCollectionDelegateAndDataSource() {
        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
    }
    
    // get a random picture
    private func getRandomPicture() -> UIImage {
        // get random Index for pictures array
        let maxIndex = pictures.count - 1
        let randomIndex = Int(arc4random_uniform(UInt32(maxIndex)))
        
        // return corresponding picture
        return pictures[randomIndex]
    }
    
    // show or hide pictures collectionView
    private func togglePictureView() {
        if (picturesView.isHidden == true) {
            showPictures()
        } else {
            hidePictures()
        }
    }
    
    // show pictures collectionView
    private func showPictures() {
        // update button
        pictureButton.isHighlighted = true
        
        // set size and location
        let frame = self.view.frame
        picturesView.frame = frame
        picturesView.layer.borderWidth = borderWidth // set border width
        picturesView.layer.borderColor = borderColor // set border color
        picturesView.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        // add to view
        self.view.addSubview(picturesView)
        picturesView.isHidden = false
    }
    
    // hide pictures collectionView
    func hidePictures() {
//        pictureButton.isHighlighted = false
        picturesView.isHidden = true
    }
    
    //******************************************//
    //**********  Difficulty Settings **********//
    //******************************************//
    
    // add difficulty buttons to array
    private func initializeDifficultyButtonArray() {
        // add buttons to array
        difficultyButtons.append(easyButton)
      //  difficultyButtons.append(mediumButton)
      //  difficultyButtons.append(hardButton)
       // difficultyButtons.append(extremeButton)
        
        // round edges
        for button in difficultyButtons {
            button.layer.cornerRadius = 15
        }
    }
    
    // update which difficulty button is selected
    private func updateDifficultyButtons() {
        switch gameBoard.difficulty {
        case GameBoard.Difficulty.Easy:
            difficultySelected(sender: easyButton)
        case GameBoard.Difficulty.Medium:
            difficultySelected(sender: mediumButton)
        case GameBoard.Difficulty.Hard:
            difficultySelected(sender: hardButton)
        case GameBoard.Difficulty.Extreme:
            difficultySelected(sender: extremeButton)
        default:
            difficultySelected(sender: easyButton)
        }
    }
    
    // select a difficulty button
    private func selectButton(button: UIButton) {
        button.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        button.tintColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        button.titleLabel?.textColor = UIColor.white
        button.isSelected = true
    }
    
    // show or hide difficulty view (difficulty buttons)
    private func toggleDifficultyView() {
      /* if (difficultyView.isHidden == true) {
            difficultyButton.isHighlighted = true
            difficultyView.isHidden = false
            powerUpView.isHidden = true
            jumbleView?.frame.origin.y += difficultyView.frame.height
        } else {
            difficultyButton.isHighlighted = false
            difficultyView.isHidden = true
            powerUpView.isHidden = false
            jumbleView?.frame.origin.y -= difficultyView.frame.height
        }*/
    }
    
    // unselect a button
    private func unselectButton(button: UIButton) {
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        button.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        button.titleLabel?.textColor = UIColor.white
        button.isSelected = false
    }
    
    // update difficulty buttons
    private func difficultySelected(sender:UIButton) {
        for button in difficultyButtons {
            unselectButton(button: button)
        }
        selectButton(button: sender)
    }
    
    // update difficulty setting
    private func updateDifficulty(difficulty: GameBoard.Difficulty) {
        resetPuzzleDifficulty(difficulty: difficulty)
        toggleDifficultyView()
    }
    
    //******************************************//
    //**************  App Settings *************//
    //******************************************//
    
    private func loadSettings() {
        hideSettings()
        initializeSettings()
    }
    

    // setup the user settings
    private func initializeSettings() {
        // print defaults
        printDefaults()
        
        // register buttons
        registerButtons()
        
        // register notifications
        NotificationCenter.default.addObserver(self, selector: #selector(updateDefaults), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    // register switch buttons to handle user settings
    private func registerButtons() {
       /* cameraSwitch.addTarget(self, action: #selector(cameraSwitchIsChanged), for: UIControlEvents.valueChanged)
        librarySwitch.addTarget(self, action: #selector(librarySwitchIsChanged), for: UIControlEvents.valueChanged)*/
    }
    
    // switch is changed -> update user defaults
    @objc private func cameraSwitchIsChanged(switchButton: UISwitch) {
        
        // determine which switch was changed
        let defaultToUpdate: String = "camera_enabled_preference"
        
        // make the update in the user settings
        if switchButton.isOn {
            print("switch button changed to true for \(defaultToUpdate)")
            UserDefaults.standard.set(true, forKey: defaultToUpdate)
        } else {
            print("switch button changed to false for \(defaultToUpdate)")
            UserDefaults.standard.set(false, forKey: defaultToUpdate)
        }
    }
    
    // switch is changed -> update user defaults
    @objc private func librarySwitchIsChanged(switchButton: UISwitch) {
        
        // determine which switch was changed
        let defaultToUpdate: String = "photo_library_enabled_preference"
        
        // make the update in the user settings
        if switchButton.isOn {
            print("switch button changed to true for \(defaultToUpdate)")
            UserDefaults.standard.set(true, forKey: defaultToUpdate)
        } else {
            print("switch button changed to false for \(defaultToUpdate)")
            UserDefaults.standard.set(false, forKey: defaultToUpdate)
        }
    }
    
    
    // update the defaults
    @objc private func updateDefaults() {
        print("updateDefaults called")
        let cameraDefault = UserDefaults.standard.bool(forKey: "camera_enabled_preference")
        let photoLibraryDefault = UserDefaults.standard.bool(forKey: "photo_library_enabled_preference")
        
//        cameraSwitch.setOn(cameraDefault, animated: false)
    //    librarySwitch.setOn(photoLibraryDefault, animated: false)
    }
    
    // check if access to photo library is allowed
    private func isAllowedAccessLibrary() -> Bool {
        return UserDefaults.standard.bool(forKey: "photo_library_enabled_preference")
    }
    
    // check if acess to camera is allowed
    private func isAllowedAcessCamera() -> Bool {
        return UserDefaults.standard.bool(forKey: "camera_enabled_preference")
    }
    
    // print defaults to console
    private func printDefaults() {
        
        let defaults = UserDefaults.standard
        let initialLaunch = defaults.string(forKey: "initial_launch")
        let cameraEnabledPreference = defaults.string(forKey: "camera_enabled_preference")
        let photoLibraryEnabledPreference = defaults.string(forKey: "photo_library_enabled_preference")
        
        print("Initial Launch: \(initialLaunch)")
        print("Camera Access Enabled: \(cameraEnabledPreference)")
        print("Photo Library Access Enabled: \(photoLibraryEnabledPreference)")
    }
    
    // show the settings view
    private func showSettings() {
        // update defaults
        updateDefaults()
        
        // make view visible
        settingsView.isHidden = false
        self.view.bringSubview(toFront: settingsView)
        
        // animate on screen
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            // drop down imageView
            self.settingsView.alpha = 1.0
        }, completion: nil)
    }
    
    // hide the settings view
    private func hideSettings() {
        // animate off screen
      /*  UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            // drop down imageView
         //   self.settingsView.alpha = 0.0
        }, completion: { finished in
            
            // make view not visible
//            self.settingsView.isHidden = true
         //   self.view.sendSubview(toBack: self.settingsView)
            
            })*/
    }
    

    // *********************************************** //
    // ***************** ALERTS ********************** //
    // *********************************************** //
    
    // show warning for changing difficulty settings
    private func showDifficultyWarning(sender: UIButton, difficulty: GameBoard.Difficulty) {
        // set title & message
        let title = "PhotoPuzzle Warning"
        let message = "This will jumble pieces."
        
        // create alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(
            UIAlertAction(title: "Proceed", style: UIAlertActionStyle.default, handler:
                { action in
                    self.difficultySelected(sender: sender) // select button
                    self.updateDifficulty(difficulty: difficulty) // update puzzle
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:
            { action in
                self.toggleDifficultyView()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // handle adding photo (show alert for choice between library and camera)
    // - Attribution: http://stackoverflow.com/questions/6110470/how-to-allow-the-user-to-pick-a-photo-from-his-camera-roll-or-photo-library
    private func showPhotoAlert() {
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Image Source", message: nil, preferredStyle: .alert)
        
        // action to add photo using camera
        alert.addAction(
            UIAlertAction(
                title: "Use Camera",
                style: .default,
                handler: {
                    action in
                    if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                        if (self.isAllowedAcessCamera()) {
                            self.imagePicker.sourceType = .camera
                            self.present(self.imagePicker, animated: true, completion: nil)
                            self.resetTimerandMoves()
                        } else {
                            self.showNeedPermission()
                        }
                    } else {
                        self.noCameraAlert()
                    }
            }
            )
        )
        
        // action to add photo using library
        alert.addAction(
            UIAlertAction(
                title: "Use Photo Library",
                style: .default,
                handler: {
                    action in
                    if (self.isAllowedAccessLibrary()) {
                        self.imagePicker.sourceType = .photoLibrary
                        self.present(self.imagePicker, animated: true, completion: nil)
                        self.resetTimerandMoves()
                        
                    } else {
                        self.showNeedPermission()
                    }
            }
            )
        )
        
        // action to cancel
        alert.addAction(
            UIAlertAction(title: "Cancel",
                style: .cancel,
                handler: nil
            )
        )
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // handle if there is no camera (show alert)
    private func noCameraAlert(){
        // create the alert
        let alertVC = UIAlertController(
            title: "No Camera Available",
            message: "Sorry, this device does not have a camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        
        // show the alert
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    // show an alert for game over
    func displayGameOver() {
        let title = "Sweet"
        let message = "Nice job!"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(
            UIAlertAction(title: "Next Puzzle",
                          style: UIAlertActionStyle.default,
                          handler:
                { action in
                    let puzzleImage = self.getRandomPicture()
                    self.resetPuzzleImage(puzzleImage: puzzleImage)

                }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // show an alert that permission is not allowed
    private func showNeedPermission() {
        let title = "Permission Needed"
        let message = "Please go to Settings and enable access in order to use this feature."
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(
            UIAlertAction(title: "Okay",
                          style: UIAlertActionStyle.default,
                          handler: nil))
        
        alert.addAction(
            UIAlertAction(title: "Settings",
                          style: UIAlertActionStyle.default,
                          handler:
                { action in
                    self.showSettings()
                }))

        self.present(alert, animated: true, completion: nil)
    }
    
}

//******************************************//
//**************  Extensions ***************//
//******************************************//

// Pictures CollectionView
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PictureCell
        
        // format cell
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = borderWidth
        cell.layer.borderColor = borderColor
        
        // assign image
        let image = pictures[(indexPath as IndexPath).row]
        cell.pictureImageView.image = image
        cell.pictureImageView.contentMode = .scaleAspectFill

        return cell
    }
}

// select item from Pictures CollectionView
extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hidePictures()  // hide pictures collection
        let image = pictures[(indexPath as IndexPath).row] // get the image
        resetPuzzleImage(puzzleImage: image) // reset the gameBoard using the new image
    }
}

// Formatting for Pictures CollectionView
extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// ImagePicker to let user choose own image
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // user chose an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // get the image, crop it, and scale it to fill screen width
        let selectedImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let squareImage = selectedImage.cropToSquare()
        let scaledImage = squareImage.resize(newWidth: screenWidth)
        
        // reset the gameBoard & hide pictures collection
        resetPuzzleImage(puzzleImage: scaledImage)
        hidePictures()
        dismiss(animated: true, completion: nil)
    }
    
    // dismiss the image picker on cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
