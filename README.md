This repository contains code and resources related to a research project described in the paper "Urban air-quality estimation using visual cues and a Deep Convolutional Neural Network in Bengaluru (Bangalore), India" [link to the paper]. The code presented here is used to create a database from video data and sensor measurements, train and evaluate a model, and contain network architectures for the task described in the paper.

Overview:
The code in this repository serves the following purposes:

1. Database Creation: The Database_maker.m script is responsible for creating a database from video data and sensor measurements. The provided sensor measurements are in the form of a CSV file, and the resulting database includes visual features extracted from the video frames (RGB), semantic segmentation, optical flow, as well as sensor data such as timestamp, CO2 levels, PM2.5 levels, and other available measurements. Sample data files are provided in the data directory.

2. Model Training and Evaluation: The main.m script is used to train and evaluate a model based on the created database. This script likely implements the methodology described in the paper and serves as the core of the research project.

3. Network Architecture: The net_lgraph.mat file contains a pre-trained network architecture used in the project. This architecture may be referenced in the main.m script for model training.

4. Semantic Segmentation Network: The Semantic_segmentation_Net.m script provides a pre-trained semantic segmentation network, which is presumably used as part of the database creation process.


If you have any questions, feel free to contact me,
Alon Feldman
alonfeldman@campus.technion.ac.il
