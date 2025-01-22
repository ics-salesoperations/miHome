import 'package:intl/intl.dart';
import 'package:mihome_app/localdb/local_database.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/models/resumen_answer.dart';

class DBService {
  /*INICIALIZAR BASE DE DATOS */
  Future<void> inicializarBD() async {
    await LocalDatabase.init();
  }

  /*INICIO FUNCIONES PARA USUARIO*/
  Future<List<Usuario>> getUsuario() async {
    await LocalDatabase.init();

    List<Map<String, dynamic>> usuario =
        await LocalDatabase.query(Usuario.table);

    return usuario.map((item) => Usuario.fromMap(item)).toList();
  }

  Future<bool> addUsuario(Usuario model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(Usuario.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> updateUsuario(Usuario model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.update(Usuario.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> deleteUsuario() async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.delete(Usuario.table);

    return resp > 0 ? true : false;
  }

  /* FIN EVENTOS PARA USUARIO*/

  /* INICIO DE EVENTOS PARA GeoReferencia*/
  Future crearGeoDB(List<Georreferencia> geos) async {
    await LocalDatabase.init();
    print("::::::::::antes de eliminar::::::::");
    await LocalDatabase.delete('georreferencia');
    print(":::::eliminado::::::::");
    await LocalDatabase.insertListGeo(geos);
  }

  Future<int> insertardetalleGeo(Georreferencia geo) async {
    final resultado = await LocalDatabase.insert(
      Georreferencia.table,
      geo,
    );

    return resultado;
  }

  Future<List<GeorreferenciaLog>> leerGeoPendienteSync() async {
    final List<Map<String, dynamic>> maps = await LocalDatabase.query(
      GeorreferenciaLog.table,
      find: "enviado = ?",
      findValue: '0',
    );
    return maps.map((json) => GeorreferenciaLog.fromJson(json)).toList();
  }

  Future<int> insertarLogGeo(GeorreferenciaLog geo) async {
    final resultado = await LocalDatabase.insert(
      GeorreferenciaLog.table,
      geo,
    );
    print("INSERTANDO GEO LOG");
    return resultado;
  }

  Future<bool> updateGeoLog(GeorreferenciaLog model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.update(GeorreferenciaLog.table, model);

    return resp > 0 ? true : false;
  }

  Future<List<Georreferencia>> filtrarGeo({required String filtro}) async {
    await LocalDatabase.init();

    String query = "";

    if (filtro.isEmpty) {
      query = """
                    SELECT *
                    FROM georreferencia 
                  """;
    } else {
      String filter = filtro.toUpperCase();
      query = """
                    SELECT *
                    FROM georreferencia
                    WHERE upper(codigo) LIKE  '%$filter%' 
                        OR upper(nombre) LIKE  '%$filter%' 
                  """;
    }

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Georreferencia.fromJson(item)).toList();
  }

  Future<List<Georreferencia>> getGeoByCodigo({required String codigo}) async {
    await LocalDatabase.init();

    String query = "";

    if (codigo.isEmpty) {
      query = """
                    SELECT *
                    FROM georreferencia 
                  """;
    } else {
      query = """
                    SELECT *
                    FROM georreferencia
                    WHERE upper(codigo) =  '$codigo' 
                  """;
    }

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Georreferencia.fromJson(item)).toList();
  }

  Future<List<GeorreferenciaLog>> getGeoLogByCodigo(
      {required String codigo}) async {
    await LocalDatabase.init();

    String query = "";

    if (codigo.isEmpty) {
      query = """
                    SELECT *
                    FROM georreferenciaLog
                  """;
    } else {
      query = """
                    SELECT *
                    FROM georreferenciaLog
                    WHERE upper(codigo) =  '$codigo' 
                  """;
    }

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => GeorreferenciaLog.fromJson(item)).toList();
  }

