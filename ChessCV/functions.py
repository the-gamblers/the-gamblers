import cv2 
import os 
import imutils
from sklearn.cluster import KMeans
from collections import Counter


def cropSquares(image, dir):
    imageDir = os.getcwd()
    src_image_path = imageDir +dir
    h, w = image.shape[1], image.shape[0]
    squareWidth = int(w/8)
    squareHeight = int(h/8)
    cnt= 0
    for i in range(8):
        currX = squareWidth * i
        for j in range(8): 
            currY = squareHeight * j
            crop = image[currY:currY+squareHeight, currX: currX+squareWidth]
            currOutput = "chessSquare"+ str(cnt)
            cv2.imwrite(src_image_path+currOutput+".jpg", crop)
            cnt+=1

def cropImageToBoard(image, x, y, w, h):
    crop = image[ y: y+h, x: x+w]
    scaled_crop = cv2.resize(crop, (700,700), interpolation= cv2.INTER_AREA)
    return scaled_crop

def centerCrop(im1):
    w1, h1 = im1.shape[1], im1.shape[0]
    crop_width = h1 if h1<im1.shape[1] else im1.shape[1]
    crop_height = w1 if w1<im1.shape[0] else im1.shape[0]
    mid_x, mid_y = int(w1/2), int(h1/2)
    cw2, ch2 = int(crop_width/3), int(crop_height/3) 
    crop_img = im1[mid_y-ch2:mid_y+ch2, mid_x-cw2:mid_x+cw2]
    return crop_img

# def findDifference(im1, im2):
#     #center crop
#     crop_img = centerCrop(im1)
#     crop_img2 = centerCrop(im2)
    
#     original = imutils.resize(crop_img, height = 600)
#     new = imutils.resize(crop_img2, height = 600)
#     original = cv2.cvtColor(original, cv2.COLOR_BGR2GRAY)
#     new = cv2.cvtColor(new, cv2.COLOR_BGR2GRAY)
#     original = cv2.GaussianBlur(original, (5,5),0)
#     new = cv2.GaussianBlur(new, (5,5),0)
#     diff = original.copy()
#     cv2.absdiff(original, new, diff)
#     cv2.imwrite("changes.png", diff)

#     if cv2.countNonZero(diff) > 345000:
#         print(cv2.countNonZero(diff))
#         return True
#     else:
#         return False

def get_dominant_color(image, k=4, image_processing_size = None):
    """
    takes an image as input
    returns the dominant color of the image as a list
    
    dominant color is found by running k means on the 
    pixels & returning the centroid of the largest cluster

    processing time is sped up by working with a smaller image; 
    this resizing can be done with the image_processing_size param 
    which takes a tuple of image dims as input

    >>> get_dominant_color(my_image, k=4, image_processing_size = (25, 25))
    [56.2423442, 34.0834233, 70.1234123]
    """
    #resize image if new dims provided
    if image_processing_size is not None:
        image = cv2.resize(image, image_processing_size, 
                            interpolation = cv2.INTER_AREA)
    image = centerCrop(image)
    #reshape the image to be a list of pixels
    image = image.reshape((image.shape[0] * image.shape[1], 3))

    #cluster and assign labels to the pixels 
    clt = KMeans(n_clusters = k)
    labels = clt.fit_predict(image)

    #count labels to find most popular
    label_counts = Counter(labels)

    #subset out most popular centroid
    dominant_color = clt.cluster_centers_[label_counts.most_common(1)[0][0]]
    return list(dominant_color)[::-1]


def findDifferenceColors(im1, im2):
    color1 = get_dominant_color(im1,4,(100,100))
    #print(color1)
    color2 = get_dominant_color(im2,4,(100,100))
    #print(color2)
    threshr = 0.2 * ((color1[0]+color2[0])/2)
    threshg = 0.2 * ((color1[1]+color2[1])/2)
    threshb = 0.2 * ((color1[2]+color2[2])/2)
    if (abs(color1[0]-color2[0]) < threshr ) and (abs(color1[1]-color2[1]) < threshb) and (abs(color1[2]-color2[2]) < threshg):
        return False
    else:
        return True
    
def giveMoves(dir1, dir2):
    moveSequence = []
    row = {0 : 'a',1:'b',2:'c',3:'d',4:'e',5:'f',6:'g',7:'h'}
    cnt = 0
    for i in range(8):
        for j in range(8):
            #compare each square from the two directories
            currImage1 = cv2.imread(dir1+"chesssquare"+str(cnt)+".jpg")
            currImage2 = cv2.imread(dir2+"chesssquare"+str(cnt)+".jpg")
            if findDifferenceColors(currImage1, currImage2):
                moveSequence.append(row[j]+str(i+1))
            cnt +=1
    return moveSequence
def liveCaptureBounds():
    array = []
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
                        xA = x
                        yA = y
                        wA = w
                        hA = h
                        frame2 = cv2.drawContours(frame2, [cnt], -1, (0,255,255), 3)
                cv2.imshow('Rectangle', frame2)
            # the 'q' button is set as the 
            # quitting button you may use any 
            # desired button of your choice 
        count+=1
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    # After the loop release the cap object 
    webCam.release() 
    # Destroy all the windows 
    cv2.destroyAllWindows() 
    print(xA)
    print(yA)
    print(wA)
    print(hA)
    return xA, yA, wA, hA