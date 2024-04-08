# Chess Master
This is a Senior Design project for Texas A&M University about a chess CV model

This is meant for a user with general knowledge of downloading from Github and running code, but it is not necessary to have advanced knowledge in any area.
## Installation:
Download a zip of the project from the Github repository 
Open the project in your preferred text editor and a terminal.
Note: the CV model will not run on WSL due to camera access issues, use a native terminal to your operating system.
Inside of the ChessMaster/cv model folder run “pip install requirements.txt” to install all backend dependencies
Open the project in XCode
Update Swift package libraries by going to File > Packages > Reset Package Caches
## Usage:
Set up a camera above an empty chess board. This camera should be able to connect to a laptop
Run the app simulator in XCode
Make an account or login to the application
  ### Track a Game:
Open the “Start Game” screen
Open a terminal and open the “cv model” folder of the project
Run “python3 gui.py”
Hit “Board Calibration” and use the prompts to get an accurate view of the board, ensure that a8 is at (0,0), if needed rotate the image with “r”. Hit “q” upon correct calibration.
Hit “Start Game” and play the game. On the GUI you’ll be able to view plays that the camera is capturing
If the camera does not grab a move cover the camera and reset the board to the last caught move and continue from there.
Ensure that pieces are placed fully in their square
Make direct movements, once you pick up a piece, move it without hesitation.
Speciality moves (en passant, castling, promotions) are coded in, however in a promotion you are only able to promote to a queen
At checkmate the program will automatically close
Back on the app hit end game and put details in about the game and save it
  ### Game Replays:
Navigate to the replay page
Select a game to view
Using the navigation buttons in the middle of the screen you can traverse through the game, seeing the positions of the game on the board above.
Clicking on the thumbs up button will show the best move from the move displayed on the board currently.
Clicking on the replay button (arrow in a circle with a play button in the middle) will reset the game to the beginning
  ### Profile:
On the profile page you can change your profile details and delete your profile.
  ### Progress Page:
Navigate to the progress page and view statistics from all games that are stored within the app as well as the option to play against a bot.
