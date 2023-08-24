import 'dart:io';

import 'package:flower_classifier/utils/assets.dart';
import 'package:flower_classifier/utils/colors.dart';
import 'package:flower_classifier/utils/common_codes.dart';
import 'package:flower_classifier/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? output;
  File img = File("");
  bool isLoading = false;
  // Interpreter? _interpreter;

  loadModel() async {
    // InterpreterOptions option = InterpreterOptions();
    // option.addDelegate(XNNPackDelegate());

    // _interpreter = await Interpreter.fromAsset("assets/ml_data/model.tflite",
    //     options: option);

    await Tflite.loadModel(
      model: "assets/ml_data/model.tflite",
      labels: "assets/ml_data/label.txt",
    );
  }

  findImage(File image) async {
    output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.5,
      imageMean: 224,
      imageStd: 224,
    );
  }

  // Future<void> classifyImage(File ig) async {
  //   final imageData = await ig.readAsBytes();
  //   final resizedImage = i.copyResize(
  //       i.decodeImage(Uint8List.fromList(imageData.buffer.asUint8List()))!,
  //       height: 224,
  //       width: 224);

  //   final imageMatrix = List.generate(
  //     resizedImage.height,
  //     (y) => List.generate(
  //       resizedImage.width,
  //       (x) {
  //         final pixel = resizedImage.getPixel(x, y);
  //         return [pixel.r, pixel.g, pixel.b];
  //       },
  //     ),
  //   );

  //   final inputss = [imageMatrix];

  //   final outputss = [List<double>.filled(5, 0)];
  //   // final outputss = List.filled(1 * 5, 0).reshape([1, 5]);
  //   log(outputss.toString());

  //   try {
  //     _interpreter!.run(inputss, outputss);
  //   } catch (e) {
  //     log(e.toString());
  //   }

  //   // log(_interpreter!.getOutputIndex("daisy").toString());
  //   log(_interpreter!.getOutputTensor(0).toString());
  //   log(_interpreter!.getOutputTensors().toString());

  //   log(outputss.toString());

  //   List<double> result = outputss[0];

  //   List labelMapping = ["daisy", "dandelion", "roses", "sunflowers", "tulips"];

  //   int predictedIndex = result.indexOf(result.reduce((a, b) => a > b ? a : b));
  //   predictedLabel = labelMapping[predictedIndex];
  // }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Flower Classifier"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColorDark,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          )),
      body: Center(
        child: Card(
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(65)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                img.path != ""
                    ? Image.file(
                        img,
                        fit: BoxFit.cover,
                        height: getProportionateScreenHeight(200),
                        width: getProportionateScreenWidth(150),
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) =>
                                SizedBox(
                          height: getProportionateScreenHeight(225),
                          width: getProportionateScreenWidth(200),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: child,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () => setState(() {
                                    img = File("");
                                  }),
                                  color: Colors.red,
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Hero(
                        tag: "logo",
                        child: Image.asset(
                          AppAssets.appLogo,
                          height: getProportionateScreenHeight(200),
                          width: getProportionateScreenWidth(200),
                        ),
                      ),
                if (img.path != "") ...<Widget>[
                  sizeBoxHeight(10),
                  isLoading
                      ? SizedBox(
                          height: getProportionateScreenHeight(30),
                          width: getProportionateScreenHeight(30),
                          child: const CircularProgressIndicator(),
                        )
                      : Text(
                          output != null && output!.isNotEmpty
                              ? output![0]["label"].split(" ").last
                              : "We are not sure about this picture!",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                ],
                sizeBoxHeight(50),
                MaterialButton(
                  onPressed: () async {
                    img = await getImage(ImageSource.gallery);
                    setState(() {
                      isLoading = true;
                    });
                    if (img.path != "") await findImage(img);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  color: Theme.of(context).primaryColorDark,
                  minWidth: getProportionateScreenHeight(200),
                  child: const Text("Select Photo"),
                ),
                MaterialButton(
                  onPressed: () async {
                    img = await getImage(ImageSource.camera);
                    setState(() {
                      isLoading = true;
                    });
                    if (img.path != "") await findImage(img);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  color: Theme.of(context).primaryColorDark,
                  minWidth: getProportionateScreenHeight(200),
                  child: const Text("Take Photo"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
