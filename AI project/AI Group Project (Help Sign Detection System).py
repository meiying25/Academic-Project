''''
import os
import cv2

# Collecting Data ===================================================================

DATA_DIR = "C:\\AI project"
if not os.path.exists(DATA_DIR):
    os.makedirs(DATA_DIR)

number_of_classes = 3
dataset_size = 100

frame_width = 640
frame_height = 480


cap = cv2.VideoCapture(0)

cap.set(cv2.CAP_PROP_FRAME_WIDTH, frame_width)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, frame_height)


for j in range(number_of_classes):
    if not os.path.exists(os.path.join(DATA_DIR, str(j))):
        os.makedirs(os.path.join(DATA_DIR, str(j)))

    print('Collecting data for class {}'.format(j))

    done = False

    while True:
        ret, frame = cap.read()
        cv2.putText(frame, 'Ready? Press "q" ! :)', (100, 50), cv2.FONT_HERSHEY_SIMPLEX, 1.3, (0, 255, 0), 3,
                    cv2.LINE_AA)
        cv2.imshow('frame', frame)
        if cv2.waitKey(25) == ord('q'):
            break

    counter = 0
    while counter < dataset_size:
        ret, frame = cap.read()
        cv2.imshow('frame', frame)
        cv2.waitKey(1000)
        cv2.imwrite(os.path.join(DATA_DIR, str(j), '{}.jpg'.format(counter)), frame)

        counter += 1

cap.release()
cv2.destroyAllWindows()


# Create Database =================================================================================

import os
import pickle

import mediapipe as mp
import cv2

mp_hands = mp.solutions.hands
mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles

hands = mp_hands.Hands(static_image_mode=True, min_detection_confidence=0.3)

DATA_DIR = "C:\\AI project"

data = []
labels = []
for dir_ in os.listdir(DATA_DIR):
    for img_path in os.listdir(os.path.join(DATA_DIR, dir_)):
        data_aux = []

        x_ = []
        y_ = []

        img = cv2.imread(os.path.join(DATA_DIR, dir_, img_path))
        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

        results = hands.process(img_rgb)
        if results.multi_hand_landmarks:
            for hand_landmarks in results.multi_hand_landmarks:
                for i in range(len(hand_landmarks.landmark)):
                    x = hand_landmarks.landmark[i].x
                    y = hand_landmarks.landmark[i].y

                    x_.append(x)
                    y_.append(y)

                for i in range(len(hand_landmarks.landmark)):
                    x = hand_landmarks.landmark[i].x
                    y = hand_landmarks.landmark[i].y
                    data_aux.append(x - min(x_))
                    data_aux.append(y - min(y_))

            data.append(data_aux)
            labels.append(dir_)

f = open('AI.pickle', 'wb')
pickle.dump({'data': data, 'labels': labels}, f)
f.close()


# Training =================================================================================================================

import pickle

from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import numpy as np


data_dict = pickle.load(open('./AI.pickle', 'rb'))

data = np.asarray(data_dict['data'])
labels = np.asarray(data_dict['labels'])

x_train, x_test, y_train, y_test = train_test_split(data, labels, test_size=0.2, shuffle=True, stratify=labels)

model = RandomForestClassifier()

model.fit(x_train, y_train)

y_predict = model.predict(x_test)

score = accuracy_score(y_predict, y_test)

print('{}% of samples were classified correctly !'.format(score * 100))

f = open('RFmodel.p', 'wb')
pickle.dump({'model': model}, f)
f.close()

'''
# Inference Classifier =========================================================================================

import tkinter as tk
from tkinter import messagebox
from PIL import ImageTk, Image
import cv2
import pickle
import mediapipe as mp
import numpy as np
import time
import pygame
import os
import threading

# Specify the new width and height
new_width = 800
new_height = 600

# Load the trained model
model_dict = pickle.load(open('./RFmodel.p', 'rb'))
model = model_dict['model']

# Setup MediaPipe hands
mp_hands = mp.solutions.hands
mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
hands = mp_hands.Hands(static_image_mode=True, min_detection_confidence=0.8, min_tracking_confidence=0.8, max_num_hands=2)

# Define labels
labels_dict = {0: 'B', 1: 'A', 2: 'other'}

# Initialize variables
prev_sign = None
help_detected = False
help_timer_start = None
help_display_duration = 3  # Adjust this value to change the duration of displaying the help message (in seconds)
alarm_duration = 5

alarm_sound_file = "C:\\AI ALARM\\ALARM SOUND EFFECT.mp3"

pygame.mixer.init()
alarm_start_time = None  # Global variable for alarm start time

# Initialize video capture object
def initialize_camera():
    return cv2.VideoCapture(0)

