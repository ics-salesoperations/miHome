import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/pages/pages.dart';
import 'package:mihome_app/services/db_service.dart';
import 'package:mihome_app/widgets/widgets.dart';
//import 'package:elegant_notification/elegant_notification.dart';

class FormulariosPage extends StatefulWidget {
  const FormulariosPage({Key? key}) : super(key: key);
  @override
  _FormulariosPageState createState() => _FormulariosPageState();
}

class _FormulariosPageState extends State<FormulariosPage> {
  late FormularioBloc formularioBloc;
  DBService db = DBService();

  @override
  void initState() {
    super.initState();
    formularioBloc = BlocProvider.of<FormularioBloc>(context);
    formularioBloc.cargarFormsGeneral();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomPaint(
      painter: HeaderPicoPainter(),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 15, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: kPrimaryColor,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Formularios",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontFamily: 'CronosSPro',
                    fontSize: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Lottie.asset(
                  'assets/lottie/form_page.json',
                  width: 30,
                  height: 30,
                  animate: true,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BlocBuilder<FormularioBloc, FormularioState>(
                  builder: (context, state) {
                if (!state.isFrmVisitaListo) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 18.0),
                        child: Center(
                          child: Text(
                            "Formularios disponibles",
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontFamily: 'Cronos-Pro',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 20,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ...state.formularios.map(
                              (frm) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return FormularioGeneralPage(
                                          form: frm,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 80,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xffcccaaa),
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        radius: 25,
                                        backgroundColor: kPrimaryColor,
                                        child: Center(
                                          child: Icon(
                                            Icons.edit_note,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            frm.formName
                                                .toString()
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Flexible(
                                            child: Container(
                                              padding: const EdgeInsets.all(1),
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  140,
                                              child: Text(
                                                frm.formDescription
                                                    .toString()
                                                    .toLowerCase(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'CronosLPro',
                                                ),
                                                maxLines: 2,
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    ));
  }
}
