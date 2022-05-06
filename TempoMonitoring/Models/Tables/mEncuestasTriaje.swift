//
//  mEncuestasTriaje.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 6/09/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
import RealmSwift

class mEncuestasTriaje: Object {
    @Persisted var id = 1
    @Persisted var success = false
    @Persisted var payload: mPayloadTriaje?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Payload
class mPayloadTriaje: EmbeddedObject {
    @Persisted var cuestionario: mCuestionario?
}

// MARK: - Cuestionario
class mCuestionario: EmbeddedObject {
    @Persisted var cuestionarioInicial: mCuestionarioModel?
    @Persisted var cuestionarioDiario: mCuestionarioModel?
    @Persisted var cuestionarioAtencion: mCuestionarioModel?
}

// MARK: - CuestionarioInicial
class mCuestionarioModel: EmbeddedObject {
    @Persisted var _id: String?
    @Persisted var nombre: String?
    @Persisted var tipo_cuestionario: String?
    @Persisted var activo: Bool? = false
    @Persisted var fecha_creacion: String?
    @Persisted var num_secciones: Int = 0
    @Persisted var secciones = List<mSecciones>()
    @Persisted var enviado: Bool = false

    func getData() -> [String: Any] {
        var seccionesData = [[String: Any]]()
        for seccion in self.secciones {
            seccionesData.append(seccion.getData())
        }
        return [
            "_id": _id,
            "nombre": nombre,
            "tipo_cuestionario": tipo_cuestionario,
            "activo": activo,
            "fecha_creacion": fecha_creacion,
            "num_secciones": num_secciones,
            "secciones": seccionesData
        ]
    }
    
    func parsetoDTO() -> [Secciones]{
        var lstSections = [Secciones]()
        
        for item in secciones {
            var pasosInSections = [Paso]()
            
            for itemPaso in item.pasos {
                let cuadro = CuadroTexto(etiqueta: itemPaso.cuadro_texto?.etiqueta ?? "", valor: itemPaso.cuadro_texto?.valor ?? "")
                print("mEncuestasTriaje: \(cuadro.etiqueta)")
                let cuadroTexto = cuadro
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
                                    respuesta: "", respuestaObj: respuestasInPaso)
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

// MARK: - Seccione
class mSecciones: EmbeddedObject {
    @Persisted var pasos = List<mPasos>()
    @Persisted var numero_seccion = 0
    @Persisted var nombre_seccion: String? = ""
    @Persisted var titulo_seccion: String? = ""
    @Persisted var numero_pasos: Int? = 0

    func getData() -> [String: Any] {
        var pasosData = [[String: Any]]()
        for paso in pasos {
            pasosData.append(paso.getData())
        }
        return [
            "numero_seccion": numero_seccion,
            "nombre_seccion": nombre_seccion,
            "titulo_seccion": titulo_seccion,
            "numero_pasos": numero_pasos,
            "pasos": pasosData
        ]
    }
}

// MARK: - Paso
class mPasos: EmbeddedObject {
    @Persisted var cuadro_texto: mCuadroTexto?
    @Persisted var data_pregunta: List<mDataPregunta>
    @Persisted var numero_paso = 0
    @Persisted var id_pregunta_cuestionario = 0
    @Persisted var pregunta: String?
    @Persisted var texto_apoyo: String?
    @Persisted var id_tipo_pregunta = 0
    @Persisted var tipo_pregunta: String?
    @Persisted var requerido = false
    @Persisted var data_colaborador: String?
    @Persisted var respuesta: List<mDataRespuesta>
    @Persisted var respuestaStr: String
    @Persisted var respuestaInt: Int
    
    func getData() -> [String: Any] {
        var respuestaData: Any
        if tipo_pregunta == "SELECCION_MULTIPLE" || tipo_pregunta == "SELECCION_SIMPLE_DESPLEGABLE" || tipo_pregunta == "SI_NO" {
            var respArr = [[String: Any]]()
            for resp in respuesta {
                respArr.append(resp.getData())
            }
            respuestaData = respArr
        } else if tipo_pregunta == "NUMBER" {
            respuestaData = respuestaInt
        } else {
            respuestaData = respuestaStr
        }
        var preguntaData = [[String: Any]]()
        for tmpPregunta in data_pregunta {
            preguntaData.append(tmpPregunta.getData())
        }
        return [
            "data_pregunta": preguntaData,
            "numero_paso": numero_paso,
            "id_pregunta_cuestionario": id_pregunta_cuestionario,
            "pregunta": pregunta,
            "texto_apoyo": texto_apoyo,
            "id_tipo_pregunta": id_tipo_pregunta,
            "tipo_pregunta": tipo_pregunta,
            "requerido": requerido,
            "data_colaborador": data_colaborador,
            "respuesta": respuestaData
        ]
    }
}

// MARK: - CuadroTexto
class mCuadroTexto: EmbeddedObject {
    @Persisted var etiqueta: String?
    @Persisted var valor: String?
}

// MARK: - DataPregunta
class mDataPregunta: EmbeddedObject {
    @Persisted var id_opcion: Int?
    @Persisted var etiqueta: String?
    @Persisted var valor: String?
    
    func getData() -> [String: Any] {
        return [
            "id_opcion": id_opcion,
            "etiqueta": etiqueta,
            "valor": valor
        ]
    }
}

// MARK: - DataPregunta
class mDataRespuesta: EmbeddedObject {
    @Persisted var id_opcion: Int?
    @Persisted var etiqueta: String?
    @Persisted var valor: String?
    @Persisted var seleccionado: Bool?
    @Persisted var disabled: Bool?
    
    func getData() -> [String: Any] {
        return [
            "id_opcion": id_opcion,
            "etiqueta": etiqueta,
            "valor": valor,
            "seleccionado": seleccionado
        ]
    }
}
