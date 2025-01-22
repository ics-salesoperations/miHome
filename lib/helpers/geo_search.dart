import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';

class GeoSearch extends SearchDelegate<Georreferencia> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          //este query ya viene implicito en el Search Delegate, es lo que la persona esta escribiendo
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        final result = Georreferencia();
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<GeoSearchBloc>(context);
    /*final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnownLocation!;*/

    searchBloc.getGeosByQuery(query);
    return BlocBuilder<GeoSearchBloc, GeoSearchState>(
      builder: (context, state) {
        final geos = state.geo;

        return ListView.separated(
          itemCount: geos.length,
          itemBuilder: (context, i) {
            final georreferencia = geos[i];

            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    georreferencia.codigo.toString(),
                    style: const TextStyle(
                      fontFamily: 'CronosLPro',
                      fontSize: 18,
                      color: kSecondaryColor,
                    ),
                  ),
                  Text(
                    georreferencia.nombre.toString(),
                    style: const TextStyle(
                      fontFamily: 'CronosLPro',
                      fontSize: 14,
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                georreferencia.tipo.toString(),
                style: const TextStyle(
                  fontFamily: 'CronosLPro',
                  fontSize: 14,
                  color: kFourColor,
                ),
              ),
              leading: const Icon(
                Icons.place_outlined,
                color: Color.fromRGBO(0, 25, 79, 1),
              ),
              onTap: () {
                searchBloc.add(
                  AddToHistoryEvent(
                    geo: georreferencia,
                  ),
                );

                close(context, georreferencia);
              },
            );
          },
          separatorBuilder: (context, i) => const Divider(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final history = BlocProvider.of<GeoSearchBloc>(context).state.historyGeo;

    return ListView(
      children: [
        ...history.map((geo) => ListTile(
              title: Column(
                children: [
                  Text(
                    geo.codigo.toString(),
                    style: const TextStyle(
                      fontFamily: 'CronosLPro',
                      fontSize: 18,
                      color: kSecondaryColor,
                    ),
                  ),
                  Text(
                    geo.nombre.toString(),
                    style: const TextStyle(
                      fontFamily: 'CronosLPro',
                      fontSize: 16,
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              ),
              subtitle: Text(geo.tipo.toString()),
              leading: const Icon(
                Icons.history,
                color: Color.fromRGBO(0, 25, 79, 1),
              ),
              onTap: () {
                close(context, geo);
              },
            )),
      ],
    );
  }
}
