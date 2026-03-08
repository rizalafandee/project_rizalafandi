# Proyek Klasifikasi Gambar: Shoe vs Sandal vs Boot Image Dataset

## About Dataset
This Shoe vs Sandal vs Boot Image Dataset contains 15,000 images of shoes, sandals and boots. 5000 images for each category. The images have a resolution of 136x102 pixels in RGB color model.

Amount of Data : 15000
There are three classes here: Shoe, Sandal & Boot
Link Kaggle: https://www.kaggle.com/datasets/hasibalmuzdadid/shoe-vs-sandal-vs-boot-dataset-15k-images

This dataset is ideal for performing multiclass classification with deep neural networks like CNNs. You can use Tensorflow, Keras, Sklearn, PyTorch or other deep/machine learning libraries to build a model from scratch or as an alternative, you can fetch pretrained models as well as fine-tune them.

This dataset is a modified version of a large image dataset provided by M.Stephenson.

## Struktur Direktori
```
submission/
├───tfjs_model
| ├───group1-shard1of4.bin
| ├───group1-shard2of4.bin
| ├───group1-shard3of4.bin
| ├───group1-shard4of4.bin
| └───model.json
├───tflite
| ├───model.tflite
| └───labels.txt
├───saved_model
| ├───saved_model.pb
| └───variables
├───notebook.ipynb
├───README.md
└───requirements.txt
```