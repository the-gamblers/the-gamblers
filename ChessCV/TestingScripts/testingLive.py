import os
import cv2
from matplotlib import pyplot as plt
import numpy as np
import functions

curWD = os.getcwd()
fileLocation = curWD + "/Images/Testing/"
webCam = cv2.VideoCapture(0)
count = 0
testingCount=0
while(True): 
      
    # Capture the video frame 
    # by frame 
    ret, frame = webCam.read() 
  
    # Display the resulting frame 
    cv2.imshow('frame', frame) 


    if count % 120 == 0:
        frame2 = frame.copy()
        gray_img = cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
        gray_blur=cv2.GaussianBlur(gray_img,(5,5),0)
        #contours, _ = cv.findContours(gray_blur, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
        edges = cv2.Canny(gray_blur,10,100)
        # find the contours in the edged image
        contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)  
        for cnt in contours:
            x1,y1 = cnt[0][0]
            approx = cv2.approxPolyDP(cnt, 0.1*cv2.arcLength(cnt, True), True)
            if len(approx) == 4:
                x, y, w, h = cv2.boundingRect(cnt)
                #print("x,y,w,h: "+str(x)+" "+str(y)+" "+str(w)+" "+str(h))
                if (w > 100 and h > 100):
                    frame2 = cv2.drawContours(frame2, [cnt], -1, (0,255,255), 3)
            cv2.imshow('Rectangle', frame2)
        # the 'q' button is set as the 
        # quitting button you may use any 
        # desired button of your choice 
    count+=1
    if cv2.waitKey(1) & 0xFF == ord('q'): 
        cv2.imwrite(fileLocation+"capture"+str(count)+".JPG", frame2)
        testingCount+=1
        if testingCount >= 5:
            break
  
# After the loop release the cap object 
webCam.release() 
# Destroy all the windows 
cv2.destroyAllWindows() 