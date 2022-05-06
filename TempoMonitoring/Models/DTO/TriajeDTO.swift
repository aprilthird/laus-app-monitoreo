//
//  TriajeDTO.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 26/08/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation

// MARK: - Triaje
struct TriajeDTO: Codable {
    var success: Bool
    var payload: Payload
}

// MARK: - Payload
struct Payload: Codable {
    var cuestionario: Cuestionario
}

// MARK: - Cuestionario
struct Cuestionario: Codable {
    var cuestionarioInicial: CuestionarioModel
    var cuestionarioDiario: CuestionarioModel
    var cuestionarioAtencion: CuestionarioModel

    enum CodingKeys: String, CodingKey {
        case cuestionarioInicial = "cuestionario_inicial"
        case cuestionarioDiario = "cuestionario_diario"
        case cuestionarioAtencion = "cuestionario_atencion"
    }
}

// MARK: - CuestionarioInicial
struct CuestionarioModel: Codable {
//    var condicionSospecha: CondicionSospecha
//    var criterioSospecha: [JSONAny]
    var id, nombre, tipoCuestionario: String
    var activo: Bool
    var fechaCreacion: String
    var numSecciones: Int
    var secciones: [Secciones]

    enum CodingKeys: String, CodingKey {
//        case condicionSospecha = "condicion_sospecha"
//        case criterioSospecha = "criterio_sospecha"
        case id = "_id"
        case nombre
        case tipoCuestionario = "tipo_cuestionario"
        case activo
        case fechaCreacion = "fecha_creacion"
        case numSecciones = "num_secciones"
        case secciones
    }
}


// MARK: - CondicionSospecha
//struct CondicionSospecha: Codable {
//    var and: [JSONAny]
//    var or: [[Int]]
//}

// MARK: - CriterioSospecha
//struct CriterioSospecha: Codable {
//    var idPreguntaCuestionario: Int
//    var or: [Int]
//    var and: [JSONAny]?
//    var expr: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case idPreguntaCuestionario = "id_pregunta_cuestionario"
//        case or, and, expr
//    }
//}

// MARK: - Seccione
struct Secciones: Codable {
    var pasos: [Paso]
    var numeroSeccion: Int
    var nombreSeccion, tituloSeccion: String
    var numeroPasos: Int?

    enum CodingKeys: String, CodingKey {
        case pasos
        case numeroSeccion = "numero_seccion"
        case nombreSeccion = "nombre_seccion"
        case tituloSeccion = "titulo_seccion"
        case numeroPasos = "numero_pasos"
    }
    
    func getData() -> [String: Any] {
        var pasosData = [[String: Any]]()
        for paso in pasos {
            pasosData.append(paso.getData())
        }
        return [
            "numero_seccion": numeroSeccion,
            "nombre_seccion": nombreSeccion,
            "titulo_seccion": tituloSeccion,
            "numero_pasos": numeroPasos,
            "paso_activo": true,
            "pasos": pasosData
        ]
    }
    
    func parseFromDB(sections: [mSecciones]) -> [Secciones]{
        var lstSections = [Secciones]()
        
        for item in sections {
            var pasosInSections = [Paso]()
            
            for itemPaso in item.pasos {
                
                let cuadroTexto = CuadroTexto(etiqueta: itemPaso.cuadro_texto?.etiqueta ?? "", valor: itemPaso.cuadro_texto?.valor ?? "")
                var preguntasInPaso = [DataPregunta]()
                var respuestasInPaso = [DataRepuesta]()
                for preguntas in itemPaso.data_pregunta {
                    let preg = DataPregunta(idOpcion: preguntas.id_opcion ?? 0,
                                            etiqueta: preguntas.etiqueta ?? "",
                                            valor: preguntas.valor ?? "")
                    let rpt = DataRepuesta(idOpcion: preguntas.id_opcion ?? 0,
                                           etiqueta: preguntas.etiqueta ?? "",
                                           valor: preguntas.valor ?? "",
                                           seleccionado: false, disabled: false)
                    preguntasInPaso.append(preg)
                    respuestasInPaso.append(rpt)
                }
                
                
                let paso = Paso(cuadroTexto: cuadroTexto,
                                    dataPregunta: preguntasInPaso,
                                    idPreguntaCuestionario: itemPaso.id_pregunta_cuestionario,
                                    numeroPaso: itemPaso.numero_paso,
                                    pregunta: itemPaso.pregunta ?? "",
                                    textoApoyo: itemPaso.texto_apoyo ?? "",
                                    idTipoPregunta: itemPaso.id_tipo_pregunta,
                                    tipoPregunta: itemPaso.tipo_pregunta ?? "",
                                    requerido: itemPaso.requerido,
                                    valor: "",
                                    crearCaso: false,
                                    dataColaborador: itemPaso.data_colaborador,
                                    respuesta: "", respuestaInt: 0, respuestaObj: respuestasInPaso)
                pasosInSections.append(paso)

            }
            
            let section = Secciones(pasos: pasosInSections,
                                    numeroSeccion: item.numero_seccion,
                                    nombreSeccion: item.nombre_seccion ?? "",
                                    tituloSeccion: item.titulo_seccion ?? "",
                                    numeroPasos: item.numero_pasos)
            lstSections.append(section)
        }
        
        return lstSections
    }
}

