# Flower Classifier
This application employs machine learning to analyze uploaded images and determine whether they contain images of flowers. The system utilizes advanced algorithms to recognize and classify different types of flowers present in the images.

## App Preview
![Preview](https://github.com/laxitramani/FlowerClassifier/blob/main/assets/images/view.gif)

## Python Code Preview

```python
import tensorflow as tf
import os
```

```python
_url = 'https://storage.googleapis.com/download.tensorflow.org/example_images/flower_photos.tgz'

zip_file = tf.keras.utils.get_file(origin=_url, fname ='flower_photos.tgz',extract=True,cache_subdir="/content")

base_dir = os.path.join(os.path.dirname(zip_file),'flower_photos')
```

```python
IMAGE_SIZE = 224
BATCH_SIZE = 64

datagen = tf.keras.preprocessing.image.ImageDataGenerator(
    rescale = 1./225,
    validation_split = 0.2
)

train_generator = datagen.flow_from_directory(base_dir, target_size=(IMAGE_SIZE,IMAGE_SIZE), batch_size=BATCH_SIZE,subset='training')

val_generator= datagen.flow_from_directory(
    base_dir, target_size=(IMAGE_SIZE,IMAGE_SIZE), batch_size=BATCH_SIZE,subset='training'
)
```

```python
print(train_generator.class_indices)

labels = "\n".join(sorted(train_generator.class_indices.keys()))

with open('label.txt', 'w') as f:
  f.write(labels)
```

```python
IMG_SHAPE = (IMAGE_SIZE, IMAGE_SIZE, 3)

base_model = tf.keras.applications.MobileNetV2(input_shape=IMG_SHAPE, include_top=False, weights= 'imagenet')
```

```python
base_model.trainable = False
```

```python
model = tf.keras.Sequential([
    base_model,
    tf.keras.layers.Conv2D(32,3),
    tf.keras.layers.Dropout(0.2),
    tf.keras.layers.GlobalAveragePooling2D(),
    tf.keras.layers.Dense(5,activation= 'softmax')
])
```

```python
model.compile(optimizer=tf.keras.optimizers.Adam(),loss='categorical_crossentropy', metrics=['accuracy'])
```

```python
epochs = 10

history = model.fit(train_generator, epochs=epochs, validation_data=val_generator)
```

```python
saved_model_dir = ''
tf.saved_model.save(model, saved_model_dir)

converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
tflite_model = converter.convert()

with open('model.tflite', 'wb') as f:
  f.write(tflite_model)
```

```python
from google.colab import files

files.download('model.tflite')
files.download('label.txt')
```
