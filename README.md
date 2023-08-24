# Flower Classifier
This application employs machine learning to analyze uploaded images and determine whether they contain images of flowers. The system utilizes advanced algorithms to recognize and classify different types of flowers present in the images.

## App Preview
![Preview](https://github.com/laxitramani/FlowerClassifier/blob/main/assets/images/view.gif)

## Python Code Preview
```
{
  "cells": [
    {
      "cell_type": "code",
      "source": [
        "import tensorflow as tf\n",
        "import os"
      ],
      "metadata": {
        "id": "YFdXN1bHp5U2"
      },
      "execution_count": 6,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "_url = 'https://storage.googleapis.com/download.tensorflow.org/example_images/flower_photos.tgz'\n",
        "\n",
        "zip_file = tf.keras.utils.get_file(origin=_url, fname ='flower_photos.tgz',extract=True,cache_subdir=\"/content\")\n",
        "\n",
        "base_dir = os.path.join(os.path.dirname(zip_file),'flower_photos')"
      ],
      "metadata": {
        "id": "94CEM2MYqhu4"
      },
      "execution_count": 11,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "IMAGE_SIZE = 224\n",
        "BATCH_SIZE = 64\n",
        "\n",
        "datagen = tf.keras.preprocessing.image.ImageDataGenerator(\n",
        "    rescale = 1./225,\n",
        "    validation_split = 0.2\n",
        ")\n",
        "\n",
        "train_generator = datagen.flow_from_directory(base_dir, target_size=(IMAGE_SIZE,IMAGE_SIZE), batch_size=BATCH_SIZE,subset='training')\n",
        "\n",
        "val_generator= datagen.flow_from_directory(\n",
        "    base_dir, target_size=(IMAGE_SIZE,IMAGE_SIZE), batch_size=BATCH_SIZE,subset='training'\n",
        ")"
      ],
      "metadata": {
        "id": "1J9Gd6hcsEPI",
        "outputId": "bdcda090-38d1-4408-9001-4e67417d88fb",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 12,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "Found 2939 images belonging to 5 classes.\n",
            "Found 2939 images belonging to 5 classes.\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "print(train_generator.class_indices)\n",
        "\n",
        "labels = \"\\n\".join(sorted(train_generator.class_indices.keys()))\n",
        "\n",
        "with open('label.txt', 'w') as f:\n",
        "  f.write(labels)"
      ],
      "metadata": {
        "id": "91pTlLqWusDm",
        "outputId": "2005c10c-fb71-4885-a52f-bae02b5784f7",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 14,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "{'daisy': 0, 'dandelion': 1, 'roses': 2, 'sunflowers': 3, 'tulips': 4}\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "IMG_SHAPE = (IMAGE_SIZE, IMAGE_SIZE, 3)\n",
        "\n",
        "base_model = tf.keras.applications.MobileNetV2(input_shape=IMG_SHAPE, include_top=False, weights= 'imagenet')"
      ],
      "metadata": {
        "id": "iTsFmw8IwR-7",
        "outputId": "9b12382b-6f26-489f-ab56-35fe3384b445",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 15,
      "outputs": [
        {
          "metadata": {
            "tags": null
          },
          "name": "stdout",
          "output_type": "stream",
          "text": [
            "Downloading data from https://storage.googleapis.com/tensorflow/keras-applications/mobilenet_v2/mobilenet_v2_weights_tf_dim_ordering_tf_kernels_1.0_224_no_top.h5\n",
            "9406464/9406464 [==============================] - 0s 0us/step\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "base_model.trainable = False"
      ],
      "metadata": {
        "id": "YeCS7LEWxJgZ"
      },
      "execution_count": 16,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "model = tf.keras.Sequential([\n",
        "    base_model,\n",
        "    tf.keras.layers.Conv2D(32,3),\n",
        "    tf.keras.layers.Dropout(0.2),\n",
        "    tf.keras.layers.GlobalAveragePooling2D(),\n",
        "    tf.keras.layers.Dense(5,activation= 'softmax')\n",
        "])"
      ],
      "metadata": {
        "id": "IQPo_LW7xW2F"
      },
      "execution_count": 17,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "model.compile(optimizer=tf.keras.optimizers.Adam(),loss='categorical_crossentropy', metrics=['accuracy'])"
      ],
      "metadata": {
        "id": "EWGaKuoHyh4k"
      },
      "execution_count": 18,
      "outputs": []
    },
    {
      "cell_type": "code",
      "source": [
        "epochs = 10\n",
        "\n",
        "history = model.fit(train_generator, epochs=epochs, validation_data=val_generator)"
      ],
      "metadata": {
        "id": "TnK7Gz3EzFEj",
        "outputId": "3cf2e381-40a8-429c-f047-37f60604b291",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 20,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stdout",
          "text": [
            "Epoch 1/10\n",
            "46/46 [==============================] - 312s 7s/step - loss: 2.5172 - accuracy: 0.7326 - val_loss: 0.4866 - val_accuracy: 0.9071\n",
            "Epoch 2/10\n",
            "46/46 [==============================] - 280s 6s/step - loss: 0.4875 - accuracy: 0.9109 - val_loss: 0.2027 - val_accuracy: 0.9479\n",
            "Epoch 3/10\n",
            "46/46 [==============================] - 295s 6s/step - loss: 0.3438 - accuracy: 0.9323 - val_loss: 0.2133 - val_accuracy: 0.9469\n",
            "Epoch 4/10\n",
            "46/46 [==============================] - 279s 6s/step - loss: 0.2069 - accuracy: 0.9507 - val_loss: 0.1802 - val_accuracy: 0.9503\n",
            "Epoch 5/10\n",
            "46/46 [==============================] - 288s 6s/step - loss: 0.1441 - accuracy: 0.9568 - val_loss: 0.0475 - val_accuracy: 0.9833\n",
            "Epoch 6/10\n",
            "46/46 [==============================] - 269s 6s/step - loss: 0.1512 - accuracy: 0.9537 - val_loss: 0.0755 - val_accuracy: 0.9752\n",
            "Epoch 7/10\n",
            "46/46 [==============================] - 291s 6s/step - loss: 0.0591 - accuracy: 0.9816 - val_loss: 0.0179 - val_accuracy: 0.9942\n",
            "Epoch 8/10\n",
            "46/46 [==============================] - 277s 6s/step - loss: 0.0468 - accuracy: 0.9854 - val_loss: 0.0199 - val_accuracy: 0.9935\n",
            "Epoch 9/10\n",
            "46/46 [==============================] - 280s 6s/step - loss: 0.0366 - accuracy: 0.9881 - val_loss: 0.0410 - val_accuracy: 0.9864\n",
            "Epoch 10/10\n",
            "46/46 [==============================] - 278s 6s/step - loss: 0.1209 - accuracy: 0.9677 - val_loss: 0.0861 - val_accuracy: 0.9707\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "saved_model_dir = ''\n",
        "tf.saved_model.save(model, saved_model_dir)\n",
        "\n",
        "converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)\n",
        "tflite_model = converter.convert()\n",
        "\n",
        "with open('model.tflite', 'wb') as f:\n",
        "  f.write(tflite_model)"
      ],
      "metadata": {
        "id": "0Op96-FIzIbn",
        "outputId": "e731cf06-e499-456f-e229-9d8ff55ca36f",
        "colab": {
          "base_uri": "https://localhost:8080/"
        }
      },
      "execution_count": 25,
      "outputs": [
        {
          "output_type": "stream",
          "name": "stderr",
          "text": [
            "WARNING:absl:Function `_wrapped_model` contains input name(s) mobilenetv2_1.00_224_input with unsupported characters which will be renamed to mobilenetv2_1_00_224_input in the SavedModel.\n",
            "WARNING:absl:Found untraced functions such as _jit_compiled_convolution_op, _update_step_xla, _jit_compiled_convolution_op, _jit_compiled_convolution_op, _jit_compiled_convolution_op while saving (showing 5 of 54). These functions will not be directly callable after loading.\n",
            "WARNING:absl:Function `signature_wrapper` contains input name(s) mobilenetv2_1.00_224_input with unsupported characters which will be renamed to mobilenetv2_1_00_224_input in the SavedModel.\n",
            "WARNING:absl:Found untraced functions such as restored_function_body, restored_function_body, restored_function_body, restored_function_body, restored_function_body while saving (showing 5 of 54). These functions will not be directly callable after loading.\n"
          ]
        }
      ]
    },
    {
      "cell_type": "code",
      "source": [
        "from google.colab import files\n",
        "\n",
        "files.download('model.tflite')\n",
        "files.download('label.txt')"
      ],
      "metadata": {
        "id": "5_fMDr_9HG05",
        "outputId": "84ea0e99-ed2c-4ce9-93c9-4a2468cc930a",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 17
        }
      },
      "execution_count": 26,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "<IPython.core.display.Javascript object>"
            ],
            "application/javascript": [
              "\n",
              "    async function download(id, filename, size) {\n",
              "      if (!google.colab.kernel.accessAllowed) {\n",
              "        return;\n",
              "      }\n",
              "      const div = document.createElement('div');\n",
              "      const label = document.createElement('label');\n",
              "      label.textContent = `Downloading \"${filename}\": `;\n",
              "      div.appendChild(label);\n",
              "      const progress = document.createElement('progress');\n",
              "      progress.max = size;\n",
              "      div.appendChild(progress);\n",
              "      document.body.appendChild(div);\n",
              "\n",
              "      const buffers = [];\n",
              "      let downloaded = 0;\n",
              "\n",
              "      const channel = await google.colab.kernel.comms.open(id);\n",
              "      // Send a message to notify the kernel that we're ready.\n",
              "      channel.send({})\n",
              "\n",
              "      for await (const message of channel.messages) {\n",
              "        // Send a message to notify the kernel that we're ready.\n",
              "        channel.send({})\n",
              "        if (message.buffers) {\n",
              "          for (const buffer of message.buffers) {\n",
              "            buffers.push(buffer);\n",
              "            downloaded += buffer.byteLength;\n",
              "            progress.value = downloaded;\n",
              "          }\n",
              "        }\n",
              "      }\n",
              "      const blob = new Blob(buffers, {type: 'application/binary'});\n",
              "      const a = document.createElement('a');\n",
              "      a.href = window.URL.createObjectURL(blob);\n",
              "      a.download = filename;\n",
              "      div.appendChild(a);\n",
              "      a.click();\n",
              "      div.remove();\n",
              "    }\n",
              "  "
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "<IPython.core.display.Javascript object>"
            ],
            "application/javascript": [
              "download(\"download_da81cae9-fd21-4399-b216-b4468efd8164\", \"model.tflite\", 10341908)"
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "<IPython.core.display.Javascript object>"
            ],
            "application/javascript": [
              "\n",
              "    async function download(id, filename, size) {\n",
              "      if (!google.colab.kernel.accessAllowed) {\n",
              "        return;\n",
              "      }\n",
              "      const div = document.createElement('div');\n",
              "      const label = document.createElement('label');\n",
              "      label.textContent = `Downloading \"${filename}\": `;\n",
              "      div.appendChild(label);\n",
              "      const progress = document.createElement('progress');\n",
              "      progress.max = size;\n",
              "      div.appendChild(progress);\n",
              "      document.body.appendChild(div);\n",
              "\n",
              "      const buffers = [];\n",
              "      let downloaded = 0;\n",
              "\n",
              "      const channel = await google.colab.kernel.comms.open(id);\n",
              "      // Send a message to notify the kernel that we're ready.\n",
              "      channel.send({})\n",
              "\n",
              "      for await (const message of channel.messages) {\n",
              "        // Send a message to notify the kernel that we're ready.\n",
              "        channel.send({})\n",
              "        if (message.buffers) {\n",
              "          for (const buffer of message.buffers) {\n",
              "            buffers.push(buffer);\n",
              "            downloaded += buffer.byteLength;\n",
              "            progress.value = downloaded;\n",
              "          }\n",
              "        }\n",
              "      }\n",
              "      const blob = new Blob(buffers, {type: 'application/binary'});\n",
              "      const a = document.createElement('a');\n",
              "      a.href = window.URL.createObjectURL(blob);\n",
              "      a.download = filename;\n",
              "      div.appendChild(a);\n",
              "      a.click();\n",
              "      div.remove();\n",
              "    }\n",
              "  "
            ]
          },
          "metadata": {}
        },
        {
          "output_type": "display_data",
          "data": {
            "text/plain": [
              "<IPython.core.display.Javascript object>"
            ],
            "application/javascript": [
              "download(\"download_3f27f8d1-fc05-4835-a149-6b619540a0bf\", \"label.txt\", 39)"
            ]
          },
          "metadata": {}
        }
      ]
    }
  ],
  "metadata": {
    "colab": {
      "name": "Welcome To Colaboratory",
      "provenance": []
    },
    "kernelspec": {
      "display_name": "Python 3",
      "name": "python3"
    }
  },
  "nbformat": 4,
  "nbformat_minor": 0
}
```