// MARK: - Paso
struct Paso: Codable {
    var cuadroTexto: CuadroTexto?
    var dataPregunta: [DataPregunta]?
    var idPreguntaCuestionario, numeroPaso: Int
    var pregunta, textoApoyo: String
    var idTipoPregunta: Int
    var tipoPregunta: String
    var requerido: Bool
    var valor: String?
    var crearCaso: Bool?
    var dataColaborador, respuesta: String?
    var respuestaInt: Int?
    var respuestaObj: [DataRepuesta]?
    
    enum CodingKeys: String, CodingKey {
        case cuadroTexto = "cuadro_texto"
        case dataPregunta = "data_pregunta"
        case idPreguntaCuestionario = "id_pregunta_cuestionario"
        case numeroPaso = "numero_paso"
        case pregunta
        case textoApoyo = "texto_apoyo"
        case idTipoPregunta = "id_tipo_pregunta"
        case tipoPregunta = "tipo_pregunta"
        case requerido, valor
        case crearCaso = "crear_caso"
        case dataColaborador = "data_colaborador"
        case respuesta, respuestaInt
    }
    
    func getData() -> [String: Any] {
        var respuestaData: Any?
        if tipoPregunta == "SELECCION_MULTIPLE" || tipoPregunta == "SELECCION_SIMPLE_DESPLEGABLE" || tipoPregunta == "SI_NO" {
            var respArr = [[String: Any]]()
            if let respuesta = respuestaObj {
                for resp in respuesta {
                    respArr.append(resp.getData())
                }
                respuestaData = respArr
            }
        } else if tipoPregunta == "NUMBER" {
            respuestaData = respuestaInt ?? 0
        } else {
            respuestaData = respuesta
        }
        var preguntaData: [[String: Any]]?
        if let pregunta = dataPregunta {
            preguntaData = [[String: Any]]()
            for tmpPregunta in pregunta {
                preguntaData!.append(tmpPregunta.getData())
            }
        } else {
            preguntaData = nil
        }
        var returnData = [
            "data_pregunta": preguntaData,
            "numero_paso": numeroPaso,
            "id_pregunta_cuestionario": idPreguntaCuestionario,
            "pregunta": pregunta,
            "texto_apoyo": textoApoyo,
            "id_tipo_pregunta": idTipoPregunta,
            "tipo_pregunta": tipoPregunta,
            "requerido": requerido,
            "crear_caso": crearCaso,
            "data_colaborador": dataColaborador ?? "",
            "respuesta": respuestaData
        ] as [String : Any]
        if tipoPregunta == "SELECCION_MULTIPLE" || tipoPregunta == "SELECCION_SIMPLE_DESPLEGABLE" || tipoPregunta == "SI_NO" {
            returnData["cuadro_texto"] = cuadroTexto?.getData()
            returnData["respuesta_cuadro_texto"] = cuadroTexto?.getData()
        }
        return returnData
    }
    
}

// MARK: - CuadroTexto
struct CuadroTexto: Codable {
    var etiqueta: String
    var valor: String?
    func getData() -> [String: String] {
        return [
            "etiqueta": etiqueta,
            "valor": valor ?? ""
        ]
    }
}

// MARK: - DataPregunta
struct DataPregunta: Codable {
    var idOpcion: Int
    var etiqueta, valor: String

    enum CodingKeys: String, CodingKey {
        case idOpcion = "id_opcion"
        case etiqueta, valor
    }

    func getData() -> [String: Any] {
        return [
            "id_opcion": idOpcion,
            "etiqueta": etiqueta,
            "valor": valor
        ]
    }
    
}

struct DataRepuesta: Codable {
    var idOpcion: Int
    var etiqueta, valor: String
    var seleccionado: Bool
    var disabled: Bool
    
    enum CodingKeys: String, CodingKey {
        case idOpcion = "id_opcion"
        case etiqueta, valor
        case seleccionado
        case disabled
    }
    
    func getData() -> [String: Any] {
        return [
            "id_opcion": idOpcion,
            "etiqueta": etiqueta,
            "valor": valor,
            "seleccionado": seleccionado,
            "disabled": disabled
        ]
    }
    
}
