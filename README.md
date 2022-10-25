# Evaluation for Towards Controllable Audio Texture Morphing

This repository outlines the objective evaluation code for the paper titled "Towards Controllable Audio Texture Morphing"  

For all metrics below, please see directory [evaluation-metrics](evaluation-metrics)  

Pre-requisites:  
* Download and setup Fréchet Audio Distance repo from - https://github.com/google-research/google-research/tree/master/frechet_audio_distance. Set the FAD_LOC variable as explained in the subsequent sections below.  
* Download and install the requisite dependencies from - https://github.com/chitralekha18/ParamSensitiveMetrics (see directory called gram_matrix_metric)  
* Unzip the folder data.zip at the root of this project  

## Evaluation Metrics used in Section 4.3 (Inter-Class Morphing) in the paper  

### Inter-Class Parameter Sensitivity Metric using FAD  

* Please run the following for MorphGAN -   
```
export FAD_LOC=<Location of Fréchet Audio Distance project>    
bash generate_fad_morphgan.sh
```
* Copy the outputs of the script into the MorphGAN section of the notebook ['fad - Param Sensitivity Metric'](evaluation-metrics/inter-class-fad/fad%20-%20Param%20Sensitivity%20Metric.ipynb) to evaluate Parameter Sensitivity using FAD

Follow the above steps for other algorithms by running -   
* One Hot GAN - ```bash generate_fad_onehot.sh``` 
* Morph2 - ```bash generate_fad_morph2.sh``` 
* Mix - ```bash generate_fad_mix.sh``` 

  
### Inter-Class Parameter Sensitivity Metric using GMLoss  

* Please run the notebook ['gmloss - Param Sensitivity Metric.ipynb'](evaluation-metrics/inter-class-gmloss/gmloss%20-%20Param%20Sensitivity%20Metric.ipynb) in the environment setup for the environment from https://github.com/chitralekha18/ParamSensitiveMetrics (see directory called gram_matrix_metric)  
  

### Perceptual Closeness and Perceptual Centeredness Metrics using FAD
* First generate the VGGish statistics for training data by - 
```
export FAD_LOC=<Location of Fréchet Audio Distance project>    
bash generate_fadstats_trainingdata.sh
```
* Please run the following for MorphGAN -   
```
export FAD_LOC=<Location of Fréchet Audio Distance project>    
bash generate_fad_morphgan_0.5.sh
```
This script generates the distances for wind and water sounds separately. The mean of the distances gives us Perceptual Closeness and the difference gives us Perceptual Centeredness.

Follow the above steps for other algorithms by running -   
* One Hot GAN - ```bash generate_fad_onehot.sh``` 
* Morph2 - ```bash generate_fad_morph2.sh``` 
* Mix - ```bash generate_fad_mix.sh``` 


## Evaluation Metrics used in Section 4.2 (Intra-Class Morphing) in the paper  

### Intra-Class Parameter Sensitivity Metric using FAD  

* Please run the following for MorphGAN -   
```
export FAD_LOC=<Location of Fréchet Audio Distance project>    
bash generate_fad_morphgan.sh
```
* Copy the outputs of the script into the MorphGAN section of the notebook ['fad - Param Sensitivity Metric'](evaluation-metrics/intra-class-fad/fad%20-%20Param%20Sensitivity%20Metric.ipynb) to evaluate Parameter Sensitivity using FAD

Follow the above steps for other algorithms by running -   
* One Hot GAN - ```bash generate_fad_onehot.sh``` 
* Morph2 - ```bash generate_fad_morph2.sh``` 
* Mix - ```bash generate_fad_mix.sh``` 


### Intra-Class Parameter Sensitivity Metric using GMLoss  

* Please run the notebook ['gmloss - Param Sensitivity Metric.ipynb'](evaluation-metrics/intra-class-gmloss/gmloss%20-%20Param%20Sensitivity%20Metric.ipynb) in the environment setup for the environment from https://github.com/chitralekha18/ParamSensitiveMetrics (see directory called gram_matrix_metric)    