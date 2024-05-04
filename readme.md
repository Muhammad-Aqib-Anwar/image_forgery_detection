# Image forgery detection by transforming local descriptors into deep-derived features

## Overview
This project is designed for feature extraction from a publicly available dataset and classification using the LIBSVM tool. The code is structured to easily select and extract specific features for further analysis.

## Getting Started

### Prerequisites
Ensure you have MATLAB installed on your system as the provided scripts are in MATLAB format.

### Dataset
This project utilizes three publicly available datasets for training and testing the image forgery detection models:
1. **Korus**: [RGB: 1980x1080x3]. Access it [here](http://kt.agh.edu.pl/korus).
2. **Casia**: [RGB: 384×256X3]. Access it [here](http://forensics.idealtest.org/).
3. **DVMM**: [Grayscale: 128x128]. Access it [here](http://www.ee.columbia.edu/ln/dvmm/downloads/ AuthSplicedDataSet/dlform.html).

Please download and place these datasets in the  folder within the project directory before proceeding with the feature extraction.


### Extracting Features
1. Navigate to the `features` folder.
2. Open the `main.m` file.
3. You will find seven features commented out. Uncomment the feature you wish to extract. The available features are represented as follows:
   - PRNU
   - Camera Fingerprint
   - LBP
   - Saliency Map
   - Energy 
   - DWT
   - YCbCr

  ![Feature Representation](imgs/feature_rep.png)

4. Run the `main.m` file. Extracted features will be saved in the specified directory.

### Extracting Deep-Derived Features
For deep-derived features, we utilize a pre-trained VGG16 model:
1. Navigate to the `features` folder.
2. Open the `extracting_CNN_features.m` file.
3. Ensure you have a trained VGG16 model file in your directory.
4. Run the `extracting_CNN_features.m` script to extract features using the VGG16 model.

### Classification
1. Use the file `Do_compute_binary_classification.m` in the `features` folder for classification.
2. Ensure you configure your paths and parameters as needed before running the classification scripts.

## Citing This Work
If you are using this project in your research or project, please cite it as follows:

```bibtex
@article{anwar2023image,
  title={Image forgery detection by transforming local descriptors into deep-derived features},
  author={Anwar, Muhammad Aqib and Tahir, Syed Fahad and Fahad, Labiba Gillani and Kifayat, Kashif},
  journal={Applied Soft Computing},
  volume={147},
  pages={110730},
  year={2023},
  publisher={Elsevier}
 } 
 ```
## Support
For any issues or questions regarding the use of this project, please open an issue on our GitHub repository or contact us directly via email at [maqibanwar747@gmail.com](mailto:maqibanwar747@gmail.com). We are committed to providing support and will do our best to assist you.

