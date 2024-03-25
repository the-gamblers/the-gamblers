import cv2
import os
import functions

curWD = os.getcwd()

print("Press q whenever there are bounds around the chessboard:")
x, y, w, h = functions.liveCaptureBounds()
webCam = cv2.VideoCapture(0)
cnt = 0
crop1 = ''
crop2 = ''
count = 0
hasBeen = True
print("Press c for a before frame and c for an after frame (Make sure that 'Finish capture' shows up after you press c). Press q to quit.")
while(True): 
      
    # Capture the video frame 
    # by frame 
    ret, frame = webCam.read() 
  
    # Display the resulting frame 
    cv2.imshow('frame', frame)
    cnt+=1
    if cv2.waitKey(1) & 0xFF == ord('q'):
        print("Quitting")
        break
    if cv2.waitKey(1) & 0xFF == ord('c'):
        if x != 0 and y != 0 and w !=0 and h !=0:
            crop = functions.cropImageToBoard(frame, x, y, w, h)
            cv2.imwrite("CroppedBoard.jpg", crop)
        if count % 2 == 0:
            crop1 = crop
            cv2.imwrite("crop"+str(count)+".png", crop1)
            hasBeen = True
        elif count % 2 == 1:
            crop2 = crop
            cv2.imwrite("crop"+str(count)+".png", crop2)
        count +=1
        print("FinishCapture")
    if count % 2 == 0 and count > 0 and hasBeen:
        dir = "/Images/SplitBoardPiecesBefore/"
        dir2 = "/Images/SplitBoardPiecesAfter/"
        functions.cropSquares(crop1, dir)
        functions.cropSquares(crop2, dir2)# After the loop release the cap object
        moveString = functions.giveMoves(curWD+dir, curWD+dir2)
        print(moveString)
        hasBeen = False
        print("FinishedMoves")
webCam.release() 
# Destroy all the windows 
cv2.destroyAllWindows() 