  Future<List<GeorreferenciaLog>> getGeoLogByNombre({
    required String nombre,
  }) async {
    await LocalDatabase.init();

    String query = """
                    SELECT *
                    FROM georreferenciaLog
                    WHERE nombre =  '$nombre' 
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => GeorreferenciaLog.fromJson(item)).toList();
  }

  Future<bool> guardarLocalizar(Localizar model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(Localizar.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> guardarActivar(Activar model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(Activar.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> guardarConsulta(Consulta model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(Consulta.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> guardarCertificar(Certificar model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(Certificar.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> guardarLiquidar(Liquidar model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(Liquidar.table, model);

    return resp > 0 ? true : false;
  }

  Future<List<Georreferencia>> filtrarGeoTipoParent({
    required String codigoPadre,
  }) async {
    await LocalDatabase.init();

    String query = "";

    query = """
                    SELECT *
                    FROM georreferencia
                    WHERE tipo IN (
                        SELECT tipo
                        FROM georreferencia
                        WHERE upper(codigoPadre) =  '$codigoPadre' 
                    )
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Georreferencia.fromJson(item)).toList();
  }

  Future<List<Georreferencia>> filtrarGeoTipo({
    required String filtro,
  }) async {
    await LocalDatabase.init();

    String query = "";

    String filter = filtro.toUpperCase();
    query = """
                    SELECT *
                    FROM georreferencia
                    WHERE upper(tipo) LIKE  '%$filter%' 
                    ORDER BY latitud DESC
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Georreferencia.fromJson(item)).toList();
  }

  Future<List<Georreferencia>> filtrarGeoParent(
      {required String filtro}) async {
    await LocalDatabase.init();

    String query = "";

    String filter = filtro.toUpperCase();
    query = """
                    SELECT *
                    FROM georreferencia
                    WHERE upper(codigoPadre) =  '$filter' 
                    ORDER BY nombre
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Georreferencia.fromJson(item)).toList();
  }

  Future<bool> updateInformacionGeo(Georreferencia model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.update(Georreferencia.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> crearGeoDep(Georreferencia geo) async {
    await LocalDatabase.init();

    int resp = 0;
    final existe = await validarExiste(geo);

    print("::::EXISTE:::::");
    print(existe.length);

    if (existe.isNotEmpty) {
      print("Actualizando:::::");
      print(existe.first.id);
      print(geo.puerto);
      final nueva = existe.first.copyWith(
        codigoPadre: geo.codigoPadre,
        foto: geo.foto,
        latitud: geo.latitud,
        longitud: geo.longitud,
        puerto: geo.puerto,
        fechaActualizacion: geo.fechaActualizacion,
      );

      print("Puertos antes de actualizar");
      print(nueva.puerto);
      print("ID:" + nueva.id.toString());
      await updateCustomGeo(
        geo: nueva,
      );
      resp = 1;
    } else {
      resp = await insertardetalleGeo(
        geo,
      );
    }

    return resp > 0 ? true : false;
  }

  Future<List<Georreferencia>> validarExiste(Georreferencia geo) async {
    await LocalDatabase.init();

    String query = """
                    SELECT *
                    FROM georreferencia
                    WHERE codigo =  '${geo.codigo}' 
                        AND nombre = '${geo.nombre}' 
                        AND tipo = '${geo.tipo}' 
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Georreferencia.fromJson(item)).toList();
  }

  Future<void> updateCustomGeo({
    required Georreferencia geo,
  }) async {
    await LocalDatabase.init();

    String update = DateTime.now().toIso8601String();

    String query = """
                    UPDATE georreferencia
                    SET codigoPadre = '${geo.codigoPadre}',
                        latitud = ${geo.latitud},
                        longitud = ${geo.longitud},
                        foto = '${geo.foto}',
                        fechaActualizacion = '$update',
                        puerto = ${geo.puerto}
                    WHERE 1=1
                      AND codigo = '${geo.codigo}'
                      AND tipo = '${geo.tipo}'
                    """;

    await LocalDatabase.customQuery(query);
  }

  /* FIN DE EVENTOS PARA GEOREFERENCIA*/

  /* INICIO EVENTOS PARA DETALLE PDV*/
  Future crearDetallePdv(List<Agenda> detpdv) async {
    for (var pdv in detpdv) {
      await insertardetallePDV(pdv);
    }
  }

  Future<int> insertardetallePDV(Agenda detpdv) async {
    await LocalDatabase.init();
    final resultado = await LocalDatabase.insert(Agenda.table, detpdv);

    return resultado;
  }

  Future<List<Agenda>> leerDetallePdv(String cliente) async {
    await LocalDatabase.init();
    List<Map<String, dynamic>> maps = await LocalDatabase.query(
      Agenda.table,
      find: 'cliente = ?',
      findValue: "'$cliente'",
    );
    return maps
        .map(
          (item) => Agenda.fromJson(item),
        )
        .toList();
  }

  Future<List<Agenda>> filtrarDetallePdv(String filtro) async {
    await LocalDatabase.init();

    final query = """
                    SELECT *
                    FROM agenda
                    WHERE nombreCliente LIKE  '%$filtro%' 
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Agenda.fromJson(item)).toList();
  }

  Future<int> actualizarDetallePdv(Agenda detpdv) async {
    await LocalDatabase.init();

    return LocalDatabase.update(Agenda.table, detpdv);
  }

  Future<int> deleteDetallePdv() async {
    await LocalDatabase.init();

    return LocalDatabase.delete(Agenda.table);
  }

  /* FIN EVENTOS PARA DETALLEPDV*/

  /*INICIO DE EVENTOS PARA PLANNING */
  Future crearAgenda(List<Agenda> agenda) async {
    await LocalDatabase.init();
    LocalDatabase.delete('agenda');

    await LocalDatabase.insertListAgenda(agenda);
  }

  Future crearConsultaOt(List<ConsultaOt> consulta) async {
    await LocalDatabase.init();

    await deleteConsultaOt(consulta.first);
    await LocalDatabase.insertLstConsultaOt(consulta);
  }

  Future deleteConsultaOt(ConsultaOt ot) async {
    await LocalDatabase.init();

    String query = """
                    DELETE
                    FROM consultaOt
                    WHERE ot = ${ot.ot}
                  """;

    await LocalDatabase.customQuery(query);
  }

  Future crearAgendaDiaria(List<Agenda> agenda, DateTime fecha) async {
    await LocalDatabase.init();

    String formattedDate = DateFormat('yyyy-MM-dd').format(fecha);

    String query = """
                    DELETE
                    FROM agenda
                    WHERE fecha LIKE '$formattedDate%'
                  """;

    await LocalDatabase.customQuery(query);

    await LocalDatabase.insertListAgenda(agenda);
  }

  Future actualizarAgendaGeo(DateTime fecha) async {
    await LocalDatabase.init();

    String formattedDate = fecha.toIso8601String().substring(0, 10);

    String query = """
                    SELECT DISTINCT
                          b.id,
                          b.fecha,
                          b.ot,
                          b.producto,
                          b.tipo,
                          b.usuario,
                          b.idTecnico,
                          b.nombreTecnico,
                          b.cliente,
                          b.nombreCliente,
                          b.nodo,
                          c.codigo nodoNuevo,
                          b.tap,
                          c.nombre tapNuevo,
                          b.colilla,
                          a.codigo colillaNueva,
                          b.horaEntrada,
                          b.horaSalida,
                          b.zona99,
                          b.seriesBBI,
                          b.seriesTV,
                          b.seriesOtras,
                          b.longitud,
                          b.latitud,
                          b.estadoNodo,
                          b.servicios,
                          b.visitado,
                          b.fechaVisita,
                          b.comentario,
                          b.distrito,
                          b.region,
                          b.estado,
                          b.direccion,
                          b.qr,
                          b.qrNuevo
                    FROM georreferenciaLog a 
                        INNER JOIN agenda b 
                            ON a.nombre = b.cliente
                        LEFT JOIN georreferencia c 
                            ON a.codigoPadre = c.codigo
                    WHERE a.fechaActualizacion LIKE '$formattedDate%'
                      AND a.tipo = 'COLILLA'
                    ORDER BY a.fechaActualizacion ASC
                  """;

    final respuesta = await LocalDatabase.customQuery(query);

    final otsAfectadas = respuesta.map((e) => Agenda.fromJson(e)).toList();

    for (var agenda in otsAfectadas) {
      await LocalDatabase.update(
        Agenda.table,
        agenda.copyWith(
            nodoNuevo: agenda.nodoNuevo.toString().split('-').first),
      );
    }
    //await LocalDatabase.insertListAgenda(agenda);
  }

  Future crearOts(List<OT> ot) async {
    await LocalDatabase.init();
    LocalDatabase.delete('ot');

    await LocalDatabase.insertListOTs(ot);
  }

  Future crearOTSteps(List<OTSteps> steps) async {
    await LocalDatabase.init();
    LocalDatabase.delete('ot_steps');

    await LocalDatabase.insertListSteps(steps);
  }

  Future<List<OTSteps>> leerOTSteps({
    required String ot,
  }) async {
    await LocalDatabase.init();
    String where = "AND ot = " + ot;

    String query = """           SELECT *
                      FROM
                      (
                      SELECT 
                            id,
                            ot,
                            step,
                            subEstado,
                            estado,
                            comentario,
                            gestion,
                            fecha,
                            estadoNuevo
                      FROM ot_steps
                      WHERE 1=1
                            $where
                      UNION
                      SELECT 
                            id,
                            ot,
                            'LOCALIZAR' step,
                            'PENDIENTE DE SINCRONIZAR' subEstado,
                            'PENDIENTE' estado,
                            '' comentario,
                            'Localizacion de Cliente via OT' gestion,
                            fecha,
                            'PENDIENTE' estadoNuevo
                      FROM localizar
                      WHERE 1=1
                            $where
                            AND enviado = 0
                      UNION
                      SELECT 
                            id,
                            ot,
                            'ACTIVAR' step,
                            'PENDIENTE DE SINCRONIZAR' subEstado,
                            'PENDIENTE' estado,
                            '' comentario,
                            cableModem gestion,
                            fecha,
                            'PENDIENTE' estadoNuevo
                      FROM activar
                      WHERE 1=1
                            $where
                            AND enviado = 0
                      UNION
                      SELECT 
                            id,
                            ot,
                            'CERTIFICAR' step,
                            'PENDIENTE DE SINCRONIZAR' subEstado,
                            'PENDIENTE' estado,
                            '' comentario,
                            bitacora gestion,
                            fecha,
                            'PENDIENTE' estadoNuevo
                      FROM certificar
                      WHERE 1=1
                            $where
                            AND enviado = 0
                      UNION
                      SELECT 
                            id,
                            ot,
                            'LIQUIDAR' step,
                            'PENDIENTE DE SINCRONIZAR' subEstado,
                            'PENDIENTE' estado,
                            '' comentario,
                            bitacora gestion,
                            fecha,
                            'PENDIENTE' estadoNuevo
                      FROM liquidar
                      WHERE 1=1
                            $where
                            AND enviado = 0
                      UNION
                      SELECT 
                            id,
                            ot,
                            'CONSULTAS_DESPACHO' step,
                            'PENDIENTE' subEstado,
                            'PENDIENTE' estado,
                            '' comentario,
                            consulta gestion,
                            fecha,
                            'PENDIENTE' estadoNuevo
                      FROM consulta
                      WHERE 1=1
                            $where
                            AND enviado = 0
                      )
                      ORDER BY fecha
        """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => OTSteps.fromJson(item)).toList();
  }

  Future<int> actualizarClienteAgenda(Agenda pdv) async {
    await LocalDatabase.init();

    return await LocalDatabase.update(
      Agenda.table,
      pdv,
    );
  }

  Future<List<Agenda>> leerListadoPdv({
    String? codigoNodo,
    List<NodoResumen>? nodos,
    DateTime? fecha,
  }) async {
    String where = "";
    String fechaFormatted = "";

    if (codigoNodo != null && codigoNodo.isNotEmpty) {
      where = where + " AND nombreNodo = '$codigoNodo'";
    }

    if (nodos != null && nodos.isNotEmpty) {
      final listaCodigos = nodos.map((item) => item.nodo);

      final listaNodos = listaCodigos.join(",");
      where = where + " AND codigoNodo IN ($listaNodos)";
    }

    if (fecha != null) {
      fechaFormatted = DateFormat('dd-MMM-yyyy').format(fecha);
      where = where + " AND fecha = '$fechaFormatted' ";
    }

    final query = """
                    SELECT *
                    FROM 
                    (
                      SELECT a.*, 
                              RANK() OVER(PARTITION BY cliente ORDER BY fecha) R
                      FROM agenda a 
                      WHERE id>=0
                          $where
                    )
                    WHERE R=1
                    ORDER BY cliente, fecha
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) {
      return Agenda.fromJson(json);
    }).toList();
  }

  Future<List<Agenda>> leerAgendaOts({DateTime? fecha}) async {
    await LocalDatabase.init();

    final usuario = await getUsuario();

    String where =
        " AND usuario = '${usuario.first.usuario.toString().toUpperCase()}' ";
    String fechaFormatted = "SIN FORMATO";

    if (fecha != null) {
      fechaFormatted = DateFormat('yyyy-MM-dd').format(fecha);
      where = " AND fecha LIKE '$fechaFormatted%' ";
    }

    String query = """
                      SELECT *
                      FROM agenda
                      WHERE 1=1
                            $where
                      ORDER BY fecha
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Agenda.fromJson(item)).toList();
  }

  Future<List<Agenda>> leerAgendaOt({
    required int ot,
  }) async {
    await LocalDatabase.init();

    String where = " AND ot = $ot ";

    String query = """
                      SELECT *
                      FROM agenda
                      WHERE 1=1
                            $where
                      ORDER BY fecha
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Agenda.fromJson(item)).toList();
  }

  Future<List<OT>> leerOtsAuditoria() async {
    await LocalDatabase.init();
    String where = "";

    String query = """
                      SELECT *
                      FROM ot
                      WHERE 1=1
                            $where
                      ORDER BY ot
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => OT.fromJson(item)).toList();
  }

  Future<List<ConsultaOt>> leerConsultasOt() async {
    await LocalDatabase.init();

    String query = """
                      SELECT *
                      FROM consultaOt
                      WHERE 1=1
                      ORDER BY id DESC
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => ConsultaOt.fromJson(item)).toList();
  }

  Future<List<ConsultaOt>> filtrarConsultasOt({
    required bool cerradas,
    required bool pendientes,
    required bool subs,
  }) async {
    await LocalDatabase.init();

    String where = "";

    if (cerradas && !pendientes & subs) {
      where += ' AND (esFinalizado = 1 OR estaSubscrito = 1)';
    } else if (!cerradas && pendientes & subs) {
      where += ' AND (esFinalizado = 0 OR estaSubscrito = 1)';
    } else if (!cerradas && !pendientes & subs) {
      where += ' AND estaSubscrito = 1';
    } else if (cerradas && !pendientes & !subs) {
      where += ' AND esFinalizado = 1';
    } else if (!cerradas && pendientes & !subs) {
      where += ' AND esFinalizado = 0';
    }

    String query = """
                      SELECT *
                      FROM consultaOt
                      WHERE 1=1
                          $where
                      ORDER BY id DESC
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => ConsultaOt.fromJson(item)).toList();
  }

  Future<void> eliminarOts() async {
    await LocalDatabase.init();

    String query = """
                      DELETE FROM consultaOt
                      WHERE esFinalizado = 1
                  """;

    await LocalDatabase.customQuery(query);
  }

  Future<List<NodoResumen>> leerAgendaSegmentado({DateTime? fecha}) async {
    await LocalDatabase.init();
    String where = "";
    String fechaFormatted = "SIN FORMATO";

    if (fecha != null) {
      fechaFormatted = DateFormat('dd-MMM-yyyy').format(fecha);
      where = " AND fecha = '$fechaFormatted' ";
    }

    String query = """
                    SELECT fecha
                          ,nodo
                          ,'' nombreNodo
                          ,'' tipo
                          ,COUNT(DISTINCT cliente) cantidad
                          ,SUM(
                            CASE WHEN visitado == 'SI' THEN 1
                            ELSE 0
                            END
                          ) visitado
                    FROM agenda
                    WHERE 1=1
                          $where
                    GROUP BY 
                          fecha
                          ,nodo
                          ,''
                          ,''
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => NodoResumen.fromJson(item)).toList();
  }

  Future<List<Sucursal>> leerSucursales() async {
    await LocalDatabase.init();

    const query = """
                    SELECT idSucursal
                          ,nombreSucursal
                    FROM agenda
                    GROUP BY 
                          idSucursal
                          ,nombreSucursal 
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Sucursal.fromJson(item)).toList();
  }

  Future<List<Dealer>> leerDealers() async {
    await LocalDatabase.init();

    const query = """
                    SELECT idDealer
                          ,nombreDealer
                    FROM agenda
                    GROUP BY 
                          idDealer
                          ,nombreDealer
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Dealer.fromJson(item)).toList();
  }

  Future<List<NodoResumen>> leerNodos() async {
    await LocalDatabase.init();

    const query = """
                    SELECT fecha 
                          ,nodo
                          ,COUNT(1) cantidad
                    FROM agenda
                    GROUP BY 
                          nodo
                          ,fecha
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => NodoResumen.fromJson(item)).toList();
  }

  Future<List<Georreferencia>> leerNodosFiltro() async {
    await LocalDatabase.init();

    const query = """
                    SELECT *
                    FROM georreferencia
                    WHERE tipo = 'NODO'
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Georreferencia.fromJson(item)).toList();
  }

  Future<List<Georreferencia>> leerTapsFiltro({
    required String nodo,
  }) async {
    await LocalDatabase.init();

    String query = """
                    SELECT *
                    FROM georreferencia
                    WHERE tipo = 'TAP'
                      AND CODIGO LIKE '$nodo-%'
                    ORDER BY CODIGO
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Georreferencia.fromJson(item)).toList();
  }

  Future<Agenda> leerPDV(String idPDV) async {
    await LocalDatabase.init();

    String query = """
                    SELECT *
                    FROM agenda
                    WHERE cliente = $idPDV 
                  """;

    List<Map<String, dynamic>> maps = await LocalDatabase.customQuery(query);

    return maps.map((item) => Agenda.fromJson(item)).toList()[0];
  }

  /*FIN DE EVENTOS PARA PLANNING */

  /*INICIO DE EVENTOS PARA FORMS */
  Future crearFormularios(List<Formulario> forms) async {
    await LocalDatabase.init();
    LocalDatabase.delete('formulario');
    for (var form in forms) {
      await LocalDatabase.insert('formulario', form);
    }
  }

  Future<List<Formulario>> leerListadoForms() async {
    final List<Map<String, dynamic>> maps =
        await LocalDatabase.query(Formulario.table);
    return maps.map((json) => Formulario.fromMap(json)).toList();
  }

  Future<List<FormularioResumen>> leerResumenForms({
    String? tipo,
    String? formId,
    String? filtrar,
    String? subType,
  }) async {
    await LocalDatabase.init();

    String where = "";

    if (tipo != null && tipo.isNotEmpty) {
      where = " AND type = '$tipo'";
    }

    if (subType != null && subType.isNotEmpty) {
      where = where + " AND subType = '$subType'";
    }

    if (filtrar != null && filtrar.isNotEmpty) {
      where = where + " AND formName = '$filtrar' ";
    }

    if (formId != null && formId.isNotEmpty) {
      where = where + " AND formId = '$formId'";
    }

    final query = """
                    SELECT formId,
                            formName,
                            formDescription,
                            type,
                            subType
                    FROM formulario
                    WHERE 1=1
                        $where
                    GROUP BY formId,
                            formName,
                            formDescription,
                            type,
                            subType
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => FormularioResumen.fromMap(json)).toList();
  }

  Future<List<FormularioResumen>> leerResumenFormsAud() async {
    await LocalDatabase.init();

    const String query = """
                    SELECT formId,
                            formName,
                            formDescription,
                            type,
                            subType
                    FROM formulario
                    WHERE subType = 'GENERAL AUDITORIA'
                      AND type = 'VISITA'
                    GROUP BY formId,
                            formName,
                            formDescription,
                            type,
                            subType
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => FormularioResumen.fromMap(json)).toList();
  }

  Future<bool> guardarRespuestasFormulario(
    List<FormularioAnswer> repuesta,
  ) async {
    try {
      await LocalDatabase.init();
      await LocalDatabase.insertLstRespuestas(repuesta);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<int> actualizarOTPlanning(OT ot) async {
    await LocalDatabase.init();

    String where =
        " AND ot = ${ot.ot} "; //" AND a.instanceId = '$instanceId' ";

    final query = """
                    UPDATE ot 
                      SET gestionado = '${ot.gestionado}'
                    WHERE 1=1
                        $where
                    """;
    int resultado = 0;

    try {
      resultado = await LocalDatabase.customUpdate(query);
    } catch (e) {
      null;
    }
    //return maps.map((json) => FormularioAnswer.fromMap(json)).toList();
    return resultado;
  }

  Future<List<FormularioAnswer>> leerListadoRespuestas() async {
    final List<Map<String, dynamic>> maps = await LocalDatabase.query(
      FormularioAnswer.table,
      find: "enviado = ?",
      findValue: "NO",
    );
    return maps.map((json) => FormularioAnswer.fromMap(json)).toList();
  }

  Future<List<Localizar>> leerListadoLocalizar() async {
    final List<Map<String, dynamic>> maps = await LocalDatabase.query(
      Localizar.table,
      find: "enviado = ?",
      findValue: '0',
    );
    return maps.map((json) => Localizar.fromJson(json)).toList();
  }

  Future<List<Activar>> leerListadoActivar() async {
    final List<Map<String, dynamic>> maps = await LocalDatabase.query(
      Activar.table,
      find: "enviado = ?",
      findValue: '0',
    );
    return maps.map((json) => Activar.fromJson(json)).toList();
  }

  Future<List<Certificar>> leerListadoCertificar() async {
    final List<Map<String, dynamic>> maps = await LocalDatabase.query(
      Certificar.table,
      find: "enviado = ?",
      findValue: '0',
    );
    return maps.map((json) => Certificar.fromJson(json)).toList();
  }

  Future<List<Liquidar>> leerListadoLiquidar() async {
    final List<Map<String, dynamic>> maps = await LocalDatabase.query(
      Liquidar.table,
      find: "enviado = ?",
      findValue: '0',
    );
    return maps.map((json) => Liquidar.fromJson(json)).toList();
  }

  Future<List<Consulta>> leerListadoConsulta() async {
    final List<Map<String, dynamic>> maps = await LocalDatabase.query(
      Consulta.table,
      find: "enviado = ?",
      findValue: '0',
    );
    return maps.map((json) => Consulta.fromJson(json)).toList();
  }

  Future<List<Formulario>> leerFormulario({
    required String idForm,
  }) async {
    await LocalDatabase.init();

    String where = "";

    if (idForm.isNotEmpty) {
      where = " AND formId = '$idForm'";
    }

    final query = """
                    SELECT *
                    FROM formulario
                    WHERE 1=1
                        $where
                    ORDER BY questionOrder
                    """;

    print(query);

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);
    print(maps);
    return maps.map((json) => Formulario.fromMap(json)).toList();
  }

  Future<List<Formulario>> leerFormularioGeo({
    required String tipo,
  }) async {
    await LocalDatabase.init();

    String where = "";

    if (tipo.isNotEmpty) {
      where = " AND subType = '$tipo' ";
    }

    final query = """
                    SELECT *
                    FROM formulario
                    WHERE 1=1
                        AND type = 'MODIFICACION'
                        $where
                    ORDER BY questionOrder
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => Formulario.fromMap(json)).toList();
  }

  Future<List<Formulario>> leerFormularioAuditoria({
    required String tipo,
  }) async {
    await LocalDatabase.init();

    String where = "";

    if (tipo.isNotEmpty) {
      where = " AND subType = '$tipo' ";
    }

    final query = """
                    SELECT *
                    FROM formulario
                    WHERE 1=1
                        AND type = 'VISITA'
                        $where
                    ORDER BY questionOrder
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => Formulario.fromMap(json)).toList();
  }

  Future<List<ResumenAnswer>> leerRespuestasResumen(
      DateTime start, DateTime end) async {
    await LocalDatabase.init();

    String inicio = DateFormat('yyyyMMdd').format(start);
    String fin = DateFormat('yyyyMMdd').format(end);

    String where =
        " AND SUBSTR(a.fechaCreacion,0,9) BETWEEN '$inicio' AND '$fin' ";

    final query = """
                    SELECT a.instanceId,
                           a.formId,
                           a.fechaCreacion,
                           a.enviado,
                           b.formName,
                           b.formDescription
                    FROM formulario_answer a 
                        INNER JOIN formulario B 
                          ON a.formId = b.formId
                    WHERE 1=1
                        $where
                    GROUP BY 
                          a.instanceId,
                           a.formId,
                           a.fechaCreacion,
                           a.enviado,
                           b.formName,
                           b.formDescription
                    ORDER BY 
                           a.fechaCreacion DESC
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.isEmpty
        ? const []
        : maps.map((json) => ResumenAnswer.fromMap(json)).toList();
  }

  Future<List<DetalleAnswer>> leerRespuestasDetalle(
      {required String instanceId}) async {
    await LocalDatabase.init();

    String where = " AND a.instanceId = '$instanceId' ";

    final query = """
                    SELECT a.instanceId,
                           a.formId,
                           a.respondentId,
                           a.questionId,
                           a.formId,
                           a.response,
                           a.fechaCreacion,
                           a.enviado,
                           b.formName,
                           b.formDescription,
                           b.questionOrder,
                           b.questionType,
                           b.questionText
                    FROM formulario_answer a 
                        INNER JOIN formulario B 
                          ON a.formId = b.formId
                            AND a.questionId = b.questionId
                    WHERE 1=1
                        $where
                    ORDER BY 
                           b.questionOrder
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => DetalleAnswer.fromMap(json)).toList();
  }

  Future guardarRespuestaFormulario(List<FormularioAnswer> repuesta) async {
    await LocalDatabase.init();
    for (var resp in repuesta) {
      await LocalDatabase.insert('formulario_answer', resp);
    }
  }

  Future guardarVisita(Visita visita) async {
    await LocalDatabase.init();
    await LocalDatabase.insert('visita', visita);
  }

  Future<List<FormularioAnswer>> leerRespuestaFormulario({
    String? instanceId,
  }) async {
    await LocalDatabase.init();

    String where = "";
    if (instanceId != null && instanceId.isNotEmpty) {
      where = "AND a.instanceId = '$instanceId' ";
    }

    final query = """
                    SELECT a.*
                    FROM formulario_answer a 
                    WHERE 1=1
                        AND response IS NOT NULL
                        AND response != 'null'
                        AND response != ''
                        AND enviado = 'NO'
                        $where
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);
    //return maps.map((json) => FormularioAnswer.fromMap(json)).toList();
    return maps.map((json) {
      return FormularioAnswer.fromMap(json);
    }).toList();
  }

  Future<bool> deleteRespuestaForm(FormularioAnswer model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.deleteForm(FormularioAnswer.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> deleteRespuestasSincronizadas() async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.deleteRespSync(
      FormularioAnswer.table,
    );

    return resp > 0 ? true : false;
  }

  Future<bool> deleteGeoSincronizadas() async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.deleteGeoSync(
      GeorreferenciaLog.table,
    );

    return resp > 0 ? true : false;
  }

  Future<bool> updateInformacionForm(FormularioAnswer model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.update(FormularioAnswer.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> updateEnviados(List<FormularioAnswer> models) async {
    await LocalDatabase.init();

    int resp = 0;
    for (var model in models) {
      resp = await LocalDatabase.update(
        FormularioAnswer.table,
        model.copyWith(enviado: 'SI'),
      );
    }

    return resp > 0 ? true : false;
  }

  /*FIN DE EVENTOS PARA FORMS*/

  /*INICIO DE EVENTOS PARA ACTUALIZACION DE TABLAS*/
  Future<List<Tabla>> leerListadoTablas() async {
    final List<Map<String, dynamic>> maps =
        await LocalDatabase.query(Tabla.table);
    return maps.map((json) => Tabla.fromMap(json)).toList();
  }

  Future<void> updateTabla({
    required String tbl,
  }) async {
    await LocalDatabase.init();

    String where = "";

    if (tbl.isNotEmpty) {
      where = " AND tabla = '$tbl'";
    }

    String update = DateTime.now().toIso8601String();

    String query = """
                    UPDATE tablas
                    SET fechaActualizacion = '$update'
                    WHERE 1=1
                      $where
                    """;

    final maps = await LocalDatabase.customQuery(query);
  }

  Future<void> updateStep({
    required String ot,
    required String tabla,
  }) async {
    await LocalDatabase.init();

    String where = " AND ot = $ot ";

    String query = """
                    UPDATE $tabla
                    SET enviado = 1
                    WHERE 1=1
                      $where
                    """;

    final maps = await LocalDatabase.customQuery(query);
  }

  Future<List<Localizar>> getStepLocalizar({
    required String ot,
  }) async {
    await LocalDatabase.init();

    String where = " AND ot = $ot ";

    String query = """
                    SELECT *
                    FROM localizar
                    WHERE 1=1
                      $where
                    """;

    final maps = await LocalDatabase.customQuery(query);

    return maps.map((json) => Localizar.fromJson(json)).toList();
  }

  Future<List<Activar>> getStepActivar({
    required String ot,
  }) async {
    await LocalDatabase.init();

    String where = " AND ot = $ot ";

    String query = """
                    SELECT *
                    FROM activar
                    WHERE 1=1
                      $where
                    """;

    final maps = await LocalDatabase.customQuery(query);

    return maps.map((json) => Activar.fromJson(json)).toList();
  }

  Future<List<Certificar>> getStepCertificar({
    required String ot,
  }) async {
    await LocalDatabase.init();

    String where = " AND ot = $ot ";

    String query = """
                    SELECT *
                    FROM certificar
                    WHERE 1=1
                      $where
                    """;

    final maps = await LocalDatabase.customQuery(query);

    return maps.map((json) => Certificar.fromJson(json)).toList();
  }

  Future<List<Liquidar>> getStepLiquidar({
    required String ot,
  }) async {
    await LocalDatabase.init();

    String where = " AND ot = $ot ";

    String query = """
                    SELECT *
                    FROM liquidar
                    WHERE 1=1
                      $where
                    """;

    final maps = await LocalDatabase.customQuery(query);

    return maps.map((json) => Liquidar.fromJson(json)).toList();
  }

  /*FIN DE EVENTOS PARA FORMS*/

  /*INICIO DE EVENTOS PARA TRACKING DE USUARIO */
  Future<bool> addTrackingHead(TrackingHead model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(TrackingHead.table, model);

    return resp > 0 ? true : false;
  }

  Future<int> actualizarTrackingHead(TrackingHead head) async {
    await LocalDatabase.init();

    return LocalDatabase.update(TrackingHead.table, head);
  }

  Future<bool> addTrackingDet(TrackingDet model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(TrackingDet.table, model);

    return resp > 0 ? true : false;
  }

  Future<List<Tracking>> leerTracking({
    required DateTime start,
    required DateTime end,
    required String idTracking,
  }) async {
    await LocalDatabase.init();

    String where =
        " AND b.fecha BETWEEN '${start.toIso8601String()}' AND '${end.toIso8601String()}' AND a.idTracking = '$idTracking' ";

    final query = """
                    SELECT a.idTracking,
                           a.usuario,
                           b.fecha,
                           b.latitude latitud,
                           b.longitude longitud,
                           a.fechaInicio,
                           a.fechaFin
                    FROM tracking_head a
                        INNER JOIN tracking_det b 
                          on a.idTracking = b.idTracking 
                    WHERE 1=1
                        $where
                    ORDER BY b.fecha
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => Tracking.fromJson(json)).toList();
  }

  Future<List<String>> leerTrackingResumen({
    required DateTime start,
    required DateTime end,
  }) async {
    await LocalDatabase.init();

    String where =
        " AND fecha BETWEEN '${start.toIso8601String()}' AND '${end.toIso8601String()}' ";

    final query = """
                    SELECT a.idTracking
                    FROM tracking_head a
                        INNER JOIN tracking_det b 
                          on a.idTracking = b.idTracking 
                    WHERE 1=1
                        $where
                    GROUP BY a.idTracking
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => json["idTracking"].toString()).toList();
  }

  Future<TrackingHead> getCurrentTrackingHed() async {
    await LocalDatabase.init();

    String where = " AND fechaFin is NULL ";

    final query = """
                    SELECT *
                    FROM tracking_head 
                    WHERE 1=1
                        $where
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => TrackingHead.fromJson(json)).toList().first;
  }

  Future<bool> updateTrackingHead(TrackingHead model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.update(TrackingHead.table, model);

    return resp > 0 ? true : false;
  }

  /*INICIO DE FUNCIONES PARA MODELOS*/
  Future guardarModelos(List<ModeloTangible> modelos) async {
    await LocalDatabase.init();
    LocalDatabase.delete('modelo');

    for (var modelo in modelos) {
      await LocalDatabase.insert('modelo', modelo);
    }
  }

  Future actualizarModelos(List<ModeloTangible> modelos) async {
    await LocalDatabase.init();

    for (var modelo in modelos) {
      await LocalDatabase.updateModelo('modelo', modelo);
    }
  }

  Future<List<ModeloTangible>> leerListadoModelos() async {
    await LocalDatabase.init();

    String where =
        " AND confirmado = 0 AND enviado = 0"; //" AND a.instanceId = '$instanceId' ";

    final query = """
                    SELECT a.id, 
                            a.tangible,
                            a.modelo,
                            a.descripcion,
                            a.imagen, 
                            SUM(b.asignado) asignado, 
                            COUNT(*) disponible,
                            MIN(b.serie) serieInicial,
                            MAX(b.serie) serieFinal
                    FROM modelo a 
                        INNER JOIN tangible b 
                          ON a.tangible = b.tangible
                            AND a.modelo = b.modelo
                    WHERE 1=1
                        $where
                    GROUP BY a.id, 
                            a.tangible,
                            a.modelo,
                            a.descripcion,
                            a.imagen, 
                            a.asignado, 
                            a.disponible
                    ORDER BY disponible DESC
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);
    //return maps.map((json) => FormularioAnswer.fromMap(json)).toList();
    return maps.map((json) {
      return ModeloTangible.fromMap(json);
    }).toList();
  }

  Future<int> confirmarTangiblesAsignados({
    required int cliente,
  }) async {
    await LocalDatabase.init();

    String where =
        " AND cliente = $cliente AND confirmado = 0 AND enviado = 0 AND asignado = 1"; //" AND a.instanceId = '$instanceId' ";

    final query = """
                    UPDATE tangible 
                      SET confirmado = 1
                    WHERE 1=1
                        $where
                    """;
    int resultado = 0;

    try {
      resultado = await LocalDatabase.customUpdate(query);
    } catch (e) {}
    //return maps.map((json) => FormularioAnswer.fromMap(json)).toList();
    return resultado;
  }

  Future<List<ModeloTangible>> leerListadoModelosAsignados() async {
    await LocalDatabase.init();

    String where = ""; //" AND a.instanceId = '$instanceId' ";

    final query = """
                    SELECT  
                            a.tangible, 
                            SUM(b.asignado) asignado, 
                            COUNT(*) disponible,
                            MIN(b.serie) serieInicial,
                            MAX(b.serie) serieFinal
                    FROM modelo a 
                        INNER JOIN tangible b 
                          ON a.tangible = b.tangible
                            AND a.modelo = b.modelo
                            AND b.asignado = 1
                            AND b.enviado = 0
                            AND b.confirmado = 0
                    WHERE 1=1
                        $where
                    GROUP BY  
                            a.tangible
                    ORDER BY SUM(b.asignado) DESC
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);
    //return maps.map((json) => FormularioAnswer.fromMap(json)).toList();
    return maps.map((json) {
      return ModeloTangible.fromMap(json);
    }).toList();
  }

  Future<int> leerTotalModelos() async {
    await LocalDatabase.init();

    String where = ""; //" AND a.instanceId = '$instanceId' ";

    final query = """
                    SELECT
                            SUM(b.asignado) asignado
                    FROM modelo a 
                        INNER JOIN tangible b 
                          ON a.tangible = b.tangible
                            AND a.modelo = b.modelo
                            AND b.enviado = 0
                            AND b.confirmado = 0
                    WHERE 1=1
                        $where
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);
    //return maps.map((json) => FormularioAnswer.fromMap(json)).toList();
    return maps[0]["asignado"] as int;
  }

  /*FIN DE FUNCIONES PARA MODELOS*/

  /*INICIO DE FUNCIONES PARA TANGIBLES */
  Future guardarTangibles(List<ProductoTangible> tangibles) async {
    await LocalDatabase.init();
    LocalDatabase.delete('tangible');

    for (var tangible in tangibles) {
      await LocalDatabase.insert('tangible', tangible);
    }
  }

  Future<int> updateTangible(ProductoTangible tangible) async {
    await LocalDatabase.init();

    return LocalDatabase.update(ProductoTangible.table, tangible);
  }

  Future<int> updateModeloTangible(ModeloTangible modelo) async {
    await LocalDatabase.init();

    return LocalDatabase.update(ModeloTangible.table, modelo);
  }

  Future<List<ProductoTangible>> getTangible({
    String? serie,
    String? modelo,
    String? tangible,
    bool asignar = false,
  }) async {
    await LocalDatabase.init();

    String where = "";
    String order = " ORDER BY fechaAsignacion DESC, serie";
    if (serie != null && serie.isNotEmpty) {
      where += " AND serie = '$serie'";
    }

    if (tangible != null && tangible.isNotEmpty) {
      where += " AND tangible = '$tangible'";
    }

    if (modelo != null && modelo.isNotEmpty) {
      where += " AND modelo = '$modelo'";
    }

    if (asignar) {
      //where += " AND asignado = 0";
    } else {
      where += " AND asignado = 1 AND confirmado = 0 AND enviado = 0 ";
      order = " ORDER BY fechaAsignacion ASC, serie DESC";
    }

    final query = """
                    SELECT *
                    FROM tangible 
                    WHERE 1=1
                        $where
                    $order
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => ProductoTangible.fromMap(json)).toList();
  }

  Future<List<ProductoTangible>> getTangibleConfirmado() async {
    await LocalDatabase.init();

    String where = " AND confirmado = 1 AND enviado = 0 ";
    String order = " ORDER BY fechaVenta ";

    final query = """
                    SELECT *
                    FROM tangible 
                    WHERE 1=1
                        $where
                    $order
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);
    print("LISTA DE TANGIBLE CONFIRMADO:");
    print(maps);

    return maps.map((json) => ProductoTangible.fromMap(json)).toList();
  }

  Future<List<ProductoTangible>> getTangibleModelo({
    required ModeloTangible modelo,
  }) async {
    await LocalDatabase.init();

    String where = """ AND tangible = '${modelo.tangible}' 
                       AND modelo = '${modelo.modelo}'
                       AND enviado = 0
                    """;
    String order = " ORDER BY fechaAsignacion DESC, serie";

    final query = """
                    SELECT *
                    FROM tangible 
                    WHERE 1=1
                        $where
                    $order
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => ProductoTangible.fromMap(json)).toList();
  }

  Future<List<ProductoTangible>> getAllTangible() async {
    await LocalDatabase.init();

    String where = """ 
                      AND asignado = 1
                    """;
    String order = " ORDER BY fechaAsignacion DESC, serie";

    final query = """
                    SELECT *
                    FROM tangible 
                    WHERE 1=1
                        $where
                    $order
                    """;

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) => ProductoTangible.fromMap(json)).toList();
  }

  /*FIN DE FUNCIONES PARA TANGIBLES*/

  /*FUNCIONES PARA SINCONRIZAR */

  Future<List<ResumenSincronizar>> getSincronizarResumen(
    DateTime start,
    DateTime end,
  ) async {
    await LocalDatabase.init();

    String inicio = DateFormat('yyyyMMdd').format(start);
    String fin = DateFormat('yyyyMMdd').format(end);

    String inicio2 = DateFormat('yyyy-MM-dd').format(start);
    String fin2 = DateFormat('yyyy-MM-dd').format(end);

    String where =
        " AND SUBSTR(a.fechaInicioVisita,0,9) BETWEEN '$inicio' AND '$fin' ";

    String where2 =
        """ AND SUBSTR(a.fechaCreacion,0,9) BETWEEN '$inicio' AND '$fin' 
          AND b.formName IN ('ACTUALIZACION DE NODO','ACTUALIZACION DE AMPLIFICADOR','ACTUALIZACION DE TAP','ACTUALIZACION DE COLILLA')
              
        """;

    String where3 = """
                      AND SUBSTR(a.fechaActualizacion,0,11) BETWEEN '$inicio2' AND '$fin2' 
                    """;

    String where4 =
        """ AND SUBSTR(a.fechaCreacion,0,9) BETWEEN '$inicio' AND '$fin' 
            AND b.subType = 'AUDITORIA HOME'
        """;

    String where5 =
        """ AND SUBSTR(a.fechaCreacion,0,9) BETWEEN '$inicio' AND '$fin' 
            AND b.subType NOT IN ('AUDITORIA HOME')  
        """;

    //AND b.subType LIKE '%AUDITORIA%'

    String order = " ORDER BY fecha DESC";

    final query = """
                    SELECT *
                    FROM (
                      SELECT 
                            a.fechaActualizacion fecha,
                            'COORDENADAS '||tipo tipo,
                            a.enviado*100 porcentajeSync,
                            a.codigo,
                            a.codigo idVisita,
                            'GEORREFERENCIACION' categoria
                      FROM georreferenciaLog a 
                      WHERE 1=1
                        $where3
                      UNION ALL
                      SELECT 
                          fecha,
                          tipo,
                          (enviado/total)*100 porcentajeSync,
                          cliente codigo,
                          idVisita,
                          'GEORREFERENCIACION' categoria
                      FROM (
                          SELECT 
                            a.fechaCreacion fecha,
                            b.formName tipo,
                            COUNT(1) TOTAL,
                            SUM(
                              CASE 
                                WHEN a.enviado == 'SI' THEN 1
                                ELSE 0
                              END
                            ) enviado,
                            MAX(
                            CASE 
                                WHEN b.shortText = 'codigo' THEN a.response
                            END
                            ) cliente,
                            a.instanceId idVisita
                        FROM formulario_answer a
                          INNER JOIN formulario b 
                            ON a.questionId = b.questionId
                        WHERE 1=1
                            $where2
                        GROUP BY a.fechaCreacion,
                                  b.formName,
                                  A.instanceId
                      )

                      UNION ALL
                      SELECT 
                          fecha,
                          tipo,
                          (enviado/total)*100 porcentajeSync,
                          cliente codigo,
                          idVisita,
                          'AUDITORIA' categoria
                      FROM (
                          SELECT 
                            a.fechaCreacion fecha,
                            b.formName tipo,
                            COUNT(1) TOTAL,
                            SUM(
                              CASE 
                                WHEN a.enviado == 'SI' THEN 1
                                ELSE 0
                              END
                            ) enviado,
                            MAX(
                            CASE 
                                WHEN b.shortText = 'codigo' THEN a.response
                            END
                            ) cliente,
                            a.instanceId idVisita
                        FROM formulario_answer a
                          INNER JOIN formulario b 
                            ON a.questionId = b.questionId
                        WHERE 1=1
                            $where4
                        GROUP BY a.fechaCreacion,
                                  b.formName,
                                  A.instanceId
                      )
                      UNION ALL
                      SELECT 
                          fecha,
                          tipo,
                          (enviado/total)*100 porcentajeSync,
                          cliente codigo,
                          idVisita,
                          'AUDITORIA' categoria
                      FROM (
                          SELECT 
                            a.fechaCreacion fecha,
                            b.formName tipo,
                            COUNT(1) TOTAL,
                            SUM(
                              CASE 
                                WHEN a.enviado == 'SI' THEN 1
                                ELSE 0
                              END
                            ) enviado,
                            MAX(
                            CASE 
                                WHEN b.shortText = 'ot' THEN a.response
                            END
                            ) cliente,
                            a.instanceId idVisita
                        FROM formulario_answer a
                          INNER JOIN formulario b 
                            ON a.questionId = b.questionId
                        WHERE 1=1
                            $where5
                        GROUP BY a.fechaCreacion,
                                  b.formName,
                                  A.instanceId
                      )
                      UNION ALL
                      SELECT 
                            fecha,
                            'LOCALIZAR' tipo,
                            enviado*100 porcentajeSync,
                            ot||'' codigo,
                            ot||'' idVisita,
                            'GESTION DESPACHO' categoria
                      FROM localizar  
                      UNION ALL
                      SELECT 
                            fecha,
                            'ACTIVAR' tipo,
                            enviado*100 porcentajeSync,
                            ot||'' codigo,
                            ot||'' idVisita,
                            'GESTION DESPACHO' categoria
                      FROM activar 
                      UNION ALL
                      SELECT 
                            fecha,
                            'CERTIFICAR' tipo,
                            enviado*100 porcentajeSync,
                            ot||'' codigo,
                            ot||'' idVisita,
                            'GESTION DESPACHO' categoria
                      FROM certificar   
                      UNION ALL
                      SELECT 
                            fecha,
                            'LIQUIDAR' tipo,
                            enviado*100 porcentajeSync,
                            ot||'' codigo,
                            ot||'' idVisita,
                            'GESTION DESPACHO' categoria
                      FROM liquidar  
                      UNION ALL
                      SELECT 
                            fecha,
                            'CONSULTA' tipo,
                            enviado*100 porcentajeSync,
                            ot||'' codigo,
                            ot||'' idVisita,
                            'GESTION DESPACHO' categoria
                      FROM consulta
                    )                    
                    $order
                    """;
    print(query);

    final List<Map<String, dynamic>> maps =
        await LocalDatabase.customQuery(query);

    return maps.map((json) {
      return ResumenSincronizar.fromJson(json);
    }).toList();
  }

  /*TRACKING DE RED*/
  Future<bool> addInformacion(NetworkInfo model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(NetworkInfo.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> deleteInformacion(NetworkInfo model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.deleteCaptura(NetworkInfo.table, model);

    return resp > 0 ? true : false;
  }

  Future<List<ManualNetworkInfo>> getInformacionManual() async {
    await LocalDatabase.init();

    List<Map<String, dynamic>> manualNetworkInfo =
        await LocalDatabase.query(ManualNetworkInfo.table);
    return manualNetworkInfo
        .map((item) => ManualNetworkInfo.fromMap(item))
        .toList();
  }

  Future<List<NetworkInfo>> getInformacion() async {
    await LocalDatabase.init();

    List<Map<String, dynamic>> networkInfo =
        await LocalDatabase.query(NetworkInfo.table);
    return networkInfo.map((item) => NetworkInfo.fromMap(item)).toList();
  }

  Future<List<NetworkInfo>> getInformacionPorLectura(String idLectura) async {
    await LocalDatabase.init();
    final query = """
                    SELECT *
                    FROM networkinfo
                    WHERE idLectura = '$idLectura' 
                  """;

    List<Map<String, dynamic>> networkInfo =
        await LocalDatabase.customQuery(query);
    return networkInfo.map((item) => NetworkInfo.fromMap(item)).toList();
  }

  Future<List<int>> getInformacionDia() async {
    await LocalDatabase.init();

    String hoy = DateFormat.yMd().format(DateTime.now());

    final query = """
                    SELECT COUNT(*) cantidad
                    FROM networkinfo
                    WHERE background = 'SI' 
                        AND fechaCorta = '$hoy'               
                    UNION ALL
                    SELECT COUNT(*) cantidad
                    FROM networkinfo
                    WHERE background = 'NO'
                        AND fechaCorta = '$hoy'
                  """;

    List<Map<String, dynamic>> networkInfo =
        await LocalDatabase.customQuery(query);
    return networkInfo
        .map((item) => int.parse(item.entries.first.value.toString()))
        .toList();
  }

  Future<List<int>> getInformacionMes() async {
    await LocalDatabase.init();
    const query = """
                    SELECT COUNT(*) cantidad
                    FROM networkinfo
                    WHERE background = 'SI'
                    UNION ALL
                    SELECT COUNT(*) cantidad
                    FROM networkinfo
                    WHERE background = 'NO'
                  """;

    List<Map<String, dynamic>> networkInfo =
        await LocalDatabase.customQuery(query);
    return networkInfo
        .map((item) => int.parse(item.entries.first.value.toString()))
        .toList();
  }

  Future<List<int>> getInformacionSinSincronizar() async {
    await LocalDatabase.init();
    const query = """
                    SELECT COUNT(*) cantidad
                    FROM networkinfo
                    WHERE background = 'SI'
                          AND enviado = 'NO'
                    UNION ALL
                    SELECT COUNT(*) cantidad
                    FROM networkinfo
                    WHERE background = 'NO'
                          AND enviado = 'NO'
                  """;

    List<Map<String, dynamic>> networkInfo =
        await LocalDatabase.customQuery(query);
    return networkInfo
        .map((item) => int.parse(item.entries.first.value.toString()))
        .toList();
  }

  Future<bool> updateInformacion(NetworkInfo model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.update(NetworkInfo.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> addInformacionManual(ManualNetworkInfo model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.insert(ManualNetworkInfo.table, model);

    return resp > 0 ? true : false;
  }

  Future<bool> updateInformacionManual(ManualNetworkInfo model) async {
    await LocalDatabase.init();

    int resp = await LocalDatabase.update(ManualNetworkInfo.table, model);

    return resp > 0 ? true : false;
  }

  /*FIN TRACKING DE RED*/
}
