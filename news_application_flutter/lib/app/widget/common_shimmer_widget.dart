import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _itemShimmer();
      },
    );
  }

  Widget _itemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Card(
          margin: const EdgeInsets.only(bottom: 12, right: 20, left: 20),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 200,
              height: 40,
              color: Colors.white,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.white,
                ),
              ],
            ),
            subtitle: Container(
              height: 14,
              width: 200,
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