def start_detection(camera):
    global prev_sign, help_detected, help_timer_start, alarm_start_time

    while True:
        data_aux = []
        x_ = []
        y_ = []

        ret, frame = camera.read()

        # Resize the frame
        frame = cv2.resize(frame, (new_width, new_height))

        H, W, _ = frame.shape

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        # Process hand landmarks
        results = hands.process(frame_rgb)
        if results.multi_hand_landmarks:
            for hand_landmarks in results.multi_hand_landmarks:
                mp_drawing.draw_landmarks(
                    frame,  # image to draw
                    hand_landmarks,  # model output
                    mp_hands.HAND_CONNECTIONS,  # hand connections
                    mp_drawing_styles.get_default_hand_landmarks_style(),
                    mp_drawing_styles.get_default_hand_connections_style())

            # Extract hand landmarks and features
            for hand_landmarks in results.multi_hand_landmarks:
                for i in range(len(hand_landmarks.landmark)):
                    x = hand_landmarks.landmark[i].x
                    y = hand_landmarks.landmark[i].y

                    x_.append(x)
                    y_.append(y)

            for i in range(len(hand_landmarks.landmark)):
                x = hand_landmarks.landmark[i].x
                y = hand_landmarks.landmark[i].y
                data_aux.append(x - min(x_))
                data_aux.append(y - min(y_))

            # Draw bounding boxes for each detected hand
            for hand_landmarks in results.multi_hand_landmarks:
                hand_landmarks_list = []
                for landmark in hand_landmarks.landmark:
                    hand_landmarks_list.append((int(landmark.x * W), int(landmark.y * H)))

                x1 = min(hand_landmarks_list, key=lambda x: x[0])[0]
                y1 = min(hand_landmarks_list, key=lambda x: x[1])[1]
                x2 = max(hand_landmarks_list, key=lambda x: x[0])[0]
                y2 = max(hand_landmarks_list, key=lambda x: x[1])[1]

            # Predict gesture using the trained model
            prediction = model.predict([np.asarray(data_aux)])

            # Check if the prediction is for A or B
            if int(prediction[0]) in labels_dict:
                detected_sign = labels_dict[int(prediction[0])]
            else:
                detected_sign = labels_dict[2]  # Assign "Other" category for other letters

            # Get the confidence score
            confidence_score = 100*results.multi_handedness[0].classification[0].score

            # Overlay confidence score on the frame
            cv2.putText(frame, f"{confidence_score:.2f}%", (x1, y1 - 35), cv2.FONT_HERSHEY_SIMPLEX, 0.7,
                        (255, 255, 255), 2)

            # Check for "help" sign (B followed by A)
            if prev_sign == 'B' and detected_sign == 'A':
                help_detected = True
                help_timer_start = time.time()
            elif help_timer_start is not None and time.time() - help_timer_start >= help_display_duration:
                help_detected = False
                help_timer_start = None

            # Update previous detected sign
            prev_sign = detected_sign

            # Display the detected sign on the frame
            if help_detected:
                cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 0, 255), 4)
                cv2.putText(frame, "Help sign detected!", (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                if not pygame.mixer.music.get_busy():  # Check if alarm is not already playing
                    pygame.mixer.music.load(alarm_sound_file)
                    pygame.mixer.music.play(-1)
                alarm_start_time = time.time()
            else:
                cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 4)
                cv2.putText(frame, detected_sign, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
                pygame.mixer.music.stop()

            # Check if alarm duration has elapsed and stop the alarm
            if (help_detected and time.time() - alarm_start_time >= alarm_duration) or not help_detected:
                pygame.mixer.music.stop()

        cv2.imshow('frame', frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Release the webcam and close all windows
    camera.release()
    cv2.destroyAllWindows()

def start_detection_thread(btn_num):
    # Start detection in a separate thread
    camera = initialize_camera()
    detection_thread = threading.Thread(target=start_detection, args=(camera,))
    detection_thread.start()

def exit():
    # Exit the GUI application
    os._exit(0)

# GUI Interface ==========================================================================================

# Create GUI window
import tkinter as tk
from PIL import ImageTk, Image
helpDetect = tk.Tk()
helpDetect.title('Help Signal Detection GUI')
helpDetect.configure(bg='#19115D')
helpDetect.geometry('600x760')
helpDetect.resizable(False, False)

# Show GUI background
background_main = ImageTk.PhotoImage(Image.open("C:\\Users\\User\\Downloads\\HELP SIGN GUI.png").resize((600, 760)))
help_label_main = tk.Label(helpDetect, image=background_main)

# ADD DETECTION BUTTONS
btnDetect1 = tk.Button(helpDetect, text="CHEMICAL LABORATORY DETECTION", width=64, height=2, fg='white', bg='#C768D1',
                       command=lambda: start_detection_thread(1))
btnDetect1.place(x=75, y=345)
btnDetect2 = tk.Button(helpDetect, text="STUDENT PANTRY DETECTION", width=64, height=2, fg='white', bg='#C768D1',
                       command=lambda: start_detection_thread(2))
btnDetect2.place(x=75, y=405)

# ADD QUIT BUTTON
btnQuit = tk.Button(helpDetect, text="QUIT", width=20, height=2, fg='white', bg='#C768D1', command=exit)
btnQuit.place(x=225, y=670)
help_label_main.pack(side=tk.TOP)

# Run the main loop
helpDetect.mainloop()














