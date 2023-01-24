/*
This file defines the image widget used in the app that 
manages both, assets and network images. Import the colors.dart
file to get the colors, sizes.dart file to get the sizes,
border_radius.dart file to get the border radius and
typography.dart to get the text styles.
Example: from flutter docs:
```
Image.asset(
  'assets/images/flutter_logo.png',
  width: 100,
  height: 100,
)
```
*/

// Path: lib/ui/molecules/images/images.dart
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';

class ImageMolecule extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final EdgeInsetsGeometry edgeInsetsGeo;
  final BoxDecoration? containerDecoration;

  const ImageMolecule({
    super.key,
    required this.image,
    this.width = Sizes.massive,
    this.height = Sizes.xxl,
    this.edgeInsetsGeo = EmpyloEdgeInserts.s,
    this.containerDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: containerDecoration,
      margin: edgeInsetsGeo,
      child: Image.asset(
        image,
      ),
    );
  }
}

class ImageMoleculeImp extends StatelessWidget {
  const ImageMoleculeImp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ImageMolecule(
      image: 'assets/images/flutter_logo.png',
    );
  }
}

class BackGroundImageMolecule extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final EdgeInsetsGeometry edgeInsetsGeo;
  final BoxDecoration? containerDecoration;

  const BackGroundImageMolecule({
    super.key,
    required this.image,
    this.width = Sizes.massive,
    this.height = Sizes.xxl,
    this.edgeInsetsGeo = EmpyloEdgeInserts.s,
    this.containerDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: containerDecoration,
      margin: edgeInsetsGeo,
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}

class BackGroundImageMoleculeImp extends StatelessWidget {
  const BackGroundImageMoleculeImp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const BackGroundImageMolecule(
      image: 'assets/images/flutter_logo.png',
    );
  }
}
