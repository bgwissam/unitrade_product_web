import 'package:flutter/material.dart';

class ImageCarousalView extends StatelessWidget {
  const ImageCarousalView(this.images);
  final images;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Carousal'),
      ),
      body: _buildImageCarousal(context),
    );
  }

  Widget _buildImageCarousal(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Image.network(images[index]),
          );
        },
      ),
    );
  }
}
