This repository contains code and resources related to a research project described in the paper "Urban air-quality estimation using visual cues and a Deep Convolutional Neural Network in Bengaluru (Bangalore), India" [link to the paper]. The code presented here is used to create a database from video data and sensor measurements, train and evaluate a model, and contain network architectures for the task described in the paper.

Overview:
The code in this repository serves the following purposes:

1. Database Creation: The Database_maker.m script is responsible for creating a database from video data and sensor measurements. The provided sensor measurements are in the form of a CSV file, and the resulting database includes visual features extracted from the video frames (RGB), semantic segmentation, optical flow, as well as sensor data such as timestamp, CO2 levels, PM2.5 levels, and other available measurements. Sample data files are provided in the data directory. Note that in our case the video names in the video folder specified the time-stamp in the format of "YYYY_MMDD_hhmmss_.MP4". For example, the video "2020_0206_100203_003.MP4" corresponds to a video that started recording on February 6th 2020 at 10:02:03. Thus, the code matches the timestamp of the video to the correct line in the csv file.

2. Model Training and Evaluation: The main.m script is used to train and evaluate a model based on the created database. This script implements the methodology described in the paper and serves as the core of the research project.

3. Network Architecture: The net_lgraph.mat file contains a pre-trained network architecture used in the project. This architecture may be referenced in the main.m script for model training.

If you have any questions, feel free to contact me,
Alon Feldman
alonfeldman@campus.technion.ac.il
