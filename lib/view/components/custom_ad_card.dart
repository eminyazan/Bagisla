import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/view/colors/app_colors.dart';
import 'package:bagisla/view/components/custom_navigation.dart';
import 'package:bagisla/view/pages/ads/ad_detail_page.dart';
import 'package:flutter/material.dart';


class AdCard extends StatelessWidget {
  final AdModel ad;

  const AdCard({
    Key? key,
    required this.ad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()=>goPage(context, AdDetailPage(ad: ad,)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: ad.payed?AppColors.payedCardColor:AppColors.unPayedCardColor,
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: size.height * 0.17,
                  width: size.width * 0.4,
                  child: Image.network(
                    ad. images!.first,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                '${ad.amount} ₺',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ad.category,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                ad.description??"Açıklama bulunmuyor",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height*0.04,
                  decoration: BoxDecoration(
                      color: AppColors.appBarColor,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(width: 9),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'İlanı Gör',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
