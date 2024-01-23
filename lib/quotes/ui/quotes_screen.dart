import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/quotes/cubit/quotes_cubit.dart';

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuotesCubit, QuotesState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case QuotesInitial:
            context.read<QuotesCubit>().getQuotesData();
            return const SizedBox();
          case QuotesDataFetchSuccess:
            final successSate = state as QuotesDataFetchSuccess;
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: successSate.quotesDataList.length,
              itemBuilder: (context, index) {
                final data = successSate.quotesDataList[index];
                return Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CachedNetworkImage(
                        imageUrl: data.img,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      padding: const EdgeInsets.all(28),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                data.quote,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    width: 15,
                                    child: Divider(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    data.author,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          default:
            return SizedBox();
        }
      },
    );
  }
}
