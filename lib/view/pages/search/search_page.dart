import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/util/human_readable_date.dart';
import 'package:bagisla/view/colors/app_colors.dart';
import 'package:bagisla/view/components/custom_navigation.dart';
import 'package:bagisla/view/pages/ads/ad_detail_page.dart';
import 'package:bagisla/viewmodel/search/search_page_view_model.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<AdModel>? _searchedAds;
  final SearchPageViewModel _searchPageViewModel = SearchPageViewModel();
  final TextEditingController _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _searched = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              5,
            ),
          ),
          child: Center(
            child: TextField(
              autofocus: true,
              onSubmitted: (value) => _search(value),
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                hintText: 'Arama yapın...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _searched == false
                    ? const SizedBox()
                    : _searchedAds != null
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: _searchedAds!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await goPage(
                                          context,
                                          AdDetailPage(
                                            ad: _searchedAds![index],
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.grey,
                                        borderOnForeground: false,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          side: BorderSide(
                                            color: _searchedAds![index].payed
                                                ? AppColors.payedCardColor
                                                : AppColors.unPayedCardColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: SizedBox(
                                          height: size.height * 0.12,
                                          width: size.width * 0.9,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: size.height * 0.12,
                                                width: size.width * 0.22,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                      _searchedAds![index].images!.first,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:size.width*0.68,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              _searchedAds![index].category,
                                                              style: const TextStyle(
                                                                fontSize: 17,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            // SizedBox(width: size.width*0.15,),
                                                            Text(
                                                              humanReadableDate(_searchedAds![index].date!),
                                                              style: const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400,
                                                                color: Colors.black45,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.66,
                                                      child: Text(
                                                        _searchedAds![index].description!,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 3,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : SizedBox(
                            width: size.width,
                            child: const Card(
                              elevation: 10,
                              shadowColor: Colors.grey,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.0),
                                child: Center(
                                  child: Text(
                                    "Malesef aradığınız ilanları bulamadık",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _search(String text) async {
    _searchedAds = await _searchPageViewModel.search(text);
    setState(() {
      _searched = true;
    });
  }
}
