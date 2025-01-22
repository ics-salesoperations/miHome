import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/models.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();

  static Database? _db;

  LocalDatabase._init();

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      // si la base de datos ya existe, no hacemos nada.
      return;
    }
    try {
      var databasePath = await getDatabasesPath();
      String _path = p.join(databasePath, 'mihome_app_database.db');
      _db = await openDatabase(_path,
          version: _version, onCreate: onCreate, onUpgrade: onUpgrade);
    } catch (ex) {
      return;
    }
  }

  static void onCreate(Database db, int version) async {
    const stringType = 'STRING';
    const textType = 'TEXT';
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER';
    const realType = 'REAL';
    String sql = "";

    //creando tabla de control de Actualizaciones
    sql = """
              CREATE TABLE tablas (
                                    id $idType,
                                    tabla $stringType,
                                    descripcion $stringType,
                                    fechaActualizacion $stringType
                                    )
            """;
    await db.execute(sql);

    //creando tabla de usuarios
    sql = """
              CREATE TABLE usuario (
                                    id $idType,
                                    flag $stringType,
                                    iddms $stringType,
                                    usuario $stringType,
                                    nombre $stringType,
                                    identidad $stringType,
                                    territorio $stringType,
                                    perfil $integerType,
                                    telefono $stringType,
                                    correo $stringType,
                                    resultado $stringType,
                                    foto $textType
                                    )
            """;
    await db.execute(sql);

    /*CREANDO TABLA DE TRACKING DEL USUARIO HEAD*/
    sql = """
                CREATE TABLE tracking_head
                (
                id $idType,
                idTracking $textType,
                usuario $textType,
                fechaInicio $textType,
                fechaFin $textType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE TRACKING DEL USUARIO DET*/
    sql = """
                CREATE TABLE tracking_det
                (
                id $idType,
                idTracking $textType,
                fecha $textType,
                latitude $realType,
                longitude $realType
                )
      """;
    await db.execute(sql);

    //insertando en tabla tabla de control de Actualizaciones
    sql = """
              INSERT INTO tablas (
                                    tabla,
                                    descripcion
                                    )
                                    VALUES ('agenda', 'Agenda')
            """;
    await db.execute(sql);

    /*CREANDO TABLA DE DETALLE PDV*/
    sql = """
                CREATE TABLE agenda
                (
                id $idType,
                fecha $integerType,
                ot $textType,
                producto $textType,
                tipo $textType,
                usuario $integerType,
                idTecnico $textType,
                nombreTecnico $integerType,
                cliente $textType,
                nombreCliente $textType,
                nodo $textType,
                nodoNuevo $textType,
                tap $textType,
                tapNuevo $textType,
                colilla $textType,
                colillaNueva $textType,
                horaEntrada $integerType,
                horaSalida $textType,
                zona99 $textType,
                seriesBBI $textType,
                seriesTV $textType,
                seriesOtras $textType,
                longitud $textType,
                latitud $textType,
                estadoNodo $integerType,
                servicios $textType,
                visitado $textType,
                fechaVisita $textType,
                comentario $textType, 
                distrito $textType, 
                region $textType, 
                estado $textType,
                direccion $textType,
                qr $textType,
                qrNuevo $textType
                )
      """;
    await db.execute(sql);

    //insertando en tabla tabla de control de Actualizaciones
    sql = """
              INSERT INTO tablas (
                                    tabla,
                                    descripcion
                                    )
                                    VALUES ('formulario', 'Formularios')
            """;
    await db.execute(sql);

    /*CREANDO TABLA DE FORMULARIOS*/
    sql = """
                CREATE TABLE formulario
                (
                id $idType,
                formId $integerType,
                formName $textType,
                formDescription $textType,
                questionId $integerType,
                questionText $textType,
                idQuestionType $integerType,
                questionType $textType,
                required $textType,
                questionOrder $integerType,
                offeredAnswer $textType,
                auto $integerType,
                shortText $textType,
                type $textType,
                subType $textType,
                conditional $integerType,
                parentQuestion $textType,
                parentAnswer $textType
                )
      """;
    await db.execute(sql);

    //insertando en tabla tabla de control de Actualizaciones
    sql = """
              INSERT INTO tablas (
                                    tabla,
                                    descripcion
                                    )
                                    VALUES ('modelo', 'Modelos')
            """;
    await db.execute(sql);

    /*CREANDO TABLA DE MODELOS*/
    sql = """
                CREATE TABLE modelo
                (
                id $idType,
                tangible $textType,
                modelo $textType,
                descripcion $textType,
                imagen $textType,
                asignado $integerType,
                disponible $integerType,
                serieInicial $textType,
                serieFinal $textType
                )
      """;
    await db.execute(sql);

    //insertando en tabla tabla de control de Actualizaciones
    sql = """
              INSERT INTO tablas (
                                    tabla,
                                    descripcion
                                    )
                                    VALUES ('georreferencia', 'Geolocalizacion')
            """;
    await db.execute(sql);

    /*CREANDO TABLA DE GEOREFERENCIA*/
    sql = """
                CREATE TABLE georreferencia
                (
                id $idType,
                codigo $textType,
                nombre $textType,
                estado $textType,
                latitud $realType,
                longitud $realType,
                territorio $textType,
                zona $textType,
                departamento $textType,
                municipio $textType,
                tipo $textType,
                codigoPadre $textType,
                distancia $realType,
                foto $textType,
                modelo $textType,
                marca $textType,
                puertos $integerType,
                updateCoordenadas $integerType,
                updatePadre $integerType,
                fechaActualizacion $textType,
                nuevo $integerType,
                puerto $integerType,
                nombreCliente
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE GEOREFERENCIA LOG*/
    sql = """
                CREATE TABLE georreferenciaLog
                (
                id $idType,
                codigo $textType,
                nombre $textType,
                latitud $realType,
                longitud $realType,
                tipo $textType,
                codigoPadre $textType,
                foto $textType,
                usuarioActualiza $textType,
                fechaActualizacion $textType,
                enviado $integerType,
                puerto $integerType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE OT STEPS*/
    sql = """
                CREATE TABLE ot_steps
                (
                id $idType,
                ot $textType,
                step $textType,
                subEstado $textType,
                estado $textType,
                comentario $textType,
                gestion $textType,
                fecha $textType,
                estadoNuevo $textType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE LOCALIZAR*/
    sql = """
                CREATE TABLE localizar
                (
                id $idType,
                fecha $textType,
                ot $integerType,
                telefono $textType,
                nodo $textType,
                region $textType,
                distrito $textType,
                tecnico $textType,
                nombreTecnico $textType,
                enviado $integerType
                )
      """;
    await db.execute(sql);

//insertando en tabla tabla de control de Actualizaciones
    sql = """
              INSERT INTO tablas (
                                    tabla,
                                    descripcion
                                    )
                                    VALUES ('ot', 'Auditoria Materiales')
            """;
    await db.execute(sql);
    /*CREANDO TABLA DE OTS*/
    sql = """
                CREATE TABLE ot
                (
                id $idType,
                fechaCierre $textType,
                ot $integerType,
                cliente $textType,
                paquete $textType,
                idTecnico $textType,
                nombreTecnico $textType,
                contratista $textType,
                ciudad $textType,
                nodo $textType,
                nombreCliente $textType,
                departamento $textType,
                tap $textType,
                colilla $textType,
                tipoOt $textType,
                gestionado $integerType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE ACTIVAR*/
    sql = """
                CREATE TABLE activar
                (
                id $idType,
                fecha $textType,
                ot $integerType,
                cajaAndroidTV $textType,
                cajaDVB $textType,
                cableModem $textType,
                telefonia $textType,
                extensores $textType,
                retiros $textType,
                ipPublica $textType,
                nodo $textType,
                tap $textType,
                colilla $textType,
                correo $textType,
                bandSteering $textType,
                nombreRed $textType,
                claveRed $textType,
                distrito $textType,
                region $textType,
                enviado $integerType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE CERTIFICAR*/
    sql = """
                CREATE TABLE certificar
                (
                id $idType,
                fecha $textType,
                ot $integerType,
                telefono $textType,
                nodo $textType,
                region $textType,
                distrito $textType,
                tecnico $textType,
                nombreTecnico $textType,
                bitacora $textType,
                tap $textType,
                colilla $textType,
                bst $textType,
                correo $textType,
                enviado $integerType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE LIQUIDAR*/
    sql = """
                CREATE TABLE liquidar
                (
                id $idType,
                fecha $textType,
                ot $integerType,
                telefono $textType,
                nodo $textType,
                region $textType,
                distrito $textType,
                tecnico $textType,
                nombreTecnico $textType,
                bitacora $textType,
                tap $textType,
                colilla $textType,
                correo $textType,
                enviado $integerType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE CONSULTA*/
    sql = """
                CREATE TABLE consulta
                (
                id $idType,
                fecha $textType,
                fechaFin $textType,
                ot $integerType,
                telefono $textType,
                consulta $textType,
                nodo $textType,
                region $textType,
                distrito $textType,
                tecnico $textType,
                nombreTecnico $textType,
                enviado $integerType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE RESPUESTA DE FORMULARIOS*/
    sql = """
                CREATE TABLE formulario_answer
                (
                id $idType,
                instanceId $textType,
                formId $integerType,
                respondentId $textType,
                questionId $integerType,
                response $textType,
                fechaCreacion $textType,
                enviado $textType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE REGISTRO DE VISITAS*/
    sql = """
                CREATE TABLE visita
                (
                id $idType,
                fechaInicioVisita $textType,
                fechaFinVisita $textType,
                cliente $integerType,
                usuario $textType,
                latitud $realType,
                longitud $realType,
                enviado $textType,
                idVisita $textType
                )
      """;
    await db.execute(sql);

    /*CREANDO TABLA DE REGISTRO DE Ots CONSULTADAS*/
    sql = """
                CREATE TABLE consultaOt
                (
                id $idType,
                ot $integerType,
                cliente $integerType,
                estadoCliente $textType,
                codigoNodo $textType,
                estadoNodo $textType,
                motivo $textType,
                descripcionMotivo $textType,
                fechaCreado $textType,
                fechaHoraEstimada $textType,
                estadoAmsys $textType,
                descripconTipoOt $textType,
                categoriaNodo $textType,
                contrato $integerType,
                vendedor $textType,
                supervisor $textType,
                territorioVendedor $textType,
                fechaHoraDigitacion $textType,
                fechaEstadoAmsys $textType,
                fechaUltimaBitacora $textType,
                ultimaBitacora $textType,
                estadoFieldService $textType,
                jordanaAsignada $textType,
                duracionHoras $textType,
                tiempoCierre $textType,
                esFinalizado $integerType,
                dataUpdate $textType,
                estaSubscrito $integerType
                )
      """;
    await db.execute(sql);

    //creando tabla de informacion de red automatico
    sql = """
              CREATE TABLE networkinfo (
                                    id $idType,
                                    marca $stringType,
                                    modelo $stringType,
                                    idLectura $textType,
                                    telefono $stringType,
                                    datos $stringType,
                                    localizacion $stringType,
                                    latitud $stringType,
                                    longitud $stringType,
                                    estadoRed $stringType,
                                    tipoRed $stringType,
                                    tipoTelefono $integerType,
                                    esRoaming $stringType,
                                    nivelSignal $stringType,
                                    dB $stringType,
                                    enviado $stringType,
                                    fecha $stringType,
                                    rsrp $stringType,
                                    rsrq $stringType,
                                    rssi $stringType,
                                    rsrpAsu $stringType,
                                    rssiAsu $stringType,
                                    cqi $stringType,
                                    snr $stringType,
                                    cid $stringType,
                                    eci $stringType,
                                    enb $stringType,
                                    networkIso $stringType,
                                    networkMcc $stringType,
                                    networkMnc $stringType,
                                    pci $stringType,
                                    cgi $stringType,
                                    ci $stringType,
                                    lac $stringType,
                                    psc $stringType,
                                    rnc $stringType,
                                    operatorName $stringType,
                                    isManual $stringType,
                                    background $stringType,
                                    fechaCorta $stringType
                                    )
            """;

    await db.execute(sql);

    //creando tabla de informacion de red manual
    sql = """
              CREATE TABLE manualnetworkinfo (
                                    id $idType,
                                    idLectura $textType,
                                    departamento $stringType,
                                    municipio $stringType,
                                    zona $stringType,
                                    ambiente $stringType,
                                    tipoAmbiente $stringType,
                                    descripcionAmbiente $stringType,
                                    comentarios $stringType,
                                    colonia $stringType,
                                    fallaDesde $stringType,
                                    horas $stringType,
                                    tipoAfectacion $stringType,
                                    afectacion $stringType,
                                    fotografia $textType,
                                    enviado $stringType,
                                    mbSubida $realType,
                                    mbBajada $realType
                                    )
            """;

    await db.execute(sql);
  }

  static void onUpgrade(Database db, int oldVersion, int version) async {
    if (oldVersion > version) {
      //crear nuevos objetos tablas de la nueva version
    }
  }

  static Future<List<Map<String, dynamic>>> customQuery(String query) async {
    List<Map<String, dynamic>> resp = await _db!.rawQuery(query);
    return resp;
  }

  static Future<int> customUpdate(String query) async {
    int resp = await _db!.rawUpdate(query);
    return resp;
  }

  static Future<List<Map<String, dynamic>>> query(String table,
      {String find = 'id>=?', String findValue = '0'}) async {
    final resp = await _db!.query(table, where: find, whereArgs: [findValue]);
    /*final resp = await _db!.query(
      table,
    );*/
    return resp;
  }

  static Future<int> insert(String table, Model model) async {
    final resp = await _db!.insert(table, model.toJson());
    return resp;
  }

  static Future<int> insertListGeo(List<Georreferencia> datos) async {
    int resp = 0;

    Batch ba = _db!.batch();
    String query = """
                      INSERT INTO georreferencia 
                      (
                        codigo,
                        nombre,
                        estado,
                        latitud,
                        longitud,
                        territorio,
                        zona,
                        departamento,
                        municipio,
                        tipo,
                        codigoPadre,
                        foto,
                        modelo,
                        marca,
                        puertos,
                        fechaActualizacion,
                        puerto
                      )
                      VALUES
                      (
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?
                      )
                    """;

    for (var dato in datos) {
      ba.rawInsert(query, [
        dato.codigo.toString(),
        dato.nombre.toString(),
        dato.estado.toString(),
        dato.latitud,
        dato.longitud,
        dato.territorio.toString(),
        dato.zona.toString(),
        dato.departamento.toString(),
        dato.municipio.toString(),
        dato.tipo.toString(),
        dato.codigoPadre.toString(),
        dato.foto.toString(),
        dato.modelo.toString(),
        dato.marca.toString(),
        dato.puertos,
        dato.fechaActualizacion != null
            ? dato.fechaActualizacion!.toIso8601String()
            : null,
        dato.puerto
      ]);
    }
    //await _db!.execute(query, datos);
    await ba.commit(noResult: true);

    return resp;
  }

  static Future<int> insertListAgenda(List<Agenda> datos) async {
    int resp = 0;

    Batch ba = _db!.batch();
    String query = """
                      INSERT INTO agenda 
                      (
                        fecha,
                        ot,
                        usuario,
                        idTecnico,
                        nombreTecnico,
                        cliente,
                        nombreCliente,
                        nodo,
                        nodoNuevo,
                        tap,
                        tapNuevo,
                        colilla,
                        colillaNueva,
                        horaEntrada,
                        horaSalida,
                        zona99,
                        seriesBBI,
                        seriesTV,
                        seriesOtras,
                        longitud,
                        latitud,
                        estadoNodo,
                        servicios,
                        visitado,
                        fechaVisita,
                        comentario,
                        estado,
                        producto,
                        tipo,
                        direccion,
                        qr,
                        qrNuevo
                      )
                      VALUES
                      (
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?
                      )
                    """;

    for (var dato in datos) {
      ba.rawInsert(query, [
        DateFormat('yyyy-MM-dd HH:mm:ss').format(dato.fecha!),
        dato.ot.toString(),
        dato.usuario.toString(),
        dato.idTecnico,
        dato.nombreTecnico,
        dato.cliente.toString(),
        dato.nombreCliente.toString(),
        dato.nodo.toString(),
        dato.nodoNuevo.toString(),
        dato.tap.toString(),
        dato.tapNuevo.toString(),
        dato.colilla.toString(),
        dato.colillaNueva.toString(),
        dato.horaEntrada.toString(),
        dato.horaSalida.toString(),
        dato.zona99.toString(),
        dato.seriesBBI.toString(),
        dato.seriesTV.toString(),
        dato.seriesOtras.toString(),
        dato.longitud.toString(),
        dato.latitud.toString(),
        dato.estadoNodo.toString(),
        dato.servicios.toString(),
        dato.visitado.toString(),
        dato.fechaVisita.toString(),
        dato.comentario.toString(),
        dato.estado.toString(),
        dato.producto.toString(),
        dato.tipo.toString(),
        dato.direccion.toString(),
        dato.qr,
        dato.qrNuevo,
      ]);
    }
    //await _db!.execute(query, datos);
    await ba.commit(noResult: true);

    return resp;
  }

  static Future<int> insertListSteps(List<OTSteps> datos) async {
    int resp = 0;

    Batch ba = _db!.batch();
    String query = """
                      INSERT INTO ot_steps 
                      (
                        ot,
                        step,
                        subEstado,
                        estado,
                        comentario,
                        gestion,
                        fecha,
                        estadoNuevo
                      )
                      VALUES
                      (
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?
                      )
                    """;

    for (var dato in datos) {
      ba.rawInsert(query, [
        dato.ot,
        dato.step,
        dato.subEstado,
        dato.estado,
        dato.comentario,
        dato.gestion,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(dato.fecha!),
        dato.estadoNuevo,
      ]);
    }
    //await _db!.execute(query, datos);
    await ba.commit(noResult: true);

    return resp;
  }

  static Future<int> insertListOTs(List<OT> datos) async {
    int resp = 0;

    Batch ba = _db!.batch();
    String query = """
                      INSERT INTO ot 
                      (
                        fechaCierre,
                        ot,
                        cliente,
                        paquete,
                        idTecnico,
                        nombreTecnico,
                        contratista,
                        ciudad,
                        nodo,
                        nombreCliente,
                        departamento,
                        tap,
                        colilla,
                        tipoOt,
                        gestionado
                      )
                      VALUES
                      (
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?
                      )
                    """;

    for (var dato in datos) {
      ba.rawInsert(query, [
        DateFormat('yyyy-MM-dd HH:mm:ss').format(dato.fechaCierre!),
        dato.ot,
        dato.cliente,
        dato.paquete,
        dato.idTecnico,
        dato.nombreTecnico,
        dato.contratista,
        dato.ciudad,
        dato.nodo,
        dato.nombreCliente,
        dato.departamento,
        dato.tap,
        dato.colilla,
        dato.tipoOt,
        0,
      ]);
    }
    //await _db!.execute(query, datos);
    await ba.commit(noResult: true);

    return resp;
  }

  static Future<int> insertLstRespuestas(List<FormularioAnswer> datos) async {
    int resp = 0;

    Batch ba = _db!.batch();
    String query = """
                      INSERT INTO formulario_answer 
                      ( 
                        instanceId,
                        formId,
                        respondentId,
                        questionId,
                        response,
                        fechaCreacion,
                        enviado
                      )
                      VALUES
                      (
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?
                      )
                    """;

    for (var dato in datos) {
      ba.rawInsert(
        query,
        [
          dato.instanceId,
          dato.formId,
          dato.respondentId,
          dato.questionId,
          dato.response,
          dato.fechaCreacion,
          "NO",
        ],
      );
    }
    //await _db!.execute(query, datos);
    await ba.commit(noResult: true);

    resp = 1;

    return resp;
  }

  static Future<int> insertLstConsultaOt(List<ConsultaOt> datos) async {
    int resp = 0;

    Batch ba = _db!.batch();
    String query = """
                      INSERT INTO consultaOt 
                      ( 
                        ot,
                        cliente,
                        estadoCliente,
                        codigoNodo,
                        estadoNodo,
                        motivo,
                        descripcionMotivo,
                        fechaCreado,
                        fechaHoraEstimada,
                        estadoAmsys,
                        descripconTipoOt,
                        categoriaNodo,
                        contrato,
                        vendedor,
                        supervisor,
                        territorioVendedor,
                        fechaHoraDigitacion,
                        fechaEstadoAmsys,
                        fechaUltimaBitacora,
                        ultimaBitacora,
                        estadoFieldService,
                        jordanaAsignada,
                        duracionHoras,
                        tiempoCierre,
                        esFinalizado,
                        dataUpdate,
                        estaSubscrito
                      )
                      VALUES
                      (
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?,
                        ?
                      )
                    """;

    for (var dato in datos) {
      ba.rawInsert(
        query,
        [
          dato.ot,
          dato.cliente,
          dato.estadoCliente,
          dato.codigoNodo,
          dato.estadoNodo,
          dato.motivo,
          dato.descripcionMotivo,
          dato.fechaCreado,
          dato.fechaHoraEstimada,
          dato.estadoAmsys,
          dato.descripconTipoOt,
          dato.categoriaNodo,
          dato.contrato,
          dato.vendedor,
          dato.supervisor,
          dato.territorioVendedor,
          dato.fechaHoraDigitacion,
          dato.fechaEstadoAmsys,
          dato.fechaUltimaBitacora,
          dato.ultimaBitacora,
          dato.estadoFieldService,
          dato.jordanaAsignada,
          dato.duracionHoras,
          dato.tiempoCierre,
          dato.esFinalizado,
          DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(dato.dataUpdate ?? DateTime.now()),
          dato.esFinalizado == 1 ? 0 : dato.estaSubscrito
        ],
      );
    }
    //await _db!.execute(query, datos);
    await ba.commit(noResult: true);

    resp = 1;

    return resp;
  }

  static Future<int> update(String table, Model model) async {
    return _db!
        .update(table, model.toJson(), where: 'id=?', whereArgs: [model.id]);
  }

  static Future<int> updateModelo(String table, ModeloTangible model) async {
    return _db!.update(table, model.toJson(),
        where: 'tangible=? AND modelo=?',
        whereArgs: [model.tangible, model.modelo]);
  }

  static Future<int> delete(String table) async {
    return _db!.delete(table);
  }

  static Future<int> deleteForm(String table, Model model) async {
    return _db!
        .update(table, model.toJson(), where: 'id=?', whereArgs: [model.id]);
  }

  static Future<int> deleteCaptura(String table, Model model) async {
    return _db!
        .update(table, model.toJson(), where: 'id=?', whereArgs: [model.id]);
  }

  static Future<int> deleteRespSync(String table) async {
    return _db!.delete(table, where: " enviado = ?", whereArgs: ["SI"]);
  }

  static Future<int> deleteGeoSync(String table) async {
    return _db!.delete(table, where: " enviado = ?", whereArgs: ["1"]);
  }
}
